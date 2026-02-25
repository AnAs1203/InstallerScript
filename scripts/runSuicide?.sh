#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Should i kill myself? ( delete the installation script )"

read -p "Type in ( y / yes ) to confirm deletion / suicide heh" choice

if [[ "$choice" == y || "$choice" == yes ]]; then
  cd "$SCRIPT_DIR"
  cd ..
  cd ..
  rm -rf InstallerScript
else
  echo "If you ever change your mind go to $SCRIPT_DIR and run me again!"
  echo "( i am called 'runSuicide?.sh' just so you know )"
fi
