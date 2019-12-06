program AdventureCreatorIDE;

uses
  Forms,
  AdventureCreatorIDEMain in 'AdventureCreatorIDEMain.pas' {Form1},
  AdventureBinary in 'AdventureBinary.pas',
  MetaData in 'MetaData.pas' {Form2},
  VarEditor in 'VarEditor.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles,
  AdventureFile in 'AdventureFile.pas';

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Amethyst Kamri');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
