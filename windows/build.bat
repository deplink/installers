:: Get first argument (deplink version),
:: or use master if version not set.
set tag=%1
set version=%1
if ["%version%"]==[""] (
    set tag=latest
    set version=master
)

:: Download PHP for Windows
if not exist "src\php" (
	mkdir tmp
	curl -L https://windows.php.net/downloads/releases/archives/php-7.1.10-Win32-VC14-x86.zip -o tmp/php-7.1.10.zip
	unzip tmp/php-7.1.10.zip -d src/php
	rmdir /S /Q tmp

	cp src/php/php.ini-production src/php/php.ini
	sed -i 's/;extension=php_openssl.dll/extension=php_openssl.dll/g' src/php/php.ini
	sed -i 's/; extension_dir = "ext"/extension_dir = "ext"/g' src/php/php.ini
)

exit \b

:: Download C++ Redistributable for Visual Studio 2015
if not exist "src\vc14" (
	mkdir src\vc14
	curl -L https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe -o src/vc14/vc_redist.x86.exe
)

:: Clone and build Deplink CLI
if not exist "output\deplink-%tag%.exe" (
	git clone https://github.com/deplink/deplink tmp
	git -C tmp checkout %version%
	call composer run-script build --working-dir tmp
	cp tmp/bin/deplink.phar src/bin/deplink.phar
	rmdir /S /Q tmp
)

:: Create setup file
iscc installer.iss
move output\deplink.exe "output\deplink-%tag%.exe"
