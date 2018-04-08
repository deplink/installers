#include "environment.iss"

[Setup] 
; Application Metadata
AppName=Deplink
AppVerName=Deplink Dependency Manager
AppPublisher=The Deplink Community
AppPublisherURL=https://deplink.org/ 

SetupIconFile=src\deplink.ico
UninstallDisplayIcon={app}\deplink.ico

; Output Artifacts
DefaultDirName={pf}\Deplink
OutputDir=output
OutputBaseFilename=deplink

; Windows Environment
ChangesEnvironment=true

[Files]
Source: "src\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs 

[Tasks]
Name: envPath; Description: "Add to PATH variable"
Name: vc14; Description: "Install VC14 (2015)"

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
    if (CurStep = ssPostInstall) and IsTaskSelected('envPath')
    then EnvAddPath(ExpandConstant('{app}') +'\bin');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep = usPostUninstall
    then EnvRemovePath(ExpandConstant('{app}') +'\bin');
end;

[Run]
// https://blogs.msdn.microsoft.com/astebner/2010/10/20/mailbag-how-to-perform-a-silent-install-of-the-visual-c-2010-redistributable-packages/
Filename: "{app}\vc14\vc_redist.x86.exe"; Parameters: "/passive /norestart"; Check: IsTaskSelected('vc14')
