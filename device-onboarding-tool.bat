@echo off
setlocal

:: Copyright 2024 Tyshawn Jones
:: Author: JONESTU (Tyshawn Jones)

:: Define file paths
set "xml_file=%~dp0ncpspnetwork.xml"
set "name_file=%~dp0pc_name.txt"
set "skip_file=%~dp0skip_network.txt"

:: Check if name and skip files exist to determine next action
if exist %name_file% (
    set /p "new_name=" < %name_file%
    if exist %skip_file% (
        goto rename_only
    ) else if exist %xml_file% (
        goto rename_and_connect
    )
)

:: Retrieve computer serial number and create PC name
for /f "tokens=2 delims==" %%i in ('wmic bios get serialnumber /value') do set "serial=%%i"
set /p "school_name=Enter the school name: "
set "new_name=%school_name%-%serial%"
echo %new_name% > %name_file%

:: Ask if user wants to connect to ncpsp network
set /p "connect_choice=Do you want to connect to ncpsp network? (y/n): "

if /i "%connect_choice%"=="y" (
    set /p password=Enter the ncpsp network password: 
    > %xml_file% (
        echo ^<?xml version="1.0"?^>
        echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
        echo     ^<name^>ncpsp^</name^>
        echo     ^<SSIDConfig^>
        echo         ^<SSID^>
        echo             ^<hex^>6e63707370^</hex^>
        echo             ^<name^>ncpsp^</name^>
        echo         ^</SSID^>
        echo     ^</SSIDConfig^>
        echo     ^<connectionType^>ESS^</connectionType^>
        echo     ^<connectionMode^>auto^</connectionMode^>
        echo     ^<MSM^>
        echo         ^<security^>
        echo             ^<authEncryption^>
        echo                 ^<authentication^>WPA2PSK^</authentication^>
        echo                 ^<encryption^>AES^</encryption^>
        echo                 ^<useOneX^>false^</useOneX^>
        echo             ^</authEncryption^>
        echo             ^<sharedKey^>
        echo                 ^<keyType^>passPhrase^</keyType^>
        echo                 ^<protected^>false^</protected^>
        echo                 ^<keyMaterial^>%password%^</keyMaterial^>
        echo             ^</sharedKey^>
        echo         ^</security^>
        echo     ^</MSM^>
        echo     ^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^>
        echo         ^<enableRandomization^>false^</enableRandomization^>
        echo     ^</MacRandomization^>
        echo ^</WLANProfile^>
    )
    goto rename_and_connect
) else (
    type NUL > %skip_file%
    goto rename_only
)

:: Rename computer and connect to the ncpsp network
:rename_and_connect
netsh wlan add profile filename=%xml_file% interface="Wi-Fi"
wmic computersystem where name="%computername%" call rename name="%new_name%" > NUL 2>&1
netsh wlan connect name="ncpsp" ssid="ncpsp" interface="Wi-Fi"
goto end

:: Rename computer only
:rename_only
wmic computersystem where name="%computername%" call rename name="%new_name%" > NUL 2>&1
goto end

:end
echo "Computer renamed to %new_name%."
pause
exit /b
