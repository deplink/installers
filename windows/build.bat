:: Download PHP for Windows
if not exist "src\php" (
	mkdir tmp
	curl -L http://windows.php.net/downloads/releases/php-7.1.10-Win32-VC14-x86.zip -o tmp/php-7.1.10.zip
	unzip tmp/php-7.1.10.zip -d src/php
	rmdir /S /Q tmp
)

:: Download C++ Redistributable for Visual Studio 2015
if not exist "src\vc14" (
	mkdir src\vc14
	curl -L https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe -o src/vc14/vc_redist.x64.exe
	curl -L https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe -o src/vc14/vc_redist.x86.exe
)

:: Clone and build Deplink CLI
if not exist "src\bin\deplink.phar" (
	git clone https://github.com/deplink/deplink tmp
	git -C tmp checkout %1
	call composer run-script test --working-dir tmp
	call composer run-script build --working-dir tmp
	cp tmp/bin/deplink.phar src/bin/deplink.phar
	rmdir /S /Q tmp
)

:: Create setup file
iscc installer.iss