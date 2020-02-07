unit ScriptEditorForm;

interface

uses
  CocoBase, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  AdventureFile, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls,
  AdventureScriptCompilerUtils, AdventureScript, SynEditHighlighter,
  AdventureBinary, SynHighlighterCS, SynCompletionProposal;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  Script: IXMLScriptType;
  ScriptParser: TAdventureScript;

procedure UpdateScripts;

implementation

uses AdventureCreatorIDEMain;

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
  Script.IsBootScript:=false;
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
var i: integer;
scriptdisassembly: TStrings;
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
   scriptdisassembly := DisassembleScript(CurrentScript);
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

procedure TForm5.IsBootScriptClick(Sender: TObject);
begin
Script.IsBootScript:=isbootscript.Checked;
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
  Script := AdventureData.Scripts.Script[ScriptList.ItemIndex];

  ScriptName.Text := Script.Name;
  ScriptFilename.Text := Script.Filename;
  ScriptAuthor.Text := Script.Author;
  isbootscript.Checked := Script.IsBootScript;

  SynEdit1.Lines.Text := Script.Text;

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
