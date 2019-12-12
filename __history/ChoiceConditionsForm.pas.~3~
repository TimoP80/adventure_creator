unit ChoiceConditionsForm;

interface

uses
  Winapi.Windows, AdventureFile, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm6 = class(TForm)
    grp1: TGroupBox;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lstconditions: TListBox;
    btn8: TButton;
    btn9: TButton;
    cbbcmd: TComboBox;
    cbbvarsel: TComboBox;
    mmoparamval: TMemo;
    Label1: TLabel;
    evallist: TComboBox;
    Button1: TButton;
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure cbbcmdClick(Sender: TObject);
    procedure cbbvarselClick(Sender: TObject);
    procedure evallistClick(Sender: TObject);
    procedure mmoparamvalKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  condition: IXMLConditionType;

procedure UpdateChoiceConditions;
procedure UpdateChoiceConditionSel;

implementation

uses AdventureCreatorIDEMain, ChoiceCommandsForm;
{$R *.dfm}

procedure UpdateChoiceConditionSel;
var
  i: integer;
begin
  i := form6.lstconditions.itemindex;
  if conditionlist.condition[i].Varname <> '' then
    form6.lstconditions.items[i] := conditionlist.condition[i].Name + ' (' +
      conditionlist.condition[i].Varname + ') ' + conditionlist.condition[i]
      .Eval + ' ' + conditionlist.condition[i].Text
  else

    form6.lstconditions.items[i] := conditionlist.condition[i].Name + ' ' +
      conditionlist.condition[i].Eval + ' ' + conditionlist.condition[i].Text;
end;

procedure UpdateChoiceConditions;
var
  i: integer;
begin
  form6.lstconditions.items.Clear;
  for i := 0 to conditionlist.count - 1 do
  begin
    if conditionlist.condition[i].Varname <> '' then
      form6.lstconditions.items.Add(conditionlist.condition[i].Name + ' (' +
        conditionlist.condition[i].Varname + ') ' + conditionlist.condition[i]
        .Eval + ' ' + conditionlist.condition[i].Text)
    else

      form6.lstconditions.items.Add(conditionlist.condition[i].Name + ' ' +
        conditionlist.condition[i].Eval + ' ' + conditionlist.condition
        [i].Text);
  end;
end;

procedure TForm6.btn8Click(Sender: TObject);
begin
  condition := conditionlist.Add;
  condition.Name := '<< NEW CONDITION >>';
  UpdateChoiceConditions;
  end;

procedure TForm6.btn9Click(Sender: TObject);
begin
 conditionlist.Delete(lstconditions.itemindex);
 UpdateChoiceConditions;
end;

procedure TForm6.cbbcmdClick(Sender: TObject);
begin
condition.Name := cbbcmd.Text;
UpdateChoiceConditionSel;
end;

procedure TForm6.cbbvarselClick(Sender: TObject);
begin
condition.Varname := cbbvarsel.Text;
UpdateChoiceConditionSel;

end;

procedure TForm6.evallistClick(Sender: TObject);
begin
condition.Eval := evallist.Text;
UpdateChoiceConditionSel;

end;

procedure TForm6.mmoparamvalKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
condition.Text := mmoparamval.Text;
UpdateChoiceConditionSel;

end;

end.
