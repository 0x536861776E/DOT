@echo off
setlocal

:choose_network
echo Select the network:
echo 1. ncpsp
echo 2. DOEGuest
set /p choice=Enter your choice (1 or 2): 

if "%choice%"=="1" (
    set network_name=ncpsp
    set network_hex=6e63707370
) else if "%choice%"=="2" (
    set network_name=DOEGuest
    set network_hex=444F454775657374
) else (
    echo Invalid choice. Please select 1 or 2.
    goto choose_network
)

:ask_password
set /p password=Enter the network password: 

:list_usb_drives
echo Available USB drives:
wmic logicaldisk where "drivetype=2" get deviceid, volumename, description
echo.

:ask_drive
set /p drive_letter=Enter the USB drive letter (e.g., E): 
set drive_letter=%drive_letter:~0,1%
if not exist %drive_letter%:\ (
    echo Drive %drive_letter% does not exist. Please enter a valid drive letter.
    goto ask_drive
)

:create_xml
set xml_path=%drive_letter%:\%network_name%.xml
(
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
) > "%xml_path%"

echo XML file "%network_name%.xml" has been created successfully on drive %drive_letter%.

:install_profile
echo Adding the profile to the system...
netsh wlan add profile filename="%xml_path%" user=all

:connect_network
echo Connecting to %network_name%...
netsh wlan connect name=%network_name%

echo Waiting for connection...
timeout /t 10 >nul

:check_connection
set connected_ssid=
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr /r /c:"SSID.*:"') do set connected_ssid=%%a
set connected_ssid=%connected_ssid:~1%
if /i "%connected_ssid%"=="%network_name%" (
    echo Successfully connected to %network_name%.
) else (
    echo Failed to connect to %network_name%. Connected to "%connected_ssid%" instead.
    echo Please check the credentials and try again.
)

pause
