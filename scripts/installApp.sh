#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$HOME/"

echo "The installation directory will be $SCRIPT_DIR..."
echo "Installing the app..."

git clone 'https://github.com/AnAs1203/Volume-And-Brightness-Controller'
mv Volume-And-Brightness-Controller $SCRIPT_DIR &&
  cd $SCRIPT_DIR/Volume-And-Brightness-Controller &&
  dotnet publish -c Release -r linux-x64 --self-contained true &&
  PUBLISH_DIR=$(find "$SCRIPT_DIR/Volume-And-Brightness-Controller/bin/Release" -type d -path "*/linux-x64/publish" | sort | tail -n 1)
cd "$PUBLISH_DIR"

cat <<EOF >"$HOME/launch-bvc.sh"
#!/usr/bin/env bash
nohup $PUBLISH_DIR/VolumeBrightnessctl &
EOF

chmod +x "$HOME/launch-bvc.sh"

echo "------------------------------------------------------------"
echo "YOU CAN FIND THE LAUNCH SCRIPT AT $HOME/launch-bvc.sh !!!!!!"
echo "TO RUN THE APP JUST TYPE ( $HOME/launch-bvc.sh ) IN YOUR TERMINAL OR IF YOU'RE ALREADY IN THE HOME DIRECTORY RUN ./launch-bvc.sh RIGHT AWAY!"
echo "------------------------------------------------------------"

echo "Meowie!"
