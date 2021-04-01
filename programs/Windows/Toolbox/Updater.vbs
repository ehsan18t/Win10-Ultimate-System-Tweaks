Set oShell = CreateObject("Shell.Application")
Set WshShell = WScript.CreateObject("WScript.Shell")
ScriptDir = CreateObject("Scripting.FileSystemObject").GetParentFolderName(Wscript.ScriptFullName)

oShell.ShellExecute ScriptDir & "\Updater.bat", , , "runas", 0
WScript.Quit