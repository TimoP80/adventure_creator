unit AdventureCreatorIDEMain;

interface

uses
  Windows, Messages, AdventureFile, AdventureBinary, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms,
  Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    DataReader: TXMLDocument;
    mm1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    LoadAdventureFile1: TMenuItem;
    SaveAdventureFile1: TMenuItem;
    N1: TMenuItem;
    CompiletoBinary1: TMenuItem;
    N2: TMenuItem;
    Quit1: TMenuItem;
    lbl1: TLabel;
    lstnodelistmain: TListBox;
    lbl2: TLabel;
    mmonodetext: TMemo;
    lbl3: TLabel;
    lstchoicelist: TListBox;
    lbl4: TLabel;
    edtchoicetext: TEdit;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    lbl5: TLabel;
    cbbchoicenodelist: TComboBox;
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    lbl6: TLabel;
    edtnodename: TEdit;
    chkendgame: TCheckBox;
    btn5: TButton;
    btn6: TButton;
    dlgSave2: TSaveDialog;
    mmomessages: TMemo;
    ValidateNodes1: TMenuItem;
    Metadata1: TMenuItem;
    lbl7: TLabel;
    edtchoicescore: TEdit;
    btn7: TButton;
    Variables1: TMenuItem;
    grp1: TGroupBox;
    lstcommands: TListBox;
    lbl8: TLabel;
    btn8: TButton;
    btn9: TButton;
    lbl9: TLabel;
    cbbcmd: TComboBox;
    lbl10: TLabel;
    cbbvarsel: TComboBox;
    lbl11: TLabel;
    mmoparamval: TMemo;
    ools1: TMenuItem;
    procedure LoadAdventureFile1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure lstnodelistmainClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure lstchoicelistClick(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure SaveAdventureFile1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure cbbchoicenodelistClick(Sender: TObject);
    procedure edtchoicetextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkendgameClick(Sender: TObject);
    procedure mmonodetextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CompiletoBinary1Click(Sender: TObject);
    procedure ValidateNodes1Click(Sender: TObject);
    procedure Metadata1Click(Sender: TObject);
    procedure edtchoicescoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn7Click(Sender: TObject);
    procedure Variables1Click(Sender: TObject);
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
  Form1: TForm1;

  TheNode: IXMLNodeType;
  thechoice: IXMLChoiceType;
  thecmd: IXMLCMDType;

  procedure LogMsg(s: string);

implementation

uses MetaData, VarEditor;


{$R *.dfm}

procedure LogMsg(s: string);
begin
  form1.mmomessages.Lines.Add(s);
end;

procedure UpdateVariables;
var
  u: integer;
begin
  form1.cbbvarsel.items.clear;
  for U := 0 to AdventureData.Variables.Count - 1 do
  begin
    form1.cbbvarsel.Items.Add(adventuredata.Variables.Variable[u].name);
  end;
end;

procedure UpdateNodeLists;
var
  u: Integer;
begin
  form1.lstnodelistmain.Clear;
  form1.cbbchoicenodelist.clear;
  for u := 0 to adventuredata.GameNodes.Count - 1 do
  begin
    Form1.lstnodelistmain.Items.Add(adventuredata.GameNodes.Node[u].Name);
    Form1.cbbchoicenodelist.Items.Add(adventuredata.GameNodes.Node[u].Name);
  end;
end;

procedure TForm1.LoadAdventureFile1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    datareader.FileName := dlgOpen1.FileName;
    AdventureData := GetAdventureGame(DataReader);
    Logmsg('Adventuregame: "'+adventuredata.MetaInfo.Title+'" by '+adventuredata.MetaInfo.Author);
    LogMsg('Node count: '+inttostr(AdventureData.GameNodes.Count));
    UpdateNodeLists;
    UpdateVariables;

  end;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  halt;
end;

procedure UpdateNodeCommandSel;
var i: integer;
begin
i := form1.lstcommands.itemindex;
       if TheNode.NodeCommands.CMD[i].Variable<>'' then
       Form1.lstcommands.items[i] := TheNode.NodeCommands.CMD[i].Name+'('+TheNode.NodeCommands.CMD[i].Variable+') '+TheNode.NodeCommands.CMD[i].Text else

       Form1.lstcommands.items[i] := TheNode.NodeCommands.CMD[i].Name+' '+TheNode.NodeCommands.CMD[i].Text;
end;


procedure UpdateNodeCommands;
var i: integer;
begin
     form1.lstcommands.items.Clear;
     for i:=0 to TheNode.NodeCommands.Count-1 do
     begin
       if TheNode.NodeCommands.CMD[i].Variable<>'' then
       Form1.lstcommands.items.Add(TheNode.NodeCommands.CMD[i].Name+'('+TheNode.NodeCommands.CMD[i].Variable+') '+TheNode.NodeCommands.CMD[i].Text) else

       Form1.lstcommands.items.Add(TheNode.NodeCommands.CMD[i].Name+' '+TheNode.NodeCommands.CMD[i].Text);
     end;
end;

 procedure UpdateChoiceSel;
var
  i: integer;
  selind: integer;
begin
 selind := form1.lstchoicelist.itemindex;
    Form1.lstchoicelist.Items[selind] := TheNode.choices.Choice[selind].text+' -> '+TheNode.choices.Choice[selind].Targetnode+' ('+inttostr(TheNode.choices.Choice[selind].Addscore)+' pts)';

end;

procedure UpdateChoices;
var
  i: integer;
begin
  Form1.lstchoicelist.Items.Clear;
  for i := 0 to TheNode.choices.Count - 1 do
  begin
    Form1.lstchoicelist.Items.Add(TheNode.choices.Choice[i].text+' -> '+TheNode.choices.Choice[i].Targetnode+' ('+inttostr(TheNode.choices.Choice[i].Addscore)+' pts)');
  end;
end;

procedure TForm1.lstnodelistmainClick(Sender: TObject);
begin
  TheNode := AdventureData.GameNodes.Node[lstnodelistmain.itemindex];
  mmonodetext.Text := thenode.DescriptionText;
  mmonodetext.text := StringReplace(mmonodetext.text, #10,'\n',[rfreplaceall]);
  mmonodetext.text := StringReplace(mmonodetext.text, '\n',#13#10,[rfreplaceall]);

  edtnodename.Text := TheNode.Name;
  UpdateChoices;
  UpdateNodeCommands;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  thechoice := TheNode.Choices.Add;
  thechoice.Targetnode := '';
  thechoice.Text := '<< NEW CHOICE >>';
  thechoice.Endgame := false;
  thechoice.Addscore:=0;
  UpdateChoices;

end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  TheNode.Choices.Delete(lstchoicelist.itemindex);
  UpdateChoices;

end;

procedure TForm1.lstchoicelistClick(Sender: TObject);
begin
  thechoice := thenode.Choices.Choice[lstchoicelist.itemindex];
  edtchoicetext.Text := thechoice.Text;
  cbbchoicenodelist.ItemIndex :=
    cbbchoicenodelist.Items.IndexOf(thechoice.Targetnode);
  chkendgame.Checked := thechoice.Endgame;
  edtchoicescore.Text := inttostr(thechoice.Addscore);
end;

procedure TForm1.btn5Click(Sender: TObject);
var
  x, y: Integer;
begin
  for x := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    for y := 0 to adventuredata.GameNodes.Node[x].Choices.Count - 1 do
    begin
      adventuredata.GameNodes.Node[x].Choices.Choice[y].addscore := 0;
    end;
  end;
end;

procedure TForm1.SaveAdventureFile1Click(Sender: TObject);
begin
  if dlgSave1.Execute then
  begin
    AdventureData := GetAdventureGame(datareader);

    DataReader.SaveToFile(dlgsave1.FileName);
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  thenode := AdventureData.GameNodes.Add;
  thenode.Name := '<< NEW NODE >>';
  UpdateNodeLists;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  AdventureData.GameNodes.Delete(lstnodelistmain.itemindex);
  UpdateNodeLists;

end;

procedure TForm1.btn6Click(Sender: TObject);
begin
  TheNode.Name := edtnodename.Text;
  UpdateNodeLists;
end;

procedure TForm1.cbbchoicenodelistClick(Sender: TObject);
begin
  thechoice.Targetnode := cbbchoicenodelist.Text;
  updatechoicesel;
end;

procedure TForm1.edtchoicetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  thechoice.text := edtchoicetext.Text;
updatechoicesel;
end;

procedure TForm1.chkendgameClick(Sender: TObject);
begin
  thechoice.Endgame := chkendgame.Checked;
end;

procedure TForm1.mmonodetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TheNode.DescriptionText := mmonodetext.text;
end;

procedure TForm1.CompiletoBinary1Click(Sender: TObject);
begin
  if dlgSave2.Execute then
  begin
    LogMsg('Compiling data...');
    CompileAdventure;
    logmsg('Max score: '+inttostr(AdventureBinData.MaxScore));
    LogMsg('Saving binary data...');
    SaveAdventureBin(dlgsave2.FileName);
  end;

end;

procedure TForm1.ValidateNodes1Click(Sender: TObject);
var x,i: integer;
begin
for x:=0 to AdventureData.GameNodes.Count-1 do
begin
  if adventuredata.GameNodes.Node[x].DescriptionText='' then
  LogMsg('Node "'+adventuredata.GameNodes.Node[x].Name+'" has no text.');
  for i:=0 to adventuredata.GameNodes.Node[x].Choices.Count-1 do
  begin
    if adventuredata.GameNodes.Node[x].Choices.Choice[i].Targetnode='' then
    begin
      LogMsg('Node "'+adventuredata.GameNodes.Node[x].Name+'" has a null link in choice #'+inttostr(i+1)+'"'+adventuredata.GameNodes.Node[x].Choices.Choice[i].text+'"');
    end;
  end;
end;
end;

procedure TForm1.Metadata1Click(Sender: TObject);
begin
form2.edttitle.text := adventuredata.MetaInfo.Title;
form2.edtauthor.text := adventuredata.MetaInfo.Author;
form2.mmodescription.text := adventuredata.MetaInfo.Description;

form2.showmodal;

end;

procedure TForm1.edtchoicescoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if edtchoicescore.text <> '' then
  begin;
  thechoice.Addscore := StrToInt(edtchoicescore.text);
  updatechoicesel;
  end;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
  thechoice := TheNode.Choices.Insert(lstchoicelist.itemindex);
  thechoice.Targetnode := '';
  thechoice.Text := '<< NEW CHOICE >>';
  thechoice.Endgame := false;
  thechoice.Addscore:=0;
  UpdateChoices;
end;

procedure TForm1.Variables1Click(Sender: TObject);
begin
updatevarlist;
Form3.ShowModal;
UpdateVariables;
end;

procedure TForm1.btn8Click(Sender: TObject);
begin
thecmd := TheNode.NodeCommands.Add;
thecmd.Name := '<< NEW COMMAND >>';
thecmd.Variable := '';
thecmd.Text :='';
UpdateNodeCommands;
end;

procedure TForm1.btn9Click(Sender: TObject);
begin
thenode.NodeCommands.Delete(lstcommands.itemindex);
UpdateNodeCommands;

end;

procedure TForm1.cbbcmdClick(Sender: TObject);
begin
thecmd.Name := cbbcmd.text;
UpdateNodeCommandSel;
end;

procedure TForm1.cbbvarselClick(Sender: TObject);
begin
thecmd.Variable := cbbvarsel.Text;
UpdateNodeCommandSel;
end;

procedure TForm1.mmoparamvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
thecmd.Text :=  mmoparamval.Text;
UpdateNodeCommandSel;
end;

procedure TForm1.lstcommandsClick(Sender: TObject);
begin
thecmd := TheNode.NodeCommands.CMD[lstcommands.itemindex];
cbbcmd.ItemIndex := cbbcmd.Items.IndexOf(thecmd.name);
cbbvarsel.ItemIndex := cbbvarsel.Items.IndexOf(thecmd.Variable);
mmoparamval.text := thecmd.Text;
end;

end.
