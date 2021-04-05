@ECHO OFF
TITLE TEMP Files^/Folders ^& RAM Cleaner
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /TempClean
TASKKILL /F /FI "STATUS EQ NOT RESPONDING"
EmptyStandbyList workingsets
EmptyStandbyList priority0standbylist
EmptyStandbyList workingsets
EmptyStandbyList standbylist
EmptyStandbyList workingsets
EmptyStandbyList modifiedpagelist
EmptyStandbyList workingsets
DEL /S /Q /F "%TMP%\*"
DEL /S /Q /F "%TEMP%\*"
DEL /S /Q /F "%WINDIR%\Temp\*"
DEL /S /Q /F "%USERPROFILE%\Local Settings\Temp\*"
DEL /S /Q /F "%LOCALAPPDATA%\Temp\*"
NIRCMD EMPTYBIN
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /Admin /ReduceMemory
