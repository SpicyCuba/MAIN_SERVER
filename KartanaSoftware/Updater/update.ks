@echo off
:: VERSION
set Version=0.6.2
:: SHORTCUTS
set Core=%Userprofile%\Appdata\Roaming
set Root=%Core%\KS-Data
set Tempfolder=%root%\Temp
set CustomDir=%Root%\Customization
set Library=%Root%\Library
:: DEBUG
set debugDisabled=0
set debugMode=DISABLED
:: PROXYS
set ProxyIP=NOT_DEFINED
set ProxyStatus=OFF
set /a ProxyAmount=0
:: ERROR_DATA
set ERROR_DATA=NOT_DEFINED
:: SAFEMODE
set safeMode=DISABLED

color 2
title Kartana Software - [%Version%]
echo.
echo  :::  .    :::.    :::::::.. :::::::::::::::.   :::.    :::.  :::.     
echo  ;;; .;;,. ;;`;;   ;;;;``;;;;;;;;;;;;'''';;`;;  `;;;;,  `;;;  ;;`;;    
echo  [[[[[/'  ,[[ '[[,  [[[,/[[['     [[    ,[[ '[[,  [[[[[. '[[ ,[[ '[[,  
echo _$$$$,   c$$$cc$$$c $$$$$$c       $$   c$$$cc$$$c $$$ "Y$c$$c$$$cc$$$c 
echo "888"88o, 888   888,888b "88bo,   88,   888   888,888    Y88 888   888,
echo  MMM "MMP"YMM   ""` MMMM   "W"    MMM   YMM   ""` MMM     YM YMM   ""` 
echo.
echo ------DEBUG_LOG------
echo Running Startup Checks... && timeout /t 1 /nobreak>nul
cd %Core%
rem -------------KS-DATA CHKS-----------------
if not exist KS-Data echo Pre-Existing folder NOT detected! && timeout /t 1 /nobreak>nul && echo Adding Folders. . . && md KS-Data && cd %Root% && md Temp && md Customization && md Library && md %Library%\Packages && echo. >> Log.txt && set/a InstallerStep=1 
:: SAFEMODE
if exist %CustomDir%\defaultSafe.ks set /p safeMode=<%CustomDir%\defaultSafe.ks
:: DEBUG_CHK
if exist %CustomDir%\debugModeState.ks set /p debugMode=<%CustomDir%\debugModeState.ks
if exist %tempfolder%\debugdisabler.ks set /a debugDisabled=1
rem -------------KS-DATA CHKS1----------------
goto BOOT_DOWNLOAD_SERVERSTATUS

:BOOT_DOWNLOAD_SERVERSTATUS
Ping www.google.com -n 1 -w 1000>NUL
if errorlevel 1 goto MAIN_PAGE
if exist %tempfolder%\serverStatus.cc DEL /Q %tempfolder%\serverStatus.cc
powershell -Command "$progressPreference = 'silentlyContinue' ; $ErrorActionPreference= 'silentlycontinue' ; Invoke-WebRequest https://raw.githubusercontent.com/SpicyCuba/MAIN_SERVER/main/KartanaSoftware/SERVER_STATUS -Outfile %tempfolder%\serverStatus.cc"
set /p serverStatus=<%tempfolder%\serverStatus.cc
:: ANALYSING_SERVERSTATUS
if %serverStatus%==0 goto MAIN_PAGE
DEL /Q %tempfolder%\serverStatus.cc
goto SERVER_STATUS_HUB

:: RESERVED_SERVERSTATUS_SECTION

:SERVER_STATUS_HUB
set serverStatComp=NOT_DEFINED
if %serverStatus%==1 set serverStatComp=DEBUG_PERMENANTLY_DISABLED
if %serverStatus%==2 set serverStatComp=LOGIN_CREDANTIALS_NEEDED
if %serverStatus%==3 set serverStatComp=ACCESS_TO_SCRIPT_BLOCKED
cls
echo.
echo Application Security Compromised : %serverStatComp% && timeout /t 4 /nobreak>nul
if %serverStatus%==1 echo PERM_DEBUG_DISABLED > %tempfolder%\debugdisabler.ks
if %serverStatus%==2 goto APP_LOCKED
if %serverStatus%==3 exit

:PERM_LOCKOUT
color c
cls
echo.
echo Error, exceeded maximum password attempts reached
echo.
echo Application Permanently Locked.
pause>nul && exit

:APP_LOCKED
if exist %tempfolder%\lockoutToken.ks goto PERM_LOCKOUT
if %wrongAttempts%==5 echo EXECEEDED_MAXIMUM_PASS_ATTEMPTS > %tempfolder%\lockoutToken.ks
cls
echo.
echo Application Security Compromised
echo.
echo Security Code Lvl : %serverStatus%
echo Wrong Attempts : %wrongAttempts%
echo.
set /p creds=Please enter admin credantials:
if %creds%==8232-3201 echo Application Unlocked! && timeout /t 1 /nobreak>nul && goto MAIN_PAGE
echo Wrong Password Attempt! && timeout /t 2 /nobreak>nul && set /a wrongAttempts+=1 && goto APP_LOCKED

:: END_RESERVED_SECTION

:BETA_BOOT_PROXYON
REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
IF ERRORLEVEL 0 echo Proxy Service Already Configured!
IF ERRORLEVEL 1 goto BOOT_PROXYON-CONFIGURE
:BOOT_PROXYON_AFTERCHK
echo Loading Section Completed!
timeout /t 1 /nobreak>nul
goto MAIN_PAGE

:BOOT_PROXYON-CONFIGURE
echo Checking available Proxy. . .188.138.11.39:5566 (FRANCE)
ping 188.138.11.39 -n 2>nul
if errorlevel 1 echo Error, Proxy not Available. Auto Skipping!
if errorlevel 0 reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f && reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d 188.138.11.39:5566 /f && echo Succesfully Added Proxy Service!
timeout /t 1 /nobreak>nul
echo Error Whilst Starting Proxy Service!
pause>nul

:MAIN_PAGE
if %debugDisabled%==1 set /a debugDisabled=1
cls
echo.
echo  :::  .    :::.    :::::::.. :::::::::::::::.   :::.    :::.  :::.     
echo  ;;; .;;,. ;;`;;   ;;;;``;;;;;;;;;;;;'''';;`;;  `;;;;,  `;;;  ;;`;;    
echo  [[[[[/'  ,[[ '[[,  [[[,/[[['     [[    ,[[ '[[,  [[[[[. '[[ ,[[ '[[,  
echo _$$$$,   c$$$cc$$$c $$$$$$c       $$   c$$$cc$$$c $$$ "Y$c$$c$$$cc$$$c 
echo "888"88o, 888   888,888b "88bo,   88,   888   888,888    Y88 888   888,
echo  MMM "MMP"YMM   ""` MMMM   "W"    MMM   YMM   ""` MMM     YM YMM   ""` 
echo.
set /p cmd="> "
echo.
:: INSTALLER_CMDS
if %cmd%==runinstaller goto RUN_INSTALLER-PRECHK
if %cmD%==run_installer goto RUN_INSTALLER-PRECHK
::PROXY_CMDS
if %cmd%==startproxy goto KS-CP
if %cmd%==proxy goto KS-CP
:: ANALYS_CMDS
if %cmd%==startwebanalysis goto KS-WA
if %cmd%==startfile_analyser goto KS-ERROR_GLOBAL
:: DEBUG_STARTCMDS
if %cmD%==restart goto RESTART_APP
if %cmD%==resetipvar set /a ProxyAmount=0 && set ProxyIP=NOT_DEFINED && set ProxyStatus=OFF && goto MAIN_PAGE
if %cmD%==refreshinstall  echo Deleting Current KS-Data... && timeout /t 1 /nobreak>nul && rmdir /s /q %Core%\KS-Data && echo Refreshing KS-Data... && timeout /t 1 /nobreak>nul && md KS-Data && cd %Root% && md Temp && md Customization && md Library && md %Library%\Packages && echo. >> Log.txt && set/a InstallerStep=1 && goto MAIN_PAGE
:: MAIN_PROGRAMS-LIST
if %cmD%==resetsherlock rmdir /s /q %Tempfolder%\SHERLOCK-TEMP && goto MAIN_PAGE
if %cmD%==runsherlock goto PROGRAMS-SHERLOCK
if %cmD%==runerror set ERROR_DATA=MANUALLY_RAN_ERROR && goto GLOBAL_ERROR
if %cmD%==delfile goto DELETE_LOCKED_FILE
if %cmD%==crackwatcher goto CRACK_WATCHER
:: SAFE_MODE_CMDS
if %cmD%==enablesafe goto ENABLE_SAFEMODE
if %cmD%==disablesafe goto DISABLE_SAFEMODE
if %cmD%==displaysafe echo SAFEMODE_STATUS : %safeMode% && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
if %cmD%==defaultsafe_enabled echo ENABLED > %CustomDir%\defaultSafe.ks && echo Changed Default to : ENABLED && timeout /t 1 /nobreak>nul && set safeMode=ENABLED && goto MAIN_PAGE
if %cmD%==defaultsafe_disabled echo DISABLED > %CustomDir%\defaultSafe.ks && echo Changed Default to : DISABLED && timeout /t 1 /nobreak>nul && set safeMode=DISABLED && goto MAIN_PAGE
if %cmD%==resetdefaultsafe goto RESET_DEFAULT_SAFE
:: PC_DESTROY_PROGRAMS
if %cmD%==getpass goto GETPASSES
if %cmD%==killpc goto KILL_PC_PROGRAM
if %cmD%==swap_mouses RUNDLL32 USER32.DLL.SwapMouseButton && goto MAIN_PAGE
:: DEBUG_MODE_CMDS
if %cmD%==enabledebug goto ENABLED_DEBUG
if %cmD%==disabledebug goto DISABLED_DEBUG
if %cmD%==defaultdebug_enabled echo ENABLED > %CustomDir%\debugModeState.ks && echo Changed Default to : ENABLED && timeout /t 1 /nobreak>nul && set debugMode=ENABLED && goto MAIN_PAGE
if %cmD%==defaultdebug_disabled echo DISABLED > %CustomDir%\debugModeState.ks && echo Changed Default to : DISABLED && timeout /t 1 /nobreak>nul && set debugMode=DISABLED && goto MAIN_PAGE
if %cmD%==displaydebug echo DEBUGMODE_STATUS : %debugMode% && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
if %cmD%==resetdefaultdebug goto RESET_DEFAULT_DEBUG
:: HELP_CMDS
if %cmD%==help goto KS-DISPLAY_COMMANDS
:: EXIT_CMDS
if %cmD%==exit exit
echo ERROR_COMMAND_NOT_FOUND : %cmd% && timeout /t 2 /nobreak>nul && goto MAIN_PAGE

:ENABLED_DEBUG_DEFAULT
if %debugDisabled%==1 echo Debug mode is locked! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
echo ENABLED > %CustomDir%\debugModeState.ks && echo Changed Default to : ENABLED && timeout /t 1 /nobreak>nul && set debugMode=ENABLED && goto MAIN_PAGE

:DISABLED_DEBUG_DEFAULT
if %debugDisabled%==1 echo Debug mode is locked! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
echo DISABLED > %CustomDir%\debugModeState.ks && echo Changed Default to : DISABLED && timeout /t 1 /nobreak>nul && set debugMode=DISABLED && goto MAIN_PAGE

:CRACK_WATCHER
cls
echo.
echo COMMAND_LOCKED : DISCONTINUED && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
set /p crackChecker=Please enter the game name:
set crackChecker=%crackChecker: =-%
echo Preparing crackWatcher Script... && timeout /t 1 /nobreak>nul
if exist %tempfolder%\crackWatcherResult.cc DEL /Q %tempfolder%\crackWatcherResult.cc
echo Downloading Web File...
ping https://steamunlocked.net/%crackChecker%/
if errorlevel 0 echo Game is Cracked
if errorlevel 1 echo Game is not Cracked
pause>nul



:KILL_PC_PROGRAM
if %safeMode%==ENABLED echo Safe Mode is enabled and prohibits use of dangerous commands! && timeout /t 3 /nobreak>nul && goto MAIN_PAGE
cls
echo.
set /p que=Are you sure you want to run KILL_PC Program?[Y/N]
if %que%==n goto MAIN_PAGE
if %que%==N goto MAIN_PAGE
:KILL_PC_PROGRAM_Y  
echo Checking if Script is Installed... && timeout /t 1 /nobreak>nul
if not exist %Library%\Packages\01\package01.bat echo Script not installed, Please install "package01" from installer menu && timeout /t 3 /nobreak>nul && goto MAIN_PAGE
:: UAC_PROMPT
    echo Set UAC = CreateObject^("Shell.Application"^) > "%tempfolder%\getadmin.vbs"
    echo UAC.ShellExecute "%Library%\Packages\01\package01.bat", "/c %~s0 %~1", "", "runas", 1 >> "%tempfolder%\getadmin.vbs"
    start %tempfolder%\getadmin.vbs
echo Executed Script! && timeout /t 2 /nobreak>nul && pause && goto MAIN_PAGE

:GETPASSES
cls
echo.
echo Gathering Potentially Sensitive Data... && timeout /t 1 /nobreak>nul
if exist 

:DELETE_LOCKED_FILE
cls
echo.
set /p cdf=Please enter location of locked file:
:: TO BE DESIGNED

:PROGRAMS-SHERLOCK
cls
echo.
set /p searchUser=Please enter the username:
echo Preparing Sherlock Script... && timeout /t 1 /nobreak>nul
:: DECLARING SHERLOCK VARIABLES
set /a sherlockLoopNum=1
set sherlockWebsite=Reddit.com
set /a sherlockFound=0
set /a sherlockMisses=0
set /a sherlockOneZero=0
set sherlockSearchTerm=NOT_DEFINED6
set sherlockShort=NOT_DEFINED
:: WRITING FILES TO DISK 
if exist %Tempfolder%\SHERLOCK-TEMP rmdir /s /q %Tempfolder%\SHERLOCK-TEMP
md %Tempfolder%\SHERLOCK-TEMP
set sherlockFolder=%Tempfolder%\SHERLOCK-TEMP
:: SETTING DOWNLOALOOP VARS
set /a sherlockDownloadloopNum=1
set sherlockDownloadloopWebsite=www.reddit.com/user/%searchUser%
set sherlockDownloadloopShorts=Reddit
goto PROGRAMS-SHERLOCK_DOWNLOADLOOP 

:PROGRAMS-SHERLOCK_DOWNLOADLOOP
if %sherlockDownloadloopNum%==2 set sherlockDownloadloopWebsite=www.twitch.tv/%searchUser% && set sherlockDownloadloopShorts=Twitch
if %sherlockDownloadloopNum%==3 set sherlockDownloadloopWebsite=www.github.com/%searchUser% && set sherlockDownloadloopShorts=Github
if %sherlockDownloadloopNum%==4 set sherlockDownloadloopWebsite=www.roblox.com/user.aspx?username=%searchUser% && set sherlockDownloadloopShorts=Roblox
if %sherlockDownloadloopNum%==5 set sherlockDownloadloopWebsite=www.api.mojang.com/users/profiles/minecraft/%searchUser% && set sherlockDownloadloopShorts=Minecraft
if %sherlockDownloadloopNum%==6 set sherlockDownloadloopWebsite=www.robertsspaceindustries.com/citizens/%searchUser%/ && set sherlockDownloadloopShorts=StarCitizen
if %sherlockDownloadloopNum%==7 set sherlockDownloadloopWebsite=www.instagram.com/%searchUser%/ && set sherlockDownloadloopShorts=Instagram
if %sherlockDownloadloopNum%==8 set sherlockDownloadloopWebsite=www.clubhouse.com/@%searchUser% && set sherlockDownloadloopShorts=Clubhouse
if %sherlockDownloadloopNum%==9 set sherlockDownloadloopWebsite=www.ask.fm/%searchUser% && set /a sherlockDownloadloopShorts=askFM
if %sherlockDownloadloopNum%==10 goto SHERLOCK_DOWNLOADLOOP-CHKS
cls
echo.
echo Downloading all Web files...(%sherlockDownloadloopNum%/9)
cd %sherlockFolder%
powershell -Command "$progressPreference = 'silentlyContinue' ; $ErrorActionPreference= 'silentlycontinue' ; Invoke-WebRequest %sherlockDownloadloopWebsite% -Outfile %sherlockDownloadloopShorts%"
set /a sherlockDownloadloopNum+=1
goto PROGRAMS-SHERLOCK_DOWNLOADLOOP

:SHERLOCK_DOWNLOADLOOP-CHKS
set /a redownloadLoopCnt=0
findstr /I "%searchUser%" Twitch>NUL
IF ERRORLEVEL 0 (goto SHERLOCK-LOOP) ELSE (goto SHERLOCK_DOWNLOADLOOP-REDOWNLOAD)

:SHERLOCK_DOWNLOADLOOP-REDOWNLOAD
cls
echo.
echo Redownloading Web Files... %redownloadLoopCnt%/1
powershell -Command "$progressPreference = 'silentlyContinue' ; $ErrorActionPreference= 'silentlycontinue' ; Invoke-WebRequest www.twitch.tv/%searchUser% -Outfile Twitch"
if %redownloadLoopCnt%==2 goto SHERLOCK-LOOP
set /a redownloadLoopCnt+=1 && goto SHERLOCK_DOWNLOADLOOP-REDOWNLOAD

:SHERLOCK-LOOP
if %sherlockLoopNum%==1 set sherlockShort=Reddit && set sherlockSearchTerm=u/%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.reddit.com/user/%searchUser%/
if %sherlockLoopNum%==2 set sherlockShort=Twitch && set sherlockSearchTerm=%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.Twitch.tv/%searchUser%/
if %sherlockLoopNum%==3 set sherlockShort=Github && set sherlockSearchTerm=%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.Github.com/%searchUser%/
if %sherlockLoopNum%==4 set sherlockShort=Roblox && set sherlockSearchTerm=content="%searchUser%" && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.roblox.com/user.aspx?username=%searchUser%/
if %sherlockLoopNum%==5 set sherlockShort=Minecraft && set sherlockSearchTerm=%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://api.mojang.com/users/profiles/minecraft/%searchUser%/
if %sherlockLoopNum%==6 set sherlockShort=StarCitizen && set sherlockSearchTerm=%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://robertsspaceindustries.com/citizens/%searchUser%/
if %sherlockLoopNum%==7 set sherlockShort=Instagram && set sherlockSearchTerm=instagram.com/%searchUser%/ && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.instagram.com/%searchUser%/
if %sherlockLoopNum%==8 set sherlockShort=Clubhouse && set sherlockSearchTerm=%searchUser% && set /a sherlockOneZero=1 && set sherlockWebsite=https://www.clubhouse.com/@%searchUser%
if %sherlockLoopNum%==9 set sherlockShort=askFM && set sherlockSearchTerm=Here used to be @%searchUser% profile && set /a sherlockOneZero=0 && set sherlockWebsite=https://ask.fm/%searchUser%
if %sherlockLoopNum%==10 goto SHERLOCKLOOP-COMPLETED
:: SHERLOCK LOOP ----------------------------------------------------------------------------------------------
cls
echo.
echo Searching for %searchUser%...[FOUND: %sherlockFound%,MISSES: %sherlockMisses%]
title Kartana Software - SHERLOCK , Loop Num : %sherlockLoopNum% , SEARCH_ID : %sherlockShort%
echo.
cd %sherlockFolder%
:: CHK_1
if not exist %sherlockShort% goto SHERLOCKLOOP-MIS
:SHERLOCK-WEBSITE_RESPONSE_Y
:: CHK 2
findstr /I "%sherlockSearchTerm%" %sherlockShort%>NUL
IF ERRORLEVEL %sherlockOneZero% (goto SHERLOCKLOOP-MIS) ELSE (goto SHERLOCKLOOP-HIT)
set ERROR_DATA=ILLEGAL_USER_PLACEMENT && goto GLOBAL_ERROR

:SHERLOCKLOOP-MIS
set /a sherlockMisses+=1
set /a sherlockLoopNum+=1
timeout /t 1 /nobreak>nul && goto SHERLOCK-LOOP

:SHERLOCKLOOP-HIT
set /a sherlockFound+=1
echo [90m[[0m[96m+[0m] [96m%sherlockShort%[0m: %sherlockWebsite% >> %sherlockFolder%\SHERLOCK_HITS.log
set /a sherlockLoopNum+=1
timeout /t 1 /nobreak>nul && goto SHERLOCK-LOOP

:SHERLOCKLOOP-COMPLETED
cls
echo.
echo Completed Operation - SHERLOCK_SEARCH : %searchUser%
echo.
if %sherlockFound% GEQ 1 type %sherlockFolder%\SHERLOCK_HITS.log
if %sherlockFound%==0 echo No Accounts Recognized!
echo.
pause>nul
rmdir /s /q %Tempfolder%\SHERLOCK-TEMP
goto MAIN_PAGE

:RUN_INSTALLER-PRECHK
cls
echo.
echo Running Installer Prechecks... && timeout /t 1 /nobreak>nul
if not exist %root%\Library echo Error %Root%\Library not found! && timeout /t 1 /nobreak>nul && goto MAIN_PAGE
:: INSTALLLER_NAME_DISPLAYS
set installerGUIname=NOT_DEFINED
set installerAPPname=NOT_DEFINED
set installURL=UNDEFINED_BY_APP
set installPackage=UNEFINED_BY_APP
set packageID=UNDEFINED_BY_APP
set debugPackageID=UNDEFINED_BY_APP
:: INSTALLER_LINK_DESTINATION
set installerLinkDest=NOT_DEFINED
echo Succesfully Completed all Pre-Checks! && goto RUN_INSTALLER
:RUN_INSTALLER
cls
echo.
echo  :::  .    :::.    :::::::.. :::::::::::::::.   :::.    :::.  :::.     
echo  ;;; .;;,. ;;`;;   ;;;;``;;;;;;;;;;;;'''';;`;;  `;;;;,  `;;;  ;;`;;    
echo  [[[[[/'  ,[[ '[[,  [[[,/[[['     [[    ,[[ '[[,  [[[[[. '[[ ,[[ '[[,  
echo _$$$$,   c$$$cc$$$c $$$$$$c       $$   c$$$cc$$$c $$$ "Y$c$$c$$$cc$$$c 
echo "888"88o, 888   888,888b "88bo,   88,   888   888,888    Y88 888   888,
echo  MMM "MMP"YMM   ""` MMMM   "W"    MMM   YMM   ""` MMM     YM YMM   ""` 
echo.
echo.
set /p Cmd2="> "
echo.
:: DISPLAY HELP /W INSTALLER
if %cmD2%==installist goto INSTALLER_LISTDISK
:: INSTALL_PACKAGES
if %cmD2%==install_doser goto INSTALLER_LOOP
if %cmD2%==install_cracker goto INSTALLER_LOOP
if %cmD2%==install_malware1 goto INSTALLER_LOOP
if %cmD2%==install_custom goto INSTALLER_LOOP-CUSTOM
:: INSTALL_PACKAGES_CMDS
if %cmD2%==install_package01 set installPackage=01 && goto INSTALL_PACKAGES
if %cmD2%==install_package02 set installPackage=02 && goto INSTALL_PACKAGES
:: DELETE_PACKAGES_CMDS
if %cmD2%==delete_package01 set packageID=01 && goto DELETE_PACKAGES
if %cmD2%==delete_package02 set packageID=02 && goto DELETE_PACKAGES
:: CHECKS_PACKAGE_STATUS
if %cmD2%==check_package01 set packageID=01 && goto CHECK_PACKAGES
:: EXTRA_CMDS
if %cmD2%==delete_metadata01 set packageID=01 && goto DELETE_METADATA
if %cmD2%==return goto MAIN_PAGE
echo ERROR_COMMAND_NOT_FOUND : %Cmd2% && timeout /t 2 /nobreak>nul && goto RUN_INSTALLER

:DELETE_METADATA
set packageID=%packageID: =%
cls
echo.
echo Checking if Package%packageID% exists... && timeout /t 1 /nobreak>nul
if not exist %Library%\Packages\%packageID%\package%packageID%.bat echo Package%packageID% Doesnt exist! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
if not exist %Library%\Packages\%packageID%\Metadata.ks echo Package%packageID% Metadata doesnt exist! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
echo Deleting Package%packageID% Metadata... && timeout /t 1 /nobreak>nul
DEL /Q %Library%\Packages\%packageID%\Metadata.ks && echo Succesfully Deleted : Package%packageID%! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER

:CHECK_PACKAGES
set packageID=%packageID: =%
cls
echo.
echo Verifying Package%packageID% Presence... && timeout /t 1 /nobreak>nul
if not exist %Library%\Packages\%packageID%\package%packageID%.bat echo Package%packageID% Doesnt exist! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
if not exist %Library%\Packages\%packageID%\Metadata.ks echo Package%packageID% Metadata doesnt exist! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
echo Getting Package%packageID% MetaData... && timeout /t 1 /nobreak>nul
setLocal EnableDelayedExpansion
for /f "tokens=* delims= " %%a in (%Library%\Packages\%packageID%\MetaData.ks) do (
set /a N+=1
set v!N!=%%a
)
set packageInstalledOn=!v1!
set packageInstalledWhen=!v2!
set packageInstalledByte=!v3!
set packageOrigin=!v4!
:: DISPLAYING_DATA
echo.
echo Package%packageID% Metadata
echo --------------------------------------
echo Installed Date : %packageInstalledOn%
echo Installed Time : %packageInstalledWhen%
echo Script Byte Size : %packageInstalledByte%
if %debugMode%==ENABLED echo Script Download Origin : %packageOrigin%
echo.
pause>NUL
goto RUN_INSTALLER

goto RUN_INSTALLER
:DELETE_PACKAGES
set packageID=%packageID: =%
cls 
echo.
echo Verifying Package%packageID% Presence... && timeout /t 1 /nobreak>nul
if not exist %Library%\Packages\%packageID%\package%packageID%.bat echo Package%packageID% Doesnt exist! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
echo Deleting Package%packageID% from Library... && timeout /t 1 /nobreak>nul && rmdir /S /Q %Library%\Packages\%packageID% && echo Package%packageID% Succesfully Deleted! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
goto RUN_INSTALLER

:INSTALL_PACKAGES
set installPackage=%installPackage: =%
cls
echo.
echo Verifying Package%installPackage% Presence... && timeout /t 1 /nobreak>nul
if exist %Library%\Packages\%installPackage%\package%installPackage%.bat echo ERROR_PACKAGE%installPackage%_ALREADY_PRESENT && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
echo Verifying Internet Connection... && timeout /t 1 /nobreak>nul
:: RUNNING_GOOGLE_CHK 
Ping www.google.com -n 1 -w 1000>NUL
if errorlevel 0 echo Internet Connection Succesfully Established! && timeout /t 1 /nobreak>nul
if errorlevel 1 echo No Internet Connection Established! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER 
echo Installing Script Package : %installPackage% && timeout /t 1 /nobreak>nul
if exist %Library%\Packages\%installPackage% rmdir /s /q %Library%\Packages\%installPackage%
md %Library%\Packages\%installPackage%
cd %Library%\Packages\%installPackage%
set packageDebug=package%installPackage%.bat
if %installPackage%==01 set installURL=https://raw.githubusercontent.com/SpicyCuba/MAIN_SERVER/main/KartanaSoftware/package01.package
if %installPackage%==02 set installURL=UNDEFINED
powershell -Command "$progressPreference = 'silentlyContinue' ; Invoke-WebRequest %installURL% -Outfile %packageDebug%"
if exist %Library%\Packages\%installPackage%\package%installPackage%.bat echo Succesfully Installed Package : %installPackage%! && timeout /t 1 /nobreak>nul
if not exist %Library%\Packages\%installPackage%\package%installPackage%.bat echo Error whilst installing Package : %installPackage%! && timeout /t 1 /nobreak>nul 
:: METADATA
echo Writing MetaData to Library... && timeout /t 1 /nobreak>nul
:: DATE
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined tempDataHolder set tempDataHolder=%%x
set fixedDate=%tempDataHolder:~4,2%-%tempDataHolder:~6,2%-%tempDataHolder:~0,4%
echo %fixedDate% > %Library%\Packages\%installPackage%\Metadata.ks
:: TIME
set fixedTime=%time: =%
echo %fixedTime% >> %Library%\Packages\%installPackage%\Metadata.ks
:: SIZE
FOR /F "usebackq" %%A IN ('%Library%\Packages\%installPackage%\package%installPackage%.bat') DO set packageSize=%%~zA
echo %packageSize% >> %Library%\Packages\%installPackage%\Metadata.ks
:: DOWNLOAD_ORIGIN
echo %installURL% >> %Library%\Packages\%installPackage%\Metadata.ks
goto RUN_INSTALLER

:INSTALLER_LOOP
cls
echo.
echo Verifying Internet Connection... && timeout /t 1 /nobreak>nul
:: RUNNING_GOOGLE_CHK 
Ping www.google.com -n 1 -w 1000>NUL
if errorlevel 0 echo Internet Connection Succesfully Established! && timeout /t 1 /nobreak>nul
if errorlevel 1 echo No Internet Connection Established! && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER 
echo Verifying URL Legitamcy... && timeout /t 1 /nobreak>nul
Ping %installURL% -n 1 -w 1000>NUL
if errorlevel 0 echo Connection Succesfully Established : %installURL% && cd .
if errorlevel 1 echo Error No Response from : %installURL% && timeout /t 1 /nobreak>nul && goto RUN_INSTALLER
timeout /t 1 /nobreak>nul
:INSTALLER_LOOP-MAIN
cd %Tempfolder%
echo Downloading Web File... && timeout /t 1 /nobreak>NUL
powershell -Command "Invoke-WebRequest %installURL% -Outfile DOWNLOADED_FILE.cc"
set /p newFilename=What do you want to rename the downloaded file to:
rename DOWNLOADED_FILE.cc %newFilename%
start %newFilename%
pause>nul
goto RUN_INSTALLER

:INSTALLER_LISTDISK
echo.
echo installist : Lists all install options
echo install_packages : Installs Script Packages
echo install_doser : Installs Kartana Softwares doser program
echo install_cracker : Installs open sourche cracker program 
echo install_malware1 : Installs Kartana Softwares malware
echo install_custom : Allows the user to put in a custom URL that KS will download!
echo.
pause>nul
goto RUN_INSTALLER

:INSTALLER_LOOP-CUSTOM
set /p installURL=Please enter your custom URL:
goto INSTALLER_LOOP


:RESTART_APP
set CurrentLocation=%~dp0
if exist RESTART_FILE.bat DEL /Q %tmp%\RESTART_FILE.bat
:: CREATING_RESTARTFILE
echo start %CurrentCD%\

:KS-DISPLAY_COMMANDS
echo.
echo startproxy : starts proxy (Settings)
echo startwebanalysis : starts web analyser
echo startfile_analyser : starts file analyser
echo console : start console
echo help : displays commands
echo runsherlock : starts program that searches username of sites E.G: Reddit,Youtube,Tiktok
echo exit : exits application
echo.
pause>nul
goto MAIN_PAGE

:KS-CP
cls
echo.
echo  :::  .    :::.    :::::::.. :::::::::::::::.   :::.    :::.  :::.     
echo  ;;; .;;,. ;;`;;   ;;;;``;;;;;;;;;;;;'''';;`;;  `;;;;,  `;;;  ;;`;;    
echo  [[[[[/'  ,[[ '[[,  [[[,/[[['     [[    ,[[ '[[,  [[[[[. '[[ ,[[ '[[,  
echo _$$$$,   c$$$cc$$$c $$$$$$c       $$   c$$$cc$$$c $$$ "Y$c$$c$$$cc$$$c 
echo "888"88o, 888   888,888b "88bo,   88,   888   888,888    Y88 888   888,
echo  MMM "MMP"YMM   ""` MMMM   "W"    MMM   YMM   ""` MMM     YM YMM   ""` 
echo.
echo ++++++++++++++++++++++++++++++++++++++
echo Proxy Status = "%ProxyStatus%"
echo Proxy IP = "%ProxyIP%"
echo ++++++++++++++++++++++++++++++++++++++
echo.
ECHO 1 - Setup Proxy
ECHO 2 - Configure Proxy Service AutoStart
echo.
ECHO 3 - Return
echo.
set/p opt=Please select an option:
if %opt% equ 1 goto KS-SP
if %opt% equ 2 goto CP-CPL
if %opt% equ 3 goto MAIN_PAGE

:KS-SP
cls
echo.
echo Everytime you restart the application without properly quitting the application a proxy service will continue PLEASE EXIT APP VIA MENU
echo.
ECHO 1 - Build-In Proxys
ECHO 2 - Custom Proxys
ECHO.
echo 3 - Return
echo.
set/p opt=Please select an option:
if %Opt%==1 goto KS-KIP
if %Opt%==2 goto KS-CUSTOM_PROXY
if %opt%==3 goto KS-CP

:DEBUG_LOG
echo error detected
pause
goto MAIN_PAGE

:ENABLE_PROXY_GEN
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /d 1 /t REG_DWORD /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d %customProxy% /f
set /a ProxyStatus=ON
set /a ProxyIP=%customProxy%
echo Applied settings to PC! && timeout /t 1 /nobreak>nul
goto KS-CP

:KS-CUSTOM_PROXY
cls
echo.
echo Please enter your custom proxy below
echo.
ECHO Format Example : 127.0.0.1:8080
echo.
set /p customProxy="> "
goto ENABLE_PROXY

:KS-KIP
cls
echo Checking in the Built-In Proxys are online. . .
timeout /t 1 /nobreak>nul
echo.
ping 169.57.1.85 -n 1>nul
set FIRSTPROXY=
if errorlevel 1 set FIRSTPROXY=OFFLINE 
if errorlevel 0 set FIRSTPROXY=ONLINE
rem ------------------2------------------------
cd .
ping 194.5.193.183 -n 1>nul
set SECONDPROXY=
if errorlevel 1 set SECONDPROXY=OFFLINE
if errorlevel 0 set SECONDPROXY=ONLINE
rem ---------------------3--------------------------
cd .
ping 173.244.200.154 -n 1>nul
set THIRDPROXY=
if errorlevel 1 set THIRDPROXY=OFFLINE
if errorlevel 0 set THIRDPROXY=ONLINE
rem -------------------4---------------------------
echo Finished Checks!
timeout /t 1 /nobreak>nul
cls
echo.
echo List of 3 Proxy(s) - [list from https://geonode.com/free-proxy-list/]
echo.
echo 169.57.1.85 [STATUS_%FIRSTPROXY%] - [PORT_8123] -[MEX]
echo 194.5.193.183 [STATUS_%SECONDPROXY%] - [PORT_80] - [NL]
echo 173.244.200.154 [STATUS_%THIRDPROXY%] - [PORT_36852] - [USA]
echo.
set /p selectedProxy=Select 1, 2 or 3:
:: SETTING_VARS
if %selectedProxy%==1 set customProxy=169.57.1.85:8123
if %selectedProxy%==2 set customProxy=194.5.193.183:80
if %selectedProxy%==3 set customProxy=173.244.200.154:36852
goto ENABLE_PROXY_GEN

pause>nul
goto KS-CP

:CP-CPS
cls
echo.
echo Changing Proxy Status. . .STATUS_%ProxyStatus%
timeout /t 1 /nobreak>nul
if %ProxyStatus%==ON goto CP-CPS_OFF
if %ProxyStatus%==OFF goto CP-CPS_ON

:CP-CPS_OFF
set ProxyStatus=OFF
goto KS-CP

:CP-CPS_ON
set ProxyStatus=ON
goto KS-CP

:KS-ERROR_GLOBAL
cls
echo.
echo Gathering Error Report Info. . .
if %OPT% == [] set OPT_Report=EMPTY_VARIABLE
if %Que% == [] set QUE_Report=EMPTY_VARIABLE
if %Command% == [] set COM_Report=EMPTY_VARIABLE
echo Done!
timeout /t 1 /nobreak>nul
cls
echo.
echo Error Report -[TYPE_GLOBAL]
echo.
echo OPT Variable Data = [%OPT_Report%]
echo Question Variable Data = [%QUE_Report%]
echo Command Variable Data = [%COM_Report%]
echo.
echo Last Log Entry = [NOT_BUILD_YET]
pause
goto MAIN_PAGE

:GLOBAL_ERROR
cd %Tempfolder%
cls
echo.
echo Application Global Error
echo ------------------------------------
echo.
echo Error MetaData : %ERROR_DATA%
::if exist GLOBAL_ERROR_MESSAGE.vbs DEL /Q GLOBAL_ERROR_MESSAGE.vbs
::echo x=msgbox("ERROR_ENCOUNTERD : %ERROR_DATA%", 1+16, "Kartana Software %Version%") > GLOBAL_ERROR_MESSAGE.vbs
::start GLOBAL_ERROR_MESSAGE.vbs
pause>nul && goto MAIN_PAGE

:ENABLED_DEBUG
if %debugMode%==ENABLED echo Debug Mode is already enabled! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
set debugMode=ENABLED && goto MAIN_PAGE

:DISABLED_DEBUG
if %debugMode%==DISABLED echo Debug Mode is already disabled! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
set debugMode=DISABLED && goto MAIN_PAGE

:RESET_DEFAULT_DEBUG
if exist %CustomDir%\debugModeState.ks DEL /Q debugModeState.ks && echo Resetted Default State! && timeout /t 1 /nobreak>nul && goto MAIN_PAGE

:RESET_DEFAULT_SAFE
if exist %CustomDir%\defaultSafe.ks DEL /Q defaultSafe.ks && echo Resetted Default State! && timeout /t 1 /nobreak>nul && goto MAIN_PAGE

:ENABLE_SAFEMODE
if %safeMode%==ENABLED echo Safe Mode is already enabled! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
set safeMode=ENABLED && goto MAIN_PAGE

:DISABLE_SAFEMODE
if %safeMode%==DISABLED echo Safe Mode is already disabled! && timeout /t 2 /nobreak>nul && goto MAIN_PAGE
set safeMode=DISABLED && goto MAIN_PAGE
