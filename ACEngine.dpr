program ACEngine;

{$APPTYPE CONSOLE}

uses
  Windows, AdventureBinary, jclstrings, Console, SysUtils;

const
  alphabets: array[0..10] of char = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i',
    'j', 'k');
  numbers: array[0..10] of integer = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

var
  ch, choice: char;
  currentmoney, numchoices: integer;
  moneystring, currentnode: string;
  endgame: boolean;
  moneydisplay, debugmode: boolean;
  savedx, savedy, choiceinteger: integer;
  addedscore, score: integer;

function AlphabetToNumber(alpha: char): integer;
var
  u: integer;
begin
  for u := 0 to 10 do
  begin
    if alpha = alphabets[u] then
    begin
      Result := numbers[u];
      exit;
    end;
  end;
end;

function Ansi2Ascii(const s: AnsiString): AnsiString;
begin
  Result := s;
  if Result <> '' then
  begin
    UniqueString(Result);
    CharToOem(Pchar(Result), Pchar(Result));
  end;
end;

function Ascii2Ansi(const s: AnsiString): AnsiString;
begin
  Result := s;
  if Result <> '' then
  begin
    UniqueString(Result);
    OemToChar(Pchar(Result), Pchar(Result));
  end;
end;

function GetNodeIndex(name: string): integer;
var
  u: integer;
begin
  result := -1;
  for u := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    if name = AdventureBinData.GameNodes[u].NodeName then
    begin
      result := u;
      exit;
    end;

  end;
end;

function GetChoiceCountInNode(name: string): integer;
var
  nodeind: integer;
begin
  result := 0;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    result := adventurebindata.gamenodes[nodeind].NodeChoiceCount;
  end;
end;

function GetEndGameFlagFromChoice(name: string; ch: integer): boolean;
var
  nodeind: integer;
begin
  result := false;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    result := adventurebindata.gamenodes[nodeind].NodeChoices[ch].endgame;
  end;
end;

function GetScoreFromChoice(name: string; ch: integer): integer;
var
  nodeind: integer;
begin
  result := 0;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    result := adventurebindata.gamenodes[nodeind].NodeChoices[ch].addscore;
  end;
end;

function GetTargetNodeFromChoice(name: string; ch: integer): string;
var
  z, nodeind: integer;
begin
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    result := adventurebindata.gamenodes[nodeind].NodeChoices[ch].Targetnode;
  end;
end;

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
      result := AdventureBinData.Variables[u].value;
      exit;
    end;
  end;
end;

function ReplaceVars(str: string): string;
var
  u: integer;
begin
  result := str;
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    result := STringReplace(result, '$' + AdventureBinData.variables[u].name,
      AdventureBinData.variables[u].value, [rfReplaceAll]);
  end;
end;

procedure ProcessNodeCommands(name: string);
var
  z, nodeind: integer;
  txt: widestring;
  valuetemp: integer;
begin

  nodeind := getnodeindex(name);
  if nodeind <> -1 then
  begin
    // Process node commands here
    for z := 0 to AdventureBinData.gamenodes[nodeind].NodeCommandCount - 1 do
    begin
      if adventurebindata.GameNodes[nodeind].NodeCommands[z].cmd = 'SetVar'
        then
      begin
        SetVarValue(adventurebindata.GameNodes[nodeind].NodeCommands[z].varparam, adventurebindata.GameNodes[nodeind].NodeCommands[z].value);
      end
      else if adventurebindata.GameNodes[nodeind].NodeCommands[z].cmd =
        'IncreaseVar' then
      begin
        valuetemp :=
          strtoint(getvarvalue(adventurebindata.GameNodes[nodeind].NodeCommands[z].varparam));
        valuetemp := valuetemp +
          StrToInt(adventurebindata.GameNodes[nodeind].NodeCommands[z].value);
        setvarvalue(adventurebindata.GameNodes[nodeind].NodeCommands[z].varparam, inttostr(valuetemp));

      end
      else if adventurebindata.GameNodes[nodeind].NodeCommands[z].cmd =
        'DecreaseVar' then
      begin
        valuetemp :=
          strtoint(getvarvalue(adventurebindata.GameNodes[nodeind].NodeCommands[z].varparam));
        valuetemp := valuetemp -
          StrToInt(adventurebindata.GameNodes[nodeind].NodeCommands[z].value);
        setvarvalue(adventurebindata.GameNodes[nodeind].NodeCommands[z].varparam, inttostr(valuetemp));
      end;

    end;
    // end of commands processing code
  end;

end;

procedure DisplayNode(name: string);
var
  z, nodeind: integer;
  txt: widestring;
  valuetemp: integer;
begin
  nodeind := getnodeindex(name);
  if nodeind <> -1 then
  begin
    txt := adventurebindata.gamenodes[nodeind].nodetext;
    txt :=  ReplaceVars(txt);
    txt := Ansi2Ascii(txt);
    if txt = '' then
    begin
      writeln('Runtime Engine Error: This node contains no text.');
    end;
    Writeln(txt);
    if adventurebindata.gamenodes[nodeind].NodeChoiceCount > 0 then
    begin
      Writeln;
      for z := 0 to adventurebindata.gamenodes[nodeind].NodeChoiceCount - 1 do
      begin
        txt := adventurebindata.gamenodes[nodeind].nodechoices[z].choicetext;
        txt := Ansi2Ascii(txt);
        GotoXY(7, wherey);
        Writeln(alphabets[z], '. ', txt);
      end;
      writeln;
    end;

  end;
end;

procedure UpdateMoney;
var
  moneyvar: string;
begin
  moneyvar := GetVarValue('MoneyVar');
  currentmoney := StrToInt(GetVarValue(moneyvar));
end;

begin
  ClrScr;
  TextBackground(blue);
  ClrEol;
  TextColor(Yellow);
  Writeln(ansi2ascii('Adventure Creator Runtime Engine v1.0 by T. Pitk�nen'));
  textbackground(black);
  textcolor(White);
  writeln;

  if Paramcount = 0 then
  begin
    writeln('Usage: ACEngine.EXE <adventurefile>');
    Writeln;
  end;
  if ParamStr(2) = '-debug' then
    debugmode := true
  else
    debugmode := false;
  if ParamStr(1) <> '' then
  begin
    if FileExists(ParamStr(1)) = false then
    begin
      Writeln('File "', paramstr(1), '" not found!');
      halt;
    end;
    LoadAdventureBin(ParamStr(1));
    Writeln('Loaded "' + ansi2ascii(adventurebindata.metatitle) + '" by ' +
      ansi2ascii(adventurebindata.metaauthor));
    Writeln;
    if GetVarValue('MoneyDisplay') = 'true' then
      moneydisplay := true
    else
      moneydisplay := false;
    currentnode := 'Start';
    endgame := false;
    TextColor(lightcyan);
 //   Writeln('MoneyDisplay: ', GetVarValue('MoneyDisplay'));
    Writeln(ansi2ascii(adventurebindata.metadescription));
    Writeln;
    textcolor(lightgray);
    writeln(ansi2ascii('Paina mit� tahansa n�pp�int�'));
    score := 0;
    choice := readkey;

    while (endgame = false) and (choice <> 'q') do
    begin
      ClrScr;
      TextBackground(blue);
      TextColor(yellow);
      ClrEol;
      ProcessNodeCommands(currentnode);
      Writeln(ansi2ascii(adventurebindata.metatitle) + ' by ' +
        ansi2ascii(adventurebindata.metaauthor));
      if debugmode = true then
      begin
        gotoxy(35, 1);
        write('Node: ' + currentnode);
      end;
      if moneydisplay = true then
      begin
        gotoxy(38, 1);
        UpdateMoney;
        moneystring := GetVarValue('MoneyCaption');
        moneystring := StringReplace(moneystring, '$Money',
          IntToStr(currentmoney), [rfReplaceAll]);
        write(moneystring);
      end;
      GotoXY(65, 1);
      writeln('Score: ', score, ' / ', adventurebindata.maxscore);
      writeln;
      TextBackground(black);
      TextColor(white);
      DisplayNode(currentnode);
      if endgame = true then
      begin
        break;
      end;
      Write('> ');
      Readln(choice);
      if choice = 'q' then
        Halt;
      if CharIsAlpha(choice) then
      begin
        choiceinteger := AlphabetToNumber(choice);
        numchoices := GetChoiceCountInNode(currentnode);
        if choiceinteger <= numchoices - 1 then
        begin
          endgame := GetEndGameFlagFromChoice(currentnode, choiceinteger);
          addedscore := GetScoreFromChoice(currentnode, choiceinteger);
          currentnode := GetTargetNodeFromChoice(currentnode,
            choiceinteger);
          Inc(score, addedscore);

          if currentnode = '' then
          begin
            Writeln('Runtime error: Null NODE!');
            halt;
          end;
        end
        else
        begin
          Writeln(ansi2ascii('V��r� valinta, yrit� uudelleen!'));
          ch := readkey;
        end;
      end;
      Writeln;
    end;
    // display final node
    DisplayNode(currentnode);
  end;

end.
