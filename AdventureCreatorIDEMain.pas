unit AdventureCreatorIDEMain;

interface

uses
  Windows, Messages, AdventureFile, AdventureScript, AdventureBinary, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms,
  JclFileUtils, Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, Menus,
  Vcl.ComCtrls,
  Vcl.WinXCtrls;

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
    NewAdventureFile1: TMenuItem;
    Label1: TLabel;
    newnodename: TEdit;
    Button1: TButton;
    Label2: TLabel;
    node_parent: TComboBox;
    nodes_tree: TTreeView;
    gamewinner: TCheckBox;
    Button2: TButton;
    ShowNodeLinks1: TMenuItem;
    Button3: TButton;
    InitnewfieldsinXMLdevonly1: TMenuItem;
    Button4: TButton;
    Scripts1: TMenuItem;
    procedure LoadAdventureFile1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure NewAdventureFile1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure nodes_treeClick(Sender: TObject);
    procedure node_parentClick(Sender: TObject);
    procedure gamewinnerClick(Sender: TObject);
    procedure lstchoicelistMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure ShowNodeLinks1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure InitnewfieldsinXMLdevonly1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Scripts1Click(Sender: TObject);
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
  CurrentFilename: string;
  NewNode: IXMLNodeType;
  Commandlist: IXMLCommandListType;
  ConditionList: IXMLConditionListType;
  newconditionlist: IXMLConditionListType;
  newcommandlist: IXMLCommandListType;
   newchoice: IXMLChoicetype;
  newcmd: IXMLCMDType;
  newcondition: IXMLConditionType;

procedure LogMsg(s: string);

implementation

uses MetaData, VarEditor, ChoiceCommandsForm, AboutForm, ChoiceConditionsForm,
  ScriptEditorForm;

procedure UpdateCaption;
begin
  Form1.Caption := 'Adventure Creator 1.0 IDE - [' + CurrentFilename + ']';
end;

{$R *.dfm}

procedure LogMsg(s: string);
begin
  Form1.mmomessages.Lines.Add(s);
end;

procedure UpdateVariables;
var
  u: Integer;
begin
  Form1.cbbvarsel.items.clear;
  form4.cbbvarsel.items.clear;
  form6.cbbvarsel.items.clear;
  for u := 0 to AdventureData.Variables.Count - 1 do
  begin
    Form1.cbbvarsel.items.Add(AdventureData.Variables.Variable[u].name);
    form4.cbbvarsel.items.Add(AdventureData.Variables.Variable[u].name);
    form6.cbbvarsel.items.Add(AdventureData.Variables.Variable[u].name);
  end;
end;

function TreeItemSearch(TV: TTreeView; SucheItem: string): TTreeNode;
var
  i: Integer;
  iItem: string;
begin
  if (TV = nil) or (SucheItem = '') then
    Exit;
  for i := 0 to TV.items.Count - 1 do
  begin
    iItem := TV.items[i].Text;
    if SucheItem = iItem then
    begin
      Result := TV.items[i];
      Exit;
    end
    else
    begin
      Result := nil;
    end;
  end;
end;

procedure UpdateNodeLists;
var
  child, node: TTreeNode;
  sibling: TTreeNode;
  u: Integer;
begin

  Form1.cbbchoicenodelist.clear;
  Form1.node_parent.clear;
  Form1.node_parent.items.Add('<< NONE >>');
  Form1.nodes_tree.items.clear;

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    sibling := nil;
    if AdventureData.GameNodes.node[u].NodeParent = '' then
      node := Form1.nodes_tree.items.Add(nil,
        AdventureData.GameNodes.node[u].name);
    // begin
    // sibling := node;
    // end;
    Form1.cbbchoicenodelist.items.Add(AdventureData.GameNodes.node[u].name);
    Form1.node_parent.items.Add(AdventureData.GameNodes.node[u].name);
  end;

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.node[u].NodeParent <> '' then
    begin
      node := TreeItemSearch(Form1.nodes_tree, AdventureData.GameNodes.node[u]
        .NodeParent);
      child := Form1.nodes_tree.items.AddChild(node,
        AdventureData.GameNodes.node[u].name);
    end;
  end;
  Form1.nodes_tree.FullExpand;
end;

procedure TForm1.LoadAdventureFile1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    DataReader.FileName := dlgOpen1.FileName;
    AdventureData := GetAdventureGame(DataReader);
    LogMsg('Adventuregame: "' + AdventureData.MetaInfo.Title + '" by ' +
      AdventureData.MetaInfo.Author);
    LogMsg('Node count: ' + inttostr(AdventureData.GameNodes.Count));
    LogMsg('Script count: '+inttostr(AdventureData.Scripts.Count));
    UpdateNodeLists;
    UpdateVariables;
    CurrentFilename := extractfilename(dlgOpen1.FileName);
    UpdateCaption;

  end;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  halt;
end;

procedure UpdateNodeCommandSel;
var
  i: Integer;
begin
  i := Form1.lstcommands.itemindex;
  if TheNode.NodeCommands.CMD[i].Variable <> '' then
    Form1.lstcommands.items[i] := TheNode.NodeCommands.CMD[i].name + '(' +
      TheNode.NodeCommands.CMD[i].Variable + ') ' +
      TheNode.NodeCommands.CMD[i].Text
  else

    Form1.lstcommands.items[i] := TheNode.NodeCommands.CMD[i].name + ' ' +
      TheNode.NodeCommands.CMD[i].Text;
end;

procedure UpdateNodeCommands;
var
  i: Integer;
begin
  Form1.lstcommands.items.clear;
  for i := 0 to TheNode.NodeCommands.Count - 1 do
  begin
    if TheNode.NodeCommands.CMD[i].Variable <> '' then
      Form1.lstcommands.items.Add(TheNode.NodeCommands.CMD[i].name + '(' +
        TheNode.NodeCommands.CMD[i].Variable + ') ' +
        TheNode.NodeCommands.CMD[i].Text)
    else

      Form1.lstcommands.items.Add(TheNode.NodeCommands.CMD[i].name + ' ' +
        TheNode.NodeCommands.CMD[i].Text);
  end;
end;

procedure UpdateChoiceSel;
var
  i: Integer;
  selind: Integer;
begin
  selind := Form1.lstchoicelist.itemindex;
  Form1.lstchoicelist.items[selind] := TheNode.choices.Choice[selind].Text +
    ' -> ' + TheNode.choices.Choice[selind].Targetnode + ' (' +
    inttostr(TheNode.choices.Choice[selind].Addscore) + ' pts)';

end;

procedure UpdateChoices;
var
  i: Integer;
begin
  Form1.lstchoicelist.items.clear;
  for i := 0 to TheNode.choices.Count - 1 do
  begin
    Form1.lstchoicelist.items.Add(TheNode.choices.Choice[i].Text + ' -> ' +
      TheNode.choices.Choice[i].Targetnode + ' (' +
      inttostr(TheNode.choices.Choice[i].Addscore) + ' pts)');
  end;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  thechoice := TheNode.choices.Add;
  thechoice.Targetnode := '';
  thechoice.Text := '<< NEW CHOICE >>';
  thechoice.Endgame := false;
  thechoice.Wingame := false;

  thechoice.Addscore := 0;
  Commandlist := TheNode.ChoiceCommands.Add;

  ConditionList := TheNode.ChoiceConditions.Add;
  UpdateChoices;

end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  TheNode.choices.Delete(lstchoicelist.itemindex);
  TheNode.ChoiceCommands.Delete(lstchoicelist.itemindex);
  TheNode.ChoiceConditions.Delete(lstchoicelist.itemindex);

  UpdateChoices;

end;

procedure TForm1.lstchoicelistClick(Sender: TObject);
begin
  // prevent list index out of bounds with this

  thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
  edtchoicetext.Text := thechoice.Text;
  cbbchoicenodelist.itemindex := cbbchoicenodelist.items.IndexOf
    (thechoice.Targetnode);
  chkendgame.Checked := thechoice.Endgame;
  gamewinner.Checked := thechoice.Wingame;
  edtchoicescore.Text := inttostr(thechoice.Addscore);
end;

procedure TForm1.lstchoicelistMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  point: TPoint;
begin
  point.X := X;
  point.Y := Y;
  if lstchoicelist.itemindex = -1 then
    Exit;

  if lstchoicelist.ItemAtPos(point, true) = -1 then

  begin
    edtchoicetext.Text := '';
    cbbchoicenodelist.itemindex := -1;

    // lstcommands.Clear;
    edtchoicescore.Text := '';
    lstchoicelist.itemindex := -1;
    Exit;
  end;

end;

procedure TForm1.btn5Click(Sender: TObject);
var
  X, Y: Integer;
  ChoiceCommands: IXMLCommandListType;
begin
  for X := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    for Y := 0 to AdventureData.GameNodes.node[X].choices.Count - 1 do
    begin
      LogMsg('Added commands list for choice: ' + inttostr(Y) + ' in node ' +
        AdventureData.GameNodes.node[X].name);
      ChoiceCommands := AdventureData.GameNodes.node[X].ChoiceCommands.Add;
      // adventuredata.GameNodes.Node[x].Choices.Choice[y].Wingame := false;
    end;
  end;
end;

procedure TForm1.SaveAdventureFile1Click(Sender: TObject);
begin
  if dlgSave1.Execute then
  begin
    AdventureData := GetAdventureGame(DataReader);

    DataReader.SaveToFile(dlgSave1.FileName);
    CurrentFilename := extractfilename(dlgSave1.FileName);
    UpdateCaption;
    // form1.Caption := 'Adventure Creator 1.0 IDE - ['+extractfilename(dlgsave1.FileName)+']';

  end;
end;

procedure TForm1.Scripts1Click(Sender: TObject);
begin
updatescripts;
form5.showmodal;

end;

procedure TForm1.ShowNodeLinks1Click(Sender: TObject);
var
  z, u: Integer;
var
  links: TSTrings;
begin
  links := TStringlist.Create;
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    for z := 0 to AdventureData.GameNodes[u].choices.Count - 1 do
    begin
      if (AdventureData.GameNodes[u].name <> TheNode.name) and
        (AdventureData.GameNodes[u].choices[z].Targetnode = TheNode.name) then
      begin
        links.Add('Node "' + AdventureData.GameNodes[u].name + '" choice #' +
          inttostr(z + 1) + ' ("' + AdventureData.GameNodes[u].choices[z]
          .Text + '")');
      end;
    end;
  end;
  if links.Count = 0 then
    showmessage('This is the start node.')
  else
    showmessage(links.Text);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  IDEAboutForm.showmodal;
end;


function GetNodeIndex (name: string): integer;
 var i: integer;
 begin
 for i := 0 to AdventureData.GameNodes.Count-1 do
   begin
     if AdventureData.GameNodes.Node[i].Name=name then
        begin
          result:= i;
          exit;
        end;
   end;
 end;

procedure TForm1.btn1Click(Sender: TObject);
begin

  TheNode := AdventureData.GameNodes.Add;
  LogMsg('Node count: ' + inttostr(AdventureData.GameNodes.Count));
  if AdventureData.GameNodes.Count <= 1 then
  begin
    TheNode.name := 'Start';
    LogMsg('Created start node');
  end
  else
    TheNode.name := '<< NEW NODE >>';

  UpdateNodeLists;
end;

procedure TForm1.btn2Click(Sender: TObject);
var nodeind: integer;
begin
  nodeind:=GetNodeIndex(nodes_tree.Selected.text);
  AdventureData.GameNodes.Delete(nodeind);
  UpdateNodeLists;

end;

procedure TForm1.btn6Click(Sender: TObject);
var
  oldname: string;
var
  u: Integer;
begin
  oldname := TheNode.name;
  // Also remap references to this node
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.node[u].NodeParent = oldname then
    begin
      LogMsg('Remapped node parent ' + oldname + ' to ' + edtnodename.Text);
      AdventureData.GameNodes.node[u].NodeParent := edtnodename.Text;
    end;
  end;

  TheNode.name := edtnodename.Text;
  UpdateNodeLists;
end;

procedure TForm1.cbbchoicenodelistClick(Sender: TObject);
begin
  thechoice.Targetnode := cbbchoicenodelist.Text;
  UpdateChoiceSel;
end;

procedure TForm1.edtchoicetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  thechoice.Text := edtchoicetext.Text;
  UpdateChoiceSel;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AdventureData := NewAdventureGame;
end;

procedure TForm1.gamewinnerClick(Sender: TObject);
begin
  thechoice.Wingame := gamewinner.Checked;
end;

procedure TForm1.InitnewfieldsinXMLdevonly1Click(Sender: TObject);
var
  z, Y: Integer;
  cond: IXMLConditionListType;
begin
  for Y := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    for z := 0 to AdventureData.GameNodes.node[Y].choices.Count - 1 do
    begin

      cond := AdventureData.GameNodes.node[Y].ChoiceConditions.Add;
    end;
  end;
  LogMsg('Conditions added to existing project!');
end;

procedure TForm1.chkendgameClick(Sender: TObject);
begin
  thechoice.Endgame := chkendgame.Checked;
end;

procedure TForm1.mmonodetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TheNode.DescriptionText := mmonodetext.Text;
end;

procedure TForm1.CompiletoBinary1Click(Sender: TObject);
begin
  if dlgSave2.Execute then
  begin
    LogMsg('Compiling data...');
    CompileAdventure;
    LogMsg('Max score: ' + inttostr(AdventureBinData.MaxScore));
    LogMsg('Saving binary data...');
    SaveAdventureBin(dlgSave2.FileName);
    LogMsg('Binary data saved');
    LogMsg('Copying engine ... ');
    FileCopy('acengine.exe', changefileext(dlgSave2.FileName, '.exe'), true);
    LogMsg('Engine copied as ' + changefileext(dlgSave2.FileName, '.exe'));

  end;

end;

procedure TForm1.ValidateNodes1Click(Sender: TObject);
var
  X, i: Integer;
var
  Messages: TSTrings;
begin
  Messages := TStringlist.Create;
  for X := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.node[X].DescriptionText = '' then
    begin
      Messages.Add('Node "' + AdventureData.GameNodes.node[X].name +
        '" has no text.');
      LogMsg('Node "' + AdventureData.GameNodes.node[X].name +
        '" has no text.');
    end;

    for i := 0 to AdventureData.GameNodes.node[X].choices.Count - 1 do
    begin
      if AdventureData.GameNodes.node[X].choices.Choice[i].Targetnode = '' then
      begin
        LogMsg('Node "' + AdventureData.GameNodes.node[X].name +
          '" has a null link in choice #' + inttostr(i + 1) + '"' +
          AdventureData.GameNodes.node[X].choices.Choice[i].Text + '"');
        Messages.Add('Node "' + AdventureData.GameNodes.node[X].name +
          '" has a null link in choice #' + inttostr(i + 1) + '"' +
          AdventureData.GameNodes.node[X].choices.Choice[i].Text + '"');
      end;
    end;
  end;
  if Messages.Count > 0 then
    showmessage('The following errors were found: ' + #13#10 + Messages.Text)
  else
    showmessage('Game data seems to be OK. No errors found.');
end;

procedure TForm1.Metadata1Click(Sender: TObject);
begin
  form2.edttitle.Text := AdventureData.MetaInfo.Title;
  form2.edtauthor.Text := AdventureData.MetaInfo.Author;
  form2.mmodescription.Text := AdventureData.MetaInfo.Description;
  form2.mmodescription.Text := Stringreplace(form2.mmodescription.Text, #10,
    '\n', [rfReplaceAll]);
  form2.mmodescription.Text := Stringreplace(form2.mmodescription.Text, '\n',
    #13#10, [rfReplaceAll]);
  form2.showmodal;

end;

procedure TForm1.edtchoicescoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtchoicescore.Text <> '' then
  begin;
    thechoice.Addscore := StrToInt(edtchoicescore.Text);
    UpdateChoiceSel;
  end;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
  thechoice := TheNode.choices.Insert(lstchoicelist.itemindex);
  thechoice.Targetnode := '';
  thechoice.Text := '<< NEW CHOICE >>';
  thechoice.Endgame := false;
  thechoice.Wingame := false;

  thechoice.Addscore := 0;
  Commandlist := TheNode.ChoiceCommands.Insert(lstchoicelist.itemindex);

  ConditionList := TheNode.ChoiceConditions.Insert(lstchoicelist.itemindex);
  UpdateChoices;
end;

procedure TForm1.Variables1Click(Sender: TObject);
begin
  updatevarlist;
  Form3.showmodal;
  UpdateVariables;
end;

procedure TForm1.btn8Click(Sender: TObject);
begin
  thecmd := TheNode.NodeCommands.Add;
  thecmd.name := '<< NEW COMMAND >>';
  thecmd.Variable := '';
  thecmd.Text := '';
  UpdateNodeCommands;
end;

procedure TForm1.btn9Click(Sender: TObject);
begin
  TheNode.NodeCommands.Delete(lstcommands.itemindex);
  UpdateNodeCommands;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  NewNode := AdventureData.GameNodes.Add;
  NewNode.name := newnodename.Text;
  NewNode.NodeParent := TheNode.name;
  UpdateNodeLists;
  thechoice.Targetnode := NewNode.name;
  UpdateChoiceSel;
  cbbchoicenodelist.itemindex := cbbchoicenodelist.items.IndexOf(NewNode.name);
  newnodename.Text := '';

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if lstchoicelist.itemindex > TheNode.ChoiceCommands.Count - 1 then
  begin
    LogMsg('Choice commands out of sync, adding new!');
    Commandlist := TheNode.ChoiceCommands.Add;
  end;
  Commandlist := TheNode.ChoiceCommands.Commandlist[lstchoicelist.itemindex];
  updatechoicecommands;
  form4.showmodal;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ConditionList := TheNode.ChoiceConditions.ConditionList
    [lstchoicelist.itemindex];
  LogMsg('Updating choice conditions, condition list has ' +
    inttostr(ConditionList.Count) + ' conditions.');
  UpdateChoiceConditions;
  form6.showmodal;
end;

procedure TForm1.Button4Click(Sender: TObject);
var i,x: integer;
begin
NewNode := AdventureData.GameNodes.Add;
newnode.Name := TheNode.Name+'_CLONE';
newnode.NodeParent := thenode.NodeParent;
newnode.DescriptionText := thenode.DescriptionText;
  for i := 0 to thenode.Choices.Count-1 do
    begin
      newchoice := newnode.Choices.Add;
      newchoice.Endgame := thenode.Choices.Choice[i].Endgame;
      newchoice.Wingame := thenode.Choices.Choice[i].Wingame;
      newchoice.Addscore := thenode.Choices.Choice[i].Addscore;
      newchoice.Targetnode := thenode.Choices.Choice[i].Targetnode;
      newchoice.Text := thenode.Choices.Choice[i].Text;
     newconditionlist := newnode.ChoiceConditions.Add;
       for x := 0 to thenode.Choiceconditions.ConditionList[i].Count-1 do
       begin
         newcondition := newconditionlist.Add;
         newcondition.Name := thenode.Choiceconditions.ConditionList[i].Condition[x].Name;
         newcondition.Varname := thenode.Choiceconditions.ConditionList[i].Condition[x].Varname;
         newcondition.Eval := thenode.Choiceconditions.ConditionList[i].Condition[x].Eval;
         newcondition.Text :=   thenode.Choiceconditions.ConditionList[i].Condition[x].Text;

       end;

      newcommandlist := newnode.ChoiceCommands.Add;
       for x := 0 to thenode.ChoiceCommands.CommandList[i].Count-1 do
       begin
       newcmd := newcommandlist.Add;
       newcmd.Name := thenode.ChoiceCommands.CommandList[i].CMD[x].Name;
       newcmd.Variable := thenode.ChoiceCommands.CommandList[i].CMD[x].Variable;
       newcmd.Text := thenode.ChoiceCommands.CommandList[i].CMD[x].Text;

      end;
    end;
    UpdateNodeLists;
end;

procedure TForm1.cbbcmdClick(Sender: TObject);
begin
  thecmd.name := cbbcmd.Text;
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
  thecmd.Text := mmoparamval.Text;
  UpdateNodeCommandSel;
end;

procedure TForm1.NewAdventureFile1Click(Sender: TObject);
begin
  AdventureData := NewAdventureGame;
  UpdateNodeLists;
  UpdateVariables;
  CurrentFilename := 'Untitled.xml';
end;

function FindNode(nodename: string): IXMLNodeType;
var
  u: Integer;
begin
  Result := nil;
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.node[u].name = nodename then
    begin
      Result := AdventureData.GameNodes.node[u];
      Exit;
    end;
  end;
end;

procedure TForm1.nodes_treeClick(Sender: TObject);
begin
  TheNode := FindNode(nodes_tree.Selected.Text);
  mmonodetext.Text := TheNode.DescriptionText;
  mmonodetext.Text := Stringreplace(mmonodetext.Text, #10, '\n',
    [rfReplaceAll]);
  mmonodetext.Text := Stringreplace(mmonodetext.Text, '\n', #13#10,
    [rfReplaceAll]);
  mmonodetext.Text := Stringreplace(mmonodetext.Text, #9, '', [rfReplaceAll]);
  edtchoicetext.Text := '';

  node_parent.itemindex := node_parent.items.IndexOf(TheNode.NodeParent);
  if TheNode.NodeParent = '' then
    node_parent.itemindex := 0;
  edtnodename.Text := TheNode.name;
  UpdateChoices;
  UpdateNodeCommands;
end;

procedure TForm1.node_parentClick(Sender: TObject);
begin
  TheNode.NodeParent := node_parent.Text;
  if node_parent.itemindex = 0 then
    TheNode.NodeParent := '';
  UpdateNodeLists;
end;

procedure TForm1.lstcommandsClick(Sender: TObject);
begin
  thecmd := TheNode.NodeCommands.CMD[lstcommands.itemindex];
  cbbcmd.itemindex := cbbcmd.items.IndexOf(thecmd.name);
  cbbvarsel.itemindex := cbbvarsel.items.IndexOf(thecmd.Variable);
  mmoparamval.Text := thecmd.Text;
end;

end.
