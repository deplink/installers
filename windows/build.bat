:: Cleanup previous artifacts
rmdir /S /Q tmp 2>nul
rmdir /S /Q output 2>nul

:: Clone and build Deplink CLI
git clone https://github.com/deplink/deplink tmp
git -C tmp checkout %1
call composer run-script build --working-dir tmp
cp tmp/bin/deplink.phar src/bin/deplink.phar

:: Create setup file
iscc installer.iss