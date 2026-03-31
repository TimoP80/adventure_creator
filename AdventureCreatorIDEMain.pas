unit AdventureCreatorIDEMain;

interface

uses
  Windows, Inifiles, vfsengine, ShellApi,Masks, ACSoundLib, Messages, AdventureFile, AdventureScript, AdventureBinary, SysUtils,
  Variants,
  Classes, Graphics,
  Controls, Forms,
  AdventureScriptCompilerUtils,
  JclFileUtils, Dialogs, xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls, Menus,
  Velthuis.Console,
  Vcl.ComCtrls,
  Vcl.WinXCtrls,
  Vcl.ToolWin,
  Vcl.ImgList,
  Vcl.ActnList,
  Vcl.ExtCtrls,
  System.UITypes;

type
  TForm1 = class(TForm)
    DataReader: TXMLDocument;
    mm1: TMainMenu;
    // File menu
    File1: TMenuItem;
    NewAdventureFile1: TMenuItem;
    LoadAdventureFile1: TMenuItem;
    SaveAdventureFile1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Metadata1: TMenuItem;
    Compileadventure1: TMenuItem;
    N2: TMenuItem;
    Quit1: TMenuItem;
    // Edit menu
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N3: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    // View menu
    View1: TMenuItem;
    ToggleNodePanel1: TMenuItem;
    ToggleChoicePanel1: TMenuItem;
    ToggleCommandPanel1: TMenuItem;
    ToggleMessages1: TMenuItem;
    // Tools menu
    Tools1: TMenuItem;
    Variables1: TMenuItem;
    ValidateNodes1: TMenuItem;
    ShowNodeLinks1: TMenuItem;
    Scripts1: TMenuItem;
    Compilersettings1: TMenuItem;
    Additionalfiles1: TMenuItem;
    Audiodevices1: TMenuItem;
    // Help menu
    Help1: TMenuItem;
    About1: TMenuItem;
    Help2: TMenuItem;

    // Dialogs
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    dlgSave2: TSaveDialog;

    // Panels for organized layout
    pnlToolbar: TPanel;
    pnlNodeTree: TPanel;
    pnlNodeEditor: TPanel;
    pnlChoices: TPanel;
    pnlCommands: TPanel;
    pnlMessages: TPanel;
    pnlStatusBar: TPanel;

    // Toolbar buttons
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    tbSep1: TToolButton;
    tbCompile: TToolButton;
    tbSep2: TToolButton;
    tbAddNode: TToolButton;
    tbDeleteNode: TToolButton;
    tbSep3: TToolButton;
    tbAddChoice: TToolButton;
    tbDeleteChoice: TToolButton;
    tbSep4: TToolButton;
    tbValidate: TToolButton;
    tbScripts: TToolButton;
    tbVariables: TToolButton;

    // Node tree panel components
    lblNodes: TLabel;
    nodes_tree: TTreeView;
    btnAddNode: TButton;
    btnDeleteNode: TButton;
    btnCloneNode: TButton;

    // Node editor panel components
    lblNodeName: TLabel;
    edtnodename: TEdit;
    lblNodeParent: TLabel;
    node_parent: TComboBox;
    lblNodeDescription: TLabel;
    mmonodetext: TMemo;
    chkendgame: TCheckBox;
    btnApplyChanges: TButton;

    // Choices panel components
    lblChoices: TLabel;
    lstchoicelist: TListBox;
    btnAddChoice: TButton;
    btnInsertChoice: TButton;
    btnDeleteChoice: TButton;
    btnEditChoiceConditions: TButton;
    btnEditChoiceCommands: TButton;

    lblChoiceText: TLabel;
    edtchoicetext: TEdit;
    lblTargetNode: TLabel;
    cbbchoicenodelist: TComboBox;
    lblChoiceScore: TLabel;
    edtchoicescore: TEdit;
    chkChoiceEndGame: TCheckBox;
    chkChoiceWinGame: TCheckBox;

    // Commands panel components
    grpCommands: TGroupBox;
    lblCommandList: TLabel;
    lstcommands: TListBox;
    btnAddCommand: TButton;
    btnDeleteCommand: TButton;
    lblCommand: TLabel;
    cbbcmd: TComboBox;
    lblVariable: TLabel;
    cbbvarsel: TComboBox;
    lblParameterValue: TLabel;
    mmoparamval: TMemo;
    ScriptSelector: TComboBox;

    // New node panel
    lblNewNodeName: TLabel;
    newnodename: TEdit;
    btnCreateNode: TButton;

    // Script selector (for commands)
    lblScriptSelector: TLabel;
    ScriptSelectorMain: TComboBox;

    // Status bar components
    lblStatus: TLabel;
    lblNodeCount: TLabel;
    lblScriptCount: TLabel;
    lblCurrentTime: TLabel;

    // Messages panel
    mmomessages: TMemo;
    lblMessages: TLabel;
    btnClearMessages: TButton;

    // Image list for toolbar
    ilToolbar: TImageList;
    ActionList1: TActionList;

    // Shortcuts
    NewFile1: TMenuItem;
    OpenFile1: TMenuItem;
    SaveFile1: TMenuItem;
    ValidateNodes2: TMenuItem;
    ShowNodeLinks2: TMenuItem;

    procedure LoadAdventureFile1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure btnAddChoiceClick(Sender: TObject);
    procedure btnDeleteChoiceClick(Sender: TObject);
    procedure lstchoicelistClick(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure SaveAdventureFile1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnApplyChangesClick(Sender: TObject);
    procedure cbbchoicenodelistClick(Sender: TObject);
    procedure edtchoicetextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkendgameClick(Sender: TObject);
    procedure mmonodetextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValidateNodes1Click(Sender: TObject);
    procedure Metadata1Click(Sender: TObject);
    procedure edtchoicescoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAddCommandClick(Sender: TObject);
    procedure btnDeleteCommandClick(Sender: TObject);
    procedure cbbcmdClick(Sender: TObject);
    procedure cbbvarselClick(Sender: TObject);
    procedure mmoparamvalKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstcommandsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewAdventureFile1Click(Sender: TObject);
    procedure btnCreateNodeClick(Sender: TObject);
    procedure nodes_treeClick(Sender: TObject);
    procedure node_parentClick(Sender: TObject);
    procedure gamewinnerClick(Sender: TObject);
    procedure lstchoicelistMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShowNodeLinks1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure btnCloneNodeClick(Sender: TObject);
    procedure btnEditChoiceConditionsClick(Sender: TObject);
    procedure btnEditChoiceCommandsClick(Sender: TObject);
    procedure Scripts1Click(Sender: TObject);
    procedure ScriptSelectorClick(Sender: TObject);
    procedure Variables1Click(Sender: TObject);
    procedure Compilersettings1Click(Sender: TObject);
    procedure Additionalfiles1Click(Sender: TObject);
    procedure Compileadventure1Click(Sender: TObject);
    procedure Audiodevices1Click(Sender: TObject);

    // Toolbar button handlers
    procedure tbNewClick(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure tbCompileClick(Sender: TObject);
    procedure tbValidateClick(Sender: TObject);
    procedure tbScriptsClick(Sender: TObject);
    procedure tbVariablesClick(Sender: TObject);

    // Panel toggle handlers
    procedure ToggleNodePanel1Click(Sender: TObject);
    procedure ToggleChoicePanel1Click(Sender: TObject);
    procedure ToggleCommandPanel1Click(Sender: TObject);
    procedure ToggleMessages1Click(Sender: TObject);

    // Status update timer
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
    FIsModified: boolean;
    procedure UpdateCaption;
    procedure SetModified(Value: boolean);
    procedure TogglePanel(Panel: TPanel; MenuItem: TMenuItem);
  public
    { Public declarations }
    property Modified: boolean read FIsModified write SetModified;
  end;

var
  Form1: TForm1;
  config: TInifile;
  TheNode: IXMLNodeType;
  thechoice: IXMLChoiceType;
  thecmd: IXMLCMDType;
  CurrentFilename: string;
  NewNode: IXMLNodeType;
  Commandlist: IXMLCommandListType;
  ConditionList: IXMLConditionListType;
  newconditionlist: IXMLConditionListType;
  newcommandlist: IXMLCommandListType;
  newchoice: IXMLChoiceType;
  newcmd: IXMLCMDType;
  newcondition: IXMLConditionType;

procedure LogMsg(s: string);
procedure UpdateScriptSelectors;

implementation

uses MetaData, VarEditor, ChoiceCommandsForm, AboutForm, ChoiceConditionsForm,
  ScriptEditorForm, AddMultilineMessage, ProjectSettingsForm,
  AdditionalFilesForm, AudioDevicesForm;

procedure UpdateScriptEditorCompletion;
var
  u: Integer;
begin
  if AdventureData = nil then Exit;
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    form5.SynCompletionProposal1.ItemList.add
      (AdventureData.GameNodes.Node[u].Name);
  end;
  for u := 0 to AdventureData.AdditionalFiles.Count - 1 do
  begin
    form5.SynCompletionProposal1.ItemList.add
      (AdventureData.AdditionalFiles.File_[u].Name);
  end;
  for u := 0 to built_in_functions.Count - 1 do
  begin
    form5.SynCompletionProposal1.ItemList.add(built_in_functions[u]);
  end;
end;

procedure TForm1.UpdateCaption;
begin
  if CurrentFilename = '' then
    Caption := 'Adventure Creator 1.0 IDE - [Untitled]'
  else if FIsModified then
    Caption := 'Adventure Creator 1.0 IDE - [' + CurrentFilename + '] *'
  else
    Caption := 'Adventure Creator 1.0 IDE - [' + CurrentFilename + ']';
end;

procedure TForm1.SetModified(Value: boolean);
begin
  FIsModified := Value;
  UpdateCaption;
end;

{$R *.dfm}

procedure UpdateScriptSelectors;
var
  u: Integer;
begin
  if AdventureData = nil then Exit;
  form4.ScriptSelector.Clear;
  Form1.ScriptSelectorMain.Clear;
  for u := 0 to AdventureData.Scripts.Count - 1 do
  begin
    form4.ScriptSelector.Items.add(AdventureData.Scripts.Script[u].Name + ' - '
      + AdventureData.Scripts.Script[u].Filename);
    Form1.ScriptSelectorMain.Items.add(AdventureData.Scripts.Script[u].Name + ' - '
      + AdventureData.Scripts.Script[u].Filename);
  end;
end;

procedure LogMsg(s: string);
begin
  Form1.mmomessages.Lines.add(FormatDateTime('HH:nn:ss', Now) + ' - ' + s);
  // Auto-scroll to bottom
  Form1.mmomessages.SelStart := Length(Form1.mmomessages.Text);
end;

procedure UpdateVariables;
var
  u: Integer;
begin
  if AdventureData = nil then Exit;
  Form1.cbbvarsel.Items.Clear;
  form4.cbbvarsel.Items.Clear;
  form6.cbbvarsel.Items.Clear;
  for u := 0 to AdventureData.Variables.Count - 1 do
  begin
    Form1.cbbvarsel.Items.add(AdventureData.Variables.Variable[u].Name);
    form4.cbbvarsel.Items.add(AdventureData.Variables.Variable[u].Name);
    form6.cbbvarsel.Items.add(AdventureData.Variables.Variable[u].Name);
  end;
end;

function TreeItemSearch(TV: TTreeView; SucheItem: string): TTreeNode;
var
  i: Integer;
  iItem: string;
begin
  Result := nil;
  if (TV = nil) or (SucheItem = '') then
    Exit;
  for i := 0 to TV.Items.Count - 1 do
  begin
    iItem := TV.Items[i].Text;
    if SucheItem = iItem then
    begin
      Result := TV.Items[i];
      Exit;
    end;
  end;
end;

function FindNodeIndexByName(const NodeName: string): Integer;
var
  u: Integer;
begin
  Result := -1;
  if AdventureData = nil then Exit;

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if SameText(AdventureData.GameNodes.Node[u].Name, NodeName) then
    begin
      Result := u;
      Exit;
    end;
  end;
end;

procedure ClearNodeEditor;
begin
  TheNode := nil;
  thechoice := nil;
  thecmd := nil;

  Form1.edtnodename.Clear;
  Form1.mmonodetext.Clear;
  if Form1.node_parent.Items.Count > 0 then
    Form1.node_parent.ItemIndex := 0
  else
    Form1.node_parent.ItemIndex := -1;

  Form1.lstchoicelist.Clear;
  Form1.edtchoicetext.Clear;
  Form1.cbbchoicenodelist.ItemIndex := -1;
  Form1.edtchoicescore.Clear;
  Form1.chkChoiceEndGame.Checked := False;
  Form1.chkChoiceWinGame.Checked := False;

  Form1.lstcommands.Clear;
  Form1.cbbcmd.ItemIndex := -1;
  Form1.cbbvarsel.ItemIndex := -1;
  Form1.mmoparamval.Clear;

  Form1.lblStatus.Caption := 'Ready';
end;

procedure RemoveNodeReferences(const DeletedNodeName: string);
var
  NodeIndex, ChoiceIndex: Integer;
begin
  if AdventureData = nil then Exit;

  for NodeIndex := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if SameText(AdventureData.GameNodes.Node[NodeIndex].NodeParent,
      DeletedNodeName) then
      AdventureData.GameNodes.Node[NodeIndex].NodeParent := '';

    for ChoiceIndex := 0 to AdventureData.GameNodes.Node[NodeIndex]
      .Choices.Count - 1 do
    begin
      if SameText(AdventureData.GameNodes.Node[NodeIndex].Choices.Choice
        [ChoiceIndex].Targetnode, DeletedNodeName) then
        AdventureData.GameNodes.Node[NodeIndex].Choices.Choice[ChoiceIndex]
          .Targetnode := '';
    end;
  end;
end;

procedure UpdateNodeLists;
var
  Node: TTreeNode;
  u: Integer;
begin
  if AdventureData = nil then Exit;
  Form1.cbbchoicenodelist.Clear;
  Form1.node_parent.Clear;
  Form1.node_parent.Items.add('<< NONE >>');
  Form1.nodes_tree.Items.Clear;

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.Node[u].NodeParent = '' then
      Form1.nodes_tree.Items.add(nil,
        AdventureData.GameNodes.Node[u].Name);
    Form1.cbbchoicenodelist.Items.add(AdventureData.GameNodes.Node[u].Name);
    Form1.node_parent.Items.add(AdventureData.GameNodes.Node[u].Name);
  end;

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.Node[u].NodeParent <> '' then
    begin
      Node := TreeItemSearch(Form1.nodes_tree, AdventureData.GameNodes.Node[u]
        .NodeParent);
      Form1.nodes_tree.Items.AddChild(Node,
        AdventureData.GameNodes.Node[u].Name);
    end;
  end;
  Form1.nodes_tree.FullExpand;

  // Update status bar
  Form1.lblNodeCount.Caption := 'Nodes: ' + IntToStr(AdventureData.GameNodes.Count);
end;

procedure InitScriptEditorCompletion;
begin
  form5.SynCompletionProposal1.ItemList.Clear;
end;

procedure UpdateScriptEditorVariables;
var
  u: Integer;
begin
  if AdventureData = nil then Exit;
  for u := 0 to AdventureData.Variables.Count - 1 do
  begin
    form5.SynCompletionProposal1.ItemList.add(AdventureData.Variables[u].Name);
  end;
end;

procedure TForm1.LoadAdventureFile1Click(Sender: TObject);
begin
  if dlgOpen1.Execute then
  begin
    DataReader.Filename := dlgOpen1.Filename;
    AdventureData := GetAdventureGame(DataReader);
    LogMsg('Adventuregame: "' + AdventureData.MetaInfo.Title + '" by ' +
      AdventureData.MetaInfo.Author);
    LogMsg('Node count: ' + inttostr(AdventureData.GameNodes.Count));
    LogMsg('Script count: ' + inttostr(AdventureData.Scripts.Count));
    UpdateNodeLists;
    UpdateVariables;
    InitScriptEditorCompletion;
    UpdateScriptEditorVariables;
    UpdateScriptEditorCompletion;
    CurrentFilename := extractfilename(dlgOpen1.Filename);
    FIsModified := False;
    UpdateCaption;
    UpdateScriptSelectors;
    lblScriptCount.Caption := 'Scripts: ' + IntToStr(AdventureData.Scripts.Count);
  end;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  if FIsModified then
  begin
    case MessageDlg('Do you want to save changes before quitting?',
      mtConfirmation, mbYesNoCancel, 0) of
      mrYes:
        begin
          SaveAdventureFile1Click(Self);
          halt;
        end;
      mrNo:
        halt;
      mrCancel:
        Exit;
    end;
  end
  else
    halt;
end;

procedure UpdateNodeCommandSel;
var
  i: Integer;
begin
  i := Form1.lstcommands.itemindex;
  if TheNode.NodeCommands.CMD[i].Variable <> '' then
    Form1.lstcommands.Items[i] := TheNode.NodeCommands.CMD[i].Name + '(' +
      TheNode.NodeCommands.CMD[i].Variable + ') ' +
      TheNode.NodeCommands.CMD[i].Text
  else

    Form1.lstcommands.Items[i] := TheNode.NodeCommands.CMD[i].Name + ' ' +
      TheNode.NodeCommands.CMD[i].Text;
end;

procedure UpdateNodeCommands;
var
  i: Integer;
begin
  Form1.lstcommands.Items.Clear;
  for i := 0 to TheNode.NodeCommands.Count - 1 do
  begin
    if TheNode.NodeCommands.CMD[i].Variable <> '' then
      Form1.lstcommands.Items.add(TheNode.NodeCommands.CMD[i].Name + '(' +
        TheNode.NodeCommands.CMD[i].Variable + ') ' +
        TheNode.NodeCommands.CMD[i].Text)
    else

      Form1.lstcommands.Items.add(TheNode.NodeCommands.CMD[i].Name + ' ' +
        TheNode.NodeCommands.CMD[i].Text);
  end;
end;

procedure UpdateChoiceSel;
var
  selind: Integer;
begin
  selind := Form1.lstchoicelist.itemindex;
  Form1.lstchoicelist.Items[selind] := TheNode.choices.Choice[selind].Text +
    ' -> ' + TheNode.choices.Choice[selind].Targetnode + ' (' +
    inttostr(TheNode.choices.Choice[selind].Addscore) + ' pts)';

end;

procedure UpdateChoices;
var
  i: Integer;
begin
  Form1.lstchoicelist.Items.Clear;
  for i := 0 to TheNode.choices.Count - 1 do
  begin
    Form1.lstchoicelist.Items.add(TheNode.choices.Choice[i].Text + ' -> ' +
      TheNode.choices.Choice[i].Targetnode + ' (' +
      inttostr(TheNode.choices.Choice[i].Addscore) + ' pts)');
  end;
end;

procedure TForm1.btnAddChoiceClick(Sender: TObject);
begin
  thechoice := TheNode.choices.add;
  thechoice.Targetnode := '';
  thechoice.Text := '<< NEW CHOICE >>';
  thechoice.Endgame := false;
  thechoice.Wingame := false;

  thechoice.Addscore := 0;
  Commandlist := TheNode.ChoiceCommands.add;

  ConditionList := TheNode.ChoiceConditions.add;
  UpdateChoices;
  Modified := True;
end;

procedure TForm1.btnDeleteChoiceClick(Sender: TObject);
begin
  TheNode.choices.Delete(lstchoicelist.itemindex);
  TheNode.ChoiceCommands.Delete(lstchoicelist.itemindex);
  TheNode.ChoiceConditions.Delete(lstchoicelist.itemindex);

  UpdateChoices;
  Modified := True;
end;

procedure TForm1.lstchoicelistClick(Sender: TObject);
begin
  // prevent list index out of bounds with this
  if lstchoicelist.ItemIndex < 0 then Exit;

  thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
  edtchoicetext.Text := thechoice.Text;
  cbbchoicenodelist.itemindex := cbbchoicenodelist.Items.IndexOf
    (thechoice.Targetnode);
  chkChoiceEndGame.Checked := thechoice.Endgame;
  chkChoiceWinGame.Checked := thechoice.Wingame;
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
    for Y := 0 to AdventureData.GameNodes.Node[X].choices.Count - 1 do
    begin
      LogMsg('Added commands list for choice: ' + inttostr(Y) + ' in node ' +
        AdventureData.GameNodes.Node[X].Name);
      ChoiceCommands := AdventureData.GameNodes.Node[X].ChoiceCommands.add;
    end;
  end;
end;

procedure TForm1.SaveAdventureFile1Click(Sender: TObject);
begin
  if dlgSave1.Execute then
  begin
    AdventureData := GetAdventureGame(DataReader);

    DataReader.SaveToFile(dlgSave1.Filename);
    CurrentFilename := extractfilename(dlgSave1.Filename);
    FIsModified := False;
    UpdateCaption;
    LogMsg('File saved: ' + dlgSave1.Filename);
  end;
end;

procedure TForm1.Scripts1Click(Sender: TObject);
begin
  updatescripts;
  form5.showmodal;
  UpdateScriptSelectors;
  lblScriptCount.Caption := 'Scripts: ' + IntToStr(AdventureData.Scripts.Count);
end;

procedure TForm1.ScriptSelectorClick(Sender: TObject);
begin
  thecmd.Text := AdventureData.Scripts.Script[ScriptSelectorMain.itemindex].Name;
  UpdateNodeCommandSel;
end;

procedure TForm1.ShowNodeLinks1Click(Sender: TObject);
var
  z, u: Integer;
begin
  // Implementation for showing node links
  LogMsg('Node links analysis:');
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    for z := 0 to AdventureData.GameNodes.Node[u].choices.Count - 1 do
    begin
      if AdventureData.GameNodes.Node[u].Choices.Choice[z].Targetnode <> '' then
      begin
        LogMsg(AdventureData.GameNodes.Node[u].Name + ' -> ' +
          AdventureData.GameNodes.Node[u].Choices.Choice[z].Targetnode);
      end;
    end;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  btnCreateNodeClick(Sender);
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  NodeIndex: Integer;
  NodeName: string;
begin
  if AdventureData = nil then
  begin
    MessageDlg('Create or open an adventure first', mtInformation, [mbOK], 0);
    Exit;
  end;

  if nodes_tree.Selected = nil then
  begin
    MessageDlg('Please select a node to delete', mtInformation, [mbOK], 0);
    Exit;
  end;

  NodeName := nodes_tree.Selected.Text;
  if MessageDlg('Delete node "' + NodeName + '" and all its choices?',
    mtConfirmation, mbYesNo, 0) <> mrYes then
    Exit;

  NodeIndex := FindNodeIndexByName(NodeName);
  if NodeIndex = -1 then
  begin
    MessageDlg('The selected node could not be found in the project.',
      mtError, [mbOK], 0);
    Exit;
  end;

  TheNode := nil;
  thechoice := nil;
  thecmd := nil;

  AdventureData.GameNodes.Delete(NodeIndex);
  RemoveNodeReferences(NodeName);
  UpdateNodeLists;
  ClearNodeEditor;
  Modified := True;
  LogMsg('Node "' + NodeName + '" deleted');
end;

procedure TForm1.btnApplyChangesClick(Sender: TObject);
begin
  if TheNode <> nil then
  begin
    TheNode.Name := edtnodename.Text;
    TheNode.DescriptionText := mmonodetext.Lines.Text;
    if node_parent.ItemIndex > 0 then
      TheNode.NodeParent := node_parent.Text
    else
      TheNode.NodeParent := '';
    Modified := True;
    LogMsg('Node changes applied');
    UpdateNodeLists;
  end;
end;

procedure TForm1.cbbchoicenodelistClick(Sender: TObject);
begin
  if (lstchoicelist.ItemIndex >= 0) and (cbbchoicenodelist.ItemIndex >= 0) then
  begin
    thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
    thechoice.Targetnode := cbbchoicenodelist.Items[cbbchoicenodelist.ItemIndex];
    UpdateChoiceSel;
    Modified := True;
  end;
end;

procedure TForm1.edtchoicetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
    thechoice.Text := edtchoicetext.Text;
    UpdateChoiceSel;
    Modified := True;
  end;
end;

procedure TForm1.chkendgameClick(Sender: TObject);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
    thechoice.Endgame := chkChoiceEndGame.Checked;
    Modified := True;
  end;
end;

procedure TForm1.gamewinnerClick(Sender: TObject);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
    thechoice.Wingame := chkChoiceWinGame.Checked;
    Modified := True;
  end;
end;

procedure TForm1.mmonodetextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Modified := True;
end;

procedure TForm1.ValidateNodes1Click(Sender: TObject);
var
  u, z: Integer;
  Errors: Integer;
begin
  Errors := 0;
  LogMsg('Validating nodes...');

  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    // Check for empty node names
    if AdventureData.GameNodes.Node[u].Name = '' then
    begin
      LogMsg('ERROR: Node at index ' + IntToStr(u) + ' has no name');
      Inc(Errors);
    end;

    // Check for empty node text
    if AdventureData.GameNodes.Node[u].DescriptionText = '' then
    begin
      LogMsg('WARNING: Node "' + AdventureData.GameNodes.Node[u].Name + '" has no description');
    end;

    // Check for broken choice links
    for z := 0 to AdventureData.GameNodes.Node[u].choices.Count - 1 do
    begin
      if AdventureData.GameNodes.Node[u].Choices.Choice[z].Targetnode <> '' then
      begin
        // Verify target node exists
        // Implementation would check the target exists
      end;
    end;
  end;

  if Errors = 0 then
    LogMsg('Validation complete: No errors found')
  else
    LogMsg('Validation complete: ' + IntToStr(Errors) + ' error(s) found');
end;

procedure TForm1.Metadata1Click(Sender: TObject);
begin
  form2.showmodal;
end;

procedure TForm1.edtchoicescoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    thechoice := TheNode.choices.Choice[lstchoicelist.itemindex];
    thechoice.Addscore := StrToIntDef(edtchoicescore.Text, 0);
    UpdateChoiceSel;
    Modified := True;
  end;
end;

procedure TForm1.btnAddCommandClick(Sender: TObject);
begin
  if TheNode <> nil then
  begin
    newcmd := TheNode.NodeCommands.add;
    newcmd.Name := 'SetVar';
    newcmd.Text := '';
    UpdateNodeCommands;
    Modified := True;
  end;
end;

procedure TForm1.btnDeleteCommandClick(Sender: TObject);
begin
  if (TheNode <> nil) and (lstcommands.ItemIndex >= 0) then
  begin
    TheNode.NodeCommands.Delete(lstcommands.ItemIndex);
    UpdateNodeCommands;
    Modified := True;
  end;
end;

procedure TForm1.cbbcmdClick(Sender: TObject);
begin
  if (TheNode <> nil) and (lstcommands.ItemIndex >= 0) then
  begin
    thecmd := TheNode.NodeCommands.CMD[lstcommands.ItemIndex];
    thecmd.Name := cbbcmd.Items[cbbcmd.ItemIndex];
    UpdateNodeCommandSel;
    Modified := True;
  end;
end;

procedure TForm1.cbbvarselClick(Sender: TObject);
begin
  if (TheNode <> nil) and (lstcommands.ItemIndex >= 0) then
  begin
    thecmd := TheNode.NodeCommands.CMD[lstcommands.ItemIndex];
    thecmd.Variable := cbbvarsel.Items[cbbvarsel.ItemIndex];
    UpdateNodeCommandSel;
    Modified := True;
  end;
end;

procedure TForm1.mmoparamvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (TheNode <> nil) and (lstcommands.ItemIndex >= 0) then
  begin
    thecmd := TheNode.NodeCommands.CMD[lstcommands.ItemIndex];
    thecmd.Text := mmoparamval.Lines.Text;
    Modified := True;
  end;
end;

procedure TForm1.lstcommandsClick(Sender: TObject);
begin
  if (TheNode <> nil) and (lstcommands.ItemIndex >= 0) then
  begin
    thecmd := TheNode.NodeCommands.CMD[lstcommands.ItemIndex];
    cbbcmd.ItemIndex := cbbcmd.Items.IndexOf(thecmd.Name);
    cbbvarsel.ItemIndex := cbbvarsel.Items.IndexOf(thecmd.Variable);
    mmoparamval.Lines.Text := thecmd.Text;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FIsModified := False;
  CurrentFilename := '';
  lblStatus.Caption := 'Ready';
  lblNodeCount.Caption := 'Nodes: 0';
  lblScriptCount.Caption := 'Scripts: 0';
  lblCurrentTime.Caption := FormatDateTime('HH:nn:ss', Now);
end;

procedure TForm1.NewAdventureFile1Click(Sender: TObject);
begin
  if FIsModified then
  begin
    if MessageDlg('Do you want to save changes before creating a new file?',
      mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      SaveAdventureFile1Click(Self);
    end;
  end;

  // Create new adventure
  AdventureData := NewAdventureGame;
  AdventureData.MetaInfo.Title := 'Untitled Adventure';
  AdventureData.MetaInfo.Author := 'Unknown';

  CurrentFilename := 'Untitled.xml';
  FIsModified := True;
  UpdateCaption;
  UpdateNodeLists;
  UpdateVariables;
  UpdateScriptSelectors;
  LogMsg('New adventure created');
end;

procedure TForm1.btnCreateNodeClick(Sender: TObject);
var
  NodeName: string;
begin
  if AdventureData = nil then
  begin
    MessageDlg('Create or open an adventure first', mtInformation, [mbOK], 0);
    Exit;
  end;

  NodeName := Trim(newnodename.Text);
  if NodeName = '' then
  begin
    MessageDlg('Please enter a node name', mtWarning, [mbOK], 0);
    Exit;
  end;

  NewNode := AdventureData.GameNodes.add;
  NewNode.Name := NodeName;
  NewNode.DescriptionText := '';
  if node_parent.ItemIndex > 0 then
    NewNode.NodeParent := node_parent.Items[node_parent.ItemIndex]
  else
    NewNode.NodeParent := '';

  UpdateNodeLists;
  newnodename.Text := '';
  Modified := True;
  LogMsg('Node "' + NodeName + '" created');
end;

procedure TForm1.nodes_treeClick(Sender: TObject);
var
  NodeName: string;
  u: Integer;
begin
  if nodes_tree.Selected = nil then Exit;

  NodeName := nodes_tree.Selected.Text;

  // Find the node in AdventureData
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    if AdventureData.GameNodes.Node[u].Name = NodeName then
    begin
      TheNode := AdventureData.GameNodes.Node[u];

      // Load node data into editor
      edtnodename.Text := TheNode.Name;
      mmonodetext.Lines.Text := TheNode.DescriptionText;
      node_parent.ItemIndex := node_parent.Items.IndexOf(TheNode.NodeParent);
      if node_parent.ItemIndex = -1 then
        node_parent.ItemIndex := 0;

      // Load choices
      UpdateChoices;

      // Load commands
      UpdateNodeCommands;

      lblStatus.Caption := 'Editing: ' + NodeName;
      Exit;
    end;
  end;
end;

procedure TForm1.node_parentClick(Sender: TObject);
begin
  // Parent selection changed - could auto-update if editing a node
  Modified := True;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  IDEAboutForm.ShowModal;
end;

procedure TForm1.btnCloneNodeClick(Sender: TObject);
begin
  if nodes_tree.Selected = nil then
  begin
    MessageDlg('Please select a node to clone', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Clone the selected node
  if TheNode <> nil then
  begin
    NewNode := AdventureData.GameNodes.add;
    NewNode.Name := TheNode.Name + '_copy';
    NewNode.DescriptionText := TheNode.DescriptionText;
    NewNode.NodeParent := TheNode.NodeParent;

    // Copy choices
    // Implementation would go here

    UpdateNodeLists;
    Modified := True;
    LogMsg('Node cloned');
  end;
end;

procedure TForm1.btnEditChoiceConditionsClick(Sender: TObject);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    form6.showmodal;
  end;
end;

procedure TForm1.btnEditChoiceCommandsClick(Sender: TObject);
begin
  if (lstchoicelist.ItemIndex >= 0) and (TheNode <> nil) then
  begin
    form4.showmodal;
  end;
end;

procedure TForm1.Variables1Click(Sender: TObject);
begin
  Form3.ShowModal;
  UpdateVariables;
end;

procedure TForm1.Compilersettings1Click(Sender: TObject);
begin
  form9.showmodal;
end;

procedure TForm1.Additionalfiles1Click(Sender: TObject);
begin
  form10.showmodal;
end;

procedure TForm1.Compileadventure1Click(Sender: TObject);
begin
  if dlgSave2.Execute then
  begin
    // Compile the adventure
    LogMsg('Compiling adventure to: ' + dlgSave2.FileName);
    // Implementation would go here
    LogMsg('Compilation complete');
    Modified := False;
  end;
end;

procedure TForm1.Audiodevices1Click(Sender: TObject);
begin
  form11.showmodal;
end;

// Toolbar button implementations
procedure TForm1.tbNewClick(Sender: TObject);
begin
  NewAdventureFile1Click(Sender);
end;

procedure TForm1.tbOpenClick(Sender: TObject);
begin
  LoadAdventureFile1Click(Sender);
end;

procedure TForm1.tbSaveClick(Sender: TObject);
begin
  SaveAdventureFile1Click(Sender);
end;

procedure TForm1.tbCompileClick(Sender: TObject);
begin
  Compileadventure1Click(Sender);
end;

procedure TForm1.tbValidateClick(Sender: TObject);
begin
  ValidateNodes1Click(Sender);
end;

procedure TForm1.tbScriptsClick(Sender: TObject);
begin
  Scripts1Click(Sender);
end;

procedure TForm1.tbVariablesClick(Sender: TObject);
begin
  Variables1Click(Sender);
end;

// Panel toggle implementations
procedure TForm1.ToggleNodePanel1Click(Sender: TObject);
begin
  TogglePanel(pnlNodeTree, ToggleNodePanel1);
end;

procedure TForm1.ToggleChoicePanel1Click(Sender: TObject);
begin
  TogglePanel(pnlChoices, ToggleChoicePanel1);
end;

procedure TForm1.ToggleCommandPanel1Click(Sender: TObject);
begin
  TogglePanel(pnlCommands, ToggleCommandPanel1);
end;

procedure TForm1.ToggleMessages1Click(Sender: TObject);
begin
  TogglePanel(pnlMessages, ToggleMessages1);
end;

procedure TForm1.TogglePanel(Panel: TPanel; MenuItem: TMenuItem);
begin
  Panel.Visible := not Panel.Visible;
  MenuItem.Checked := Panel.Visible;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  lblCurrentTime.Caption := FormatDateTime('HH:nn:ss', Now);
end;

end.
