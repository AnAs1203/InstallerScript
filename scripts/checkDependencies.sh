#!/usr/bin/env bash
set -euo pipefail

dependencyCheck() {
  if [[ "$1" == "pulseaudio" ]]; then
    if ! command -v "pactl" >/dev/null 2>&1; then
      echo "pulseaudio"
    fi
  else
    if ! command -v "$1" >/dev/null 2>&1; then
      echo "$1"
    fi
  fi
}

SCRIPT_DIR="$(pwd)"

packages=()

cd "$SCRIPT_DIR/scripts"

read -r -a packages <requirements.txt

for package in "${packages[@]}"; do
  dependencyCheck "$package"
done
