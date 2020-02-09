unit AddMultilineMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm8 = class(TForm)
    Label2: TLabel;
    StringsList: TMemo;
    Button1: TButton;
    Button2: TButton;
    LineDelay: TCheckBox;
    DelayAmount: TEdit;
    procedure LineDelayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.LineDelayClick(Sender: TObject);
begin
  DelayAmount.enabled:=linedelay.Checked;
end;

end.
