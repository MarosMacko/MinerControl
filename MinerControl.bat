@ECHO off
::if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit ) &::For debugging only

::USER CONFIG
SET minerProcess=ccminer.exe   &:: Process name of your miner software (you can find it out in the Task Manager)
SET /a checkDelay=10           &:: Delay (approx) between checks (can be low) in seconds
SET /a resetFreq=1             &:: Delay (approx) between miner restarts in minutes (0=never)
SET color=0a                   &:: Color of the console background and text. 0-9,A-F (hexadecimal). Type "color /?" in empty Command prompt window to find what's what
                                :: Don't forget to change the START command with your miner settings
::END OF USER CONFIG

::
ECHO Get the latest version at github.com/MarosMacko/MinerControl
ECHO You can buy me a cryptocoffee - Adresses in the batch file 
:: 
::BTC: 1bGDkc2577mAryFfodTX9ByoMXjBATq3B
::BCH: 1AHo7fPUFoZYQgCc4ivVadaYRk9BXxsoFP
::LTC: LcnTUd7C3kQQsZq1s3vgYSo6DLbX8NSGu9
::XMR: 47LDu6TLnSHa1QPSARpxnK7PwMFtSuaQcDayKGoFkjnuEA6hK4V5xZPVNJT1GWbdUBRn5GZQNLZtbK7nDGkZoqoqRN3asDi
::

COLOR %color%
set VERSION=1.0
TITLE Miner controller v%VERSION%
ECHO [%TIME%] Miner controller v%VERSION% started
SET /a delayer=0

IF NOT %resetFreq%==0 (
  SET /a resetDelay=%checkDelay%*60*%resetFreq%
) ELSE (
  SET /a resetDelay=0
)

:MAIN

  TASKLIST | FIND /i "%minerProcess%" && ECHO [%TIME%] %minerProcess% running OK. || CALL :startminer
  SET /a restart=(%resetDelay%-%delayer%)/60
  
  IF NOT "%resetDelay%" EQU "0" ECHO Scheduled restart in %restart%min.
  
  IF "%delayer%" GTR "%resetDelay%" (
  
    IF NOT "%resetDelay%" EQU "0" (
	  CALL :RESETMINER
	  ECHO [%TIME%] %minerProcess% - scheduled restart completed.
	  SET /a delayer=0
	) ELSE (
	  TIMEOUT %checkDelay%
	)
	
  ) ELSE (
  
	SET /a delayer=%delayer%+%checkDelay%
	TIMEOUT %checkDelay% /nobreak
	REM Delete /nobreak if you want to skip the 'Wait' sequences by pressing any key
	
  )

  GOTO MAIN

EXIT /B %ERRORLEVEL%


:STARTMINER

  ECHO [%TIME%] Starting %minerProcess%
  ::REPLACE WITH YOUR MINER CONFIG
  ::
  START ccminer -o stratum+tcp://address:port -u wallet -p x
  ::
  ::REPLACE WITH YOUR MINER CONFIG

EXIT /B


:RESETMINER

  ::SET /a delayer=0
  ECHO [%TIME%] Killing miner...
  TASKLIST | FIND /i "%minerProcess%" && taskkill /im %minerProcess% /F || ECHO [%TIME%] Can't kill %minerProcess% - not running.
  CALL :STARTMINER

EXIT /B