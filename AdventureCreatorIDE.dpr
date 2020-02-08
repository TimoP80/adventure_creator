program AdventureCreatorIDE;

uses
  Windows,
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
  ScriptEditorForm in 'ScriptEditorForm.pas' {Form5},
  AdventureFile in 'AdventureFile.pas',
  AddRandomGroup in 'AddRandomGroup.pas' {Form7};

{$R *.res}

begin

  Application.Initialize;
  Application.Title := 'Adventure Creator IDE';
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TIDEAboutForm, IDEAboutForm);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TIDEAboutForm, IDEAboutForm);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm7, Form7);
  Application.Run;

end.
