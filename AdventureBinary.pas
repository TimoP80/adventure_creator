unit AdventureBinary;

interface

uses sysutils, classes, jclstrings,JclFileUtils, FileIOFunctions, AdventureScript, AdventureScriptCompilerUtils,AdventureFile;

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
    MetaTitle: ansistring;
    MetaAuthor: ansistring;
    MetaDescription: ansistring;
    MaxScore: integer;
  end;

var

  AdventureBinData: AdventureGame;
  ScriptParser: TAdventureScript;
  AdventureData: IXMLAdventureGameType;
  Script: TStrings;
procedure SaveAdventureBin(filename: string);
procedure CompileAdventure;
procedure LoadAdventureBin(filename: string);

implementation

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
        blockread(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].eval, 4);
        ReadString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].value);

      end;


    end;
  end;

  BlockRead(x, adventurebindata.ScriptCount, 4);

  setlength(adventurebindata.Scripts, adventurebindata.ScriptCount+1);

  for y := 0 to adventurebindata.ScriptCount-1 do
  begin

  writeln('Load script '+adventurebindata.Scripts[y].script_name);
  LoadScriptFromAGF(x, adventurebindata.Scripts[y]);
  end;

  CloseFile(x);

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
        blockwrite(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].eval, 4);
        WriteString(x, AdventureBinData.GameNodes[i].NodeChoices[j]
          .ChoiceConditions[y].value);

      end;

    end;

  end;

  BlockWrite(x, adventurebindata.ScriptCount, 4);

  for y := 0 to adventurebindata.ScriptCount-1 do
  begin
  writeln('Save script '+adventurebindata.Scripts[y].script_name);
  SaveScriptToAGF(x, adventurebindata.Scripts[y]);
  end;
  CloseFile(x);
end;

function eval2enum(eval: string): integer;
begin
result:=0;
if eval='is equal to' then
  result := is_equal else
if eval='less than or equal to' then
  result := less_than_or_equal else
if eval='larger than or equal to' then
  result := larger_than_or_equal else
if eval='larger than' then
  result := larger_than else
if eval='less than' then
  result := less_than else
if eval='not equal to' then
  result := not_equal_to else


end;

procedure CompileAdventure;
var
  i, z, u: integer;
begin
  AdventureBinData.MetaTitle := AdventureData.MetaInfo.Title;
  AdventureBinData.MetaAuthor := AdventureData.MetaInfo.Author;
  AdventureBinData.MetaDescription := AdventureData.MetaInfo.Description;
  setlength(AdventureBinData.GameNodes, AdventureData.GameNodes.Count + 1);
  AdventureBinData.GameNodeCount := 0;
  AdventureBinData.MaxScore := 0;
  setlength(AdventureBinData.Variables, AdventureData.Variables.Count + 1);
  AdventureBinData.VariableCount := 0;
  for u := 0 to AdventureData.Variables.Count - 1 do
  begin
    AdventureBinData.Variables[AdventureBinData.VariableCount].name :=
      AdventureData.Variables.Variable[u].name;
    AdventureBinData.Variables[AdventureBinData.VariableCount].value :=
      AdventureData.Variables.Variable[u].text;
    inc(AdventureBinData.VariableCount);
  end;
  for u := 0 to AdventureData.GameNodes.Count - 1 do
  begin
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeName :=
      AdventureData.GameNodes.Node[u].name;
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeText :=
      AdventureData.GameNodes.Node[u].DescriptionText;
    setlength(AdventureBinData.GameNodes[u].NodeChoices,
      AdventureData.GameNodes.Node[u].Choices.Count + 1);
    setlength(AdventureBinData.GameNodes[u].NodeCommands,
      AdventureData.GameNodes.Node[u].NodeCommands.Count + 1);
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
      .NodeCommandCount := 0;
    for z := 0 to AdventureData.GameNodes.Node[u].NodeCommands.Count - 1 do
    begin
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeCommands
        [AdventureBinData.GameNodes[u].NodeCommandCount].cmd :=
        AdventureData.GameNodes.Node[u].NodeCommands.cmd[z].name;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeCommands
        [AdventureBinData.GameNodes[u].NodeCommandCount].varparam :=
        AdventureData.GameNodes.Node[u].NodeCommands.cmd[z].Variable;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeCommands
        [AdventureBinData.GameNodes[u].NodeCommandCount].value :=
        AdventureData.GameNodes.Node[u].NodeCommands.cmd[z].text;
      inc(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeCommandCount);
    end;

    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
      .NodeChoiceCount := 0;
    for z := 0 to AdventureData.GameNodes.Node[u].Choices.Count - 1 do
    begin
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceText := AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].text;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].Targetnode := AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].Targetnode;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].endgame := AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].endgame;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].wingame := AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].wingame;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].addscore := AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].addscore;
      inc(AdventureBinData.MaxScore, AdventureData.GameNodes.Node[u]
        .Choices.Choice[z].addscore);
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceCommandCount := AdventureData.GameNodes.Node[u]
        .ChoiceCommands[z].Count;
      setlength(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceCommands,
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceCommandCount + 1);
      for i := 0 to AdventureData.GameNodes.Node[u].ChoiceCommands[z]
        .Count - 1 do
      begin
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceCommands[i].cmd := AdventureData.GameNodes[u]
          .ChoiceCommands[z].cmd[i].name;
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceCommands[i].varparam :=
          AdventureData.GameNodes[u].ChoiceCommands[z].cmd[i].Variable;
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceCommands[i].value := AdventureData.GameNodes
          [u].ChoiceCommands[z].cmd[i].text;
      end;

        setlength(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceConditions,
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceConditionCount + 1);

        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
        [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount].ChoiceConditionCount := AdventureData.GameNodes.Node[u].ChoiceConditions[z]
      .Count;
      for i := 0 to AdventureData.GameNodes.Node[u].ChoiceConditions[z]
        .Count - 1 do
      begin
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceConditions[i].cmd := AdventureData.GameNodes[u]
          .ChoiceConditions[z].Condition[i].Name;
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceConditions[i].varparam :=
          AdventureData.GameNodes[u].ChoiceConditions[z].Condition[i].Varname;
        AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceConditions[i].value := AdventureData.GameNodes[u].ChoiceConditions[z].Condition[i].Text;
             AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices
          [AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
          .NodeChoiceCount].ChoiceConditions[i].eval := eval2enum(AdventureData.GameNodes[u].ChoiceConditions[z].Condition[i].Eval);


      end;



      inc(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount]
        .NodeChoiceCount);
    end;
    inc(AdventureBinData.GameNodeCount);
  end;

  // compile scripts
  ScriptParser :=TAdventureScript.Create(nil);
  writeln('Compiling scripts ... ');
InitBuiltInFunctions;
  for i := 0 to Adventuredata.Scripts.Count-1 do
  begin
  CurrentScript.instruction_count := 0;
   stringtofile('temp.as',AdventureData.Scripts.Script[i].Text);
   Scriptparser.SourceFileName := 'temp.as';
   ScriptParser.execute;
   setlength(adventurebindata.Scripts, adventurebindata.ScriptCount+1);

   if scriptparser.Successful=true then
   begin
     CurrentScript.script_name := adventuredata.Scripts[i].Name;
     CurrentScript.script_filename := adventuredata.Scripts[i].Filename;
     CurrentScript.script_author := adventuredata.Scripts[i].Author;
     currentscript.is_boot_script := adventuredata.Scripts[i].IsBootScript;
     if currentscript.is_boot_script=true then
     writeln('"'+currentscript.script_name+'" will be executed at startup');
     writeln('Compiled successfully: '+Currentscript.script_name);
     AdventureBinData.Scripts[adventurebindata.ScriptCount] := CurrentScript;
   DeleteFile('temp.as');

     inc(adventurebindata.scriptcount);
   end else
   begin
     writeln('Error compiling script: '+AdventureData.Scripts.Script[i].Filename);
     Scriptparser.ListStream.SaveToFile(changefileext(AdventureData.Scripts.Script[i].Filename, '.lst'));
   end;
  end;


end;

end.
