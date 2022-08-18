@echo off
color 2
cls
echo.
echo [%time%] Started RT-Engine with Version : V%appVer%!
:: APP_VARS
set appVer=1.0.0
set Root=%userprofile%\appdata\roaming\KS-Data
set engineDir=%Root%\RT-Engine
set /a startError=0
set /a launchData=1
title Kartana Software - Real-Time Protection Engine V%appVer%
:RT-START
:: BOOT_CHECKS
if not exist %Root% set /a startError+=1
if not exist %Root%\RT-Engine set /a startError+=1
if not exist %Root%\RT-Engine\launchData.ks set /a startError+=1 && set /a launchData=0
if %startError% EQU 0 goto RT-LOOP
goto RT-MISSINGFILES

:RT-MISSINGFILES
cls
echo.
echo [%time%] Error, %startError% Files missing, RT-Engine could not start!

:RT-LOOP
echo rt LOOP
pause


