unit ScriptEditorForm;

interface

uses
  CocoBase, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  AdventureFile, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls,
  AdventureScriptCompilerUtils, AdventureScript, SynEditHighlighter,
  AdventureBinary, SynHighlighterCS, SynCompletionProposal, Vcl.Menus;

type
  TForm5 = class(TForm)
    ScriptList: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    SynEdit1: TSynEdit;
    SynCSSyn1: TSynCSSyn;
    Label3: TLabel;
    ScriptName: TEdit;
    Label4: TLabel;
    ScriptFilename: TEdit;
    Label5: TLabel;
    ScriptAuthor: TEdit;
    Button3: TButton;
    SynCompletionProposal1: TSynCompletionProposal;
    Button4: TButton;
    Label6: TLabel;
    compileddataview: TMemo;
    Button5: TButton;
    IsBootScript: TCheckBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    PopupMenu1: TPopupMenu;
    CreateRandomstringgroup1: TMenuItem;
    Createmultilinemessage1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScriptListClick(Sender: TObject);
    procedure ScriptNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScriptFilenameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScriptAuthorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure IsBootScriptClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure CreateRandomstringgroup1Click(Sender: TObject);
    procedure Createmultilinemessage1Click(Sender: TObject);
    procedure ScriptListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  Script: IXMLScriptType;
  ScriptParser: TAdventureScript;
  ScriptListTemp: IXMLScriptsType;

procedure UpdateScripts;

implementation

uses AdventureCreatorIDEMain, AddRandomGroup, AddMultilineMessage;

{$R *.dfm}

procedure UpdateSelected;
var
  ind: integer;
begin
  ind := Form5.ScriptList.ItemIndex;

  Form5.ScriptList.Items[ind] := AdventureData.Scripts.Script[ind].Name;

end;

procedure UpdateScripts;
var
  u: integer;
begin
  Form5.ScriptList.Clear;

  for u := 0 to AdventureData.Scripts.Count - 1 do
  begin
    Form5.ScriptList.Items.Add(AdventureData.Scripts.Script[u].Name);
  end;
  updatescriptselectors;
end;

procedure TForm5.Button1Click(Sender: TObject);
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

end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  AdventureData.Scripts.Delete(ScriptList.ItemIndex);
  UpdateScripts;

end;

procedure TForm5.Button4Click(Sender: TObject);
var
  i: integer;
begin
  ScriptParser := TAdventureScript.Create(nil);
  SynEdit1.Lines.SaveToFile('temp.as');
  ScriptParser.SourceFileName := 'temp.as';
  InitScriptData(currentscript, '', '', '');
  ScriptParser.Execute;
  if ScriptParser.Successful = true then
  begin
    LogMsg('Successfully compiled the edited script with ' +
      inttostr(currentscript.instruction_count) + ' instructions.');
    RunScript(currentscript, 'Main');
    DeleteFile('temp.as');
  end
  else
  begin
    // showmessage(Scriptparser.ListStream.ToString);
    LogMsg('Script has ' + inttostr(ScriptParser.ErrorList.Count) +
      ' error(s).');
    for i := 0 to ScriptParser.ErrorList.Count - 1 do
    begin
      LogMsg('Error #' + inttostr(i) + ' line ' +
        inttostr(TCocoError(ScriptParser.ErrorList.Items[i]).Line) + ', col ' +
        inttostr(TCocoError(ScriptParser.ErrorList.Items[i]).Col) + ': ' +
        ScriptParser.ErrorStr(TCocoError(ScriptParser.ErrorList.Items[i])
        .ErrorCode, TCocoError(ScriptParser.ErrorList.Items[i]).Data));
    end;
    DeleteFile('temp.as');
  end;
end;

procedure TForm5.Button5Click(Sender: TObject);
var
  i: integer;
  scriptdisassembly: tstrings;
begin
  ScriptParser := TAdventureScript.Create(nil);
  SynEdit1.Lines.SaveToFile('temp.as');
  ScriptParser.SourceFileName := 'temp.as';
  InitScriptData(currentscript, '', '', '');
  ScriptParser.Execute;
  if ScriptParser.Successful = true then
  begin
    LogMsg('Successfully compiled the edited script with ' +
      inttostr(currentscript.instruction_count) + ' instructions.');
    scriptdisassembly := DisassembleScript(currentscript);
    compileddataview.Text := scriptdisassembly.Text;

    DeleteFile('temp.as');
  end
  else
  begin
    // showmessage(Scriptparser.ListStream.ToString);
    LogMsg('Script has ' + inttostr(ScriptParser.ErrorList.Count) +
      ' error(s).');
    for i := 0 to ScriptParser.ErrorList.Count - 1 do
    begin
      LogMsg('Error #' + inttostr(i) + ' line ' +
        inttostr(TCocoError(ScriptParser.ErrorList.Items[i]).Line) + ', col ' +
        inttostr(TCocoError(ScriptParser.ErrorList.Items[i]).Col) + ': ' +
        ScriptParser.ErrorStr(TCocoError(ScriptParser.ErrorList.Items[i])
        .ErrorCode, TCocoError(ScriptParser.ErrorList.Items[i]).Data));
    end;
    DeleteFile('temp.as');
  end;
end;

procedure TForm5.Button6Click(Sender: TObject);
var
  script_temp_current: IXMLScriptType;
  script_temp_name, script_temp_filename, script_temp_author: string;
  script_temp_bootscript: boolean;
  script_temp_text: string;
begin
  if ScriptList.ItemIndex = 0 then
    exit;
  // ScriptListTemp:=
  script_temp_name := AdventureData.Scripts.Script
    [ScriptList.ItemIndex - 1].Name;
  script_temp_filename := AdventureData.Scripts.Script
    [ScriptList.ItemIndex - 1].Filename;
  script_temp_author := AdventureData.Scripts.Script
    [ScriptList.ItemIndex - 1].Author;
  script_temp_bootscript := AdventureData.Scripts.Script
    [ScriptList.ItemIndex - 1].IsBootScript;
  script_temp_text := AdventureData.Scripts.Script
    [ScriptList.ItemIndex - 1].Text;

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
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename :=
    script_temp_filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Author :=
    script_temp_author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript :=
    script_temp_bootscript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Text := script_temp_text;
  UpdateScripts;

end;

procedure TForm5.Button7Click(Sender: TObject);
var
  script_temp_current: IXMLScriptType;
  script_temp_name, script_temp_filename, script_temp_author: string;
  script_temp_bootscript: boolean;
  script_temp_text: string;
begin
  if ScriptList.ItemIndex = ScriptList.Items.Count - 1 then
    exit;
  // ScriptListTemp:=
  script_temp_name := AdventureData.Scripts.Script
    [ScriptList.ItemIndex + 1].Name;
  script_temp_filename := AdventureData.Scripts.Script
    [ScriptList.ItemIndex + 1].Filename;
  script_temp_author := AdventureData.Scripts.Script
    [ScriptList.ItemIndex + 1].Author;
  script_temp_bootscript := AdventureData.Scripts.Script
    [ScriptList.ItemIndex + 1].IsBootScript;
  script_temp_text := AdventureData.Scripts.Script
    [ScriptList.ItemIndex + 1].Text;

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
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Filename :=
    script_temp_filename;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Author :=
    script_temp_author;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].IsBootScript :=
    script_temp_bootscript;
  AdventureData.Scripts.Script[ScriptList.ItemIndex].Text := script_temp_text;
  UpdateScripts;

end;

procedure TForm5.Button8Click(Sender: TObject);
var
  templateloader: tstrings;
begin
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
  end;

end;

procedure TForm5.CreateRandomstringgroup1Click(Sender: TObject);
var
  Text: string;
  i: integer;
begin
  form7.showmodal;

  if form7.modalresult = mrOK then
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
  end;
end;

procedure TForm5.IsBootScriptClick(Sender: TObject);
begin
  Script.IsBootScript := IsBootScript.Checked;
end;

procedure TForm5.ScriptAuthorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Script.Author := ScriptAuthor.Text;
end;

procedure TForm5.ScriptFilenameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Script.Filename := ScriptFilename.Text;
end;

procedure TForm5.ScriptListClick(Sender: TObject);
begin
if scriptlist.ItemIndex=-1 then
  exit;

  Script := AdventureData.Scripts.Script[ScriptList.ItemIndex];

  ScriptName.Text := Script.Name;
  ScriptFilename.Text := Script.Filename;
  ScriptAuthor.Text := Script.Author;
  IsBootScript.Checked := Script.IsBootScript;

  SynEdit1.Lines.Text := Script.Text;

end;

procedure TForm5.ScriptListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var CursorPos: tpoint;
  begin
  cursorpos.X:=x;
  cursorpos.Y:=y;
 if ScriptList.ItemAtPos(cursorpos,true)=-1 then
      begin
        ScriptName.Text:='';
        ScriptFilename.Text:='';
        ScriptAuthor.Text := '';
        SynEdit1.Text := '';
        IsBootScript.Checked:=false;
        scriptlist.ItemIndex:=-1;
      end;
end;

procedure TForm5.ScriptNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Script.Name := ScriptName.Text;
  UpdateSelected;
end;

procedure TForm5.SynEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Script.Text := SynEdit1.Lines.Text;
end;

end.
