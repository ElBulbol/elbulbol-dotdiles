# Sway Window Manager Configuration Documentation

## Overview

This document provides comprehensive documentation for an **Arch Linux** system running **Sway** (a Wayland compositor and tiling window manager) with **Waybar** as the status bar. This setup is designed for performance, minimal resource usage, and a clean dark aesthetic.

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         WAYLAND COMPOSITOR                       │
│                              (Sway)                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │   Waybar    │  │    Wofi     │  │    Applications         │  │
│  │ (Status Bar)│  │ (Launcher)  │  │ (foot, discord, etc.)   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│                      AUDIO SUBSYSTEM                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │  PipeWire   │  │ WirePlumber │  │      Bluetooth          │  │
│  │   (Audio)   │  │  (Session)  │  │   (bluez/blueman)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
~/.config/
├── sway/
│   ├── config                    # Main Sway configuration
│   └── scripts/
│       ├── screenshot.sh         # Screenshot utility (grim + slurp)
│       └── wofi-toggle.sh        # Toggle application launcher
│
├── waybar/
│   ├── config                    # Waybar modules configuration (JSON)
│   ├── style.css                 # Waybar styling (CSS)
│   ├── icons/                    # Custom PNG icons for modules
│   │   ├── cpu.png
│   │   ├── ram.png
│   │   ├── temp.png
│   │   ├── speaker.png
│   │   ├── battery.png
│   │   └── internet.png
│   └── scripts/
│       ├── volume-change.sh      # Volume control (up/down/mute)
│       ├── volume-popup.sh       # Volume popup display
│       ├── volume.sh             # Volume status display
│       ├── audio-output.sh       # Current audio output display
│       ├── toggle-audio-output.sh # Toggle between audio sinks
│       ├── toggle-bluetooth.sh   # Toggle blueman-manager
│       └── platform_profile.sh   # Power profile display
│
├── gtk-3.0/
│   └── settings.ini              # GTK3 dark theme settings
│
├── gtk-4.0/
│   └── settings.ini              # GTK4 dark theme settings
│
├── foot/
│   └── foot.ini                  # Foot terminal configuration
│
└── wofi/                         # Wofi launcher configuration
```

---

## Core Components

### 1. Sway Window Manager

**Config Location:** `~/.config/sway/config`

Sway is an i3-compatible Wayland compositor. It handles:
- Window management (tiling, floating, tabbed)
- Keybindings
- Display/output configuration
- Running the status bar (waybar)

#### Key Variables
```bash
$mod = Mod4 (Super/Windows key)
$term = foot (terminal emulator)
$menu = wofi --show run (application launcher)
```

#### Visual Settings (SwayFX)
- **Corner Radius:** 10px on all windows
- **Gaps:** 8px inner gaps between windows
- **Borders:** 2px gray borders (#404040)
- **Blur:** Enabled for foot terminal

#### Keybindings Summary

| Keybinding | Action |
|------------|--------|
| `Ctrl+Return` | Open terminal (foot) |
| `Ctrl+Space` | Toggle wofi launcher |
| `Mod+q` | Kill focused window |
| `Mod+Shift+c` | Reload sway config |
| `Mod+Shift+q` | Exit sway (with confirmation) |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window left/down/up/right |
| `Mod+1-9` | Switch to workspace 1-9 |
| `Mod+Shift+1-9` | Move window to workspace 1-9 |
| `Alt+Tab` | Switch to last workspace |
| `Mod+e` | Toggle fullscreen |
| `Mod+Shift+Space` | Toggle floating |
| `Mod+t` | Toggle split layout |
| `Mod+m` | Tabbed layout |
| `Mod+v` | Split vertical |
| `Mod+Shift+v` | Split horizontal |
| `Mod+g` | Grow window width |
| `Mod+f` | Shrink window width |
| `Mod+b` | Toggle waybar visibility |
| `Mod+Shift+s` | Screenshot (region select) |

#### Media/Hardware Keys
| Key | Action |
|-----|--------|
| `Fn+F1 (XF86AudioMute)` | Toggle mute |
| `Fn+F2 (XF86AudioLowerVolume)` | Volume down 5% |
| `Fn+F3 (XF86AudioRaiseVolume)` | Volume up 5% |
| `XF86AudioPlay/Pause` | Play/pause media |
| `XF86MonBrightnessUp/Down` | Brightness ±5% |

---

### 2. Waybar Status Bar

**Config Location:** `~/.config/waybar/config` (JSON)
**Style Location:** `~/.config/waybar/style.css`

Waybar displays system information and provides clickable modules.

#### Module Layout
```
[workspaces] [mode]          [clock]          [profile][cpu][mem][temp][vol][audio][bt][bat][lang][net][tray]
```

#### Modules Explained

| Module | Description | Click Action |
|--------|-------------|--------------|
| `sway/workspaces` | Shows workspaces 1-9 | Switch workspace |
| `clock` | Time (Africa/Cairo timezone) | Toggle date display |
| `cpu` | CPU usage % | - |
| `memory` | RAM usage % | - |
| `temperature` | CPU temperature | - |
| `custom/volume-popup` | Volume bar + percentage | Mute toggle |
| `custom/audio-output` | SPK/BT indicator | Toggle audio sink |
| `bluetooth` | Device name when connected | Toggle blueman-manager |
| `battery` | Battery percentage | Toggle time remaining |
| `language` | EN/AR keyboard layout | - |
| `network` | WiFi SSID or "Disconnected" | Toggle IP display |
| `tray` | System tray icons | - |

#### Signal-Based Updates
The volume and audio modules use **signal 8** for updates:
```bash
pkill -RTMIN+8 waybar  # Triggers immediate refresh
```

This is more efficient than polling - modules only update when triggered.

---

### 3. Audio System

**Backend:** PipeWire with WirePlumber session manager
**Control Tool:** `pactl` (PulseAudio-compatible CLI)

#### How Volume Control Works

1. **User presses Fn+F1/F2/F3** → Sway executes `volume-change.sh`
2. **volume-change.sh:**
   - Runs `pactl set-sink-volume/mute @DEFAULT_SINK@`
   - Creates lockfile `/tmp/waybar_volume_popup.lock`
   - Sends signal to waybar: `pkill -RTMIN+8 waybar`
   - Starts 3-second timeout to hide popup
3. **Waybar refreshes** → Runs `volume-popup.sh`
4. **volume-popup.sh:**
   - Checks if lockfile exists
   - Gets volume from `pactl get-sink-volume @DEFAULT_SINK@`
   - Returns JSON: `{"text":"━━━━━━━━── 80%","class":"visible"}`
5. **After 3 seconds:** Lockfile removed, waybar refreshes, popup hidden

#### Audio Scripts Flow
```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  Fn Key Press    │────▶│ volume-change.sh │────▶│     pactl        │
│  (Sway binding)  │     │                  │     │ (PipeWire API)   │
└──────────────────┘     └────────┬─────────┘     └──────────────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │  pkill -RTMIN+8  │
                         │     waybar       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ volume-popup.sh  │────▶ Display in waybar
                         └──────────────────┘
```

#### Audio Output Switching
- **toggle-audio-output.sh** cycles through available sinks
- Uses `pactl list short sinks` to get all outputs
- Moves active streams to new sink with `pactl move-sink-input`

---

### 4. Bluetooth Management

**Service:** bluez (system) + blueman (GUI)
**Control Script:** `toggle-bluetooth.sh`

#### Behavior
- **Click bluetooth module** → Opens blueman-manager
- **Click again** → Kills all blueman processes (including tray icon)

```bash
# toggle-bluetooth.sh logic
if pgrep -f "blueman" > /dev/null; then
    pkill -9 -f "blueman"
else
    blueman-manager &
fi
```

#### Bluetooth Audio Profile
When bluetooth audio device connects:
- PipeWire automatically creates a new sink (e.g., `bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink`)
- `audio-output.sh` detects "bluez" in sink name → displays "BT"
- User can click to switch between SPK/BT

---

### 5. Screenshots

**Script:** `~/.config/sway/scripts/screenshot.sh`
**Tools:** `grim` (screenshot) + `slurp` (region select) + `wl-copy` (clipboard)

```bash
# Flow:
# 1. Create ~/screenshots/ if needed
# 2. User selects region with slurp
# 3. grim captures to ~/screenshots/YYYY-MM-DD_HH-MM-SS.png
# 4. wl-copy puts image in clipboard
```

---

### 6. Application Launcher (Wofi)

**Script:** `~/.config/sway/scripts/wofi-toggle.sh`

Toggle behavior - if wofi is running, kill it; otherwise, launch it:
```bash
if pgrep -x wofi > /dev/null; then
    pkill wofi
else
    wofi --show drun
fi
```

---

## Theme Configuration

### Dark Mode (GTK Applications)
**Files:** `~/.config/gtk-3.0/settings.ini` and `~/.config/gtk-4.0/settings.ini`

```ini
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
```

This ensures all GTK applications (including blueman-manager) use dark theme.

### Waybar Colors
- **Background:** `rgba(0, 0, 0, 0.3)` (30% transparent black)
- **Foreground:** `#eeeeee` (light gray)
- **Inactive:** `#aaaaaa` (darker gray)
- **Font:** JetBrainsMono Nerd Font, 17px

---

## Dependencies

### Required Packages (Arch Linux)
```bash
# Core
sway                    # Window manager
waybar                  # Status bar
foot                    # Terminal emulator
wofi                    # Application launcher

# Audio
pipewire                # Audio server
wireplumber             # Session manager
pipewire-pulse          # PulseAudio compatibility
bluez                   # Bluetooth stack
blueman                 # Bluetooth GUI manager

# Utilities
grim                    # Screenshot tool
slurp                   # Region selector
wl-clipboard            # Wayland clipboard (wl-copy)
brightnessctl           # Brightness control
playerctl               # Media control
autotiling              # Auto tiling script

# Fonts
ttf-jetbrains-mono-nerd # Nerd font for icons
```

---

## Troubleshooting

### Volume keys not working
1. Check if PipeWire is running: `systemctl --user status pipewire`
2. Test pactl: `pactl get-sink-volume @DEFAULT_SINK@`
3. Check keybindings: `swaymsg -t get_bindings | grep Audio`

### Bluetooth won't connect
1. Restart bluetooth: `sudo systemctl restart bluetooth`
2. Remove and re-pair device in blueman-manager
3. Check logs: `journalctl --user -u wireplumber -f`

### Waybar not updating
1. Send manual signal: `pkill -RTMIN+8 waybar`
2. Restart waybar: `killall waybar && waybar &`
3. Check script permissions: `ls -la ~/.config/waybar/scripts/`

### Screen sharing not working
Sway config includes necessary environment setup:
```bash
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```
Also uses `xwaylandvideobridge` for Discord compatibility.

---

## File Modification Guide

### To change keybindings
Edit `~/.config/sway/config`, then reload: `Mod+Shift+c`

### To change waybar modules
Edit `~/.config/waybar/config` (JSON), restart waybar

### To change waybar appearance
Edit `~/.config/waybar/style.css`, waybar auto-reloads

### To add custom waybar script
1. Create script in `~/.config/waybar/scripts/`
2. Make executable: `chmod +x script.sh`
3. Add to waybar config as `custom/name` module
4. Use `signal` for event-driven updates or `interval` for polling

---

## Quick Reference

### Reload Commands
```bash
swaymsg reload                    # Reload sway config
pkill -RTMIN+8 waybar            # Refresh waybar modules
killall waybar && waybar &       # Restart waybar completely
```

### Useful Commands
```bash
swaymsg -t get_outputs           # List displays
swaymsg -t get_tree              # Window tree
pactl list short sinks           # List audio outputs
pactl get-sink-volume @DEFAULT_SINK@  # Current volume
bluetoothctl devices             # List bluetooth devices
```

---

## Author Notes

This configuration prioritizes:
- **Performance:** Signal-based updates instead of polling where possible
- **Minimalism:** Text-only display, no unnecessary icons in modules
- **Dark theme:** Consistent dark appearance across all applications
- **Reliability:** Using `pactl` over `wpctl` for better compatibility

Last updated: January 8, 2026
