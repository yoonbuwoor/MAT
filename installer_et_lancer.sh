#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

command -v flutter >/dev/null 2>&1 || {
  echo "Flutter n'est pas installé ou n'est pas dans le PATH."
  exit 1
}

rm -rf .backup_source
mkdir -p .backup_source
cp -R lib assets .backup_source/
cp pubspec.yaml analysis_options.yaml .backup_source/

flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android,web .
rm -rf lib assets
cp -R .backup_source/lib .backup_source/assets .
cp .backup_source/pubspec.yaml .backup_source/analysis_options.yaml .
rm -rf .backup_source

flutter pub get
dart run flutter_launcher_icons
python3 - <<'PYCODE'
from pathlib import Path
manifest = Path("android/app/src/main/AndroidManifest.xml")
text = manifest.read_text(encoding="utf-8")
text = text.replace('android:label="moi_geomaticien"', 'android:label="Moi, Géomaticien"')
manifest.write_text(text, encoding="utf-8")
PYCODE
flutter run
