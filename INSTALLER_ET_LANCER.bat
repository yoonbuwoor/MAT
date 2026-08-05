@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo.
  echo ERREUR : Flutter n'est pas installe ou n'est pas dans le PATH.
  echo Installe Flutter puis relance ce fichier.
  pause
  exit /b 1
)

echo Sauvegarde du code source...
if exist .backup_source rmdir /s /q .backup_source
mkdir .backup_source
xcopy lib .backup_source\lib /E /I /Y >nul
xcopy assets .backup_source\assets /E /I /Y >nul
copy pubspec.yaml .backup_source\pubspec.yaml >nul
copy analysis_options.yaml .backup_source\analysis_options.yaml >nul

echo Generation des plateformes Flutter...
flutter create --org com.novateur221 --project-name moi_geomaticien --platforms=android,web .
if errorlevel 1 goto :error

echo Restauration du code Moi, Geomaticien...
if exist lib rmdir /s /q lib
if exist assets rmdir /s /q assets
xcopy .backup_source\lib lib /E /I /Y >nul
xcopy .backup_source\assets assets /E /I /Y >nul
copy /Y .backup_source\pubspec.yaml pubspec.yaml >nul
copy /Y .backup_source\analysis_options.yaml analysis_options.yaml >nul
rmdir /s /q .backup_source

flutter pub get
if errorlevel 1 goto :error

echo.
echo Projet pret. Lancement de l'application...
flutter run
exit /b 0

:error
echo.
echo Une erreur est survenue. Verifie l'installation de Flutter.
pause
exit /b 1
