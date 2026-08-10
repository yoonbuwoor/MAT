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
  echo Creation de la plateforme Android...
  set "GENERATED_PROJECT=%TEMP%\moi_geomaticien_%RANDOM%_%RANDOM%"
  flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android "%GENERATED_PROJECT%"
  if errorlevel 1 goto :error
  xcopy "%GENERATED_PROJECT%\android" android\ /E /I /Y >nul
  rmdir /s /q "%GENERATED_PROJECT%"
)

flutter pub get
if errorlevel 1 goto :error
python tool\configure_android.py
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

