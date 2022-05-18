' Checking if Patameter has been passed or not
if WScript.Arguments.Count <> 3 then
    WScript.Quit
end if

programName = WScript.Arguments.Item(0)
user = WScript.Arguments.Item(1)
openLocation = WScript.Arguments.Item(2)

Set app = CreateObject("Shell.Application")

If user="admin" Then
	openAs = "runas"
Else
	openAs = "open"
End If

If programName="cmd" Then
		app.ShellExecute programName, " /k pushd """ & openLocation & "\""", , openAs, 1
ElseIf programName="powershell" Then
		app.ShellExecute programName, " -noexit -command Set-Location -literalPath '" & openLocation & "\'", , openAs, 1
Else
		app.ShellExecute programName, " """ & openLocation & """", , openAs, 1
End If

WScript.Quit
