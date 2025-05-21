@echo off
setlocal

:: Ruta de origen del archivo wincmd.ini (ajústala si está en otro lugar)
set ORIGEN=wincmd.ini

:: Ruta de destino usando la variable de entorno %APPDATA%
set DESTINO=%APPDATA%\GHISLER

:: Crear la carpeta de destino si no existe
if not exist "%DESTINO%" (
    mkdir "%DESTINO%"
)

:: Copiar el archivo
copy "%ORIGEN%" "%DESTINO%\wincmd.ini" /Y

echo Archivo copiado a %DESTINO%
endlocal
pause
