@echo off
cls
:start
echo ---------------------------------
echo **** Shodan IP Checker ****
SET /p ip_addr="Enter IP address to check: "
START  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.shodan.io/host/%ip_addr%
#START  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.shodan.io/search^?query=%ip_addr%
set choice=
set /p choice="Do you want to restart? Press 'e' for Yes, 'Enter' to quit: "
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='e' goto start
@echo on