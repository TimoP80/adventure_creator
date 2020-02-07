program ACCompiler;

{$APPTYPE CONSOLE}

uses
  Windows, JclFileUtils, ActiveX, comobj, AdventureBinary, AdventureFile,
  SysUtils;

var
  outputname: string;

begin
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  writeln('Adventure Creator Compiler v1.0 by T. Pitkanen');
  writeln;
  if paramcount = 0 then
  begin
    writeln('Usage: ACCompiler.exe <sourcefile>.xml');
    halt;
  end;
  if ParamStr(2) = '' then
    outputname := changefileext(ParamStr(1), '.agf')
  else
    outputname := ParamStr(2);
  AdventureData := LoadAdventureGame(ParamStr(1));
  writeln('Compiling data..');
  CompileAdventure;
  writeln('Saving binary to "', outputname, '"');
  SaveAdventureBin(outputname);
  writeln('Creating executable ... ');
  FileCopy('.\ACEngine.exe', changefileext(ParamStr(1), '.exe'), true);
  FileCopy('.\ACEngine.ini', changefileext(ParamStr(1), '.ini'), true);
  writeln('Bimary file "' + changefileext(ParamStr(1), '.exe') + '" created.');
  writeln('Configuration file "' + changefileext(ParamStr(1), '.ini') + '" created.');
  writeln;
end.
