@ECHO OFF
TITLE Clear all TEMP Files and Folders
DEL /S /Q "%TMP%\*.*"
DEL /S /Q "%TEMP%\*.*"
DEL /S /Q "%WINDIR%\Temp\*.*"
DEL /S /Q "%USERPROFILE%\Local Settings\Temp\*.*"
DEL /S /Q "%LOCALAPPDATA%\Temp\*.*"
IF EXIST "%SystemRoot%\MagicX\NecessaryLib\EcMenu.ini" DEL "%SystemRoot%\MagicX\NecessaryLib\EcMenu.ini"
IF EXIST "%SystemRoot%\MagicX\NecessaryLib\Items.ini" DEL "%SystemRoot%\MagicX\NecessaryLib\Items.ini"
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /TempClean
nircmd emptybin
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /Admin /ReduceMemory
