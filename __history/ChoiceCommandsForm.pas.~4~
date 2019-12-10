unit ChoiceCommandsForm;

interface

uses
  Winapi.Windows, AdventureFile, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure cbbcmdClick(Sender: TObject);
    procedure cbbvarselClick(Sender: TObject);
    procedure mmoparamvalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstcommandsClick(Sender: TObject);
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
var i: integer;
begin
i := form4.lstcommands.itemindex;
       if commandlist.CMD[i].Variable<>'' then
       Form4.lstcommands.items[i] := commandlist.CMD[i].Name+'('+commandlist.CMD[i].Variable+') '+commandlist.CMD[i].Text else

       Form4.lstcommands.items[i] := commandlist.CMD[i].Name+' '+commandlist.CMD[i].Text;
end;

procedure UpdateChoiceCommands;
var i: integer;
begin
     form4.lstcommands.items.Clear;
     for i:=0 to Commandlist.count-1 do
     begin
       if Commandlist.CMD[i].Variable<>'' then
       Form4.lstcommands.items.Add(commandlist.CMD[i].Name+'('+commandlist.CMD[i].Variable+') '+commandlist.CMD[i].Text) else

       Form4.lstcommands.items.Add(commandlist.CMD[i].Name+' '+commandlist.CMD[i].Text);
     end;
end;

procedure TForm4.btn8Click(Sender: TObject);
begin
command := commandlist.Add;
command.Name := '<< NEW COMMAND >>';
command.Variable := '';
command.Text :='';
 updatechoicecommands;
end;

procedure TForm4.btn9Click(Sender: TObject);
begin
commandlist.delete(lstcommands.ItemIndex);
UpdateChoiceCommands;
end;

procedure TForm4.cbbcmdClick(Sender: TObject);
begin
command.Name := cbbcmd.Text;

UpdateChoiceCommandSel;
end;

procedure TForm4.cbbvarselClick(Sender: TObject);
begin
command.Variable := cbbvarsel.Text;

UpdateChoiceCommandSel;

end;

procedure TForm4.lstcommandsClick(Sender: TObject);
begin
command := Commandlist.CMD[lstcommands.itemindex];
cbbcmd.ItemIndex := cbbcmd.Items.IndexOf(command.Name);
cbbvarsel.ItemIndex := cbbvarsel.Items.IndexOf(command.Variable);
mmoparamval.Text := command.Text;
end;

procedure TForm4.mmoparamvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
command.text := mmoparamval.Text;

UpdateChoiceCommands;

end;

end.
