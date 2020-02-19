program ACCompiler;

{$APPTYPE CONSOLE}

uses
  Winapi.ShellAPI, Winapi.Windows, Inifiles, JclFileUtils, ActiveX, comobj, AdventureBinary, AdventureFile,
  SysUtils,vfsengine,velthuis.console;

var
  config: TInifile;
  returndir: string;
  outputname: string;
  i: integer;
  vfsfile: vfs_header_rec;
f: file;
begin
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  ClrScr;
  TextBackground(blue);
  ClrEol;
  TextColor(Yellow);
  writeln('Adventure Creator Data Compiler v1.0 by T. Pitkänen');
  TextBackground(black);
  TextColor(LightGray);
  if paramcount = 0 then
  begin
    writeln('Usage: ACCompiler.exe <sourcefile>.xml');
    halt;
  end;
  if ParamStr(2) = '' then
    outputname := changefileext(ParamStr(1), '.agf')
  else
    outputname := ParamStr(2);
  writeln('Starting compilation process of ',paramstr(1));
  AdventureData := LoadAdventureGame(ParamStr(1));
  writeln('Compiling data..');
  CompileAdventure;
  writeln('Saving binary to "', outputname, '"');
  SaveAdventureBin(outputname);
  writeln('Compressing data...');

  createnewpackfile(f, vfsfile, AdventureBinData.MetaAuthor, changefileext(outputname,'.dat'));
  writeln('adding ',outputname,' to .dat file');
  add_file_to_vfs(vfsfile, outputname);
  returndir := getcurrentdir;
  for i := 0 to adventuredata.AdditionalFiles.Count-1 do
  begin
  writeln('adding ',adventuredata.AdditionalFiles.File_[i].Name);
  chdir(adventuredata.AdditionalFiles.File_[i].Path);
  add_file_to_vfs(vfsfile, adventuredata.AdditionalFiles.File_[i].Name);
  end;
  chdir(returndir);
  writeheader(f, vfsfile);
  closevfshandle(f);
  // delete agf output
  DeleteFile(outputname);
  writeln('Creating executable ... ');
  FileCopy('.\ACEngine.exe', changefileext(ParamStr(1), '.exe'), true);
  FileCopy('.\ACEngine.ini', changefileext(ParamStr(1), '.ini'), true);
  config := TInifile.Create('.\'+changefileext(paramstr(1),'.ini'));
  config.WriteBool('Main Config','DebugMode',AdventureData.ProjectSettings.DebugMode);
  config.WriteBool('Main Config','AudioEnabled',AdventureData.ProjectSettings.AudioEnabled);
  config.WriteInteger('Main Config','AudioVolume',AdventureData.ProjectSettings.AudioVolume);
  writeln('Compressing executable with UPX');
  ShellExecute(0 , 'open', 'upx.exe', pwidechar(changefileext(ParamStr(1), '.exe')+' --best'), pwidechar(GetCurrentDir), SW_SHOWNORMAL);
  writeln('Bimary file "' + changefileext(ParamStr(1), '.exe') + '" created.');
  writeln('Configuration file "' + changefileext(ParamStr(1), '.ini') + '" created.');
  writeln;
end.
