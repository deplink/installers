:: Turn off printing called commands in console
:: (user will see only output of the deplink command)
@echo off

:: The "%~dp0" returns path of the current file,
:: after installation it's the path to a "bin" directory
:: in installation folder (equivalent to iss "{app}\bin").
"%~dp0\..\php\php.exe" "%~dp0\deplink.phar" %*
