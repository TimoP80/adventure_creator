unit AdventureBinaryRuntime;

interface

uses Sysutils, inifiles, classes, AdventureScriptCompilerUtils, FileIOFunctions,Velthuis.Console;

const
  is_equal = 1;
  less_than_or_equal = 2;
  less_than = 3;
  larger_than_or_equal = 4;
  larger_than = 5;
  not_equal_to = 6;

type
  NodeCondition = record
    cmd: ansistring;
    varparam: ansistring;
    eval: integer;
    value: ansistring;
  end;

  NodeCommand = record
    cmd: ansistring;
    varparam: ansistring;
    value: ansistring;
  end;

type
  NodeChoice = record
    ChoiceText: ansistring;
    Targetnode: ansistring;
    addscore: integer;
    endgame: boolean;
    wingame: boolean;
    ChoiceConditions: array of NodeCondition;
    ChoiceConditionCount: integer;
    ChoiceCommands: array of NodeCommand;
    ChoiceCommandCount: integer;
  end;

type
  GameNode = record
    NodeName: ansistring;
    NodeText: ansistring;
    NodeCommands: array of NodeCommand;
    NodeCommandCount: integer;
    NodeChoices: array of NodeChoice;
    NodeChoiceCount: integer;
  end;

type AdditionalFile = record
     filename: ansistring;
     description: ansistring;
     filetype: ansistring;
end;

type
  GameVariable = record
    name: ansistring;
    value: ansistring;
  end;

type
  AdventureGame = record
    GameNodes: array of GameNode;
    GameNodeCount: integer;
    Variables: array of GameVariable;
    VariableCount: integer;
    Scripts: array of Script;
    ScriptCount: integer;
    AdditionalFiles: array of AdditionalFile;
    AdditionalFileCount: integer;
    MetaTitle: ansistring;
    MetaAuthor: ansistring;
    MetaDescription: ansistring;
    MaxScore: integer;
  end;

type
  TranscriptEntry = record
    NodeName: ansistring;
    NodeText: ansistring;
    ChoiceText: ansistring;
    Timestamp: TDateTime;
  end;

  Transcript = record
    Entries: array of TranscriptEntry;
    EntryCount: integer;
  end;

const
  alphabets: array [0 .. 10] of char = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k');
  numbers: array [0 .. 10] of integer = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

type
  choicemapping = record
    letter: char;
    number: integer;
  end;

var

  AdventureBinData: AdventureGame;
  GameTranscript: Transcript;

  ch, choice: char;
  choicemappings: array of choicemapping;
  choicemappingcount: integer;
  currentmoney, numchoices: integer;
 lastnode, moneystring, currentnode: ansistring;
  wingame, endgame: boolean;
  audiosupport: boolean;
  debugmode: boolean;
  audiovolume: integer;
  random_min, random_max: integer;
  rcstream: Tresourcestream;
  datafile: string;
  moneydisplay: boolean;
  msg_gameover, msg_wrongchoice, msg_pressanykey: ansistring;
  msgtemp, msg_gamefinished: ansistring;
  savedx, savedy, choiceinteger: integer;
  addedscore, score: integer;
  config: TIniFile;

procedure SaveAdventureBin(filename: string);
procedure LoadAdventureBin(filename: string);
function FindScriptByName(name: string): integer;
function ReplaceVars(str: string): string;
procedure SetVarValue(varname, value: string);
function GetVarValue(varname: string): string;
function ReplaceScriptVars(thescript: script; str: string): string;
procedure UpdateMoney;
procedure PrintHeader;
procedure ResetGameState;
procedure ResetAllVariables;
procedure AddToTranscript(NodeName, NodeText, ChoiceText: string);
procedure SaveTranscriptToHTML(Filename: string);
procedure ClearTranscript;

implementation

procedure SetVarValue(varname, value: string);
var
  u: integer;
  found: boolean;
begin
  found := false;
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if varname = AdventureBinData.Variables[u].name then
    begin
      AdventureBinData.Variables[u].value := value;
      found := true;
      exit;
    end;
  end;
end;

function GetVarValue(varname: string): string;
var
  u: integer;
begin
  Result := '';
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if varname = AdventureBinData.Variables[u].name then
    begin
      if AdventureBinData.Variables[u].value = '' then
        Result := ''
      else
        Result := AdventureBinData.Variables[u].value;
      exit;
    end;
  end;
end;
procedure UpdateMoney;
var
  moneyvar: string;
begin
  moneyvar := GetVarValue('MoneyVar');
  currentmoney := strtoint(GetVarValue(moneyvar));
end;

procedure PrintHeader;
begin
        TextBackground(blue);
        TextColor(Yellow);
        ClrEol;

        writeln(AdventureBinData.metatitle + ' by ' +
          AdventureBinData.metaauthor);

        if moneydisplay = true then
        begin
          GotoXY(38, 1);
          UpdateMoney;
          moneystring := GetVarValue('MoneyCaption');
          moneystring := STringReplace(moneystring, '$Money',
            inttostr(currentmoney), [rfReplaceAll]);
          write(moneystring);
        end;
        GotoXY(65, 1);
        writeln('Score: ', score, ' / ', AdventureBinData.maxscore);
        writeln;
        TextBackground(black);
        TextColor(White);

end;

function ReplaceScriptVars(thescript: script; str: string): string;
var
  u: integer;
begin
  Result := str;
  for u := 0 to thescript.variablecnt - 1 do
  begin
   Result := StringReplace(Result, '$' + thescript.variables[u].name,
      thescript.variables[u].value, [rfReplaceAll]);
  end;
end;

function ReplaceVars(str: string): string;
var
  u: integer;
begin
  Result := str;
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
   Result := StringReplace(Result, '$' + AdventureBinData.Variables[u].name,
      AdventureBinData.Variables[u].value, [rfReplaceAll]);
  end;
end;


procedure LoadAdventureBin(filename: string);
var
  x: file;
  y, i, j: integer;
begin
  AssignFile(x, filename);
  Reset(x, 1);
  ReadString(x, AdventureBinData.MetaTitle);
  ReadString(x, AdventureBinData.MetaAuthor);
  ReadString(x, AdventureBinData.MetaDescription);
  BlockRead(x, AdventureBinData.MaxScore, 4);
  BlockRead(x, AdventureBinData.GameNodeCount, 4);
  BlockRead(x, AdventureBinData.AdditionalFileCount, 4);
  setlength(adventurebindata.AdditionalFiles, adventurebindata.AdditionalFileCount+1);
  for i := 0 to AdventureBinData.AdditionalFileCount - 1 do
  begin
    ReadString(x, AdventureBinData.AdditionalFiles[i].filename);
    ReadString(x, AdventureBinData.AdditionalFiles[i].description);
    ReadString(x, AdventureBinData.AdditionalFiles[i].filetype);
  end;

  BlockRead(x, AdventureBinData.VariableCount, 4);
  setlength(AdventureBinData.Variables, AdventureBinData.VariableCount + 1);
  for i := 0 to AdventureBinData.VariableCount - 1 do
  begin
    ReadString(x, AdventureBinData.Variables[i].name);
    ReadString(x, AdventureBinData.Variables[i].value);
  end;
  setlength(AdventureBinData.GameNodes, AdventureBinData.GameNodeCount + 1);
  for i := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    ReadString(x, AdventureBinData.GameNodes[i].NodeName);
    ReadString(x, AdventureBinData.GameNodes[i].NodeText);
    BlockRead(x, AdventureBinData.GameNodes[i].NodeCommandCount, 4);
    setlength(AdventureBinData.GameNodes[i].NodeCommands,
      AdventureBinData.GameNodes[i].NodeCommandCount + 1);
    for j := 0 to AdventureBinData.GameNodes[i].NodeCommandCount - 1 do
    begin
      ReadString(x, AdventureBinData.GameNodes[i].NodeCommands[j].cmd);
      ReadString(x, AdventureBinData.GameNodes[i].NodeCommands[j].varparam);
      ReadString(x, AdventureBinData.GameNodes[i].NodeCommands[j].value);
    end;
    BlockRead(x, AdventureBinData.GameNodes[i].NodeChoiceCount, 4);

    setlength(AdventureBinData.GameNodes[i].NodeChoices,
      AdventureBinData.GameNodes[i].NodeChoiceCount + 1);
    for j := 0 to AdventureBinData.GameNodes[i].NodeChoiceCount - 1 do
    begin
      ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceText);
      ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j].Targetnode);
      BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j].endgame, 1);
      BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j].wingame, 1);
      BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j].addscore, 4);
      BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceCommandCount, 4);
      setlength(AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceCommands,
        AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceCommandCount + 1);
      for y := 0 to AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceCommandCount - 1 do
      begin
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].cmd);
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].varparam);
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].value);
      end;

      setlength(AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceConditions,
        AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceConditionCount + 1);

      BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceConditionCount, 4);
      for y := 0 to AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceConditionCount - 1 do
      begin
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].cmd);
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].varparam);
        BlockRead(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].eval, 4);
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].value);

      end;

    end;
  end;

  BlockRead(x, AdventureBinData.ScriptCount, 4);

  setlength(AdventureBinData.Scripts, AdventureBinData.ScriptCount + 1);

  for y := 0 to AdventureBinData.ScriptCount - 1 do
  begin

    LoadScriptFromAGF(x, AdventureBinData.Scripts[y]);
  end;

  CloseFile(x);

end;

function FindScriptByName(name: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to AdventureBinData.ScriptCount - 1 do
  begin
    if AdventureBinData.Scripts[i].script_name = name then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure SaveAdventureBin(filename: string);
var
  x: file;
  y, i, j: integer;
begin
  AssignFile(x, filename);
  Rewrite(x, 1);
  WriteString(x, AdventureBinData.MetaTitle);
  WriteString(x, AdventureBinData.MetaAuthor);
  WriteString(x, AdventureBinData.MetaDescription);
  BlockWrite(x, AdventureBinData.MaxScore, 4);
  BlockWrite(x, AdventureBinData.GameNodeCount, 4);
  BlockWrite(x, AdventureBinData.VariableCount, 4);
  for i := 0 to AdventureBinData.VariableCount - 1 do
  begin
    WriteString(x, AdventureBinData.Variables[i].name);
    WriteString(x, AdventureBinData.Variables[i].value);
  end;
  for i := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    WriteString(x, AdventureBinData.GameNodes[i].NodeName);
    WriteString(x, AdventureBinData.GameNodes[i].NodeText);
    BlockWrite(x, AdventureBinData.GameNodes[i].NodeCommandCount, 4);
    for j := 0 to AdventureBinData.GameNodes[i].NodeCommandCount - 1 do
    begin
      WriteString(x, AdventureBinData.GameNodes[i].NodeCommands[j].cmd);
      WriteString(x, AdventureBinData.GameNodes[i].NodeCommands[j].varparam);
      WriteString(x, AdventureBinData.GameNodes[i].NodeCommands[j].value);
    end;
    BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoiceCount, 4);
    for j := 0 to AdventureBinData.GameNodes[i].NodeChoiceCount - 1 do
    begin
      WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j].ChoiceText);
      WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j].Targetnode);
      BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j].endgame, 1);
      BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j].wingame, 1);
      BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j].addscore, 4);
      BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceCommandCount, 4);
      for y := 0 to AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceCommandCount - 1 do
      begin
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].cmd);
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].varparam);
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceCommands[y].value);

      end;

      BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceConditionCount, 4);
      for y := 0 to AdventureBinData.GameNodes[i].NodeChoices[j]
        .ChoiceConditionCount - 1 do
      begin
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].cmd);
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].varparam);
        BlockWrite(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].eval, 4);
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].value);

      end;

    end;
  end;
  CloseFile(x);
end;

function eval2enum(eval: string): integer;
begin
  if eval = 'is_equal_to' then
    Result := is_equal
  else if eval = 'less_than_or_equal_to' then
    Result := less_than_or_equal
  else if eval = 'larger_than_or_equal_to' then
    Result := larger_than_or_equal
  else if eval = 'larger_than' then
    Result := larger_than
  else if eval = 'less_than' then
    Result := less_than
  else if eval = 'not_equal_to' then
    Result := not_equal_to
  else

end;

procedure ResetGameState;
var
  i: integer;
begin
  currentnode := '';
  lastnode := '';
  score := 0;
  addedscore := 0;
  wingame := false;
  endgame := false;
  currentmoney := 0;
  numchoices := 0;
  random_min := 0;
  random_max := 0;
end;

procedure ResetAllVariables;
var
  i: integer;
begin
  for i := 0 to AdventureBinData.VariableCount - 1 do
  begin
    AdventureBinData.Variables[i].value := '';
  end;
  for i := 0 to AdventureBinData.ScriptCount - 1 do
  begin
    AdventureBinData.Scripts[i].variablecnt := 0;
    SetLength(AdventureBinData.Scripts[i].variables, 0);
  end;
end;

procedure AddToTranscript(NodeName, NodeText, ChoiceText: string);
begin
  SetLength(GameTranscript.Entries, GameTranscript.EntryCount + 1);
  GameTranscript.Entries[GameTranscript.EntryCount].NodeName := NodeName;
  GameTranscript.Entries[GameTranscript.EntryCount].NodeText := NodeText;
  GameTranscript.Entries[GameTranscript.EntryCount].ChoiceText := ChoiceText;
  GameTranscript.Entries[GameTranscript.EntryCount].Timestamp := Now;
  Inc(GameTranscript.EntryCount);
end;

procedure ClearTranscript;
begin
  SetLength(GameTranscript.Entries, 0);
  GameTranscript.EntryCount := 0;
end;

procedure SaveTranscriptToHTML(Filename: string);
var
  HTMLFile: TextFile;
  i: integer;
  ColorClass: string;
begin
  AssignFile(HTMLFile, Filename);
  Rewrite(HTMLFile);
  try
    WriteLn(HTMLFile, '<!DOCTYPE html>');
    WriteLn(HTMLFile, '<html>');
    WriteLn(HTMLFile, '<head>');
    WriteLn(HTMLFile, '  <meta charset="UTF-8">');
    WriteLn(HTMLFile, '  <title>Game Transcript - ' + AdventureBinData.MetaTitle + '</title>');
    WriteLn(HTMLFile, '  <style>');
    WriteLn(HTMLFile, '    body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }');
    WriteLn(HTMLFile, '    .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }');
    WriteLn(HTMLFile, '    h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }');
    WriteLn(HTMLFile, '    .meta { color: #7f8c8d; margin-bottom: 20px; }');
    WriteLn(HTMLFile, '    .entry { margin: 20px 0; padding: 15px; border-left: 4px solid #3498db; background: #ecf0f1; border-radius: 4px; }');
    WriteLn(HTMLFile, '    .nodename { font-weight: bold; color: #2980b9; }');
    WriteLn(HTMLFile, '    .nodetext { margin: 10px 0; color: #34495e; }');
    WriteLn(HTMLFile, '    .choice { color: #27ae60; font-style: italic; }');
    WriteLn(HTMLFile, '    .timestamp { color: #95a5a6; font-size: 0.85em; }');
    WriteLn(HTMLFile, '    .footer { margin-top: 30px; text-align: center; color: #95a5a6; font-size: 0.9em; }');
    WriteLn(HTMLFile, '  </style>');
    WriteLn(HTMLFile, '</head>');
    WriteLn(HTMLFile, '<body>');
    WriteLn(HTMLFile, '  <div class="container">');
    WriteLn(HTMLFile, '    <h1>Game Transcript</h1>');
    WriteLn(HTMLFile, '    <div class="meta">');
    WriteLn(HTMLFile, '      <p><strong>Game:</strong> ' + AdventureBinData.MetaTitle + '</p>');
    WriteLn(HTMLFile, '      <p><strong>Author:</strong> ' + AdventureBinData.MetaAuthor + '</p>');
    WriteLn(HTMLFile, '      <p><strong>Playthrough Date:</strong> ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + '</p>');
    WriteLn(HTMLFile, '      <p><strong>Final Score:</strong> ' + IntToStr(score) + ' / ' + IntToStr(AdventureBinData.MaxScore) + '</p>');
    WriteLn(HTMLFile, '    </div>');

    for i := 0 to GameTranscript.EntryCount - 1 do
    begin
      ColorClass := 'entry';
      if (i mod 2) = 0 then
        ColorClass := 'entry';

      WriteLn(HTMLFile, '    <div class="' + ColorClass + '">');
      WriteLn(HTMLFile, '      <span class="timestamp">Step ' + IntToStr(i + 1) + ' - ' + FormatDateTime('hh:nn:ss', GameTranscript.Entries[i].Timestamp) + '</span>');
      WriteLn(HTMLFile, '      <div class="nodename">' + GameTranscript.Entries[i].NodeName + '</div>');
      WriteLn(HTMLFile, '      <div class="nodetext">' + GameTranscript.Entries[i].NodeText + '</div>');
      WriteLn(HTMLFile, '      <div class="choice">> ' + GameTranscript.Entries[i].ChoiceText + '</div>');
      WriteLn(HTMLFile, '    </div>');
    end;

    WriteLn(HTMLFile, '    <div class="footer">');
    WriteLn(HTMLFile, '      <p>Generated by Adventure Creator</p>');
    WriteLn(HTMLFile, '    </div>');
    WriteLn(HTMLFile, '  </div>');
    WriteLn(HTMLFile, '</body>');
    WriteLn(HTMLFile, '</html>');
  finally
    CloseFile(HTMLFile);
  end;
end;

end.
