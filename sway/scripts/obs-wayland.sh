#!/bin/bash
# ============================================
# OBS Studio Launcher for Wayland/Sway
# Optimized for screen recording and capture
# ============================================

# Set Qt platform to Wayland
export QT_QPA_PLATFORM=wayland

# Enable Wayland-specific features
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# Force hardware acceleration
export QT_XCB_GL_INTEGRATION=xcb_egl

# PipeWire for screen capture (already configured via xdg-desktop-portal)
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland

# Launch OBS Studio
exec obs "$@"
