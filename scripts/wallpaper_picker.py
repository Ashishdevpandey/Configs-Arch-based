#!/usr/bin/env python3
import os
import subprocess
import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk, ImageDraw
import glob
import hashlib
import threading
import queue
import json
from concurrent.futures import ThreadPoolExecutor

WS_CONF = os.path.expanduser("~/.cache/workspace_walls.conf")

# --- Configuration ---
ROOT_WALLPAPER_DIR = os.path.expanduser("~/Pictures/Archive")
CACHE_DIR          = os.path.expanduser("~/.cache/wallpaper_picker")
THUMB_SIZE         = (160, 90)
RADIUS             = 12
BG_COLOR           = "#0f0d0e"
TEXT_COLOR         = "#e6e1e3"
ACCENT_COLOR       = "#d4a860"
FOLDER_BG          = "#262324"
CLOSE_RED          = "#c0392b"
PLACEHOLDER_COLOR  = "#2a2727"
SCROLL_WIDTH       = 32   # ← thick scrollbar, easy to grab
POLL_MS            = 20
WORKERS            = 8


class WallpaperPicker:
    def __init__(self, root):
        self.root = root
        self.root.title("Wallpaper Picker")

        screen_height = self.root.winfo_screenheight()
        self.root.geometry(f"380x{screen_height}+0+0")
        self.root.configure(bg=BG_COLOR)
        self.root.overrideredirect(True)
        self.root.attributes("-alpha", 0.97)

        self.current_folder = tk.StringVar()
        self.wallpapers     = []
        self.buttons        = []
        self.folders        = self._get_folders()

        self._thumb_queue   = queue.Queue()
        self._active_folder = None
        self._render_job    = None
        self._btn_refs      = {}
        self._executor      = ThreadPoolExecutor(max_workers=WORKERS)

        os.makedirs(CACHE_DIR, exist_ok=True)
        self._placeholder = self._make_placeholder()

        self.setup_ui()

        if self.folders:
            self.select_folder(self.folders[0])

        # Pre-cache ALL folders in background immediately
        self._precache_all_folders()

        self._poll_thumb_queue()

    # ── helpers ──────────────────────────────────────────────────────────────

    def _get_folders(self):
        try:
            valid_folders = []
            exts = ('.jpg', '.jpeg', '.png', '.webp')
            for f in os.listdir(ROOT_WALLPAPER_DIR):
                full_path = os.path.join(ROOT_WALLPAPER_DIR, f)
                if os.path.isdir(full_path):
                    try:
                        has_images = any(file.lower().endswith(exts) for file in os.listdir(full_path))
                        if has_images:
                            valid_folders.append(f)
                    except Exception:
                        pass
            return sorted(valid_folders)
        except Exception:
            return []

    def _make_placeholder(self):
        img  = Image.new("RGBA", THUMB_SIZE, PLACEHOLDER_COLOR)
        draw = ImageDraw.Draw(img)
        draw.rounded_rectangle([(0, 0), (THUMB_SIZE[0]-1, THUMB_SIZE[1]-1)],
                                radius=RADIUS, fill=PLACEHOLDER_COLOR)
        return ImageTk.PhotoImage(img)

    def _thumb_path(self, img_path):
        m = hashlib.md5(img_path.encode()).hexdigest()
        return os.path.join(CACHE_DIR, f"{m}_v2.png")

    def add_corners(self, im, rad):
        """Rounded corners — skipped for speed (thumbnails are square)."""
        return im

    # ── thumbnail generation ─────────────────────────────────────────────────

    def _gen_thumb(self, img_path, folder=None, notify=False):
        """Generate thumbnail for img_path. If notify=True, push to queue."""
        thumb = self._thumb_path(img_path)
        if not os.path.exists(thumb):
            try:
                img = Image.open(img_path)
                # DRAFT MODE — 4-8x faster for JPEGs (decode at reduced size)
                if img.format == "JPEG":
                    img.draft("RGB", (THUMB_SIZE[0]*2, THUMB_SIZE[1]*2))
                    img = img.convert("RGBA")
                else:
                    img = img.convert("RGBA")

                w, h         = img.size
                target_ratio = THUMB_SIZE[0] / THUMB_SIZE[1]
                cur_ratio    = w / h
                if cur_ratio > target_ratio:
                    new_w  = int(h * target_ratio)
                    offset = (w - new_w) // 2
                    img    = img.crop((offset, 0, offset + new_w, h))
                else:
                    new_h  = int(w / target_ratio)
                    offset = (h - new_h) // 2
                    img    = img.crop((0, offset, w, offset + new_h))

                img = img.resize(THUMB_SIZE, Image.Resampling.BILINEAR)  # BILINEAR = faster than LANCZOS
                img = self.add_corners(img, RADIUS)
                img.save(thumb, format="PNG", optimize=False)
            except Exception:
                return

        if notify and folder is not None:
            self._thumb_queue.put((folder, img_path, thumb))

    def _precache_all_folders(self):
        """Background: generate thumbs for every image in every folder."""
        def _worker():
            for folder in self.folders:
                path  = os.path.join(ROOT_WALLPAPER_DIR, folder)
                exts  = ['*.jpg','*.jpeg','*.png','*.webp','*.JPG','*.JPEG','*.PNG','*.WEBP']
                files = []
                for ext in exts:
                    files.extend(glob.glob(os.path.join(path, ext)))
                for f in files:
                    if not os.path.exists(self._thumb_path(f)):
                        self._gen_thumb(f)          # silent, no notify
        threading.Thread(target=_worker, daemon=True).start()

    # ── UI setup ─────────────────────────────────────────────────────────────

    def setup_ui(self):
        style = ttk.Style()
        style.theme_use('clam')

        # Vertical scrollbar (right side)
        style.configure("Vertical.TScrollbar",
                         gripcount=0,
                         background=FOLDER_BG, darkcolor=FOLDER_BG, lightcolor=FOLDER_BG,
                         troughcolor=BG_COLOR,  bordercolor=BG_COLOR,
                         arrowsize=1, width=SCROLL_WIDTH)

        # Horizontal scrollbar (folder row) — THICK & EASY TO GRAB
        style.configure("Horizontal.TScrollbar",
                         gripcount=0,
                         background=ACCENT_COLOR, darkcolor=ACCENT_COLOR, lightcolor=ACCENT_COLOR,
                         troughcolor=BG_COLOR,    bordercolor=BG_COLOR,
                         arrowsize=1, width=SCROLL_WIDTH)

        # Header
        header = tk.Frame(self.root, bg=BG_COLOR, padx=25, pady=25)
        header.pack(fill="x")

        top_bar = tk.Frame(header, bg=BG_COLOR)
        top_bar.pack(fill="x")

        tk.Label(top_bar, text="Gallery", bg=BG_COLOR, fg=TEXT_COLOR,
                 font=("Playfair Display", 26, "bold")).pack(side="left")

        # Close button
        close_c = tk.Canvas(top_bar, width=35, height=35, bg=FOLDER_BG,
                            highlightthickness=0, cursor="hand2")
        close_c.pack(side="right")

        def draw_x(color=ACCENT_COLOR):
            close_c.delete("all")
            close_c.create_line(10, 10, 25, 25, fill=color, width=3)
            close_c.create_line(10, 25, 25, 10, fill=color, width=3)

        draw_x()
        close_c.bind("<Enter>",   lambda e: (close_c.configure(bg=CLOSE_RED),  draw_x("white")))
        close_c.bind("<Leave>",   lambda e: (close_c.configure(bg=FOLDER_BG),  draw_x(ACCENT_COLOR)))
        close_c.bind("<Button-1>",lambda e: self.root.destroy())

        tk.Label(header, text="FOLDERS", bg=BG_COLOR, fg="#666",
                 font=("Inter", 9, "bold")).pack(anchor="w", pady=(20, 5))

        # Folder scroll row
        folder_outer = tk.Frame(header, bg=BG_COLOR)
        folder_outer.pack(fill="x")

        self.folder_canvas = tk.Canvas(folder_outer, bg=BG_COLOR, height=60,
                                        highlightthickness=0)
        self.folder_frame = tk.Frame(self.folder_canvas, bg=BG_COLOR)

        self.folder_frame.bind(
            "<Configure>",
            lambda e: (self.folder_canvas.configure(
                scrollregion=self.folder_canvas.bbox("all")),
                self._update_custom_hscroll()))
        self.folder_canvas.create_window((0, 0), window=self.folder_frame, anchor="nw")
        self.folder_canvas.configure(xscrollcommand=self._on_folder_xscroll)
        self.folder_canvas.pack(fill="x")

        # ── Custom thick horizontal scrollbar (Canvas-based) ──────────────────
        SBAR_H = 18
        self._hscroll_canvas = tk.Canvas(
            folder_outer, bg="#1a1819", height=SBAR_H,
            highlightthickness=0, cursor="hand2")
        self._hscroll_canvas.pack(fill="x", pady=(6, 0))
        self._hscroll_thumb = None
        self._hscroll_drag_x = None
        self._hscroll_pos   = (0.0, 1.0)   # (lo, hi)

        self._hscroll_canvas.bind("<Configure>", lambda e: self._update_custom_hscroll())
        self._hscroll_canvas.bind("<ButtonPress-1>",   self._hscroll_click)
        self._hscroll_canvas.bind("<B1-Motion>",       self._hscroll_drag)
        self._hscroll_canvas.bind("<ButtonRelease-1>", self._hscroll_release)

        self._render_folder_buttons()

        # Image grid
        grid_outer = tk.Frame(self.root, bg=BG_COLOR)
        grid_outer.pack(fill="both", expand=True, padx=15, pady=10)

        self.canvas = tk.Canvas(grid_outer, bg=BG_COLOR, highlightthickness=0)
        self.vscroll = ttk.Scrollbar(grid_outer, orient="vertical",
                                      command=self.canvas.yview,
                                      style="Vertical.TScrollbar")
        self.grid_frame = tk.Frame(self.canvas, bg=BG_COLOR)

        self.grid_frame.bind(
            "<Configure>",
            lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all")))
        self._cw = self.canvas.create_window((0, 0), window=self.grid_frame, anchor="nw")
        self.canvas.configure(yscrollcommand=self.vscroll.set)

        self.canvas.pack(side="left", fill="both", expand=True)
        self.vscroll.pack(side="right", fill="y")

        self.root.bind("<Configure>", lambda e: self.canvas.itemconfig(self._cw, width=self.canvas.winfo_width()))
        self.root.bind_all("<MouseWheel>", self._on_mousewheel)

    def _render_folder_buttons(self):
        for w in self.folder_frame.winfo_children():
            w.destroy()
        self.folder_btns = {}
        for folder in self.folders:
            btn = tk.Button(self.folder_frame, text=folder.upper(),
                            command=lambda f=folder: self.select_folder(f),
                            bg=FOLDER_BG, fg="#ccc", bd=0, padx=20, pady=12,
                            font=("Inter", 13, "bold"), cursor="hand2",
                            activebackground=ACCENT_COLOR, activeforeground=BG_COLOR)
            btn.pack(side="left", padx=6)
            self.folder_btns[folder] = btn

    # ── Custom horizontal scrollbar helpers ───────────────────────────────────

    def _on_folder_xscroll(self, lo, hi):
        """Called by folder_canvas when scroll position changes."""
        self._hscroll_pos = (float(lo), float(hi))
        self._update_custom_hscroll()

    def _update_custom_hscroll(self):
        """Redraw the custom scrollbar thumb."""
        c = self._hscroll_canvas
        w = c.winfo_width()
        h = c.winfo_height()
        if w <= 1:
            return
        lo, hi = self._hscroll_pos
        c.delete("all")
        # Track background (already set via bg)
        pad = 3
        thumb_x0 = int(lo * w) + pad
        thumb_x1 = int(hi * w) - pad
        thumb_x1 = max(thumb_x1, thumb_x0 + 30)   # min thumb width
        r = (h - 2*pad) // 2                        # corner radius
        # Draw rounded thumb
        c.create_rectangle(thumb_x0+r, pad, thumb_x1-r, h-pad,
                            fill=ACCENT_COLOR, outline="", tags="thumb")
        c.create_oval(thumb_x0, pad, thumb_x0+2*r, h-pad,
                      fill=ACCENT_COLOR, outline="", tags="thumb")
        c.create_oval(thumb_x1-2*r, pad, thumb_x1, h-pad,
                      fill=ACCENT_COLOR, outline="", tags="thumb")

    def _hscroll_click(self, event):
        self._hscroll_drag_x = event.x

    def _hscroll_drag(self, event):
        if self._hscroll_drag_x is None:
            return
        w  = self._hscroll_canvas.winfo_width()
        dx = (event.x - self._hscroll_drag_x) / w
        self._hscroll_drag_x = event.x
        lo, hi = self._hscroll_pos
        lo = max(0.0, min(lo + dx, 1.0 - (hi - lo)))
        self.folder_canvas.xview_moveto(lo)

    def _hscroll_release(self, event):
        self._hscroll_drag_x = None

    def select_folder(self, folder):
        self.current_folder.set(folder)
        for f, btn in self.folder_btns.items():
            btn.configure(bg=(ACCENT_COLOR if f == folder else FOLDER_BG),
                          fg=(BG_COLOR     if f == folder else "#888"))
        self._load_folder(folder)

    # ── grid rendering ────────────────────────────────────────────────────────

    def _load_folder(self, folder):
        self._active_folder = folder
        path  = os.path.join(ROOT_WALLPAPER_DIR, folder)
        exts  = ['*.jpg','*.jpeg','*.png','*.webp','*.JPG','*.JPEG','*.PNG','*.WEBP']
        files = []
        for ext in exts:
            files.extend(glob.glob(os.path.join(path, ext)))
        self.wallpapers = sorted(files)
        self._render_grid(folder, self.wallpapers)

    def _render_grid(self, folder, files):
        if self._render_job:
            self.root.after_cancel(self._render_job)
            self._render_job = None

        for btn in self.buttons:
            btn.destroy()
        self.buttons = []

        # ← RESET scroll to TOP on every folder switch
        self.canvas.yview_moveto(0)

        # Flush stale queue
        while not self._thumb_queue.empty():
            try: self._thumb_queue.get_nowait()
            except queue.Empty: break

        self._btn_refs = {}
        self._pending  = 0
        cols = 2

        if not files:
            tk.Label(self.grid_frame, text="No images found",
                     bg=BG_COLOR, fg="#555", font=("Inter", 11)).grid(
                         row=0, column=0, columnspan=2, pady=40)
            return

        # ── PHASE 1: Show ALL placeholders instantly (synchronous) ────────────
        uncached = []
        for i, f in enumerate(files):
            thumb = self._thumb_path(f)
            frame = tk.Frame(self.grid_frame, bg=BG_COLOR, padx=5, pady=8)
            frame.grid(row=i // cols, column=i % cols, sticky="nsew")
            self.grid_frame.grid_columnconfigure(i % cols, weight=1)

            if os.path.exists(thumb):
                try:
                    photo = ImageTk.PhotoImage(Image.open(thumb))
                    btn = tk.Button(frame, image=photo,
                                    command=lambda x=f: self.set_wallpaper(x),
                                    bg=BG_COLOR, activebackground=BG_COLOR,
                                    bd=0, cursor="hand2", highlightthickness=0)
                    btn.image = photo
                except Exception:
                    btn = self._placeholder_btn(frame, f)
                    uncached.append(f)
                    self._pending += 1
            else:
                btn = self._placeholder_btn(frame, f)
                uncached.append(f)
                self._pending += 1

            btn.pack(expand=True)
            name = os.path.basename(f).rsplit('.', 1)[0]
            if len(name) > 15: name = name[:12] + "..."
            lbl = tk.Label(frame, text=name, bg=BG_COLOR, fg="#555",
                           font=("Inter", 8))
            lbl.pack(pady=4)
            self._btn_refs[f] = (btn, lbl, frame)
            self._bind_hover(btn, lbl)
            self.buttons.append(frame)

        # Loading counter label
        if uncached:
            self._loading_lbl = tk.Label(
                self.root, text=f"Loading {len(uncached)} images...",
                bg=BG_COLOR, fg="#444", font=("Inter", 8))
            self._loading_lbl.place(relx=0.5, rely=0.97, anchor="s")
        else:
            self._loading_lbl = None

        # ── PHASE 2: Generate uncached thumbs in background (parallel) ────────
        for f in uncached:
            self._executor.submit(self._gen_thumb, f, folder, True)

    def _placeholder_btn(self, frame, img_path):
        btn = tk.Button(frame, image=self._placeholder,
                        command=lambda x=img_path: self.set_wallpaper(x),
                        bg=PLACEHOLDER_COLOR, activebackground=PLACEHOLDER_COLOR,
                        bd=0, cursor="hand2", highlightthickness=0)
        btn.image = self._placeholder
        return btn

    def _bind_hover(self, btn, lbl):
        btn.bind("<Enter>", lambda e: (btn.configure(bg="#151314"), lbl.configure(fg=ACCENT_COLOR)))
        btn.bind("<Leave>", lambda e: (btn.configure(bg=BG_COLOR),  lbl.configure(fg="#555")))

    # ── queue polling ─────────────────────────────────────────────────────────

    def _poll_thumb_queue(self):
        try:
            # Process up to 15 items per poll cycle
            for _ in range(15):
                folder, img_path, thumb = self._thumb_queue.get_nowait()
                if folder != self._active_folder:
                    continue
                refs = self._btn_refs.get(img_path)
                if refs is None:
                    continue
                btn, lbl, _ = refs
                try:
                    photo = ImageTk.PhotoImage(Image.open(thumb))
                    btn.configure(image=photo, bg=BG_COLOR, activebackground=BG_COLOR)
                    btn.image = photo
                    self._bind_hover(btn, lbl)
                    # Update loading counter
                    self._pending = max(0, self._pending - 1)
                    if hasattr(self, '_loading_lbl') and self._loading_lbl:
                        if self._pending == 0:
                            self._loading_lbl.place_forget()
                        else:
                            self._loading_lbl.configure(
                                text=f"Loading {self._pending} images...")
                except Exception:
                    pass
        except queue.Empty:
            pass
        self.root.after(POLL_MS, self._poll_thumb_queue)

    # ── wallpaper apply ───────────────────────────────────────────────────────

    def _get_current_workspace(self):
        """Get the currently focused Hyprland workspace ID."""
        try:
            result = subprocess.run(
                ["hyprctl", "monitors", "-j"],
                capture_output=True, text=True, timeout=2
            )
            monitors = json.loads(result.stdout)
            for m in monitors:
                if m.get("focused"):
                    return str(m["activeWorkspace"]["id"])
        except Exception:
            pass
        return None

    def _save_workspace_wall(self, ws_id, path):
        """Write ws_id=path into ~/.cache/workspace_walls.conf"""
        lines = []
        if os.path.exists(WS_CONF):
            with open(WS_CONF, "r") as f:
                lines = [l for l in f.readlines() if not l.startswith(f"{ws_id}=")]
        lines.append(f"{ws_id}={path}\n")
        with open(WS_CONF, "w") as f:
            f.writelines(lines)

    def set_wallpaper(self, path):
        try:
            # Save last wallpaper
            with open(os.path.join(CACHE_DIR, "last_wallpaper.txt"), "w") as f:
                f.write(path)

            # Save per-workspace mapping
            ws_id = self._get_current_workspace()
            if ws_id:
                self._save_workspace_wall(ws_id, path)

            # Apply wallpaper
            subprocess.run(["pkill", "swaybg"], check=False)
            subprocess.Popen(["swaybg", "-i", path, "-m", "fill"],
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

            # Update Omarchy symlink
            system_bg = os.path.expanduser("~/.config/omarchy/current/background")
            if os.path.exists(os.path.dirname(system_bg)):
                if os.path.islink(system_bg):
                    os.remove(system_bg)
                os.symlink(path, system_bg)
        except Exception:
            pass

    def _on_mousewheel(self, event):
        x, y   = self.root.winfo_pointerxy()
        widget = self.root.winfo_containing(x, y)
        if str(widget).startswith(str(self.folder_canvas)):
            self.folder_canvas.xview_scroll(int(-1*(event.delta/120)), "units")
        else:
            self.canvas.yview_scroll(int(-1*(event.delta/120)), "units")


if __name__ == "__main__":
    root = tk.Tk()
    app  = WallpaperPicker(root)
    root.mainloop()
