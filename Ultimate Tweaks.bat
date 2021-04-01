@echo off
TITLE Ultimate System Tweaks by Ahsan
color 0A
cd /d %~dp0
COPY /Y "bin\wtee.exe" "%SystemRoot%\System32\wtee.exe" >NUL 2>&1
Codes.bat 2>&1 | wtee log.txt
DEL "%SystemRoot%\System32\wtee.exe" >NUL 2>&1