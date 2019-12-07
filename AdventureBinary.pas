unit AdventureBinary;

interface

uses FileIOFunctions, AdventureFile;

type
  NodeChoice = record
    ChoiceText: string;
    Targetnode: string;
    addscore: integer;
    endgame: boolean;
    wingame: boolean;
  end;

type
  NodeCommand = record
    cmd: string;
    varparam: string;
    value: string;
  end;

type
  GameNode = record
    NodeName: string;
    NodeText: string;
    NodeCommands: array of NodeCommand;
    NodeCommandCount: integer;
    NodeChoices: array of NodeChoice;
    NodeChoiceCount: integer;
  end;
type
  GameVariable = record
    name: string;
    value: string;
  end;

type
  AdventureGame = record
    GameNodes: array of GameNode;
    GameNodeCount: integer;
    Variables: array of GameVariable;
    VariableCount: integer;
    MetaTitle: string;
    MetaAuthor: string;
    MetaDescription: string;
    MaxScore: integer;
  end;

var

  AdventureBinData: Adventuregame;
  AdventureData: IXMLAdventureGameType;

procedure SaveAdventureBin(filename: string);
procedure CompileAdventure;
procedure LoadAdventureBin(filename: string);

implementation

procedure LoadAdventureBin(filename: string);
var
  x: file;
  i, j: integer;
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
  ReadString(x,AdventureBinData.variables[i].name);
  ReadString(x,AdventureBinData.variables[i].value);
  end;
  setlength(AdventureBinData.GameNodes, AdventureBinData.GameNodeCount + 1);
  for i := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    ReadString(x, adventurebindata.gamenodes[i].NodeName);
    ReadString(x, adventurebindata.gamenodes[i].NodeText);
   BlockRead(x, AdventureBinData.gamenodes[i].NodeCommandCount, 4);
     setlength(AdventureBinData.gamenodes[i].NodeCommands,
      AdventureBinData.gamenodes[i].NodeCommandCount + 1);
    for j := 0 to AdventureBinData.gamenodes[i].NodeCommandCount - 1 do
    begin
    ReadString(x, AdventureBinData.gamenodes[i].nodecommands[j].cmd);
    ReadString(x, AdventureBinData.gamenodes[i].nodecommands[j].varparam);
    ReadString(x, AdventureBinData.gamenodes[i].nodecommands[j].value);
    end;
    BlockRead(x, AdventureBinData.gamenodes[i].NodeChoiceCount, 4);

    setlength(AdventureBinData.gamenodes[i].NodeChoices,
      AdventureBinData.gamenodes[i].NodeChoiceCount + 1);
    for j := 0 to AdventureBinData.gamenodes[i].NodeChoiceCount - 1 do
    begin
      ReadString(x, AdventureBinData.gamenodes[i].nodechoices[j].ChoiceText);
      ReadString(x, AdventureBinData.gamenodes[i].nodechoices[j].Targetnode);
      BlockRead(x, AdventureBinData.gamenodes[i].nodechoices[j].endgame, 1);
      BlockRead(x, AdventureBinData.gamenodes[i].nodechoices[j].wingame, 1);
      BlockRead(x, AdventureBinData.gamenodes[i].nodechoices[j].addscore, 4);
    end;
  end;
  CloseFile(x);

end;

procedure SaveAdventureBin(filename: string);
var
  x: file;
  i, j: integer;
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
  WriteString(x,AdventureBinData.variables[i].name);
  WriteString(x,AdventureBinData.variables[i].value);
  end;
  for i := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    WriteString(x, adventurebindata.gamenodes[i].NodeName);
    WriteString(x, adventurebindata.gamenodes[i].NodeText);
    BlockWrite(x, AdventureBinData.gamenodes[i].NodeCommandCount, 4);
    for j := 0 to AdventureBinData.gamenodes[i].NodeCommandCount - 1 do
    begin
    WriteString(x, AdventureBinData.gamenodes[i].nodecommands[j].cmd);
    WriteString(x, AdventureBinData.gamenodes[i].nodecommands[j].varparam);
    WriteString(x, AdventureBinData.gamenodes[i].nodecommands[j].value);
    end;
    BlockWrite(x, AdventureBinData.gamenodes[i].NodeChoiceCount, 4);
    for j := 0 to AdventureBinData.gamenodes[i].NodeChoiceCount - 1 do
    begin
      WriteString(x, AdventureBinData.gamenodes[i].nodechoices[j].ChoiceText);
      WriteString(x, AdventureBinData.gamenodes[i].nodechoices[j].Targetnode);
      BlockWrite(x, AdventureBinData.gamenodes[i].nodechoices[j].endgame, 1);
      BlockWrite(x, AdventureBinData.gamenodes[i].nodechoices[j].wingame, 1);
      BlockWrite(x, AdventureBinData.gamenodes[i].nodechoices[j].addscore, 4);
    end;
  end;
  CloseFile(x);
end;

procedure CompileAdventure;
var
  z, u: integer;
begin
  AdventureBinData.MetaTitle := AdventureData.MetaInfo.Title;
  AdventureBinData.MetaAuthor := AdventureData.MetaInfo.Author;
  AdventureBinData.MetaDescription := AdventureData.MetaInfo.Description;
  SetLength(AdventureBinData.GameNodes, AdventureData.GameNodes.Count + 1);
  AdventureBinData.gamenodecount := 0;
  AdventureBinData.MaxScore := 0;
  SetLength(AdventureBinData.Variables, adventuredata.Variables.Count+1);
  AdventureBinData.VariableCount:=0;
  for u:=0 to AdventureData.Variables.count-1 do
  begin
    AdventureBinData.Variables[AdventureBinData.VariableCount].name := AdventureData.Variables.Variable[u].Name;
    AdventureBinData.Variables[AdventureBinData.VariableCount].value := AdventureData.Variables.Variable[u].text;
  inc(AdventureBinData.VariableCount);
  end;
  for u := 0 to adventuredata.GameNodes.Count - 1 do
  begin
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeName :=
      adventuredata.gamenodes.Node[u].Name;
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeText :=
      adventuredata.gamenodes.Node[u].DescriptionText;
    SetLength(AdventureBinData.GameNodes[u].NodeChoices,
      adventuredata.gamenodes.Node[u].Choices.Count + 1);
    SetLength(AdventureBinData.GameNodes[u].NodeCommands,
      adventuredata.gamenodes.Node[u].NodeCommands.Count + 1);
    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeCommandCount:=0;
    for z := 0 to Adventuredata.GameNodes.Node[u].NodeCommands.Count - 1 do
    begin
     adventurebindata.gamenodes[AdventureBinData.GameNodeCount].NodeCommands[AdventureBinData.GameNodes[u].NodeCommandCount].cmd := adventuredata.GameNodes.Node[u].NodeCommands.CMD[z].Name;
     adventurebindata.gamenodes[AdventureBinData.GameNodeCount].NodeCommands[AdventureBinData.GameNodes[u].NodeCommandCount].varparam := adventuredata.GameNodes.Node[u].NodeCommands.CMD[z].Variable;
     adventurebindata.gamenodes[AdventureBinData.GameNodeCount].NodeCommands[AdventureBinData.GameNodes[u].NodeCommandCount].value := adventuredata.GameNodes.Node[u].NodeCommands.CMD[z].text;
    inc(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeCommandCount);
    end;

    AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount
      := 0;
    for z := 0 to Adventuredata.GameNodes.Node[u].Choices.Count - 1 do
    begin
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount].ChoiceText :=
        Adventuredata.GameNodes.Node[u].Choices.Choice[z].text;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount].Targetnode :=
        Adventuredata.GameNodes.Node[u].Choices.Choice[z].Targetnode;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount].endgame :=
        Adventuredata.GameNodes.Node[u].Choices.Choice[z].Endgame;
      AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoices[AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount].addscore :=
        Adventuredata.GameNodes.Node[u].Choices.Choice[z].Addscore;
      inc(AdventureBinData.MaxScore,
        Adventuredata.GameNodes.Node[u].Choices.Choice[z].Addscore);
      Inc(AdventureBinData.GameNodes[AdventureBinData.GameNodeCount].NodeChoiceCount);
    end;
    Inc(AdventureBinData.GameNodeCount);
  end;
end;

end.

