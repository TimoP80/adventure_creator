unit AudioDevicesForm;

interface

uses
  Winapi.Windows, Dynamic_bass, Winapi.Messages, ACSOundLib, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm11 = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Close: TButton;
    devicename: TLabel;
    edtdevicename: TEdit;
    Label2: TLabel;
    edtdevicedriver: TEdit;
    Label3: TLabel;
    DeviceEnabledFlag: TCheckBox;
    DeviceInitFlag: TCheckBox;
    DeviceDefaultFlag: TCheckBox;
    Button1: TButton;
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;
  deviceinfos: array of BASS_DEVICEINFO;
  infocnt: integer;
procedure GetDevices;
implementation

{$R *.dfm}

procedure GetDevices;
var
  u: integer;
begin
  Form11.ListBox1.Clear;
  u := 1;
  infocnt := 0;
  setlength(deviceinfos, infocnt + 1);
  while BASS_GetDeviceinfo(u, deviceinfos[infocnt]) = true do
  begin
    setlength(deviceinfos, u + 1);
    inc(infocnt);
    inc(u);
  end;

  for u := 0 to infocnt - 1 do
  begin
   if ((deviceinfos[u].flags and BASS_DEVICE_INIT)<>0) then

    Form11.ListBox1.Items.Add(deviceinfos[u].name+' [Current device]') else
    Form11.ListBox1.Items.Add(deviceinfos[u].name);
  end;
end;

procedure TForm11.Button1Click(Sender: TObject);
begin
BASS_Free;
InitSound(application.Handle, ListBox1.itemindex+1);
GetDevices;
end;

procedure TForm11.ListBox1Click(Sender: TObject);
begin;

edtdevicename.Text := deviceinfos[listbox1.itemindex].name;
edtdevicedriver.Text := deviceinfos[listbox1.ItemIndex].driver;
if ((deviceinfos[listbox1.ItemIndex].flags and BASS_DEVICE_ENABLED) <> 0) then
  DeviceEnabledFlag.Checked := true else DeviceEnabledFlag.checked:=false;

if ((deviceinfos[listbox1.ItemIndex].flags and BASS_DEVICE_INIT)<>0) then
  DeviceInitFlag.Checked := true else DeviceInitFlag.checked:=false;

if ((deviceinfos[listbox1.ItemIndex].flags and BASS_DEVICE_DEFAULT)<>0) then

  DeviceDefaultFlag.Checked := true else DeviceDefaultFlag.checked:=false;

end;

end.
