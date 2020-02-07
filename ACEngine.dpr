program ACEngine;

{$APPTYPE CONSOLE}



uses

  AdventureBinaryRuntime,
  AdventureScriptCompilerUtils,
  Velthuis.Console,
  classes,
  Inifiles,
  SysUtils;


var i: integer;
    strs: tstrings;

label start;

function ChoiceToNumber (choice: char): integer;
var y: integer;
begin
 for y := 0 to choicemappingcount-1 do
 begin
   if choice = choicemappings[y].letter then
   begin
     result := choicemappings[y].number;
   exit;
   end;
 end;
end;

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

function GetNodeIndex(name: string): integer;
var
  u: integer;
begin
  Result := -1;
  for u := 0 to AdventureBinData.GameNodeCount - 1 do
  begin
    if name = AdventureBinData.GameNodes[u].NodeName then
    begin
      Result := u;
      exit;
    end;

  end;
end;

function GetChoiceCountInNode(name: string): integer;
var
  nodeind: integer;
begin
  Result := 0;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    Result := AdventureBinData.GameNodes[nodeind].NodeChoiceCount;
  end;
end;

function GetWinGameFlagFromChoice(name: string; ch: integer): boolean;
var
  nodeind: integer;
begin
  Result := false;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    Result := AdventureBinData.GameNodes[nodeind].NodeChoices[ch].wingame;
  end;
end;

function GetEndGameFlagFromChoice(name: string; ch: integer): boolean;
var
  nodeind: integer;
begin
  Result := false;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    Result := AdventureBinData.GameNodes[nodeind].NodeChoices[ch].endgame;
  end;
end;

function GetScoreFromChoice(name: string; ch: integer): integer;
var
  nodeind: integer;
begin
  Result := 0;
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    Result := AdventureBinData.GameNodes[nodeind].NodeChoices[ch].addscore;
  end;
end;

function GetTargetNodeFromChoice(name: string; ch: integer): string;
var
  z, nodeind: integer;
begin
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    Result := AdventureBinData.GameNodes[nodeind].NodeChoices[ch].Targetnode;
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
      Result := AdventureBinData.Variables[u].value;
      exit;
    end;
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

procedure ProcessChoiceCommands(name: string; choiceindex: integer);
var
  z, nodeind: integer;
  ch: char;
  varvaluetemp, textvaluetemp, txt: widestring;
  randomnumber: integer;
  valuetemp: integer;
  script_index: integer;
  cmd, variable, value: string;
begin

  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    // Process node commands here
    for z := 0 to AdventureBinData.GameNodes[nodeind].NodeChoices[choiceindex]
      .ChoiceCommandCount - 1 do
    begin
      cmd := AdventureBinData.GameNodes[nodeind].NodeChoices[choiceindex]
        .ChoiceCommands[z].cmd;
      variable := AdventureBinData.GameNodes[nodeind].NodeChoices[choiceindex]
        .ChoiceCommands[z].varparam;
      value := AdventureBinData.GameNodes[nodeind].NodeChoices[choiceindex]
        .ChoiceCommands[z].value;

      if cmd = 'SetVar' then
      begin
        SetVarValue(variable, value);
      end
      else if cmd = 'IncreaseVar' then
      begin
        if pos('$', value) <> 0 then
        begin
          varvaluetemp := ReplaceVars(value);
          Delete(value,1,1);
          valuetemp := strtoint(GetVarValue(variable));

          valuetemp := valuetemp + strtoint(varvaluetemp);
              SetVarValue(variable, inttostr(valuetemp));

        end
        else
        begin
          valuetemp := strtoint(GetVarValue(value));

          valuetemp := valuetemp + strtoint(value);
          SetVarValue(variable, inttostr(valuetemp));
        end;

      end
      else if cmd = 'DisplayMessage' then
      begin
        writeln;
        textvaluetemp := value;
        textvaluetemp := ReplaceVars(textvaluetemp);
        writeln(textvaluetemp);
        ch := ReadKey;

      end
      else if cmd = 'RunScript' then
      begin
         script_index := FindScriptByName(value);
         if script_index<>-1 then
          begin
          ImportVariableData(adventurebindata.Scripts[script_index]);
          RunScript(adventurebindata.Scripts[script_index], 'Main');
          ExportVariableData(adventurebindata.Scripts[script_index]);

          end;
      end
      else if cmd = 'RandomNumber' then
      begin
        valuetemp := strtoint(value);
        randomnumber := random(valuetemp);
        SetVarValue(variable, inttostr(randomnumber));
      end
      else if cmd = 'ExecuteRandom' then
      begin
        randomnumber := random_min + random(random_max-random_min);
        SetVarValue(variable, inttostr(randomnumber));
      end
      else if cmd = 'SetRandomMin' then
      begin
        valuetemp := strtoint(value);
        random_min := valuetemp;
        SetVarValue(variable, inttostr(randomnumber));
      end
      else if cmd = 'SetRandomMax' then
      begin
        valuetemp := strtoint(value);
        random_max := valuetemp;
        SetVarValue(variable, inttostr(randomnumber));
      end

      else if cmd = 'DisplayMessageDirect' then
      begin
        writeln;
        textvaluetemp := value;
        textvaluetemp := ReplaceVars(textvaluetemp);
        writeln(textvaluetemp);

      end
      else if cmd = 'TextPrompt' then
      begin
        writeln;
        write(value);
        readln(textvaluetemp);
        SetVarValue(variable, textvaluetemp);
      end

      else if cmd = 'DecreaseVar' then
      begin
        valuetemp := strtoint(GetVarValue(variable));
        valuetemp := valuetemp - strtoint(value);
        SetVarValue(variable, inttostr(valuetemp));
      end;

    end;
    // end of commands processing code
  end;

end;

procedure ProcessNodeCommands(name: string);
var
  z, script_index, nodeind: integer;
  ch: char;
  varnametemp, textvaluetemp, txt: widestring;
  varvaluetemp, valuetemp: integer;
begin

  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    // Process node commands here
    for z := 0 to AdventureBinData.GameNodes[nodeind].NodeCommandCount - 1 do
    begin
      if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'SetVar' then
      begin
        SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
          .varparam, AdventureBinData.GameNodes[nodeind].NodeCommands[z].value);
      end
      else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'IncreaseVar'
      then
      begin
        if pos('$', AdventureBinData.GameNodes[nodeind].NodeCommands[z]
          .value) <> 0 then
        begin

          varvaluetemp :=
            strtoint(ReplaceVars(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].value));
          valuetemp :=
            strtoint(GetVarValue(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].varparam));

          valuetemp := valuetemp + varvaluetemp;
          SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
            .varparam, inttostr(valuetemp));
        end
        else
        begin

          valuetemp :=
            strtoint(GetVarValue(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].varparam));
          valuetemp := valuetemp +
            strtoint(AdventureBinData.GameNodes[nodeind].NodeCommands[z].value);
          SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
            .varparam, inttostr(valuetemp));
        end;

      end
else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'RunScript' then
      begin
         script_index := FindScriptByName(AdventureBinData.GameNodes[nodeind].NodeCommands[z].value);
         if script_index<>-1 then
          begin
          ImportVariableData(adventurebindata.Scripts[script_index]);
          RunScript(adventurebindata.Scripts[script_index], 'Main');
          ExportVariableData(adventurebindata.Scripts[script_index]);
         end;
      end

      else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'DisplayMessage'
      then
      begin
        writeln;
        textvaluetemp := AdventureBinData.GameNodes[nodeind]
          .NodeCommands[z].value;
        textvaluetemp := ReplaceVars(textvaluetemp);
        writeln(textvaluetemp);
        ch := ReadKey;

      end
      else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'DisplayMessageDirect'
      then
      begin
        writeln;
        textvaluetemp := AdventureBinData.GameNodes[nodeind]
          .NodeCommands[z].value;
        textvaluetemp := ReplaceVars(textvaluetemp);
        writeln(textvaluetemp);

      end
      else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'TextPrompt'
      then
      begin
        writeln;
        write(AdventureBinData.GameNodes[nodeind].NodeCommands[z].value);
        readln(textvaluetemp);
        SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
          .varparam, textvaluetemp);
      end

      else if AdventureBinData.GameNodes[nodeind].NodeCommands[z].cmd = 'DecreaseVar'
      then
      begin
        if pos('$', AdventureBinData.GameNodes[nodeind].NodeCommands[z]
          .value) <> 0 then
        begin

          varvaluetemp :=
            strtoint(ReplaceVars(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].value));
          valuetemp :=
            strtoint(GetVarValue(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].varparam));

          valuetemp := valuetemp - varvaluetemp;
          SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
            .varparam, inttostr(valuetemp));
        end
        else
        begin

          valuetemp :=
            strtoint(GetVarValue(AdventureBinData.GameNodes[nodeind]
            .NodeCommands[z].varparam));
          valuetemp := valuetemp -
            strtoint(AdventureBinData.GameNodes[nodeind].NodeCommands[z].value);
          SetVarValue(AdventureBinData.GameNodes[nodeind].NodeCommands[z]
            .varparam, inttostr(valuetemp));
        end;
      end;

    end;
    // end of commands processing code
  end;

end;

function GetNodeVisibilityByCondition(nodeindex: integer;
  choiceindex: integer): boolean;
var
  value, cmd, varparam: string;
  eval: integer;
  u: integer;
  conditions_true, conditions_false: integer;
  current_condition: boolean;

  begin
 // by default return true if no conditions are present
 result := false;

  if AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
    .ChoiceConditionCount > 0 then
  begin
    // choice contains conditions so process it here
    conditions_true := 0;
    conditions_false := 0;
    for u := 0 to AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
      .ChoiceConditionCount - 1 do
    begin
      value := AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
        .ChoiceConditions[u].value;
      cmd := AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
        .ChoiceConditions[u].cmd;
      varparam := AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
        .ChoiceConditions[u].varparam;
      eval := AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
        .ChoiceConditions[u].eval;
      if cmd='VariableValue' then
      begin
      case eval of
        less_than_or_equal:
          begin
            current_condition := strtoint(GetVarValue(varparam)) <= strtoint(value);
          end;
        larger_than_or_equal:
          begin
            current_condition := strtoint(GetVarValue(varparam)) >= strtoint(value);
          end;
        less_than:
          begin
            current_condition := strtoint(GetVarValue(varparam)) < strtoint(value);
          end;
        larger_than:
          begin
            current_condition := strtoint(GetVarValue(varparam)) > strtoint(value);
          end;
        is_equal:
          begin
            current_condition := strtoint(GetVarValue(varparam)) = strtoint(value);
          end;
        not_equal_to:
          begin
            current_condition := strtoint(GetVarValue(varparam)) <> strtoint(value);
          end;
      end;
      end;
      
      if current_condition = true then inc(conditions_true);
      if current_condition = false then inc(conditions_false);

    end;
  end;

  result := (conditions_true = AdventureBinData.GameNodes[nodeindex].NodeChoices[choiceindex]
      .ChoiceConditionCount);
end;

procedure DisplayNode(name: string);
var
  z, nodeind: integer;
  txt: widestring;
  valuetemp: integer;
begin
  nodeind := GetNodeIndex(name);
  if nodeind <> -1 then
  begin
    txt := AdventureBinData.GameNodes[nodeind].nodetext;
    txt := ReplaceVars(txt);
    // txt := Ansi2Ascii(txt);
    if txt = '' then
    begin
      writeln('Runtime Engine Error: This node contains no text.');
    end;
    writeln(WrapText(txt, 80));
    writeln;
    if AdventureBinData.GameNodes[nodeind].NodeChoiceCount > 0 then
    begin
      // process node conditions here
      // map visible choices to a,b,c and the corresponding
      // number for it
      choicemappingcount := 0;

      for z := 0 to AdventureBinData.GameNodes[nodeind].NodeChoiceCount - 1 do
      begin
       setlength(choicemappings, choicemappingcount+1);
        txt := AdventureBinData.GameNodes[nodeind].NodeChoices[z].choicetext;

        GotoXY(7, wherey);
        if GetNodeVisibilityByCondition(nodeind, z)=true then
        begin
         writeln(alphabets[z], '. ', txt);
        choicemappings[choicemappingcount].letter := alphabets[choicemappingcount];
        choicemappings[choicemappingcount].number := z;
           inc(choicemappingcount);
        end;



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
  currentmoney := strtoint(GetVarValue(moneyvar));
end;

procedure WriteHeader;
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


begin
  config := TIniFile.Create('.\'+changefileext(ParamStr(0),'.ini'));
  ClrScr;
  TextBackground(blue);
  ClrEol;
  TextColor(Yellow);
  writeln('Adventure Creator Runtime Engine v1.0 by T. Pitkänen');
  TextBackground(black);
  TextColor(White);
  writeln;
  InitBuiltInFunctions;
  InitColorTable;
 if fileexists(changefileext(ParamStr(0),'.agf')) then
    datafile := extractfilename(changefileext(ParamStr(0),'.agf'));
 if paramstr(1)<>'' then
    datafile := paramstr(1);
//  rcstream := TResourceStream.Create(HInstance, 'Resource_1', rt_rcdata);
//  rcstream.SaveToFile('temp.dat');
//  datafile := 'temp.dat';


  if datafile <> '' then
  begin
    if FileExists(datafile) = false then
    begin
      writeln('File "', paramstr(1), '" not found!');
      halt;
    end;
    // writeln('Loading '+paramstr(1));
    LoadAdventureBin(datafile);
    msg_pressanykey := config.ReadString(GetVarValue('GameLanguage'),
      'PressAnyKey', '');
    msg_gamefinished := config.ReadString(GetVarValue('GameLanguage'),
      'FinishedGame', '');
    msg_wrongchoice := config.ReadString(GetVarValue('GameLanguage'),
      'WrongChoice', '');
    msg_gameover := config.ReadString(GetVarValue('GameLanguage'),
      'GameOver', '') + ' ';

    writeln('Loaded "' + AdventureBinData.metatitle + '" by ' +
      AdventureBinData.metaauthor);

   // look for boot scripts and execute them in the order they were organized
   // in the editor
   for i := 0 to adventurebindata.ScriptCount-1 do
   begin
    if adventurebindata.Scripts[i].is_boot_script=true then
    begin
     RunScript(adventurebindata.Scripts[i], 'Main');

    end;
   end;

clrscr;
   writeheader;
  start:

    begin

      if GetVarValue('MoneyDisplay') = 'true' then
        moneydisplay := true
      else
        moneydisplay := false;
      currentnode := 'Start';
      endgame := false;
      TextColor(lightcyan);
      // Writeln('MoneyDisplay: ', GetVarValue('MoneyDisplay'));
      writeln(AdventureBinData.metadescription);
      writeln;
      TextColor(lightgray);
      // msgtemp := msg_pressanykey;
      writeln(msg_pressanykey);
      score := 0;
      wingame := false;
      choice := ReadKey;

      while ((wingame = false) or (endgame = false)) and (choice <> 'q') do
      begin
        ClrScr;
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
        if wingame = true then
        begin
          break;
        end;
        if endgame = true then
        begin
          break;
        end;
        DisplayNode(currentnode);
        ProcessNodeCommands(currentnode);

        Write('> ');
        readln(choice);
        if choice = 'q' then
          halt;

          choiceinteger := ChoiceToNumber(choice);
          numchoices := GetChoiceCountInNode(currentnode);
          if choiceinteger <= numchoices - 1 then
          begin
            endgame := GetEndGameFlagFromChoice(currentnode, choiceinteger);
            wingame := GetWinGameFlagFromChoice(currentnode, choiceinteger);

            addedscore := GetScoreFromChoice(currentnode, choiceinteger);
            lastnode:=currentnode;
            currentnode := GetTargetNodeFromChoice(currentnode, choiceinteger);
            //
            // scripts can override the target node by using the random chance system
            // so currentnode assignment is before choice command processing
            //
            ProcessChoiceCommands(lastnode, choiceinteger);
            Inc(score, addedscore);
            if wingame = true then
            begin
              endgame := true;
              break;
            end;
            if currentnode = '' then
            begin
              writeln('Runtime error: Null NODE!');
              halt;
            end;
          end
          else
          begin

            writeln(msg_wrongchoice);
            ch := ReadKey;
            writeln;
          end;


      end;
      // display final node
      if wingame = true then
      begin
        writeln;
        DisplayNode(currentnode);
        writeln;
        msgtemp := msg_gamefinished;
        msgtemp := STringReplace(msgtemp, '%score%', inttostr(score),
          [rfReplaceAll]);
        msgtemp := STringReplace(msgtemp, '%maxscore%',
          inttostr(AdventureBinData.maxscore), [rfReplaceAll]);
        writeln(msgtemp);

        // writeln('You finished the game with the score '+inttostr(score)+ ' out of '+inttostr(AdventureBinData.MaxScore));
      end
      else
      begin
        DisplayNode(currentnode);
        write(msg_gameover);
        readln(choice);
        if choice = 'y' then
          Goto start;

      end;
    end;

  end;

end.
