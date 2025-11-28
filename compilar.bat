@echo off
echo ========================================
echo  Compilando ArtCollab Mobile App
echo ========================================
echo.

echo [1/4] Limpiando proyecto...
flutter clean
if errorlevel 1 goto error

echo.
echo [2/4] Eliminando carpeta build...
if exist build rmdir /s /q build
if exist android\.gradle rmdir /s /q android\.gradle

echo.
echo [3/4] Instalando dependencias...
flutter pub get
if errorlevel 1 goto error

echo.
echo [4/4] Compilando aplicacion...
echo Esto puede tardar 3-5 minutos la primera vez...
echo.
flutter run -d emulator-5554
if errorlevel 1 goto error

goto end

:error
echo.
echo ========================================
echo  ERROR: La compilacion fallo
echo ========================================
echo.
echo Posibles soluciones:
echo 1. Cierra VS Code y vuelve a abrir
echo 2. Reinicia el emulador Android
echo 3. Ejecuta: flutter doctor
echo.
pause
exit /b 1

:end
echo.
echo ========================================
echo  Compilacion completada!
echo ========================================
pause
