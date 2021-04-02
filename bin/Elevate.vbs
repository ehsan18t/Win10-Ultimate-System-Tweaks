Set oShell = CreateObject("Shell.Application")
Set WshShell = WScript.CreateObject("WScript.Shell")
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(CreateObject("Scripting.FileSystemObject").GetParentFolderName(Wscript.ScriptFullName))

oShell.ShellExecute ScriptDir & "\Ultimate Tweaks.bat", , , "runas", 1
WScript.Quit