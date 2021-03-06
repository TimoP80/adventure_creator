unit ChoiceCommandsForm;

interface

uses
  Winapi.Windows, AdventureFile,masks, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, AdventureBinary, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm4 = class(TForm)
    grp1: TGroupBox;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lstcommands: TListBox;
    btn8: TButton;
    btn9: TButton;
    cbbcmd: TComboBox;
    cbbvarsel: TComboBox;
    mmoparamval: TMemo;
    Button1: TButton;
    ScriptSelector: TComboBox;
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure cbbcmdClick(Sender: TObject);
    procedure cbbvarselClick(Sender: TObject);
    procedure mmoparamvalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstcommandsClick(Sender: TObject);
    procedure ScriptSelectorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  command: IXMLCMDType;

procedure UpdateChoiceCommands;

implementation

{$R *.dfm}

uses AdventureCreatorIDEMain;

procedure UpdateChoiceCommandSel;
var
  i: integer;
begin
  i := Form4.lstcommands.itemindex;
  if commandlist.CMD[i].Variable <> '' then
    Form4.lstcommands.items[i] := commandlist.CMD[i].Name + '(' +
      commandlist.CMD[i].Variable + ') ' + commandlist.CMD[i].Text
  else

    Form4.lstcommands.items[i] := commandlist.CMD[i].Name + ' ' +
      commandlist.CMD[i].Text;
end;

procedure UpdateChoiceCommands;
var
  i: integer;
begin
  Form4.lstcommands.items.Clear;
  for i := 0 to commandlist.count - 1 do
  begin
    if commandlist.CMD[i].Variable <> '' then
      Form4.lstcommands.items.Add(commandlist.CMD[i].Name + '(' +
        commandlist.CMD[i].Variable + ') ' + commandlist.CMD[i].Text)
    else

      Form4.lstcommands.items.Add(commandlist.CMD[i].Name + ' ' +
        commandlist.CMD[i].Text);
  end;
end;

procedure TForm4.btn8Click(Sender: TObject);
begin
  command := commandlist.Add;
  command.Name := '<< NEW COMMAND >>';
  command.Variable := '';
  command.Text := '';
  UpdateChoiceCommands;
end;

procedure TForm4.btn9Click(Sender: TObject);
begin
  commandlist.delete(lstcommands.itemindex);
  UpdateChoiceCommands;
end;

procedure TForm4.cbbcmdClick(Sender: TObject);
begin
  command.Name := cbbcmd.Text;
  if command.Name = 'RunScript' then
  begin
    ScriptSelector.Visible := true;
    mmoparamval.Visible := false;
    cbbvarsel.Visible:=false;
    lbl10.Visible:=false;
  end
  else
  begin
    ScriptSelector.Visible := false;
    mmoparamval.Visible := true;
    cbbvarsel.Visible:=true;
    lbl10.Visible:=true;
  end;
  UpdateChoiceCommandSel;
end;

procedure TForm4.cbbvarselClick(Sender: TObject);
begin
  command.Variable := cbbvarsel.Text;

  UpdateChoiceCommandSel;

end;

function FindScript (txt: string): integer;
var u: integer;
begin
result:=-1;
for u := 0 to form4.ScriptSelector.items.Count-1 do
  begin
    if MatchesMask(form4.ScriptSelector.Items[u], txt+'*') then
    begin
      result:=u;
      exit;
    end;
  end;
end;

procedure TForm4.lstcommandsClick(Sender: TObject);
begin
  command := commandlist.CMD[lstcommands.itemindex];
  cbbcmd.itemindex := cbbcmd.items.IndexOf(command.Name);
   if command.Name = 'RunScript' then
  begin
    ScriptSelector.Visible := true;
    mmoparamval.Visible := false;
    cbbvarsel.Visible:=false;
    ScriptSelector.ItemIndex:=FindScript(command.text);
    lbl10.Visible:=false;
  end
  else
  begin
    ScriptSelector.Visible := false;
    mmoparamval.Visible := true;
    cbbvarsel.Visible:=true;
    lbl10.Visible:=true;
  end;
  cbbvarsel.itemindex := cbbvarsel.items.IndexOf(command.Variable);
  mmoparamval.Text := command.Text;
end;

procedure TForm4.mmoparamvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  command.Text := mmoparamval.Text;

  UpdateChoiceCommands;

end;

procedure TForm4.ScriptSelectorClick(Sender: TObject);
begin
  command.Text := adventuredata.scripts.script[scriptselector.itemindex].name;
  UpdateChoiceCommandSel;
end;

end.
