unit AdditionalFilesForm;

interface

uses
  Winapi.Windows, AdventureFile, ACSoundLib,Winapi.Messages, System.SysUtils,
  System.Variants, Dynamic_bass,  ID3v1library, id3v2library,
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
    Label6: TLabel;
    Button4: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure filedescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure filepathKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure filenameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure typeselectorClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;
  filetemp: IXMLFileType;
  id3v1: TID3v1Tag;
  id3v2: TID3v2Tag;

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

procedure TForm10.Button4Click(Sender: TObject);
begin

if BASS_ChannelIsActive(musicstream)=BASS_ACTIVE_PLAYING then
  BASS_ChannelStop(musicstream);

if BASS_ChannelIsActive(
modulestream)=BASS_ACTIVE_PLAYING then
  BASS_ChannelStop(modulestream);

  if (extractfileext(JvFilenameEdit1.FileName)='.mp3')
or (extractfileext(JvFilenameEdit1.FileName)='.flac') or
 (extractfileext(JvFilenameEdit1.FileName)='.wav')
then
begin
   PlayMusic(jvfilenameedit1.FileName, -1);
end else
begin
   PlayModule(jvfilenameedit1.FileName);

end;
end;

function GetMediafileTitle(filename: string): string;
var
  ext: string;
  fname: pointer;
  modhandle: HMUSIC;
  streamhandle: HSTREAM;
  tags: ansistring;
begin
 result:='';
 ext := ExtractFileExt(filename);
 if (ext = '.xm') or (ext = '.mod') or (ext='.s3m') or (ext = '.it') then
 begin
 fname:=pchar(filename);
   modhandle := BASS_MusicLoad(false, fname, 0, 0, 0 or BASS_UNICODE, 0);
   if modhandle<>0 then
   begin
     tags := BASS_channelgettags(modhandle, BASS_TAG_MUSIC_NAME);
     if tags<>'' then

     result:=tags;

   end;
 end;
 if (ext = '.mp3') then
 begin
   id3v2 := TID3v2Tag.Create;
   id3v2.LoadFromFile(filename);
   if id3v2.Loaded then
   begin
       result := id3v2.GetUnicodeText('TPE1')+' - '+id3v2.GetUnicodeText('TIT2');
   end else
   begin
      id3v1 := TID3v1Tag.Create;
     id3v1.LoadFromFile(filename);
     if id3v1.Loaded=True then
     begin
     
       result:=id3v1.Artist + ' - '+id3v1.Title;

     end;
   end;
 end;
end;

procedure TForm10.Button5Click(Sender: TObject);
var str: string;
begin
  filepath.text := extractfiledir(JvFilenameEdit1.filename);
  filename.text := extractfilename(JvFilenameEdit1.filename);
  filetemp.Name := filename.text;
  filetemp.Path := filepath.text;
str := GetMediafileTitle(jvfilenameedit1.filename);
  if str<>'' then filedesc.Text := str;
  filetemp.Text := str;
  UpdateAdditionalFilesSel;
end;

procedure TForm10.Button6Click(Sender: TObject);
begin
if BASS_ChannelIsActive(musicstream)=BASS_ACTIVE_PLAYING then
  BASS_ChannelStop(musicstream);

if BASS_ChannelIsActive(
modulestream)=BASS_ACTIVE_PLAYING then
  BASS_ChannelStop(modulestream);

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
