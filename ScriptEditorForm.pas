unit ScriptEditorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  AdventureFile, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls,
  SynEditHighlighter, AdventureBinary, SynHighlighterCS;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  Script: IXMLScriptType;

  procedure UpdateScripts;

implementation

uses AdventureCreatorIDEMain;

{$R *.dfm}

procedure UpdateSelected;
var ind: integer;
begin
 ind := Form5.ScriptList.ItemIndex;

  Form5.ScriptList.Items[ind]  := AdventureData.Scripts.Script[ind].Name;

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

end;

procedure TForm5.Button1Click(Sender: TObject);
begin
  Script := AdventureData.Scripts.Add;
  Script.Name := '<< NEW SCRIPT >>';
  Script.Filename := '';
  Script.Author := AdventureData.MetaInfo.Author;
  UpdateScripts;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  AdventureData.Scripts.Delete(ScriptList.itemindex);
  UpdateScripts;

end;

procedure TForm5.ScriptAuthorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Script.Author := scriptauthor.Text;
end;

procedure TForm5.ScriptFilenameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Script.Filename := scriptfilename.text;
end;

procedure TForm5.ScriptListClick(Sender: TObject);
begin
  Script := AdventureData.Scripts.Script[ScriptList.itemindex];

  ScriptName.text := Script.Name;
  ScriptFilename.text := Script.Filename;
  ScriptAuthor.text := Script.Author;

  SynEdit1.Lines.text := Script.text;

end;

procedure TForm5.ScriptNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 script.Name := scriptname.Text;
 UpdateSelected;
end;

procedure TForm5.SynEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Script.text := SynEdit1.Lines.text;
end;

end.