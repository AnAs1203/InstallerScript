#!/usr/bin/env bash
set -euo pipefail

readFileSepByNL() { # Read file, separate by new lines
  IFS=$'\n' read -r -d '' -a missing_deps < <(
    "$1"
    printf '\0'
  )
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

APP_DIR="$(find / -type d -name "Volume-And-Brightness-Controller" 2>/dev/null || true)"

if [[ -n "$APP_DIR" ]]; then
  echo "App already installed at $APP_DIR"
  echo "Exiting installation script..."
  exit 1
fi

echo "Checking required dependencies..."

if [ ! -f "$SCRIPT_DIR/scripts/requirements.txt" ]; then
  echo "Requirements not found, please reinstall the installation script"
  exit 1
fi

readFileSepByNL "$SCRIPT_DIR/scripts/checkDependencies.sh"

"$SCRIPT_DIR/scripts/installDependencies.sh" "${missing_deps[@]}"

echo "Verifying dependencies..."

readFileSepByNL "$SCRIPT_DIR/scripts/checkDependencies.sh"

if [ "${#missing_deps[@]}" -gt 0 ]; then
  echo "Dependencies missed / not installed."
  echo "Quitting installation to avoid loop."
  echo "Try to reinstall and try again. If all else fails contact me heh"
  exit 1
fi

echo "Verification complete!"
echo "Installing the app..."

"$SCRIPT_DIR/scripts/installApp.sh"

echo "Running suicide script..."

"$SCRIPT_DIR/scripts/runSuicide?.sh"
