@ECHO OFF
TITLE Aggressive Boost
SET "Current_Dir=%~dp0"

CALL "%Current_Dir%\Common.bat"

EmptyStandbyList workingsets
EmptyStandbyList priority0standbylist
EmptyStandbyList workingsets
EmptyStandbyList standbylist
EmptyStandbyList workingsets
EmptyStandbyList modifiedpagelist
EmptyStandbyList workingsets

NIRCMD EMPTYBIN
"%SystemRoot%\MagicX\NecessaryLib\EcMenu.exe" /Admin /ReduceMemory
