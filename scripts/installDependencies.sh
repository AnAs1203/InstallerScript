#!/usr/bin/env bash
set -euo pipefail

installDotnet() {
  case "$PMO" in
  "apt")
    sudo apt install -y libgtk-3-0 libgdk-pixbuf2.0-0 libx11-6 &&
      wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb &&
      sudo dpkg -i packages-microsoft-prod.deb &&
      rm packages-microsoft-prod.deb &&
      sudo apt update &&
      sudo apt install -y dotnet-sdk-7.0
    ;;
  "dnf")
    sudo dnf install -y gtk3 gdk-pixbuf2 libX11 &&
      sudo dnf install dotnet-sdk-7.0 &&
      sudo dnf install dotnet-runtime-7.0
    ;;
  "pacman")
    sudo pacman -S --needed gtk3 gdk-pixbuf2 libx11 &&
      sudo pacman -S dotnet-sdk dotnet-runtime
    ;;
  "zypper")
    sudo zypper --non-interactive install gtk3 gdk-pixbuf2 libX11-6 &&
      sudo zypper --non-interactive install dotnet-sdk-7.0 &&
      sudo zypper --non-interactive install dotnet-runtime-7.0
    ;;
  *)
    echo "Package manager is unsupported / not found" >&2
    exit 1
    ;;
  esac
}

installBrightnessctl() {
  git clone https://github.com/Hummer12007/brightnessctl.git &&
    cd brightnessctl &&
    ./configure &&
    make &&
    sudo make install
}

installDependency() {
  if [[ "$1" == "brightnessctl" && "$PMO" != "pacman" ]]; then
    installBrightnessctl
  else
    case "$PMO" in
    "apt")
      sudo apt update
      sudo apt install -y "$1"
      ;;
    "dnf")
      sudo dnf update -y
      sudo dnf install -y "$1"
      ;;
    "pacman")
      sudo pacman -S --noconfirm --needed "$1"
      ;;
    "zypper")
      sudo zypper refresh
      sudo zypper --non-interactive install "$1"
      ;;
    *)
      echo "Package manager is unsupported / not found" >&2
      exit 1
      ;;
    esac
  fi
}

if [ "$#" -eq 0 ]; then
  echo "All dependencies in place..."
  exit 0
fi

if command -v apt >/dev/null 2>&1; then
  PMO="apt"
elif command -v dnf >/dev/null 2>&1; then
  PMO="dnf"
elif command -v pacman >/dev/null 2>&1; then
  PMO="pacman"
elif command -v zypper >/dev/null 2>&1; then
  PMO="zypper"
else
  echo "Unsupported package manager, sorry!" >&2
  exit 1
fi

echo "Found package manager: $PMO"
echo "Packages to be installed: $*"

for dependency in "$@"; do
  if [[ "$dependency" == "dotnet" ]]; then
    installDotnet
  else
    installDependency "$dependency"
  fi
done
