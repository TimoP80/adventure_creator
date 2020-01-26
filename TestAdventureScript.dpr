program TestAdventureScript;

uses
  Forms,
  AdventureScript in 'AdventureScript.PAS',
  fTestAdventureScript in 'fTestAdventureScript.pas' {fmTestAdventureScript}
  , CocoBase in 'C:\Program Files (x86)\CocoR for Delphi\Frames\CocoBase.pas'  ;

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmTestAdventureScript, fmTestAdventureScript);
  Application.Run;
end.    
