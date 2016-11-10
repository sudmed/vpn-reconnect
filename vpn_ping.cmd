@echo off
cmdow @ /HID
echo %date% %time% --- STARTED --- >> pinger.log
set Try=1
rem имя подключения
set DialName=VPN_user1
rem таймаут пинга в мс
set TimeOut=10000
rem количество попыток пинга
set MaxPing=5
rem пауза в сек
set Pause=30
rem адрес хоста в vpn-сети для пинга
set host=hoshname1
:start
echo.
echo start ping
ping %host% -n 1 -w %TimeOut%
if errorlevel=1 goto bad
goto ok
:ping
echo.
ping %host% -n 1 -w %TimeOut%
if not errorlevel=1 goto ok
set /a Try=%Try%+1
if %Try% geq %MaxPing% goto bad
goto ping
:ok
echo.
echo OK
goto end
:bad
set /a Try=1
echo.
echo BAD CONNECT
echo %date% %time% --! Trouble, reconnect !-- >> pinger.log
rasdial %DialName% /disconnect
rasphone -d %DialName%
if errorlevel=1 goto bad
goto ping
:end
rem goto ping
set /a Try=1
echo.
choice.exe /C:PRDE /D:P /T:60 /N /M "[P]ing [R]econnect [D]isconnect [E]xit?"
goto %ERRORLEVEL%
:1
goto ping
:2
goto bad
:3
rasdial %DialName% /disconnect
:4
echo %date% %time% == Exit script == >> pinger.log
