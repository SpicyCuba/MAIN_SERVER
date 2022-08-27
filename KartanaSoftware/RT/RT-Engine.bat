@echo off
color 2
cls
echo.
set appVer=1.0.0
echo [%time%] Started RT-Engine with Version : V%appVer%!
:: APP_VARS
set root=%userprofile%\appdata\roaming\KS-Data
set engineDir=%Root%\RT-Engine
set /a engineMissing=0
set /a launchData=1
set /a RTloop=0
set /a newThreatsNum=0
set tempfolder=%root%\Temp
title Kartana Software - Real-Time Protection Engine V%appVer%
:RT-START
:: BOOT_CHECKS
if exist %tempfolder%\missingFile.ks DEL /Q %tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine set /a engineMissing+=1 && echo %Root%\RT-Engine >> %tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine\Data set /a engineMissing+=1 && echo %Root%\RT-Engine\Data >> %tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine\Quarantine set /a engineMissing+=1 && ECHO %Root%\RT-Engine\Quarantine >> %Tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine\sharedFolder set /a engineMissing+=1 && echo %Root%\RT-Engine\sharedFolder >> %tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine\RT-Engine.bat set /a engineMissing+=1 && echo %Root%\RT-Engine\RT-Engine.bat >> %tempfolder%\missingFile.ks
if not exist %Root%\RT-Engine\NO_WINDOW.vbs set /a engineMissing+=1 && echo %root%\RT-Engine\NO_WINDOW.vbs >> %tempfolder%\missingFile.ks
:: LAUNCH_DATA_CHK
if not exist %Root%\RT-Engine\sharedFolder\launchData.ks set /a engineMissing+=1
if %engineMissing%==0 goto RT-LOOP-PRE
goto RT-MISSINGFILES

:RT-MISSINGFILES
cls
echo.
echo [%time%] Error, %engineMissing% Files missing, RT-Engine could not start!
if exist %tempfolder%\missingfile.ks type %tempfolder%\missingFile.ks
pause>nul && net send localhost Error whilst starting RT-Engine! && exit

:RT-LOOP-PRE
setlocal enableextensions
echo [%time%] Finished RT-Engine Bootchecks! && timeout /t 1 /nobreak>nul
echo [%time%] Succesfully Started RT-Engine! && timeout /t 1 /nobreak>nul
:RT-Loop
title Current RT-Loop Iteration : %RTloop%
:: START PART 1
set/a count=0
set count=0
for %%x in (%TMP%\*.tmp.exe) do set /a count+=1
if %count% GEQ 1 goto RT-LOOP-REMOVE1
:RT-RETURN1
:: START PART 2
set /a forkbombCount=0
set itemName=UNDEFINED_BY_APP
for /f %%x in ('TASKLIST /FI "IMAGENAME eq calc.exe" /NH') do set /a forkbombCount+=1
if %forkbombCount% GEQ 50 set itemName=calc.exe && goto RT-LOOP-REMOVE2
for /f %%x in ('TASKLIST /FI "IMAGENAME eq chrome.exe" /NH') do set /a forkbombCount+=1
if %forkbombCount% GEQ 50 set itemName=chrome.exe && goto RT-LOOP-REMOVE2
for /f %%x in ('TASKLIST /FI "IMAGENAME eq notepad.exe" /NH') do set /a forkbombCount+=1
if %forkbombCount% GEQ 50 set itemName=notepad.exe && goto RT-LOOP-REMOVE2
for /f %%x in ('TASKLIST /FI "IMAGENAME eq cmd.exe" /NH') do set /a forkbombCount+=1
if %forkbombCount% GEQ 50 set itemName=cmd.exe && goto RT-LOOP-REMOVE2
timeout /t 2 /nobreak>nul && set /a RTloop+=1 && goto RT-LOOP

:RT-LOOP-REMOVE1
for /r "%tmp%\" %%x in (*.tmp.exe) do move "%%x" "%root%\RT-Engine\Quarantine">nul
REN %root%\RT-Engine\Quarantine\*.tmp.exe *.QUARANTINED%random%
echo [%time%] Identified Potential Threat in : %tmp% , Quarantined Item! && goto RT-RETURN1

:RT-LOOP-REMOVE2
taskkill /im %itemName% /f>NUL && echo Limited Threat Damage - Type : Forkbomb , Amount : %forkbombCount% , Item Name : %itemName% && goto RT-LOOP

