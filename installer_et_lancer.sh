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
  rm -rf .backup_source
  mkdir -p .backup_source
  cp -R lib assets tool .backup_source/
  cp pubspec.yaml analysis_options.yaml .backup_source/
  [ -d test ] && cp -R test .backup_source/ || true

  flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android .
  rm -rf lib assets tool test
  cp -R .backup_source/lib .backup_source/assets .backup_source/tool .
  cp .backup_source/pubspec.yaml .backup_source/analysis_options.yaml .
  [ -d .backup_source/test ] && cp -R .backup_source/test . || true
  rm -rf .backup_source
fi

python3 tool/configure_android.py
flutter pub get
dart run flutter_launcher_icons
flutter run
