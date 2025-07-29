#!/usr/bin/env bash

LED_PATH="/sys/class/leds/tpacpi::kbd_backlight/brightness"
MAX=2

cur=$(cat "$LED_PATH")
next=$(( (cur + 1) % (MAX + 1) ))

echo $next | sudo tee "$LED_PATH" > /dev/null

case "$next" in
  0) notify-send "💡 Keyboard Backlight" "Turned OFF" ;;
  1) notify-send "💡 Keyboard Backlight" "Set to LOW" ;;
  2) notify-send "💡 Keyboard Backlight" "Set to HIGH" ;;
esac
