unit AdditionalFilesForm;

interface

uses
  Winapi.Windows, AdventureFile, Winapi.Messages, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit;

type
  TForm10 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    filepath: TEdit;
    Label2: TLabel;
    filename: TEdit;
    Label3: TLabel;
    filedesc: TEdit;
    Button3: TButton;
    Label4: TLabel;
    Button5: TButton;
    JvFilenameEdit1: TJvFilenameEdit;
    Label5: TLabel;
    typeselector: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure filedescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure filepathKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure filenameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure typeselectorClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
  filetemp: IXMLFileType;

procedure UpdateAdditionalFiles;

implementation

uses adventurebinary;
{$R *.dfm}

procedure UpdateAdditionalFilesSel;
var
  i: integer;
begin
  i := Form10.ListBox1.ItemIndex;
  Form10.ListBox1.Items[i] := adventuredata.AdditionalFiles.File_[i].text + ' ('
    + adventuredata.AdditionalFiles.File_[i].Name + ')';
end;

procedure UpdateAdditionalFiles;
var
  i: integer;
begin
  Form10.ListBox1.Items.Clear;
  for i := 0 to adventuredata.AdditionalFiles.Count - 1 do
  begin
    Form10.ListBox1.Items.Add(adventuredata.AdditionalFiles.File_[i].text + ' ('
      + adventuredata.AdditionalFiles.File_[i].Name + ')');
  end;
end;

procedure TForm10.Button1Click(Sender: TObject);
begin
  filetemp := adventuredata.AdditionalFiles.Add;
  filetemp.Path := '';
  filetemp.text := '<< NEW FILE >>';
  filetemp.File_type := '';
  filetemp.Name := 'newfile.txt';
  UpdateAdditionalFiles;
end;

procedure TForm10.Button2Click(Sender: TObject);
begin
  adventuredata.AdditionalFiles.Delete(ListBox1.ItemIndex);
  UpdateAdditionalFiles;
end;

procedure TForm10.Button5Click(Sender: TObject);
begin
filepath.Text := extractfiledir(JvFilenameEdit1.FileName);
filename.Text := extractfilename(jvfilenameedit1.FileName);
filetemp.Name := filename.Text;
filetemp.Path := filepath.text;
UpdateAdditionalFilesSel;
end;

procedure TForm10.filedescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  filetemp.text := filedesc.text;
  UpdateAdditionalFilesSel;

end;

procedure TForm10.filenameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  filetemp.Name := filename.text;
  UpdateAdditionalFilesSel;

end;

procedure TForm10.filepathKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  filetemp.Path := filepath.text;
  UpdateAdditionalFilesSel;
end;

procedure TForm10.ListBox1Click(Sender: TObject);
begin
  filetemp := adventuredata.AdditionalFiles.File_[ListBox1.ItemIndex];

  filepath.text := filetemp.Path;
  filename.text := filetemp.Name;
  filedesc.text := filetemp.text;
  typeselector.ItemIndex := typeselector.Items.IndexOf(filetemp.File_type);
end;

procedure TForm10.typeselectorClick(Sender: TObject);
begin
  filetemp.File_type := typeselector.text;
  UpdateAdditionalFilesSel;

end;

end.
