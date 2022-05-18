@ECHO OFF
TITLE Lite Boost
SET "Current_Dir=%~dp0"

CALL "%Current_Dir%\Common.bat"

NIRCMD EMPTYBIN
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /Admin /ReduceMemory
