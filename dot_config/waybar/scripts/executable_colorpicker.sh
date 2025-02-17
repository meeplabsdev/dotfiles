#!/usr/bin/env bash
check() {
  command -v "$1" 1>/dev/null
}

loc="$HOME/.cache/colorpicker"
[ -d "$loc" ] || mkdir -p "$loc"
[ -f "$loc/colors" ] || touch "$loc/colors"

[[ $# -eq 1 && $1 = "-l" ]] && {
  cat "$loc/colors"
  exit
}

check hyprpicker || {
  notify "hyprpicker is not installed"
  exit
}

killall -q hyprpicker
hyprpicker -a
