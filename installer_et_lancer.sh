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
flutter run
