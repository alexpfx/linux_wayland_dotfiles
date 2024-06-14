#!/bin/bash

# Get the current brightness
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENTAGE=$(( 100 * BRIGHTNESS / MAX_BRIGHTNESS ))

echo "Brightness: $PERCENTAGE%"
