unit ProjectSettingsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, JvExControls, JvLabel,
  JvxSlider;

type
  TForm9 = class(TForm)
    audioenabled: TCheckBox;
    Label1: TLabel;
    soundvolume: TJvxSlider;
    debugmode: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    soundvolumelabel: TLabel;
    procedure soundvolumeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.soundvolumeChange(Sender: TObject);
begin
soundvolumelabel.caption := inttostr(soundvolume.Value);
end;

end.
