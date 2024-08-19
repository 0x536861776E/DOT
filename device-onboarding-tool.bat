@echo off
setlocal

:: Copyright 2024 Tyshawn Jones
:: Author: JONESTU (Tyshawn Jones)

:: Define file paths
set "xml_file=%~dp0network.xml"
set "ssid_file=%~dp0ssid.txt"
set "name_file=%~dp0pc_name.txt"

:: Auto-run if essential files exist
if exist %xml_file% if exist %name_file% if exist %ssid_file% (
    set /p "network_name=" < %ssid_file%
    set /p "new_name=" < %name_file%
    goto rename_and_connect
)

:network_selection
set /p choice=Select the network (1=ncpsp, 2=DOEGuest): 
if "%choice%"=="1" (
    set "network_name=ncpsp"
    set "network_hex=6e63707370"
) else if "%choice%"=="2" (
    set "network_name=DOEGuest"
    set "network_hex=444F454775657374"
) else (
    echo Invalid choice. Please try again.
    goto :network_selection
)
echo %network_name% > %ssid_file%

set /p password=Enter the network password: 

:: Prompt for PC name
set /p "new_name=Enter the new computer name: "
echo %new_name% > %name_file%

:: Create the XML profile file if not found
> %xml_file% (
    echo ^<?xml version="1.0"?^>
    echo ^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>
    echo     ^<name^>%network_name%^</name^>
    echo     ^<SSIDConfig^>
    echo         ^<SSID^>
    echo             ^<hex^>%network_hex%^</hex^>
    echo             ^<name^>%network_name%^</name^>
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

:rename_and_connect
:: Rename the computer
wmic computersystem where name="%computername%" call rename name="%new_name%" >nul 2>&1

:: Add network profile and connect
netsh wlan add profile filename=%xml_file% user=current
netsh wlan connect name=%network_name%
pause
