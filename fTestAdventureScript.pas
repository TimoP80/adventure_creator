unit fTestAdventureScript;

interface

uses
  Classes,
  ComCtrls,
  Forms,
  Buttons,
  ExtCtrls,
  StdCtrls,
  Dialogs,
  Controls,
  SysUtils,
  AdventureScript;

type
  TfmTestAdventureScript = class(TForm)
    pnlButtons: TPanel;
    pnlSource: TPanel;
    pnlOutput: TPanel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    memSource: TMemo;
    memOutput: TMemo;
    splSourceOutput: TSplitter;
    btnOpen: TButton;
    btnSave: TButton;
    btnExecute: TButton;
    procedure btnExecuteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure memSourceChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FAdventureScript: TAdventureScript;
  public
    property AdventureScript : TAdventureScript read FAdventureScript write FAdventureScript;
  end;

var
  fmTestAdventureScript: TfmTestAdventureScript;

implementation

{$R *.DFM}


procedure TfmTestAdventureScript.FormCreate(Sender: TObject);
begin
  FAdventureScript := TAdventureScript.Create(nil);
end;

procedure TfmTestAdventureScript.FormDestroy(Sender: TObject);
begin
  if Assigned(FAdventureScript) then
    FAdventureScript.Free;
end;

procedure TfmTestAdventureScript.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    memSource.Clear;
    memSource.Lines.LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TfmTestAdventureScript.btnSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    memSource.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TfmTestAdventureScript.btnExecuteClick(Sender: TObject);
begin
  memSource.Lines.SaveToStream(AdventureScript.SourceStream);
  AdventureScript.Execute;
  memOutput.Clear;
  memOutput.Lines.LoadFromStream(AdventureScript.ListStream);
end;

procedure TfmTestAdventureScript.memSourceChange(Sender: TObject);
begin
  btnSave.Enabled := memSource.Text > '';
end;

end.    
