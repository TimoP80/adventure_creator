unit AboutForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GR32_Image;

type
  TIDEAboutForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Image321: TImage32;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IDEAboutForm: TIDEAboutForm;

implementation

{$R *.dfm}

end.
