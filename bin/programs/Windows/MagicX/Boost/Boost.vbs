boost = WScript.Arguments.Item(0)

Set oShell = CreateObject("Shell.Application")
Set WshShell = WScript.CreateObject("WScript.Shell")
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(Wscript.ScriptFullName)

If boost="Lite" Then
	oShell.ShellExecute ScriptDir & "\Lite.bat", , , "runas", 0
ElseIf Boost="Aggressive" Then
	oShell.ShellExecute ScriptDir & "\Aggressive.bat", , , "runas", 0
End If
WScript.Quit
