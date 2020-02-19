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

implementation


procedure SetVarValue(varname, value: string);
var
  u: integer;
begin
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if varname = AdventureBinData.Variables[u].name then
    begin
      AdventureBinData.Variables[u].value := value;
      exit;
    end;
  end;
end;

function GetVarValue(varname: string): string;
var
  u: integer;
begin
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if varname = AdventureBinData.Variables[u].name then
    begin
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

end.
