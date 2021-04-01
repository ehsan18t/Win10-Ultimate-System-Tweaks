@echo off
TITLE Ultimate System Tweaks by Ahsan
color 0A
Codes.bat 2>&1 | wtee log.txt
SET "Current_Dir=%~dp0"
SET "Bin_Dir=%Current_Dir%\bin"
SET "Programs_Dir=%Current_Dir%\programs"

COPY /Y "%Bin_Dir%\wtee.exe" "%SystemRoot%\System32\wtee.exe" >NUL 2>&1
DEL "%SystemRoot%\System32\wtee.exe" >NUL 2>&1
