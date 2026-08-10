#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

command -v flutter >/dev/null 2>&1 || {
  echo "Flutter n'est pas installé ou n'est pas dans le PATH."
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "Python 3 est nécessaire pour configurer Android."
  exit 1
}

if [ ! -d android ]; then
  generated_project="$(mktemp -d)"
  flutter create \
    --org com.novateur221 \
    --project-name moi_geomaticien \
    --platforms android \
    "$generated_project"
  cp -R "$generated_project/android" ./android
fi

flutter clean
flutter pub get
python3 tool/configure_android.py
dart run flutter_launcher_icons
flutter run
