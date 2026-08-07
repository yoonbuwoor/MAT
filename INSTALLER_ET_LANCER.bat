@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter n'est pas installe ou n'est pas dans le PATH.
  pause
  exit /b 1
)
where python >nul 2>nul
if errorlevel 1 (
  echo Python est necessaire pour configurer Android.
  pause
  exit /b 1
)

if not exist android (
  echo Creation du projet Android...
  if exist .backup_source rmdir /s /q .backup_source
  mkdir .backup_source
  xcopy lib .backup_source\lib /E /I /Y >nul
  xcopy assets .backup_source\assets /E /I /Y >nul
  xcopy tool .backup_source\tool /E /I /Y >nul
  copy pubspec.yaml .backup_source\pubspec.yaml >nul
  copy analysis_options.yaml .backup_source\analysis_options.yaml >nul
  if exist test xcopy test .backup_source\test /E /I /Y >nul

  flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android .
  if errorlevel 1 goto :error

  if exist lib rmdir /s /q lib
  if exist assets rmdir /s /q assets
  if exist tool rmdir /s /q tool
  xcopy .backup_source\lib lib /E /I /Y >nul
  xcopy .backup_source\assets assets /E /I /Y >nul
  xcopy .backup_source\tool tool /E /I /Y >nul
  copy /Y .backup_source\pubspec.yaml pubspec.yaml >nul
  copy /Y .backup_source\analysis_options.yaml analysis_options.yaml >nul
  if exist .backup_source\test xcopy .backup_source\test test /E /I /Y >nul
  rmdir /s /q .backup_source
)

python tool\configure_android.py
if errorlevel 1 goto :error
flutter pub get
if errorlevel 1 goto :error
dart run flutter_launcher_icons
if errorlevel 1 goto :error

echo Lancement de Moi, Geomaticien...
flutter run
exit /b 0

:error
echo Une erreur est survenue.
pause
exit /b 1
