program AdventureCreatorIDE;

uses
  Forms,
  AdventureCreatorIDEMain in 'AdventureCreatorIDEMain.pas' {Form1},
  AdventureBinary in 'AdventureBinary.pas',
  MetaData in 'MetaData.pas' {Form2},
  VarEditor in 'VarEditor.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles,
  ChoiceCommandsForm in 'ChoiceCommandsForm.pas' {Form4},
  AdventureFile in 'AdventureFile.pas',
  AboutForm in 'AboutForm.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Auric');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, IDEAboutForm);
  Application.Run;
end.
