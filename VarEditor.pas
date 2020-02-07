unit VarEditor;

interface

uses
  Windows, AdventureFile, AdventureBinary, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm3 = class(TForm)
    lbl1: TLabel;
    lstvarlist: TListBox;
    btn1: TButton;
    btn2: TButton;
    lbl2: TLabel;
    edtvarname: TEdit;
    lbl3: TLabel;
    edtstartval: TEdit;
    btn3: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure lstvarlistClick(Sender: TObject);
    procedure edtvarnameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtstartvalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  TheVar: IXMLVariabletype;

procedure UpdateVarList;

implementation

procedure UpdateVarList;
var
  u: integer;
begin
  Form3.lstvarlist.items.clear;
  for u := 0 to AdventureData.Variables.Count - 1 do
  begin
    Form3.lstvarlist.items.Add(AdventureData.Variables.Variable[u].name);
  end;
end;
{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
begin
  TheVar := AdventureData.Variables.Add;
  TheVar.name := '<< NEW VARIABLE >>';
  UpdateVarList;
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
  AdventureData.Variables.Delete(lstvarlist.itemindex);
  UpdateVarList;

end;

procedure TForm3.lstvarlistClick(Sender: TObject);
begin
  TheVar := AdventureData.Variables[lstvarlist.itemindex];
  edtvarname.Text := TheVar.name;
  edtstartval.Text := TheVar.Text;
end;

procedure TForm3.edtvarnameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TheVar.name := edtvarname.Text;
  lstvarlist.items[lstvarlist.itemindex] := TheVar.name;
end;

procedure TForm3.edtstartvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TheVar.Text := edtstartval.Text;
end;

end.
