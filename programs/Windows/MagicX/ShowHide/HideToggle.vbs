Hidden = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden"
SSHidden = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSuperHidden"
Set Command1 = WScript.CreateObject("WScript.Shell")
Check = Command1.RegRead(Hidden)
If Check = 2 Then
Command1.RegWrite Hidden, 1, "REG_DWORD"
Command1.RegWrite SSHidden, 0, "REG_DWORD"
Else
Command1.RegWrite Hidden, 2, "REG_DWORD"
Command1.RegWrite SSHidden, 0, "REG_DWORD"
End If
Command1.SendKeys "{F5}"






