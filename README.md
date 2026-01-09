
# Arch Linux Wayland Desktop Configuration
A minimal, keyboard-driven Wayland desktop environment built on sway, waybar, wofi, and foot.

## Design Philosophy

This setup prioritizes:

- **Keyboard-first workflow** — vim-style navigation, minimal mouse dependency
- **Visual minimalism** — dark theme, translucent surfaces, rounded corners
- **Wayland-native stack** — no X11 dependencies or compatibility layers
- **Self-contained scripts** — custom audio, bluetooth, and screenshot tooling

All components share a unified aesthetic: JetBrainsMono Nerd Font, near-black backgrounds with subtle transparency, and consistent gray/white accent colors.

---

## Components

### sway

**Role:** Tiling Wayland compositor (SwayFX fork for visual effects)

**Configuration:** [sway/config](sway/config)

#### Display Setup

Dual-monitor configuration:
- Primary: HDMI-A-1 at 1920×1080@144Hz (position 0,0)
- Secondary: DP-1 at 1920×1080@60Hz (position 1920,0)

Static wallpaper applied to all outputs from `sway/wallpapers/`.

#### Visual Appearance

Uses SwayFX extensions:
- `corner_radius 10` — rounded window corners
- `gaps inner 8` — spacing between tiled windows
- `default_border pixel 2` — minimal 2px borders

Border colors follow a dark gray palette:
- Focused: `#404040`
- Unfocused: `#1f1f1f`

#### Keybindings

| Binding | Action |
|---------|--------|
| `Ctrl+Return` | Terminal (foot) |
| `Ctrl+Space` | Application launcher (wofi) |
| `Mod+q` | Kill window |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window |
| `Mod+1-9` | Switch workspace |
| `Mod+Shift+1-9` | Move to workspace |
| `Alt+Tab` | Previous workspace |
| `Mod+e` | Fullscreen |
| `Mod+Shift+Space` | Float toggle |
| `Mod+t` | Toggle split layout |
| `Mod+m` | Tabbed layout |
| `Mod+b` | Toggle waybar |
| `Mod+Shift+b` | Restart waybar |
| `Mod+Shift+s` | Screenshot (region select) |
| `Mod+s` | Sync dotfiles |
| `Mod+Shift+c` | Reload config |
| `Mod+Shift+q` | Exit sway |

Arrow keys also work for navigation alongside vim bindings.

#### Idle & Lock

Managed via [scripts/swayidle-launch.sh](sway/scripts/swayidle-launch.sh):
- Lock after 5 minutes (`swaylock -f -c 000000`)
- Display off after 10 minutes
- Lock before sleep

The script fails gracefully if swayidle is not installed.

#### Media Keys

Hardware keys are bound:
- Volume: XF86Audio{Mute,Lower,Raise}Volume → waybar volume scripts
- Playback: XF86Audio{Play,Pause,Next,Prev} → playerctl
- Brightness: XF86MonBrightness{Up,Down} → brightnessctl

#### Float Rules

- `blueman-manager` — always float
- Picture-in-Picture — float + sticky

#### Autostart

Waybar is launched on startup and restarted on config reload. Uses `pkill` + `setsid` pattern to ensure single instance.

---

### waybar

**Role:** Status bar with custom modules and icon-based indicators

**Configuration:** [waybar/config.jsonc](waybar/config.jsonc) | [waybar/style.css](waybar/style.css)

#### Layout

```
[workspaces] [mode] [date]          [clock]          [volume] [audio-out] [bt] [net] [cpu] [ram] [bat] [tray]
```

Position: top, 30px height.

#### Modules

| Module | Behavior |
|--------|----------|
| `sway/workspaces` | Numbered workspaces, scroll disabled, shows on all outputs |
| `clock` | HH:MM format, click for full date, hover for calendar |
| `custom/date` | DD/MM/YY in muted gray |
| `custom/volume` | Popup volume bar with ▰▱ blocks, auto-hides after 2s |
| `custom/audio-output` | Shows SPK/BT/HDMI, click to cycle sinks |
| `custom/bluetooth` | Click opens blueman-manager (toggle behavior) |
| `network` | Icon-based, tooltip shows IP |
| `cpu` | Icon-based, 5s interval |
| `memory` | Text-only `[RAM] X%` |
| `battery` | Warning at 30%, critical at 15% with blink animation |

#### Volume System

Three scripts work together:

1. **volume-change.sh** — handles up/down/mute, creates a lockfile, signals waybar
2. **volume-popup.sh** — reads lockfile, outputs JSON with volume bar if active
3. Lockfile auto-deletes after 2 seconds, hiding the popup

Output format: `VOL ▰▰▰▱▱▱ 50%`

#### Audio Output Switching

**toggle-audio-output.sh** cycles through available PulseAudio sinks and moves all active streams to the new sink.

**audio-output-display.sh** detects device type:
- `bluez` → headset icon + "BT"
- `hdmi` → headset icon + "HDMI"
- else → speaker icon + "SPK"

#### Styling

- Font: JetBrainsMono Nerd Font, 20px (bar), 14px (modules)
- Background: `rgba(0, 0, 0, 0.3)` — translucent black
- Workspace indicator: bottom border on focused
- Hover: subtle white highlight
- Critical battery: red + blink animation

Icons are PNG files in [waybar/icons/](waybar/icons/) and positioned via CSS `background-image`.

---

### wofi

**Role:** Application launcher (drun mode)

**Configuration:** [wofi/config](wofi/config) | [wofi/style.css](wofi/style.css)

#### Behavior

- Mode: `drun` (desktop entries only)
- Dimensions: 900×450px, centered
- Matching: `contains` — partial string matching
- Case insensitive
- Cache file at `~/.cache/wofi-drun` for frecency tracking

#### Toggle Script

[wofi-toggle.sh](wofi/wofi-toggle.sh) implements toggle behavior:
- If wofi running → kill it
- Else → launch with explicit config/style paths

Runs as `--normal-window` for proper sway integration.

#### Styling

- Background: `rgba(8, 8, 8, 0.85)` — near-black with blur-ready alpha
- Input: dark gray, rounded
- Selection: left border accent, white text
- Icons: 24×24px
- Font: JetBrainsMono Nerd Font, 15px

Scrollbars hidden via `display: none`.

---

### foot

**Role:** GPU-accelerated Wayland terminal

**Configuration:** [foot/foot.ini](foot/foot.ini) | [foot/prompt.sh](foot/prompt.sh)

#### Terminal Settings

- Font: JetBrainsMono Nerd Font, 12pt
- Padding: 8×8px
- Scrollback: 5000 lines
- Cursor: block, no blink
- Mouse: hides when typing
- URLs: clickable (xdg-open)

#### Color Scheme

Tokyo Night-inspired dark palette:
- Background: `#0a0a0a` at 80% alpha
- Foreground: `#e6e6e6`
- Accent colors: soft reds, greens, blues

#### Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+Shift+c/v` | Copy/Paste |
| `Ctrl++/-/0` | Font size |
| `Shift+PgUp/PgDn` | Scroll page |
| `Ctrl+Shift+o` | Open URLs |
| `Ctrl+Shift+y` | Copy URL |

#### Custom Prompt

[prompt.sh](foot/prompt.sh) provides a minimal bash prompt:

```
 Arch@elbulbol ~/path/to/dir (branch*)
❯ 
```

- Arch Linux icon (Nerd Font)
- Git branch with dirty indicator (`*`)
- Two-line format for readability
- White text throughout

Source it in `.bashrc`:
```bash
source ~/.config/foot/prompt.sh
```

---

## Component Interaction

```
┌─────────────────────────────────────────────────────┐
│                      sway                           │
│  - launches waybar on startup                       │
│  - launches wofi via Ctrl+Space                     │
│  - launches foot via Ctrl+Return                    │
│  - signals waybar for audio changes                 │
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
   ┌─────────┐    ┌─────────┐    ┌─────────┐
   │ waybar  │    │  wofi   │    │  foot   │
   │         │    │         │    │         │
   │ scripts │    │ toggle  │    │ prompt  │
   │   ▼     │    │ script  │    │ script  │
   │ pactl   │    └─────────┘    └─────────┘
   │ blueman │
   └─────────┘
```

- sway binds volume keys → waybar's `volume-change.sh`
- waybar signals refresh via `pkill -RTMIN+8/9`
- wofi toggle script ensures single instance
- foot inherits environment from sway session

---

## Dependencies

Required:
- sway / swayfx
- waybar
- wofi
- foot
- pactl (pulseaudio / pipewire-pulse)
- playerctl
- grim, slurp, wl-copy (screenshots)
- brightnessctl
- mako (notifications)
- swayidle, swaylock
- JetBrainsMono Nerd Font

Optional:
- blueman (bluetooth management)

---

## Files Analyzed

```
sway/
  config
  sway-reload.sh
  sway-start.sh
  scripts/
    mako-launch.sh
    screenshot.sh
    swayidle-launch.sh

waybar/
  config.jsonc
  style.css
  audio-output-display.sh
  bluetooth-toggle.sh
  toggle-audio-output.sh
  volume-change.sh
  volume-popup.sh
  icons/
    bluetooth.png
    charge.png
    cpu.png
    headset.png
    internet.png
    no_internet.png
    speaker.png

wofi/
  config
  style.css
  wofi-toggle.sh

foot/
  foot.ini
  prompt.sh
```
