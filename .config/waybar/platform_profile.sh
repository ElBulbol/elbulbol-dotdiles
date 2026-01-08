#!/bin/bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"

# Check if platform_profile is available
if [ ! -f "$PROFILE_FILE" ]; then
    echo ""
    exit 0
fi

if [ "$1" = "toggle" ]; then
    # Toggle between profiles
    CURRENT=$(cat "$PROFILE_FILE")
    case $CURRENT in
        low-power)
            echo "balanced" | sudo tee "$PROFILE_FILE" > /dev/null
            ;;
        balanced)
            echo "performance" | sudo tee "$PROFILE_FILE" > /dev/null
            ;;
        performance)
            echo "low-power" | sudo tee "$PROFILE_FILE" > /dev/null
            ;;
    esac
else
    # Display current profile
    CURRENT=$(cat "$PROFILE_FILE")
    case $CURRENT in
        low-power)
            echo "🔋"
            ;;
        balanced)
            echo "⚡"
            ;;
        performance)
            echo "🚀"
            ;;
        *)
            echo "?"
            ;;
    esac
fi
