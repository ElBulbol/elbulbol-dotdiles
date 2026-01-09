#!/bin/bash
# Discord launcher with Wayland support for screen sharing

# Launch Discord with Wayland and WebRTC PipeWire flags
exec discord \
    --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations \
    --ozone-platform-hint=auto \
    --enable-wayland-ime \
    "$@"
