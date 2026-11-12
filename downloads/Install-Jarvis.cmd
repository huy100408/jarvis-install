@echo off
title Install Jarvis
echo Installing Jarvis. Keep this window open until it says it is finished.
echo.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object Net.WebClient).DownloadString('https://huy100408.github.io/jarvis-install/install.ps1'))"
echo.
pause
