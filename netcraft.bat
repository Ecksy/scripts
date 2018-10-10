@echo off
cls
:start
echo ---------------------------------
echo **** Netcraft Domain Check ****
SET /p domain="Enter domain name to check: "
START  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://toolbar.netcraft.com/site_report?url=%domain%^&refresh=1#history_table
#START  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.shodan.io/search^?query=%ip_addr%
set choice=
set /p choice="Do you want to restart? Press 'e' for Yes, 'Enter' to quit:"
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='e' goto start
@echo on
