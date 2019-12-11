program AdventureCreatorIDE;

uses
  Forms,
  AdventureCreatorIDEMain in 'AdventureCreatorIDEMain.pas' {Form1},
  AdventureBinaryRuntime in 'AdventureBinaryRuntime.pas',
  MetaData in 'MetaData.pas' {Form2},
  VarEditor in 'VarEditor.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles,
  ChoiceCommandsForm in 'ChoiceCommandsForm.pas' {Form4},
  AboutForm in 'AboutForm.pas' {IDEAboutForm},
  ChoiceConditionsForm in 'ChoiceConditionsForm.pas' {Form6},
  AdventureFile in 'AdventureFile.pas';

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Auric');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TIDEAboutForm, IDEAboutForm);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TIDEAboutForm, IDEAboutForm);
  Application.Run;
end.
