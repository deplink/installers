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
OutputBaseFilename=Deplink Setup

; Windows Environment
ChangesEnvironment=true

[Files]
Source: "src\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs 

[Tasks]
Name: envPath; Description: "Add to PATH variable"    

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