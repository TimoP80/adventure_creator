unit ScriptEditorForm;

interface

uses
  CocoBase, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  AdventureFile, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls,
  AdventureScriptCompilerUtils, AdventureScript, SynEditHighlighter,
  AdventureBinary, SynHighlighterCS, SynCompletionProposal, Vcl.Menus,
  Vcl.ToolWin, Vcl.ImgList,
  System.UITypes, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  // Debug information types
  TDebugTimestamp = record
    TickCount: Int64;
    Timestamp: TDateTime;
    Description: string;
    Category: string;
  end;

  TVariableDebugInfo = record
    Name: string;
    Value: string;
    VarType: string;
    LineNumber: Integer;
  end;

  TExecutionTraceEntry = record
    StepNumber: Integer;
    Instruction: string;
    LineNumber: Integer;
    Timestamp: Int64;
    Variables: array of TVariableDebugInfo;
  end;

  TPerformanceMetric = record
    Name: string;
    StartTime: Int64;
    EndTime: Int64;
    Duration: Double;
    MemoryBefore: Int64;
    MemoryAfter: Int64;
  end;

  TForm5 = class(TForm)
    // Main panels
    pnlToolbar: TPanel;
    pnlScriptList: TPanel;
    pnlEditor: TPanel;
    pnlOutput: TPanel;
    pnlDebug: TPanel;

    // Toolbar buttons
    tbNewScript: TToolButton;
    tbInsertScript: TToolButton;
    tbDeleteScript: TToolButton;
    tbSep1: TToolButton;
    tbMoveUp: TToolButton;
    tbMoveDown: TToolButton;
    tbSep2: TToolButton;
    tbCompile: TToolButton;
    tbRun: TToolButton;
    tbSep3: TToolButton;
    tbClose: TToolButton;

    // Script list panel
    lblScriptList: TLabel;
    ScriptList: TListBox;
    btnNewScript: TButton;
    btnInsertScript: TButton;
    btnDeleteScript: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;

    // Editor panel
    lblScriptName: TLabel;
    ScriptName: TEdit;
    lblScriptFilename: TLabel;
    ScriptFilename: TEdit;
    lblScriptAuthor: TLabel;
    ScriptAuthor: TEdit;
    chkIsBootScript: TCheckBox;
    lblScriptCode: TLabel;
    SynEdit1: TSynEdit;
    SynCSSyn1: TSynCSSyn;
    SynCompletionProposal1: TSynCompletionProposal;

    // Output panel
    lblOutput: TLabel;
    btnClearOutput: TButton;
    compileddataview: TMemo;

    // Debug panel components
    pnlDebugControls: TPanel;
    lblDebugInfo: TLabel;
    debugTreeView: TTreeView;
    pnlDebugFilter: TPanel;
    lblFilter: TLabel;
    cmbDebugFilter: TComboBox;
    chkShowTimestamps: TCheckBox;
    chkShowVariables: TCheckBox;
    chkShowTrace: TCheckBox;
    chkShowErrors: TCheckBox;
    chkShowPerformance: TCheckBox;
    btnExportDebug: TButton;
    btnClearDebug: TButton;
    pnlDebugStats: TPanel;
    lblMemoryUsage: TLabel;
    lblCompileTime: TLabel;
    lblInstructionCount: TLabel;
    lblErrorCount: TLabel;
    lblExecutionTime: TLabel;

    // Action buttons
    btnCompileScript: TButton;
    btnRunScript: TButton;
    btnScriptTools: TButton;

    // Popup menu
    PopupMenu1: TPopupMenu;
    CreateRandomstringgroup1: TMenuItem;
    Createmultilinemessage1: TMenuItem;

    // Debug panel tabs
    tabDebugOutput: TTabControl;

    // Keyboard shortcuts
    procedure ScriptListClick(Sender: TObject);
    procedure ScriptNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScriptFilenameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScriptAuthorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScriptListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    // Button handlers
    procedure btnNewScriptClick(Sender: TObject);
    procedure btnInsertScriptClick(Sender: TObject);
    procedure btnDeleteScriptClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnCompileScriptClick(Sender: TObject);
    procedure btnRunScriptClick(Sender: TObject);
    procedure btnClearOutputClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkIsBootScriptClick(Sender: TObject);
    procedure btnExportDebugClick(Sender: TObject);
    procedure btnClearDebugClick(Sender: TObject);

    // Debug tree view handlers
    procedure debugTreeViewClick(Sender: TObject);
    procedure debugTreeViewExpander(TNode: TTreeNode);

    // Filter handlers
    procedure cmbDebugFilterChange(Sender: TObject);
    procedure chkDebugFilterClick(Sender: TObject);

    // Popup menu handlers
    procedure CreateRandomstringgroup1Click(Sender: TObject);
    procedure Createmultilinemessage1Click(Sender: TObject);

    // Panel toggle handlers
    procedure ToggleOutputPanel(Sender: TObject);

  private
    { Private declarations }
    FCurrentScriptModified: boolean;
    // Debug data
    FDebugTimestamps: array of TDebugTimestamp;
    FExecutionTrace: array of TExecutionTraceEntry;
    FPerformanceMetrics: array of TPerformanceMetric;
    FErrorStackTrace: TStrings;
    FVariableSnapshots: array of array of TVariableDebugInfo;
    FDebugStartTime: Int64;
    FLastMemoryUsage: Int64;
    procedure SetModified(Value: boolean);
    procedure UpdateStatusBar;
    procedure AddDebugTimestamp(Category, Description: string);
    procedure AddExecutionTrace(Instruction: string; LineNumber: Integer);
    procedure AddVariableSnapshot(const Variables: array of TVariableDebugInfo);
    procedure StartPerformanceMetric(Name: string);
    procedure EndPerformanceMetric(Name: string);
    procedure CaptureMemoryUsage(var Memory: Int64);
    procedure PopulateDebugTreeView;
    procedure FilterDebugTreeView;
    procedure ExportDebugInfoToFile(Filename: string);
    procedure ClearDebugData;
    procedure GetCurrentVariables(var Variables: TArray<TVariableDebugInfo>);
  public
    { Public declarations }
    property Modified: boolean read FCurrentScriptModified write SetModified;
  end;

var
  Form5: TForm5;
  Script: IXMLScriptType;
  ScriptParser: TAdventureScript;
  ScriptListTemp: IXMLScriptsType;

procedure UpdateScripts;

implementation

uses AdventureCreatorIDEMain, AddRandomGroup, AddMultilineMessage, System.Diagnostics;

{ TForm5 Debug Methods }

procedure TForm5.CaptureMemoryUsage(var Memory: Int64);
var
  MemStatus: TMemoryStatus;
begin
  MemStatus.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MemStatus);
  Memory := MemStatus.dwAvailPhys;
end;

procedure TForm5.AddDebugTimestamp(Category, Description: string);
var
  Index: Integer;
begin
  Index := Length(FDebugTimestamps);
  SetLength(FDebugTimestamps, Index + 1);
  FDebugTimestamps[Index].TickCount := GetTickCount64;
  FDebugTimestamps[Index].Timestamp := Now;
  FDebugTimestamps[Index].Category := Category;
  FDebugTimestamps[Index].Description := Description;
end;

procedure TForm5.AddExecutionTrace(Instruction: string; LineNumber: Integer);
var
  Index: Integer;
begin
  Index := Length(FExecutionTrace);
  SetLength(FExecutionTrace, Index + 1);
  FExecutionTrace[Index].StepNumber := Index + 1;
  FExecutionTrace[Index].Instruction := Instruction;
  FExecutionTrace[Index].LineNumber := LineNumber;
  FExecutionTrace[Index].Timestamp := GetTickCount64;
  SetLength(FExecutionTrace[Index].Variables, 0);
end;

procedure TForm5.AddVariableSnapshot(const Variables: array of TVariableDebugInfo);
var
  SnapshotIndex, VarIndex: Integer;
begin
  SnapshotIndex := Length(FVariableSnapshots);
  SetLength(FVariableSnapshots, SnapshotIndex + 1);
  SetLength(FVariableSnapshots[SnapshotIndex], Length(Variables));
  for VarIndex := 0 to Length(Variables) - 1 do
    FVariableSnapshots[SnapshotIndex][VarIndex] := Variables[VarIndex];
end;

procedure TForm5.StartPerformanceMetric(Name: string);
var
  Index: Integer;
begin
  Index := Length(FPerformanceMetrics);
  SetLength(FPerformanceMetrics, Index + 1);
  FPerformanceMetrics[Index].Name := Name;
  FPerformanceMetrics[Index].StartTime := GetTickCount64;
  CaptureMemoryUsage(FPerformanceMetrics[Index].MemoryBefore);
end;

procedure TForm5.EndPerformanceMetric(Name: string);
var
  i: Integer;
begin
  for i := 0 to Length(FPerformanceMetrics) - 1 do
  begin
    if (FPerformanceMetrics[i].Name = Name) and (FPerformanceMetrics[i].EndTime = 0) then
    begin
      FPerformanceMetrics[i].EndTime := GetTickCount64;
      FPerformanceMetrics[i].Duration := (FPerformanceMetrics[i].EndTime - FPerformanceMetrics[i].StartTime) / 1000.0;
      CaptureMemoryUsage(FPerformanceMetrics[i].MemoryAfter);
      Break;
    end;
  end;
end;

procedure TForm5.GetCurrentVariables(var Variables: TArray<TVariableDebugInfo>);
begin
  // This would need to be connected to the actual runtime variable system
  // Placeholder implementation - the actual variables would come from the script engine
  SetLength(Variables, 0);
end;

procedure TForm5.PopulateDebugTreeView;
var
  RootNode, CategoryNode, ItemNode: TTreeNode;
  i, j: Integer;
  TimestampStr: string;
begin
  debugTreeView.Items.Clear;

  // Root node
  RootNode := debugTreeView.Items.Add(nil, 'Debug Session: ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));

  // Compilation timestamps
  if chkShowTimestamps.Checked then
  begin
    CategoryNode := debugTreeView.Items.AddChild(RootNode, 'Compilation Timestamps');
    for i := 0 to Length(FDebugTimestamps) - 1 do
    begin
      if FDebugTimestamps[i].Category = 'Compilation' then
      begin
        TimestampStr := FormatDateTime('hh:nn:ss.zzz', FDebugTimestamps[i].Timestamp);
        ItemNode := debugTreeView.Items.AddChild(CategoryNode,
          TimestampStr + ' - ' + FDebugTimestamps[i].Description);
        ItemNode.Data := Pointer(i);
      end;
    end;
    if CategoryNode.Count = 0 then
      CategoryNode.Delete;
  end;

  // Execution trace
  if chkShowTrace.Checked and (Length(FExecutionTrace) > 0) then
  begin
    CategoryNode := debugTreeView.Items.AddChild(RootNode, 'Execution Trace (' + IntToStr(Length(FExecutionTrace)) + ' steps)');
    for i := 0 to Length(FExecutionTrace) - 1 do
    begin
      ItemNode := debugTreeView.Items.AddChild(CategoryNode,
        Format('[%4d] Line %d: %s', [FExecutionTrace[i].StepNumber, FExecutionTrace[i].LineNumber, FExecutionTrace[i].Instruction]));
      ItemNode.Data := Pointer(i + 1000); // Offset to distinguish from timestamps
    end;
  end;

  // Variable snapshots
  if chkShowVariables.Checked and (Length(FVariableSnapshots) > 0) then
  begin
    CategoryNode := debugTreeView.Items.AddChild(RootNode, 'Variable Snapshots (' + IntToStr(Length(FVariableSnapshots)) + ' snapshots)');
    for i := 0 to Length(FVariableSnapshots) - 1 do
    begin
      ItemNode := debugTreeView.Items.AddChild(CategoryNode, 'Snapshot #' + IntToStr(i + 1));
      for j := 0 to Length(FVariableSnapshots[i]) - 1 do
      begin
        debugTreeView.Items.AddChild(ItemNode,
          FVariableSnapshots[i][j].Name + ' = ' + FVariableSnapshots[i][j].Value + ' (' + FVariableSnapshots[i][j].VarType + ')');
      end;
    end;
  end;

  // Performance metrics
  if chkShowPerformance.Checked and (Length(FPerformanceMetrics) > 0) then
  begin
    CategoryNode := debugTreeView.Items.AddChild(RootNode, 'Performance Metrics');
    for i := 0 to Length(FPerformanceMetrics) - 1 do
    begin
      if FPerformanceMetrics[i].EndTime > 0 then
      begin
        ItemNode := debugTreeView.Items.AddChild(CategoryNode,
          Format('%s: %.3f seconds', [FPerformanceMetrics[i].Name, FPerformanceMetrics[i].Duration]));
        debugTreeView.Items.AddChild(ItemNode,
          Format('Memory Delta: %d bytes', [FPerformanceMetrics[i].MemoryAfter - FPerformanceMetrics[i].MemoryBefore]));
      end;
    end;
  end;

  // Errors and warnings
  if chkShowErrors.Checked and (FErrorStackTrace.Count > 0) then
  begin
    CategoryNode := debugTreeView.Items.AddChild(RootNode, 'Errors & Warnings (' + IntToStr(FErrorStackTrace.Count) + ')');
    for i := 0 to FErrorStackTrace.Count - 1 do
      debugTreeView.Items.AddChild(CategoryNode, FErrorStackTrace[i]);
  end;

  RootNode.Expand(True);
end;

procedure TForm5.FilterDebugTreeView;
begin
  PopulateDebugTreeView;
end;

procedure TForm5.ExportDebugInfoToFile(Filename: string);
var
  ExportFile: TextFile;
  i, j: Integer;
begin
  AssignFile(ExportFile, Filename);
  Rewrite(ExportFile);

  WriteLn(ExportFile, '=== Adventure Creator IDE - Debug Export ===');
  WriteLn(ExportFile, 'Generated: ', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
  WriteLn(ExportFile);

  // Timestamps
  WriteLn(ExportFile, '--- COMPILATION TIMESTAMPS ---');
  for i := 0 to Length(FDebugTimestamps) - 1 do
  begin
    WriteLn(ExportFile, Format('[%s] %s: %s',
      [FormatDateTime('hh:nn:ss.zzz', FDebugTimestamps[i].Timestamp),
       FDebugTimestamps[i].Category,
       FDebugTimestamps[i].Description]));
  end;
  WriteLn(ExportFile);

  // Execution trace
  WriteLn(ExportFile, '--- EXECUTION TRACE ---');
  for i := 0 to Length(FExecutionTrace) - 1 do
  begin
    WriteLn(ExportFile, Format('[Step %4d] Line %4d: %s',
      [FExecutionTrace[i].StepNumber, FExecutionTrace[i].LineNumber, FExecutionTrace[i].Instruction]));
  end;
  WriteLn(ExportFile);

  // Performance metrics
  WriteLn(ExportFile, '--- PERFORMANCE METRICS ---');
  for i := 0 to Length(FPerformanceMetrics) - 1 do
  begin
    if FPerformanceMetrics[i].EndTime > 0 then
    begin
      WriteLn(ExportFile, Format('%s: %.3f seconds', [FPerformanceMetrics[i].Name, FPerformanceMetrics[i].Duration]));
      WriteLn(ExportFile, Format('  Memory: %d -> %d (delta: %d)',
        [FPerformanceMetrics[i].MemoryBefore, FPerformanceMetrics[i].MemoryAfter,
         FPerformanceMetrics[i].MemoryAfter - FPerformanceMetrics[i].MemoryBefore]));
    end;
  end;
  WriteLn(ExportFile);

  // Errors
  if FErrorStackTrace.Count > 0 then
  begin
    WriteLn(ExportFile, '--- ERRORS & WARNINGS ---');
    for i := 0 to FErrorStackTrace.Count - 1 do
      WriteLn(ExportFile, FErrorStackTrace[i]);
  end;

  CloseFile(ExportFile);
end;

procedure TForm5.ClearDebugData;
begin
  SetLength(FDebugTimestamps, 0);
  SetLength(FExecutionTrace, 0);
  SetLength(FPerformanceMetrics, 0);
  SetLength(FVariableSnapshots, 0);
  FErrorStackTrace.Clear;
  debugTreeView.Items.Clear;
  lblMemoryUsage.Caption := 'Memory: N/A';
  lblCompileTime.Caption := 'Compile Time: N/A';
  lblInstructionCount.Caption := 'Instructions: N/A';
  lblErrorCount.Caption := 'Errors: N/A';
  lblExecutionTime.Caption := 'Execution Time: N/A';
end;

procedure TForm5.btnExportDebugClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'Text Files (*.txt)|*.txt|XML Files (*.xml)|*.xml|JSON Files (*.json)|*.json';
    SaveDialog.DefaultExt := 'txt';
    SaveDialog.FileName := 'DebugExport_' + FormatDateTime('yyyyMMdd_hhnnss', Now);
    if SaveDialog.Execute then
      ExportDebugInfoToFile(SaveDialog.FileName);
  finally
    SaveDialog.Free;
  end;
end;

procedure TForm5.btnClearDebugClick(Sender: TObject);
begin
  ClearDebugData;
end;

procedure TForm5.debugTreeViewClick(Sender: TObject);
begin
  // Handle click on tree view items if needed
end;

procedure TForm5.debugTreeViewExpander(TNode: TTreeNode);
begin
  // Handle expansion events if needed
end;

procedure TForm5.cmbDebugFilterChange(Sender: TObject);
begin
  FilterDebugTreeView;
end;

procedure TForm5.chkDebugFilterClick(Sender: TObject);
begin
  FilterDebugTreeView;
end;

{$R *.dfm}

procedure UpdateSelected;
var
  ind: integer;
begin
  ind := Form5.ScriptList.ItemIndex;
  if ind >= 0 then
    Form5.ScriptList.Items[ind] := AdventureData.Scripts.Script[ind].Name;
end;

procedure UpdateScripts;
var
  u: integer;
begin
  if AdventureData = nil then Exit;
  Form5.ScriptList.Clear;
  for u := 0 to AdventureData.Scripts.Count - 1 do
  begin
    Form5.ScriptList.Items.Add(AdventureData.Scripts.Script[u].Name);
  end;
  updatescriptselectors;
end;

procedure TForm5.SetModified(Value: boolean);
begin
  FCurrentScriptModified := Value;
  UpdateStatusBar;
end;

procedure TForm5.UpdateStatusBar;
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    if FCurrentScriptModified then
      lblScriptList.Caption := 'Scripts - ' + ScriptName.Text + ' *'
    else
      lblScriptList.Caption := 'Scripts - ' + ScriptName.Text;
  end
  else
    lblScriptList.Caption := 'Scripts';
end;

procedure TForm5.btnNewScriptClick(Sender: TObject);
var
  templateloader: tstrings;
begin
  templateloader := TStringlist.Create;
  Script := AdventureData.Scripts.Add;
  Script.Name := '<< NEW SCRIPT >>';
  Script.Filename := '';
  Script.Author := AdventureData.MetaInfo.Author;
  Script.IsBootScript := false;
  templateloader.LoadFromFile('Script Templates\Script_Template.as');
  Script.Text := templateloader.Text;
  UpdateScripts;
  templateloader.Free;
  Modified := True;
end;

procedure TForm5.btnInsertScriptClick(Sender: TObject);
var
  templateloader: tstrings;
begin
  if ScriptList.ItemIndex < 0 then
  begin
    btnNewScriptClick(Sender);
    Exit;
  end;

  templateloader := TStringlist.Create;
  Script := AdventureData.Scripts.Insert(ScriptList.ItemIndex);
  Script.Name := '<< NEW SCRIPT >>';
  Script.Filename := '';
  Script.Author := AdventureData.MetaInfo.Author;
  Script.IsBootScript := false;
  templateloader.LoadFromFile('Script Templates\Script_Template.as');
  Script.Text := templateloader.Text;
  UpdateScripts;
  templateloader.Free;
  Modified := True;
end;

procedure TForm5.btnDeleteScriptClick(Sender: TObject);
begin
  if ScriptList.ItemIndex < 0 then Exit;

  if MessageDlg('Delete script "' + AdventureData.Scripts.Script[ScriptList.ItemIndex].Name + '"?',
    mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    AdventureData.Scripts.Delete(ScriptList.ItemIndex);
    UpdateScripts;
    // Clear editor
    ScriptName.Text := '';
    ScriptFilename.Text := '';
    ScriptAuthor.Text := '';
    SynEdit1.Lines.Text := '';
    chkIsBootScript.Checked := False;
    Modified := True;
  end;
end;

procedure TForm5.btnMoveUpClick(Sender: TObject);
var
  script_temp_name, script_temp_filename, script_temp_author: string;
  script_temp_bootscript: boolean;
  script_temp_text: string;
begin
  if ScriptList.ItemIndex <= 0 then Exit;

  script_temp_name := AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Name;
  script_temp_filename := AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Filename;
  script_temp_author := AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Author;
  script_temp_bootscript := AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].IsBootScript;
  script_temp_text := AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Text;

  AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Name :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Name;
  AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Filename :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Author :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].IsBootScript :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex - 1].Text :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Text;

  AdventureData.Scripts.Script[ScriptList.ItemIndex].Name := script_temp_name;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename := script_temp_filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Author := script_temp_author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript := script_temp_bootscript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Text := script_temp_text;

  UpdateScripts;
  ScriptList.ItemIndex := ScriptList.ItemIndex - 1;
  Modified := True;
end;

procedure TForm5.btnMoveDownClick(Sender: TObject);
var
  script_temp_name, script_temp_filename, script_temp_author: string;
  script_temp_bootscript: boolean;
  script_temp_text: string;
begin
  if ScriptList.ItemIndex >= ScriptList.Items.Count - 1 then Exit;

  script_temp_name := AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Name;
  script_temp_filename := AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Filename;
  script_temp_author := AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Author;
  script_temp_bootscript := AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].IsBootScript;
  script_temp_text := AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Text;

  AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Name :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Name;
  AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Filename :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Author :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].IsBootScript :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex + 1].Text :=
    AdventureData.Scripts.Script[ScriptList.ItemIndex].Text;

  AdventureData.Scripts.Script[ScriptList.ItemIndex].Name := script_temp_name;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename := script_temp_filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Author := script_temp_author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript := script_temp_bootscript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Text := script_temp_text;

  UpdateScripts;
  ScriptList.ItemIndex := ScriptList.ItemIndex + 1;
  Modified := True;
end;

procedure TForm5.btnCompileScriptClick(Sender: TObject);
var
  i: integer;
  scriptdisassembly: tstrings;
  CompileStartTime, CompileEndTime: Int64;
  MemoryBefore, MemoryAfter: Int64;
  ErrorStr: string;
begin
  if ScriptList.ItemIndex < 0 then
  begin
    MessageDlg('Please select a script to compile', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Start debug tracking
  ClearDebugData;
  FErrorStackTrace := TStringList.Create;
  FDebugStartTime := GetTickCount64;
  CaptureMemoryUsage(MemoryBefore);
  AddDebugTimestamp('Compilation', 'Starting script compilation: ' + ScriptName.Text);
  StartPerformanceMetric('Script Compilation');

  ScriptParser := TAdventureScript.Create(nil);
  SynEdit1.Lines.SaveToFile('temp.as');
  ScriptParser.SourceFileName := 'temp.as';
  InitScriptData(currentscript, '', '', '');

  AddDebugTimestamp('Compilation', 'Parser initialized, starting compilation');
  ScriptParser.Execute;

  if ScriptParser.Successful = true then
  begin
    AddDebugTimestamp('Compilation', 'Compilation successful');
    LogMsg('Successfully compiled script "' + ScriptName.Text + '" with ' +
      IntToStr(currentscript.instruction_count) + ' instructions.');
    scriptdisassembly := DisassembleScript(currentscript);
    compileddataview.Text := scriptdisassembly.Text;
    DeleteFile('temp.as');

    // Update debug info
    lblInstructionCount.Caption := 'Instructions: ' + IntToStr(currentscript.instruction_count);
    lblErrorCount.Caption := 'Errors: 0';
  end
  else
  begin
    AddDebugTimestamp('Compilation', 'Compilation failed with errors');
    ErrorStr := 'Script "' + ScriptName.Text + '" has ' + IntToStr(ScriptParser.ErrorList.Count) + ' error(s).';
    LogMsg(ErrorStr);
    FErrorStackTrace.Add(ErrorStr);

    for i := 0 to ScriptParser.ErrorList.Count - 1 do
    begin
      ErrorStr := 'Error #' + IntToStr(i) + ' line ' +
        IntToStr(TCocoError(ScriptParser.ErrorList.Items[i]).Line) + ', col ' +
        IntToStr(TCocoError(ScriptParser.ErrorList.Items[i]).Col) + ': ' +
        string(TCocoError(ScriptParser.ErrorList.Items[i]).Data);
      LogMsg(ErrorStr);
      FErrorStackTrace.Add(ErrorStr);
      AddDebugTimestamp('Error', ErrorStr);
    end;
    DeleteFile('temp.as');

    // Update debug info
    lblInstructionCount.Caption := 'Instructions: 0';
    lblErrorCount.Caption := 'Errors: ' + IntToStr(ScriptParser.ErrorList.Count);
  end;

  // End debug tracking
  EndPerformanceMetric('Script Compilation');
  CompileEndTime := GetTickCount64;
  CaptureMemoryUsage(MemoryAfter);
  AddDebugTimestamp('Compilation', Format('Compilation finished in %d ms', [CompileEndTime - FDebugStartTime]));

  lblCompileTime.Caption := 'Compile Time: ' + FormatFloat('0.000', (CompileEndTime - FDebugStartTime) / 1000.0) + 's';
  lblMemoryUsage.Caption := 'Memory: ' + FormatFloat('#,', MemoryAfter) + ' bytes';

  // Populate debug tree view
  PopulateDebugTreeView;
end;

procedure TForm5.btnRunScriptClick(Sender: TObject);
var
  i: integer;
  ExecStartTime, ExecEndTime: Int64;
  ErrorStr: string;
begin
  if ScriptList.ItemIndex < 0 then
  begin
    MessageDlg('Please select a script to run', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Start execution debug tracking
  AddDebugTimestamp('Execution', 'Starting script execution: ' + ScriptName.Text);
  StartPerformanceMetric('Script Execution');
  ExecStartTime := GetTickCount64;

  ScriptParser := TAdventureScript.Create(nil);
  SynEdit1.Lines.SaveToFile('temp.as');
  ScriptParser.SourceFileName := 'temp.as';
  InitScriptData(currentscript, '', '', '');
  ScriptParser.Execute;

  if ScriptParser.Successful = true then
  begin
    AddDebugTimestamp('Execution', 'Compilation successful, starting runtime');
    LogMsg('Successfully compiled the edited script with ' +
      IntToStr(currentscript.instruction_count) + ' instructions.');

    // Add execution trace entry
    AddExecutionTrace('Starting main entry point', 0);
    RunScript(currentscript, 'Main');

    DeleteFile('temp.as');
    AddDebugTimestamp('Execution', 'Script execution completed');
    LogMsg('Script executed successfully');
  end
  else
  begin
    AddDebugTimestamp('Execution', 'Compilation failed, cannot execute');
    ErrorStr := 'Script has ' + IntToStr(ScriptParser.ErrorList.Count) + ' error(s).';
    LogMsg(ErrorStr);
    FErrorStackTrace.Add(ErrorStr);

    for i := 0 to ScriptParser.ErrorList.Count - 1 do
    begin
      ErrorStr := 'Error #' + IntToStr(i) + ' line ' +
        IntToStr(TCocoError(ScriptParser.ErrorList.Items[i]).Line) + ', col ' +
        IntToStr(TCocoError(ScriptParser.ErrorList.Items[i]).Col) + ': ' +
        string(TCocoError(ScriptParser.ErrorList.Items[i]).Data);
      LogMsg(ErrorStr);
      FErrorStackTrace.Add(ErrorStr);
      AddDebugTimestamp('Error', ErrorStr);
    end;
    DeleteFile('temp.as');
  end;

  // End execution debug tracking
  EndPerformanceMetric('Script Execution');
  ExecEndTime := GetTickCount64;
  AddDebugTimestamp('Execution', Format('Execution finished in %d ms', [ExecEndTime - ExecStartTime]));

  lblExecutionTime.Caption := 'Execution Time: ' + FormatFloat('0.000', (ExecEndTime - ExecStartTime) / 1000.0) + 's';

  // Update debug tree
  PopulateDebugTreeView;
end;

procedure TForm5.btnClearOutputClick(Sender: TObject);
begin
  compileddataview.Clear;
end;

procedure TForm5.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm5.Createmultilinemessage1Click(Sender: TObject);
var
  Text: string;
  i: integer;
  linetemp: string;
begin
  form8.showmodal;

  if form8.modalresult = mrOK then
  begin
    for i := 0 to form8.StringsList.Lines.Count - 1 do
    begin
      linetemp := form8.StringsList.Lines[i];
      linetemp := StringReplace(linetemp, '\','\\',[rfReplaceAll]);
      linetemp := StringReplace(linetemp, '"','\"',[rfReplaceAll]);

      Text := 'DisplayMessage("' + linetemp + '");' + #13#10;
      SynEdit1.InsertLine(SynEdit1.CaretXY, SynEdit1.CaretXY,
        pwidechar(Text), false);
      if form8.LineDelay.Checked then
      begin
        Text := 'Delay(' + form8.DelayAmount.Text + ');' + #13#10;
        SynEdit1.InsertLine(SynEdit1.CaretXY, SynEdit1.CaretXY,
          pwidechar(Text), false);
      end;
    end;
    Modified := True;
  end;
end;

procedure TForm5.CreateRandomstringgroup1Click(Sender: TObject);
var
  Text: string;
  i: integer;
begin
  form7.showmodal;

  if form7.ModalResult = mrOK then
  begin
    Text := 'InitRandomList("' + form7.GroupID.Text + '");' + #13#10;
    SynEdit1.InsertLine(SynEdit1.CaretXY, SynEdit1.CaretXY,
      pwidechar(Text), false);
    for i := 0 to form7.StringsList.Lines.Count - 1 do
    begin
      Text := 'AddToRandomList("' + form7.GroupID.Text + '","' +
        form7.StringsList.Lines[i] + '");' + #13#10;
      SynEdit1.InsertLine(SynEdit1.CaretXY, SynEdit1.CaretXY,
        pwidechar(Text), false);
    end;
    Modified := True;
  end;
end;

procedure TForm5.chkIsBootScriptClick(Sender: TObject);
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    Script.IsBootScript := chkIsBootScript.Checked;
    Modified := True;
  end;
end;

procedure TForm5.ScriptAuthorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    Script.Author := ScriptAuthor.Text;
    Modified := True;
  end;
end;

procedure TForm5.ScriptFilenameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    Script.Filename := ScriptFilename.Text;
    Modified := True;
  end;
end;

procedure TForm5.ScriptListClick(Sender: TObject);
begin
  if ScriptList.ItemIndex < 0 then Exit;

  Script := AdventureData.Scripts.Script[ScriptList.ItemIndex];

  ScriptName.Text := Script.Name;
  ScriptFilename.Text := Script.Filename;
  ScriptAuthor.Text := Script.Author;
  chkIsBootScript.Checked := Script.IsBootScript;
  SynEdit1.Lines.Text := Script.Text;

  FCurrentScriptModified := False;
  UpdateStatusBar;
end;

procedure TForm5.ScriptListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  CursorPos: TPoint;
begin
  CursorPos.X := X;
  CursorPos.Y := Y;
  if ScriptList.ItemAtPos(CursorPos, True) = -1 then
  begin
    ScriptName.Text := '';
    ScriptFilename.Text := '';
    ScriptAuthor.Text := '';
    SynEdit1.Text := '';
    chkIsBootScript.Checked := False;
    ScriptList.ItemIndex := -1;
    FCurrentScriptModified := False;
    UpdateStatusBar;
  end;
end;

procedure TForm5.ScriptNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    Script.Name := ScriptName.Text;
    UpdateSelected;
    UpdateStatusBar;
    Modified := True;
  end;
end;

procedure TForm5.SynEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ScriptList.ItemIndex >= 0 then
  begin
    Script.Text := SynEdit1.Lines.Text;
    Modified := True;
  end;
end;

procedure TForm5.ToggleOutputPanel(Sender: TObject);
begin
  pnlOutput.Visible := not pnlOutput.Visible;
end;

end.
