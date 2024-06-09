#!/bin/bash
set -e
swaymsg -r -t get_outputs | jq length
