(*

  This is the main unit for the AdventureScript compiler/interpreter. This unit is used
  by the generated CoCo/R parser AdventureScript.pas to generate the bytecode.

  What works now is:

  - Variable definitions
  - Built-in Functions
  - Function calls
  - Variable assignments (SetVar $<variable> = <>)
  - If-else blocks (you can chain if statements endlessly)

  What I'd like to add:

  - Function calls with parameters passed to them (future feature)


*)
unit AdventureScriptCompilerUtils;

interface

uses Velthuis.Console, Classes, Sysutils, Variants, FileIOFunctions;

type
  ColourTable = record
    name: string;
    color: integer;
  end;

const
  EXEC_MODE_NORMAL = $4000;
  EXEC_MODE_SETVAR = $4001;
  EXEC_MODE_CONDITION = $4002;
  EXEC_MODE_SWITCH = $4003;

  COMPARE_MODE_STRING = $4500;
  COMPARE_MODE_INTEGER = $4501;

  MODE_ADD = $5000;
  MODE_SUBTRACT = $5001;
  MODE_DIVIDE = $5002;
  MODE_MULTIPLY = $5003;
  MODE_ASSIGN = $5004;

  OP_BEGININSTRUCTION = $8000;
  OP_ENDINSTRUCTION = $8001;
  OP_FUNCTIONCALL = $8002;
  OP_IFBEGIN = $8003;
  OP_IFEND = $8004;
  OP_IFELSEBEGIN = $8005;
  OP_IFELSEEND = $8006;
  OP_CONDITION = $8007;
  OP_IF = $8008;
  OP_SETVAR = $8009;
  OP_RANDOMCHANCE = $800A;
  OP_FUNCTIONDEF = $800B;
  OP_FUNCTIONBEGIN = $800C;
  OP_FUNCTIONEND = $800D;
  OP_ADD = $800E;
  OP_SUBTRACT = $800F;
  OP_DIVIDE = $8010;
  OP_MULTIPLY = $8011;
  OP_EXPRESSIONDATA = $8012;
  OP_IF_CONNECTOR = $8013;
  OP_END_CONDITIONLIST = $8014;
  OP_IF_CHAINED = $8015;
  OP_IF_ELSE = $8016;
  OP_CONDITION_BLOCK_START = $8017;
  OP_CONDITION_BLOCK_END = $8018;
  OP_FUNCTION_PARAMS = $8019;
  OP_SWITCH_VAR = $801A;
  OP_SWITCH_LABEL = $801B;
  OP_SWITCH_LABEL_CODE_BEGIN = $B01C;
  OP_SWITCH_LABEL_CODE_END = $B01D;
  OP_SWITCH_BEGIN = $B01E;
  OP_SWITCH_END = $B01F;


  RETURN_TYPE_VOID = $4000;
  RETURN_TYPE_INTEGER = $4001;
  RETURN_TYPE_STRING = $4002;

  PARAM_TYPE_INT = $5000;
  PARAM_TYPE_STRING = $5001;

  DATA_TYPE_PARAMETER = $A001;
  DATA_TYPE_RETURN_TYPE = $A002;
  DATA_TYPE_FUNCTION_NAME = $A003;
  DATA_TYPE_VAR_NAME = $A004;
  DATA_TYPE_REGULARDATA = $A005;
  DATA_TYPE_TARGETNODE = $A006;
  DATA_TYPE_PROBABILITY = $A007;
  DATA_TYPE_IF_EVAL = $A008;
  DATA_TYPE_IF_VARIABLE = $A009;
  DATA_TYPE_IF_VALUE = $A010;
  DATA_TYPE_IF_CONNECTOR = $A011;
  DATA_TYPE_FUNCTION_PARAMETER = $A012;
  DATA_TYPE_FUNCTION_PARAMETER_TYPE = $A013;
  DATA_TYPE_PARAMETER_STRING = $A014;
  DATA_TYPE_PARAMETER_VARIABLEREF = $A015;
  DATA_TYPE_PARAMETER_INT = $A016;
  DATA_TYPE_SWITCH_VAR = $A017;
  DATA_TYPE_SWITCH_LABEL_DATA =$A018;

  IF_CONNECT_AND = $C000;
  IF_CONNECT_OR = $C001;

  IF_EVAL_EQUALS = $D000;
  IF_EVAL_LARGER_OR_EQUAL = $D001;
  IF_EVAL_LESS_OR_EQUAL = $D002;
  IF_EVAL_LARGER = $D003;
  IF_EVAL_LESS = $D004;
  IF_EVAL_NOT_EQUAL = $D005;

type

  stringtable = record
    strings: array of variant;
    stringcnt: integer;
  end;

  param = record
    data_type: integer;
    stringtableindex: integer;
    data: variant;
  end;

type
  instruction = record
    inst_type: integer;
    inst_params: array of param;
    inst_paramcount: integer;
  end;

type
  RandomStringListData = record
    text: string;
  end;

type
  RandomStringList = record
    name_id: string;
    StringData: array of RandomStringListData;
    stringcnt: integer;
  end;

type
  RandomChanceData = record
    probability: integer;
    targetnode: string;
  end;

type
  scriptvar = record
    name: ansistring;
    value: variant;
  end;

type
  Script = record
    script_name: ansistring;
    script_filename: ansistring;
    script_author: ansistring;
    is_boot_script: boolean;
    StringData: stringtable;
    variables: array of scriptvar;
    variablecnt: integer;
    instructions: array of instruction;
    instruction_count: integer;

  end;

type
  TArrayofVariant = array of variant;

var
  CurrentScript: Script;
  TestScript: Script;
  RandomChanceTable: array of RandomChanceData;
  RandomChanceCnt: integer;
  RandomStringLists: array of RandomStringList;
  RandomStringListCnt: integer;
  ColourData: array of ColourTable;
  ColourDataCnt: integer;
  instruction_created: boolean;
  instruction_ended: boolean;
  built_in_functions: TStrings;

function DecodeInstruction (i: integer; instr: instruction): string;
function AddInstruction(var TheScript: Script; inst_type: integer): instruction;
procedure NextInstruction(var TheScript: Script; prev_instruction: instruction);
procedure AddParam(var instruction: instruction; param: variant;
  data_type: integer);
procedure InitScriptData(var TheScript: Script; name: ansistring;
  filename: ansistring; author: ansistring);
procedure SaveScript(TheScript: Script; filename: string);
function OpcodeToStr(opcode: integer): string;
procedure InitBuiltInFunctions;
function IsValidFunctionName(TheScript: Script; str: string): boolean;
procedure LoadScript(TheScript: Script; filename: string);
procedure SaveScriptToAGF(var f: file; TheScript: Script);
procedure LoadScriptFromAGF(var f: file; var TheScript: Script);
function ParamTypeToStr(paramtype: integer): string;
procedure RunScript(TheScript: Script; FunctionName: string);
procedure InitColorTable;
function VariableExists(TheScript: Script; varname: string): boolean;
procedure AddVariable(var TheScript: Script; varname: string);
procedure SetVariableValue(var TheScript: Script; varname: string;
  varvalue: variant);
function GetVariableValue(TheScript: Script; varname: string): variant;
procedure ImportVariableData(TheScript: Script);
procedure ExportVariableData(TheScript: Script);
function DisassembleScript(TheScript: Script): TStrings;

implementation

uses AdventureBinaryRuntime;

procedure AddColor(name: string; color: integer);
begin
  SetLength(ColourData, ColourDataCnt + 1);
  ColourData[ColourDataCnt].name := name;
  ColourData[ColourDataCnt].color := color;
  inc(ColourDataCnt);

end;

procedure InitColorTable;
begin
  AddColor('Black', Black);
  AddColor('Blue', Blue);
  AddColor('Green', Green);
  AddColor('Cyan', Cyan);
  AddColor('Red', Red);
  AddColor('Magenta', Magenta);
  AddColor('Brown', Brown);
  AddColor('LightGray', LightGray);

  AddColor('DarkGray', DarkGray);
  AddColor('LightBlue', LightBlue);
  AddColor('LightGreen', LightGreen);
  AddColor('LightCyan', LightCyan);
  AddColor('LightRed', LightRed);
  AddColor('LightMagenta', LightMagenta);
  AddColor('Yellow', Yellow);
  AddColor('White', White);

end;

function GetParams(instr: instruction): string;
var
  i: integer;
  strdata: string;
  intdata: integer;
begin
  result := '';
  for i := 0 to instr.inst_paramcount - 1 do
  begin
    if vartype(instr.inst_params[i].data) = varInteger then
    begin
      intdata := instr.inst_params[i].data;
      result := result + inttostr(intdata);
    end
    else if (vartype(instr.inst_params[i].data) = varString) or
      (vartype(instr.inst_params[i].data) = varUString) then
    begin
      strdata := instr.inst_params[i].data;
      result := result + strdata;
    end;

    if i < instr.inst_paramcount - 1 then
      result := result + ', ';
  end;

end;

function DecodeInstruction (i: integer; instr: instruction): string;
begin

result := format('%0.4x: %s %s',
      [i, OpcodeToStr(instr.inst_type),
      GetParams(instr)])

end;

function DisassembleScript(TheScript: Script): TStrings;
var
  i, j: integer;
begin
  result := TStringlist.Create;
  result.Clear;
  for i := 0 to TheScript.instruction_count - 1 do
  begin
    result.Add(format('%0.4x: %s %s',
      [i, OpcodeToStr(TheScript.instructions[i].inst_type),
      GetParams(TheScript.instructions[i])]))
  end;
end;

function FindFunctionStart(TheScript: Script; name: string): integer;
var
  u: integer;
begin
  for u := 0 to TheScript.instruction_count - 1 do
  begin
    if (TheScript.instructions[u].inst_type = OP_FUNCTIONDEF) and
      (TheScript.instructions[u].inst_params[0].data = name) then
    begin
      result := u;
      exit;

    end;
  end;
end;

function ColorStringToConst(color: string): integer;
var
  u: integer;
begin
  result := -1;
  for u := 0 to ColourDataCnt - 1 do
  begin
    if ColourData[u].name = color then
    begin
      result := ColourData[u].color;
      exit;
    end;
  end;
end;

procedure AddToList(data: variant; var list: TArrayofVariant;
  var listcnt: integer);
begin
  SetLength(list, listcnt + 1);
  list[listcnt] := data;
  inc(listcnt);
end;

procedure ClearRandomChanceTable;
begin
  SetLength(RandomChanceTable, 0);
  RandomChanceCnt := 0;

end;

function VariableExists(TheScript: Script; varname: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    if TheScript.variables[i].name = varname then
    begin
      result := true;
      exit;
    end;
  end;

end;

procedure SetAGFVariableValue(name: ansistring; value: variant);
var
  u: integer;
  strvalue: string;
begin
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if AdventureBinData.variables[u].name = name then
    begin
      strvalue := value;
      AdventureBinData.variables[u].value := strvalue;
      exit;
    end;
  end;
end;

function GetAGFVariableValue(name: ansistring): ansistring;
var
  u: integer;
begin
  result := '';
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if AdventureBinData.variables[u].name = name then
    begin
      result := AdventureBinData.variables[u].value;
      exit;
    end;
  end;
end;

function IsAGFVariable(name: ansistring): boolean;
var
  u: integer;
begin
  result := false;
  for u := 0 to AdventureBinData.VariableCount - 1 do
  begin
    if AdventureBinData.variables[u].name = name then
    begin
      result := true;
      exit;
    end;
  end;
end;

function IsVariable(var TheScript: Script; varname: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    if TheScript.variables[i].name = varname then
    begin
      result := true;
      // TheScript.variables[i].value := varvalue;
      exit;
    end;
  end;
end;

function GetVariableValue(TheScript: Script; varname: string): variant;
var
  i: integer;
begin
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    if TheScript.variables[i].name = varname then
    begin
      result := TheScript.variables[i].value;
      // TheScript.variables[i].value := varvalue;
      exit;
    end;
  end;
end;

procedure SetVariableValue(var TheScript: Script; varname: string;
  varvalue: variant);
var
  i: integer;
begin
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    if TheScript.variables[i].name = varname then
    begin
      TheScript.variables[i].value := varvalue;
      exit;
    end;
  end;
end;

//
// When a variable is added to the script,
// it is initially Null until it is used in the script

procedure AddVariable(var TheScript: Script; varname: string);
begin
  SetLength(TheScript.variables, TheScript.variablecnt + 1);
  TheScript.variables[TheScript.variablecnt].name := varname;
  TheScript.variables[TheScript.variablecnt].value := Null;
  inc(TheScript.variablecnt);

end;

procedure AddRandomChance(chance: integer; target_node: string);
begin
  SetLength(RandomChanceTable, RandomChanceCnt + 1);
  RandomChanceTable[RandomChanceCnt].probability := chance;
  RandomChanceTable[RandomChanceCnt].targetnode := target_node;
  inc(RandomChanceCnt);
end;

function FindStringList(strid: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to RandomStringListCnt - 1 do
  begin
    if strid = RandomStringLists[i].name_id then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure CallBuiltInFunction(TheScript: Script; instr: instruction;
  funcname: string; var resultstorage: variant);
var
  ch: char;
  z: integer;
  list: TArrayofVariant;
  xpos, ypos, listcnt: integer;
  resultdata: variant;
  paramdatax, paramdatay: string;
  randomvalue, randomrange, finalindex, index: integer;
  i: integer;
  delayamount, throw: integer;
  varvalue: variant;
  temp, randomchancefinalresult: string;
  output: string;
begin
  if funcname = 'DisplayMessage' then
  begin
    output := '';
    for z := 1 to instr.inst_paramcount - 1 do
    begin
      if instr.inst_params[z].data_type = DATA_TYPE_PARAMETER_VARIABLEREF then
      begin
        varvalue := GetVariableValue(TheScript, instr.inst_params[z].data);
        if vartype(varvalue) = varInteger then
          output := output + inttostr(varvalue)
        else if (vartype(varvalue) = varString) or
          (vartype(varvalue) = varUString) then
          output := output + varvalue;

      end
      else
        output := output + instr.inst_params[z].data;
    end;
    writeln(output);
  end
  else if funcname = 'DisplayMessageNoLN' then
  begin
    output := '';
    for z := 1 to instr.inst_paramcount - 1 do
    begin
      if instr.inst_params[z].data_type = DATA_TYPE_PARAMETER_VARIABLEREF then
      begin
        varvalue := GetVariableValue(TheScript, instr.inst_params[z].data);
        if vartype(varvalue) = varInteger then
          output := output + inttostr(varvalue)
        else if (vartype(varvalue) = varString) or
          (vartype(varvalue) = varUString) then
          output := output + varvalue;

      end
      else
        output := output + instr.inst_params[z].data;
    end;
    write(output);
  end
  else if funcname = 'SetCurrentNode' then
  begin
    // code here for current node changes
    // can't do it elsewhere but ACEngine.exe
    if IsVariable(thescript, instr.inst_params[1].data) then
    currentnode := GetVariableValue(thescript, instr.inst_params[1].data) else
    currentnode := instr.inst_params[1].data;

  end
  else if funcname = 'Random' then
  begin
    randomrange := instr.inst_params[1].data;
    randomvalue := random(randomrange);
    resultstorage := randomvalue;
  end
  else if funcname = 'Delay' then
  begin
    delayamount := instr.inst_params[1].data;
    sleep(delayamount);

  end

  else if funcname = 'WaitForKeyPress' then
  begin
    ch := readkey;
  end

  else if funcname = 'ClrEol' then
  begin
    ClrEol;
  end
  else if funcname = 'ClrScr' then
  begin
    ClrScr;
  end
  else if funcname = 'GotoXY' then
  begin

    if instr.inst_params[1].data_type = DATA_TYPE_PARAMETER_VARIABLEREF then
      xpos := wherex;

    if instr.inst_params[2].data_type = DATA_TYPE_PARAMETER_VARIABLEREF then
      xpos := wherey;

    if instr.inst_params[1].data_type = DATA_TYPE_PARAMETER_INT then
      xpos := instr.inst_params[1].data;

    if instr.inst_params[2].data_type = DATA_TYPE_PARAMETER_INT then
      ypos := instr.inst_params[2].data;
    GotoXY(xpos, ypos);
  end
  else if funcname = 'ReadInput' then
  begin
    Readln(temp);
    resultstorage := temp;
  end
  else if funcname = 'TextColor' then
  begin
    TextColor(ColorStringToConst(instr.inst_params[1].data));
  end
  else if funcname = 'TextBackground' then
  begin
    TextBackground(ColorStringToConst(instr.inst_params[1].data));
  end
  else if funcname = 'InitRandomList' then
  begin

    // Check if the specified string list exists
    // if not, then initialize
    // if it does, then nothing happens here

    index:=FindStringList(instr.inst_params[2].data);
    if index=-1 then
    begin
    SetLength(RandomStringLists, RandomStringListCnt + 1);
    RandomStringLists[RandomStringListCnt].name_id := instr.inst_params[1].data;
    RandomStringLists[RandomStringListCnt].stringcnt := 0;
    inc(RandomStringListCnt);
    end;

  end
  else if funcname = 'CombineStrings' then
  begin

   output := '';
    for z := 1 to instr.inst_paramcount - 1 do
    begin
      if instr.inst_params[z].data_type = DATA_TYPE_PARAMETER_VARIABLEREF then
      begin
        varvalue := GetVariableValue(TheScript, instr.inst_params[z].data);
        if vartype(varvalue) = varInteger then
          output := output + inttostr(varvalue)
        else if (vartype(varvalue) = varString) or
          (vartype(varvalue) = varUString) then
          output := output + varvalue;

      end
      else
        output := output + instr.inst_params[z].data;
    end;

   resultstorage := output;
  end
  else if funcname = 'AddToRandomList' then
  begin
    index := FindStringList(instr.inst_params[1].data);
    SetLength(RandomStringLists[index].StringData,
      RandomStringLists[index].stringcnt + 1);
    RandomStringLists[index].StringData[RandomStringLists[index].stringcnt].text
      := instr.inst_params[2].data;
    inc(RandomStringLists[index].stringcnt)
  end
  else if funcname = 'GetFromRandomList' then
  begin
    index := FindStringList(instr.inst_params[1].data);
    randomvalue := random(RandomStringLists[index].stringcnt);

    resultstorage := RandomStringLists[index].StringData[randomvalue].text;

  end
  else if funcname = 'ReplaceVars' then
  begin
    temp := GetVariableValue(TheScript, instr.inst_params[1].data);
    temp := ReplaceScriptVars(TheScript, temp);
    SetVariableValue(TheScript, instr.inst_params[1].data, temp);

  end
  else if funcname = 'FlushRandomListTable' then
  begin
    RandomStringListCnt := 0;
    SetLength(RandomStringLists, 0);
  end
  else if funcname = 'InitRandomChance' then
  begin
    ClearRandomChanceTable;
  end
  else if funcname = 'ExecuteRandomChance' then
  begin
    listcnt := 0;
    for i := 0 to RandomChanceCnt - 1 do
    begin
      throw := random(100 - RandomChanceTable[i].probability);
      if throw < RandomChanceTable[i].probability then
      begin
       writeln('Throw ',throw,' = HIT!');
        AddToList(i, list, listcnt);
      end else
        writeln('Throw ',throw,' = MISS!');

    end;
    index := random(listcnt);
    finalindex := list[index];
    randomchancefinalresult := RandomChanceTable[finalindex].targetnode;
    resultstorage := randomchancefinalresult;
  end
  else

    if funcname = 'RandomFromList' then
  begin
    listcnt := 0;
    for z := 1 to instr.inst_paramcount - 1 do
    begin
      AddToList(instr.inst_params[z].data, list, listcnt);
    end;
    index := random(listcnt);
    resultstorage := list[index];
    // writeln('Function result: ',resultdata);
  end
  else
  begin
    writeln('Unhandled function ' + funcname);
  end;

end;

function EvalTypeToStr(evaltype: integer): string;
begin
  case evaltype of
    IF_EVAL_EQUALS:
      result := 'IF_EVAL_EQUALS';
    IF_EVAL_LARGER_OR_EQUAL:
      result := 'IF_EVAL_LARGER_OR_EQUAL';
    IF_EVAL_LESS_OR_EQUAL:
      result := 'IF_EVAL_LESS_OR_EQUAL';
    IF_EVAL_LARGER:
      result := 'IF_EVAL_LARGER';
    IF_EVAL_LESS:
      result := 'IF_EVAL_LESS';
    IF_EVAL_NOT_EQUAL:
      result := 'IF_EVAL_NOT_EQUAL';
  end;
end;

function FindOpcodeRange(TheScript: Script; start: integer;
  opcodetofind: integer; stop_at_opcode: integer): integer;
var
  i: integer;
  opcodeindex: integer;
  opcodefound: boolean;
begin
  result := -1;
  i := start;
  opcodefound := false;
  writeln('Seek opcode from ', start, ' to find opcode ',
    OpcodeToStr(opcodetofind), ' stop at opcode ', OpcodeToStr(stop_at_opcode));
  while (TheScript.instructions[i].inst_type <> stop_at_opcode) do
  begin
    writeln('I = ', i);
    if TheScript.instructions[i].inst_type = opcodetofind then
    begin
      opcodefound := true;
      opcodeindex := i;
      break;
    end;
    inc(i);
  end;

  if opcodefound = true then
  begin
    result := opcodeindex;
  end;

end;

function FindOpcode(TheScript: Script; start: integer;
  opcodetofind: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := start to TheScript.instruction_count - 1 do
  begin
    if TheScript.instructions[i].inst_type = opcodetofind then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure ExportVariableData(TheScript: Script);
var
  u: integer;
begin
  for u := 0 to TheScript.variablecnt - 1 do
  begin
    if IsAGFVariable(TheScript.variables[u].name) = true then
    begin
      SetAGFVariableValue(TheScript.variables[u].name,
        TheScript.variables[u].value);

    end;
  end;
end;

// Import variables from the XML structure
// if matching variable names are found
procedure ImportVariableData(TheScript: Script);
var
  u: integer;
begin
  for u := 0 to TheScript.variablecnt - 1 do
  begin
    if IsAGFVariable(TheScript.variables[u].name) = true then
    begin
      TheScript.variables[u].value :=
        GetAGFVariableValue(TheScript.variables[u].name);

    end;
  end;
end;

// Run a script starting from the function named FunctionName e.g. 'Main'

// Some opcodes have empty code blocks because they just need to be addressed
// in the RunScript procedure, otherwise this function will report the
// unhandled opcode, this is great for checking that all opcodes are
// accounted for
//
procedure RunScript(TheScript: Script; FunctionName: string);
var
  x, i: integer;
  execution_mode: integer;
  last_mode: integer;
  condition_result: boolean;
  numifopcodes: integer;
  numconditions: integer;
  numconditionstrue: integer;
  numconditionsfalse: integer;
  funcresult: variant;
  finaldata: variant;
  condition_variable: string;
  case_var_value_str: string;

  condition_value: variant;
  condition_eval: integer;
  condition_eval_value: variant;
  condition_eval_string: string;
  condition_eval_integer: integer;
  if_was_true: boolean;
  else_was_true: boolean;
  last_condition_result: boolean;
  else_has_condition: boolean;
  execute_else: boolean;
  compare_mode: integer;
  intermediatedata: variant;
  instruction_param_data: variant;
  if_position: integer;
  if_else_position: integer;
  jump_position: integer;
  finalresult: integer;
  condition_was_true: boolean;
  function_called: boolean;
  current_instruction: integer;
  variable_to_manipulate: string;
begin
  x := FindFunctionStart(TheScript, FunctionName);
  current_instruction := TheScript.instructions[x].inst_type;
  execution_mode := EXEC_MODE_NORMAL;
  function_called := false;
  numifopcodes := 0;
  while (current_instruction <> OP_FUNCTIONEND) do
  begin

    current_instruction := TheScript.instructions[x].inst_type;
    case current_instruction of
      OP_SWITCH_VAR:
      begin
        case_var_value_str := GetVariableValue(thescript, thescript.instructions[x].inst_params[0].data);
        execution_mode:=EXEC_MODE_SWITCH;

      end;
      OP_SWITCH_LABEL_CODE_BEGIN:
      begin

      end;
      OP_SWITCH_LABEL_CODE_END:
      begin
       x:=FindOpcode(thescript,x+1, OP_SWITCH_END);

      end;
      OP_SWITCH_BEGIN:
      begin

      end;
      OP_SWITCH_END:
      begin
       execution_mode:=EXEC_MODE_NORMAL;
      end;
      OP_SWITCH_LABEL:
      begin
        if case_var_value_str = thescript.instructions[x].inst_params[0].data then
        begin
         x:=FindOpcode(thescript,x+1, OP_SWITCH_LABEL_CODE_BEGIN);
         end
        else
        begin
         x:=FindOpcode(thescript,x+1, OP_SWITCH_LABEL);
        end;
      end;
      OP_CONDITION_BLOCK_START:
        begin

        end;
      OP_CONDITION_BLOCK_END:
        begin

        end;
      OP_IF_ELSE:
        begin
          else_has_condition := false;
        end;
      OP_IF:

        begin
          if_was_true := false;
          else_was_true := false;
          execute_else := false;
          condition_was_true := false;
          numifopcodes := 0;
          numconditionstrue := 0;
          numconditionsfalse := 0;
          execution_mode := EXEC_MODE_CONDITION;
          if_position := FindOpcode(TheScript, x + 1, OP_IFBEGIN);
          if_else_position := FindOpcode(TheScript, x + 1, OP_IF_ELSE);
          if if_else_position = -1 then
            if_else_position := FindOpcode(TheScript, x + 1,
              OP_CONDITION_BLOCK_END);

          jump_position := FindOpcode(TheScript, if_else_position + 1,
            OP_IFELSEEND);
          numconditions := 0;
          inc(numifopcodes);

        end;
      OP_IF_CHAINED:
        begin
          condition_was_true := false;
          else_has_condition := true;
          numconditionstrue := 0;
          numconditionsfalse := 0;
          execution_mode := EXEC_MODE_CONDITION;
          if_position := FindOpcode(TheScript, x + 1, OP_IFELSEBEGIN);
          if_else_position := FindOpcode(TheScript, if_position + 1,
            OP_IF_ELSE);
          jump_position := FindOpcode(TheScript, x + 1, OP_CONDITION_BLOCK_END);
          numconditions := 0;
          inc(numifopcodes);
        end;
      OP_CONDITION:
        begin

          condition_variable := TheScript.instructions[x].inst_params[0].data;
          condition_eval := TheScript.instructions[x].inst_params[1].data;
          condition_eval_value := TheScript.instructions[x].inst_params[2].data;
          condition_value := GetVariableValue(TheScript, condition_variable);
          if (vartype(condition_eval_value) = varString) or
            (vartype(condition_eval_value) = varUString) then
          begin
            condition_eval_string := condition_eval_value;
            compare_mode := COMPARE_MODE_STRING;
          end
          else if (vartype(condition_value) = varInteger) then
          begin
            condition_eval_integer := condition_eval_value;
            compare_mode := COMPARE_MODE_INTEGER;
          end;

          if compare_mode = COMPARE_MODE_INTEGER then
          begin

            case condition_eval of
              IF_EVAL_EQUALS:
                condition_result := (condition_value = condition_eval_integer);
              IF_EVAL_LARGER_OR_EQUAL:
                condition_result := (condition_value >= condition_eval_integer);
              IF_EVAL_LESS_OR_EQUAL:
                condition_result := (condition_value <= condition_eval_integer);
              IF_EVAL_LARGER:
                condition_result := (condition_value > condition_eval_integer);
              IF_EVAL_LESS:
                condition_result := (condition_value < condition_eval_integer);
              IF_EVAL_NOT_EQUAL:
                condition_result := (condition_value <> condition_eval_integer);

            end;
          end
          else
          begin
            if compare_mode = COMPARE_MODE_STRING then
            begin
              case condition_eval of
                IF_EVAL_EQUALS:
                  condition_result := (condition_value = condition_eval_string);
                IF_EVAL_NOT_EQUAL:
                  condition_result :=
                    (condition_value <> condition_eval_string);
              end;

            end;
          end;

          if condition_result = true then
          begin
            inc(numconditionstrue);
            if numconditionstrue > 0 then
              condition_was_true := true;

          end
          else if condition_result = false then
            inc(numconditionsfalse);

          inc(numconditions);

        end;
      OP_END_CONDITIONLIST:
        begin
          if numconditionstrue = numconditions then
          begin
            if_was_true := true;
            x := if_position;
            last_condition_result := true;
          end
          else if numconditionsfalse = numconditions then
          begin
            else_was_true := false;
            x := if_else_position;
            last_condition_result := false;
          end;

        end;
      OP_IFBEGIN:
        begin

        end;
      OP_IFEND:
        begin
          execution_mode := EXEC_MODE_NORMAL;

        end;
      OP_IFELSEBEGIN:
        begin
          (*
            debug stuff for later use if things get weird again
            now this should work as expected with chained if statements
            writeln('IF ELSE BEGIN');
            writeln('ELSE_HAS_CONDITION: ',booltostr(else_has_condition ,true));
            writeln('last condition result: ',BoolToStr(last_condition_result,true));
            writeln('if_was_true: ',booltostr(if_was_true, true));
            writeln('else_was_true: ',booltostr(else_was_true, true)); *)
          if ((last_condition_result = true) or (last_condition_result = false))
            and (else_was_true = false) and (if_was_true = true) then
          begin
            // writeln('Skipping out of else block');
            // writeln('jump position: ',jump_position);
            x := jump_position;

          end;
          execution_mode := EXEC_MODE_CONDITION;
        end;
      OP_IFELSEEND:
        begin
          execution_mode := EXEC_MODE_NORMAL;
        end;
      OP_FUNCTIONEND:
        begin

        end;
      OP_FUNCTIONDEF:
        begin

        end;
      OP_FUNCTIONBEGIN:
        begin

        end;
      OP_ADD:
        begin
          last_mode := MODE_ADD;
        end;
      OP_SUBTRACT:
        begin
          last_mode := MODE_SUBTRACT;
        end;
      OP_MULTIPLY:
        begin
          last_mode := MODE_MULTIPLY;
        end;
      OP_DIVIDE:
        begin
          last_mode := MODE_DIVIDE;
        end;
      //
      // note: if the parameter is not number or string, then it is a variable reference
      // in this case, the variable value must be resolved before manipulating the intermediate data
      //
      //
      OP_EXPRESSIONDATA:
        begin
          if IsVariable(TheScript, TheScript.instructions[x].inst_params[0].data)
          then
            instruction_param_data := GetVariableValue(TheScript,
              TheScript.instructions[x].inst_params[0].data)
          else

            instruction_param_data := TheScript.instructions[x]
              .inst_params[0].data;
          case last_mode of
            MODE_ASSIGN:
              begin
                intermediatedata := TheScript.instructions[x]
                  .inst_params[0].data;
              end;
            MODE_ADD:
              begin
                intermediatedata := intermediatedata + TheScript.instructions[x]
                  .inst_params[0].data;
              end;
            MODE_SUBTRACT:
              begin
                intermediatedata := intermediatedata - TheScript.instructions[x]
                  .inst_params[0].data;
              end;
            MODE_DIVIDE:
              begin
                intermediatedata := intermediatedata div TheScript.instructions
                  [x].inst_params[0].data;
              end;
            MODE_MULTIPLY:
              begin
                intermediatedata := intermediatedata * TheScript.instructions[x]
                  .inst_params[0].data;
              end;
          end;
        end;
      OP_SETVAR:
        begin
          execution_mode := EXEC_MODE_SETVAR;
          last_mode := MODE_ASSIGN;
          variable_to_manipulate := TheScript.instructions[x]
            .inst_params[0].data;
        end;
      OP_RANDOMCHANCE:
        begin
          AddRandomChance(TheScript.instructions[x].inst_params[0].data,
            TheScript.instructions[x].inst_params[1].data);
        end;
      OP_BEGININSTRUCTION:
        begin

        end;
      OP_ENDINSTRUCTION:
        begin
          finaldata := intermediatedata;
          if (function_called = true) and (varisnull(funcresult) = false) then
          begin
            finaldata := funcresult;
            function_called := false;
            funcresult := Null;
          end;

          if execution_mode = EXEC_MODE_SETVAR then
          begin
            SetVariableValue(TheScript, variable_to_manipulate, finaldata);
          end;
          execution_mode := EXEC_MODE_NORMAL;
        end;
      OP_FUNCTIONCALL:
        begin
          if built_in_functions.indexof(TheScript.instructions[x].inst_params[0]
            .data) <> -1 then
          begin
            function_called := true;
            CallBuiltInFunction(TheScript, TheScript.instructions[x],
              TheScript.instructions[x].inst_params[0].data, funcresult)
          end
          else
          begin
            RunScript(TheScript, TheScript.instructions[x].inst_params[0].data);
          end;
        end;
    else
      writeln('Unhandled opcode: ' + OpcodeToStr(current_instruction) + ' (' +
        format('%0.4x', [current_instruction]) + ') Paramcount: ',
        TheScript.instructions[x].inst_paramcount);
    end;

    inc(x);
  end;

end;

function GetIsValidFunctionFromCode(TheScript: Script; str: ansistring)
  : boolean;
var
  u: integer;
begin
  result := false;
  for u := 0 to TheScript.instruction_count - 1 do
  begin
    if TheScript.instructions[u].inst_type = OP_FUNCTIONDEF then
    begin
      if TheScript.instructions[u].inst_params[0].data = str then
      begin
        result := true;
        exit;
      end;
    end;
  end;
end;

function IsValidFunctionName(TheScript: Script; str: string): boolean;
begin
  result := (built_in_functions.indexof(str) <> -1);
  if result = false then
  begin
    result := GetIsValidFunctionFromCode(TheScript, str);
  end;
end;

procedure InitBuiltInFunctions;
begin
  built_in_functions := TStringlist.Create;
  built_in_functions.Add('GotoXY');
  built_in_functions.Add('ClrScr');
  built_in_functions.Add('ClrEol');
  built_in_functions.Add('TextColor');
  built_in_functions.Add('TextBackground');
  built_in_functions.Add('RandomFromList');
  built_in_functions.Add('DisplayMessage');
  built_in_functions.Add('DisplayMessageNoLN');
  built_in_functions.Add('WaitForKeyPress');
  built_in_functions.Add('FlushRandomListTable');
  built_in_functions.Add('InitRandomList');
  built_in_functions.Add('AddToRandomList');
  built_in_functions.Add('GetFromRandomList');
  built_in_functions.Add('CombineStrings');

  built_in_functions.Add('InitRandomChance');
  built_in_functions.Add('ExecuteRandomChance');
  built_in_functions.Add('ReadInput');
  built_in_functions.Add('Random');
  built_in_functions.Add('Delay');
  built_in_functions.Add('Return');
  built_in_functions.Add('SetCurrentNode');
  built_in_functions.Add('ReplaceVars');
end;

function ParamTypeToStr(paramtype: integer): string;
begin
  case paramtype of
    DATA_TYPE_PARAMETER:
      result := 'DATA_TYPE_PARAMETER';
    DATA_TYPE_PARAMETER_STRING:
      result := 'DATA_TYPE_PARAMETER_STRING';
    DATA_TYPE_PARAMETER_VARIABLEREF:
      result := 'DATA_TYPE_PARAMETER_VARIABLEREF';
    DATA_TYPE_PARAMETER_INT:
      result := 'DATA_TYPE_PARAMETER_INT';
    DATA_TYPE_RETURN_TYPE:
      result := 'DATA_TYPE_RETURN_TYPE';
    DATA_TYPE_FUNCTION_NAME:
      result := 'DATA_TYPE_FUNCTION_NAME';
    DATA_TYPE_VAR_NAME:
      result := 'DATA_TYPE_VAR_NAME';
    DATA_TYPE_REGULARDATA:
      result := 'DATA_TYPE_REGULARDATA';
    DATA_TYPE_TARGETNODE:
      result := 'DATA_TYPE_TARGETNODE';
    DATA_TYPE_PROBABILITY:
      result := 'DATA_TYPE_PROBABILITY';
    DATA_TYPE_IF_EVAL:
      result := 'DATA_TYPE_IF_EVAL';
    DATA_TYPE_IF_VARIABLE:
      result := 'DATA_TYPE_IF_VARIABLE';
    DATA_TYPE_IF_VALUE:
      result := 'DATA_TYPE_IF_VALUE';
    DATA_TYPE_IF_CONNECTOR:
      result := 'DATA_TYPE_IF_CONNECTOR';
    DATA_TYPE_FUNCTION_PARAMETER:
      result := 'DATA_TYPE_FUNCTION_PARAMETER';
    DATA_TYPE_FUNCTION_PARAMETER_TYPE:
      result := 'DATA_TYPE_FUNCTION_PARAMETER_TYPE';

  else
    result := 'DATA_TYPE_UNKNOWN';
  end;
end;

function OpcodeToStr(opcode: integer): string;
begin
  case opcode of
    OP_BEGININSTRUCTION:
      result := 'OP_BEGININSTRUCTION';
    OP_ENDINSTRUCTION:
      result := 'OP_ENDINSTRUCTION';
    OP_FUNCTIONCALL:
      result := 'OP_FUNCTIONCALL';
    OP_IF:
      result := 'OP_IF';
    OP_IFBEGIN:
      result := 'OP_IFBEGIN';
    OP_IFEND:
      result := 'OP_IFEND';
    OP_IFELSEBEGIN:
      result := 'OP_IFELSEBEGIN';
    OP_IFELSEEND:
      result := 'OP_IFELSEEND';
    OP_CONDITION:
      result := 'OP_CONDITION';
    OP_SETVAR:
      result := 'OP_SETVAR';
    OP_RANDOMCHANCE:
      result := 'OP_RANDOMCHANCE';
    OP_FUNCTIONDEF:
      result := 'OP_FUNCTIONDEF';
    OP_FUNCTIONBEGIN:
      result := 'OP_FUNCTIONBEGIN';
    OP_FUNCTIONEND:
      result := 'OP_FUNCTIONEND';
    OP_ADD:
      result := 'OP_ADD';
    OP_SUBTRACT:
      result := 'OP_SUBTRACT';
    OP_DIVIDE:
      result := 'OP_DIVIDE';
    OP_MULTIPLY:
      result := 'OP_MULTIPLY';
    OP_EXPRESSIONDATA:
      result := 'OP_EXPRESSIONDATA';
    OP_IF_CONNECTOR:
      result := 'OP_IF_CONNECTOR';
    OP_IF_CHAINED:
      result := 'OP_IF_CHAINED';
    OP_END_CONDITIONLIST:
      result := 'OP_END_CONDITIONLIST';
    OP_CONDITION_BLOCK_START:
      result := 'OP_CONDITION_BLOCK_START';
    OP_CONDITION_BLOCK_END:
      result := 'OP_CONDITION_BLOCK_END';
    OP_IF_ELSE:
      result := 'OP_IF_ELSE';
    OP_SWITCH_VAR:
      result:='OP_SWITCH_VAR';
    OP_SWITCH_LABEL:
     result:='OP_SWITCH_LABEL';
     OP_SWITCH_LABEL_CODE_BEGIN:
     result:='OP_SWITCH_LABEL_CODE_BEGIN';
     OP_SWITCH_LABEL_CODE_END:
     result:='OP_SWITCH_LABEL_CODE_END';
     OP_SWITCH_BEGIN:
     result:='OP_SWITCH_BEGIN';
     OP_SWITCH_END:
     result:='OP_SWITCH_END';
  else

    result := 'OP_UNKNOWN (' + format('%0.4x', [opcode]) + ')';
  end;
end;

function GetStringIndex(stringtbl: stringtable; str: ansistring): integer;
var
  u: integer;
  int_temp: integer;
  str_temp: ansistring;
begin
  result := -1;
  for u := 0 to stringtbl.stringcnt - 1 do
  begin
    if str = VarAsType(stringtbl.strings[u], varString) then
    begin
      result := u;
      exit;
    end;
  end;

end;

function AddToStringTable(var stringtbl: stringtable; str: variant): integer;
var
  strdata: ansistring;
  intdata: integer;
  data_type: integer;
begin
  result := 0;
  intdata := 0;
  strdata := '';
  data_type := vartype(str);
  if (vartype(str) = varInteger) or (vartype(str) = VarWord) then
  begin
    intdata := str;
    strdata := inttostr(str);
  end
  else
  begin
    strdata := str;
  end;

  if GetStringIndex(stringtbl, strdata) = -1 then
  begin
    SetLength(stringtbl.strings, stringtbl.stringcnt + 1);
    if (data_type = varString) or (data_type = varUString) then
      stringtbl.strings[stringtbl.stringcnt] := strdata
    else if (data_type = varInteger) then
      stringtbl.strings[stringtbl.stringcnt] := intdata;
    result := stringtbl.stringcnt;
    inc(stringtbl.stringcnt);
  end
  else
  begin
    result := GetStringIndex(stringtbl, strdata);
  end;
end;

procedure LoadScriptFromAGF(var f: file; var TheScript: Script);
var
  j, i: integer;
  lengths: array of integer;
  int_temp: integer;
  lengthcnt: integer;
  vartypes: array of integer;
  vartypecnt: integer;
  stringtemp: ansistring;
  length_temp: integer;
  vartype_temp: integer;
begin
  ReadHeader(f, 'AdventureScript v1.0');
  ReadString(f, TheScript.script_name);
  ReadString(f, TheScript.script_filename);
  ReadString(f, TheScript.script_author);
  blockread(f, TheScript.is_boot_script, 1);
  blockread(f, TheScript.variablecnt, 4);
  SetLength(TheScript.variables, TheScript.variablecnt);
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    ReadString(f, TheScript.variables[i].name);
    blockread(f, vartype_temp, 4);
    if vartype_temp <> varNull then
    begin;
      if (vartype_temp = varString) or (vartype_temp = varUString) then
      begin
        ReadString(f, stringtemp);
        TheScript.variables[i].value := stringtemp;
      end
      else

        if (vartype_temp = varInteger) then
        blockread(f, TheScript.variables[i].value, 4);
    end;

  end;

  // writeln('Load script: '+thescript.script_name+' ('+thescript.script_filename+')');
  blockread(f, TheScript.instruction_count, 4);
  SetLength(TheScript.instructions, TheScript.instruction_count + 1);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockread(f, TheScript.instructions[i].inst_type, 4);
    blockread(f, TheScript.instructions[i].inst_paramcount, 4);
    SetLength(TheScript.instructions[i].inst_params,
      TheScript.instructions[i].inst_paramcount + 1);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockread(f, TheScript.instructions[i].inst_params[j].data_type, 4);

      blockread(f, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockread(f, TheScript.StringData.stringcnt, 4);
  lengthcnt := TheScript.StringData.stringcnt;
  vartypecnt := TheScript.StringData.stringcnt;
  SetLength(lengths, lengthcnt + 1);
  SetLength(vartypes, vartypecnt + 1);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    blockread(f, length_temp, 4);
    lengths[j] := length_temp;
    blockread(f, vartype_temp, 4);
    vartypes[j] := vartype_temp;

  end;
  SetLength(TheScript.StringData.strings, TheScript.StringData.stringcnt + 1);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    vartype_temp := vartypes[j];
    if (vartype_temp = varString) or (vartype_temp = varUString) then
    begin
      ReadStringWithLength(f, lengths[j], stringtemp);
      TheScript.StringData.strings[j] := VarAsType(stringtemp, varString);
    end
    else

      if (vartype_temp = varInteger) then
    begin

      blockread(f, int_temp, 4);
      TheScript.StringData.strings[j] := int_temp;
    end;
    ReadHeader(f, ' ');
  end;

  for i := 0 to TheScript.instruction_count - 1 do
  begin
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      TheScript.instructions[i].inst_params[j].data :=
        TheScript.StringData.strings[TheScript.instructions[i].inst_params[j]
        .stringtableindex];
    end;

  end;

end;

procedure LoadScript(TheScript: Script; filename: string);
var
  j, i: integer;
  lengths: array of integer;
  lengthcnt: integer;
  vartypes: array of integer;
  vartypecnt: integer;
  stringtemp: ansistring;
  length_temp: integer;
  vartype_temp: integer;
  f: file;
begin
  assignfile(f, filename);
  reset(f, 1);
  ReadHeader(f, 'AdventureScript v1.0');
  ReadString(f, TheScript.script_name);
  ReadString(f, TheScript.script_filename);
  ReadString(f, TheScript.script_author);
  blockread(f, TheScript.is_boot_script, 1);

  blockread(f, TheScript.variablecnt, 4);
  SetLength(TheScript.variables, TheScript.variablecnt);
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    ReadString(f, TheScript.variables[i].name);
    blockread(f, vartype_temp, 4);
    if vartype_temp <> varNull then
    begin;
      if (vartype_temp = varString) or (vartype_temp = varUString) then
      begin
        ReadString(f, stringtemp);
        TheScript.variables[i].value := stringtemp;
      end
      else

        if (vartype_temp = varInteger) then
        blockread(f, TheScript.variables[i].value, 4);
    end;

  end;

  blockread(f, TheScript.instruction_count, 4);
  SetLength(TheScript.instructions, TheScript.instruction_count + 1);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockread(f, TheScript.instructions[i].inst_type, 4);
    blockread(f, TheScript.instructions[i].inst_paramcount, 4);
    SetLength(TheScript.instructions[i].inst_params,
      TheScript.instructions[i].inst_paramcount + 1);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockread(f, TheScript.instructions[i].inst_params[j].data_type, 4);

      blockread(f, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockread(f, TheScript.StringData.stringcnt, 4);
  lengthcnt := TheScript.StringData.stringcnt;
  vartypecnt := TheScript.StringData.stringcnt;
  SetLength(lengths, lengthcnt + 1);
  SetLength(vartypes, vartypecnt + 1);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    blockread(f, length_temp, 4);
    lengths[j] := length_temp;
    blockread(f, vartype_temp, 4);
    vartypes[j] := vartype_temp;

  end;
  SetLength(TheScript.StringData.strings, TheScript.StringData.stringcnt + 1);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    vartype_temp := vartypes[j];
    if (vartype_temp = varString) or (vartype_temp = varUString) then
    begin
      ReadStringWithLength(f, lengths[j], stringtemp);
      TheScript.StringData.strings[j] := VarAsType(stringtemp, varString);
    end
    else

      if (vartype_temp = varInteger) then
    begin
      blockread(f, TheScript.StringData.strings[j], 4);
    end;
    ReadHeader(f, ' ');
  end;

  for i := 0 to TheScript.instruction_count - 1 do
  begin
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      TheScript.instructions[i].inst_params[j].data :=
        TheScript.StringData.strings[TheScript.instructions[i].inst_params[j]
        .stringtableindex];
    end;

  end;

  closefile(f);
end;

procedure SaveScriptToAGF(var f: file; TheScript: Script);
var
  j, i: integer;
  int_temp, length_temp: integer;
  vartype_temp: integer;
begin
  WriteStringNoLength(f, 'AdventureScript v1.0');
  WriteString(f, TheScript.script_name);
  WriteString(f, TheScript.script_filename);
  WriteString(f, TheScript.script_author);

  blockwrite(f, TheScript.is_boot_script, 1);
  blockwrite(f, TheScript.variablecnt, 4);
  for i := 0 to TheScript.variablecnt - 1 do
  begin
    WriteString(f, TheScript.variables[i].name);

    vartype_temp := vartype(TheScript.variables[i].value);
    blockwrite(f, vartype_temp, 4);
    if vartype_temp <> varNull then
    begin;
      if (vartype_temp = varString) or (vartype_temp = varUString) then
        WriteString(f, TheScript.variables[i].value)
      else

        if (vartype_temp = varInteger) then
        blockwrite(f, TheScript.variables[i].value, 4);
    end;

  end;

  blockwrite(f, TheScript.instruction_count, 4);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockwrite(f, TheScript.instructions[i].inst_type, 4);
    blockwrite(f, TheScript.instructions[i].inst_paramcount, 4);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockwrite(f, TheScript.instructions[i].inst_params[j].data_type, 4);
      TheScript.instructions[i].inst_params[j].stringtableindex :=
        AddToStringTable(TheScript.StringData,
        TheScript.instructions[i].inst_params[j].data);
      blockwrite(f, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockwrite(f, TheScript.StringData.stringcnt, 4);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    length_temp := length(TheScript.StringData.strings[j]);
    blockwrite(f, length_temp, 4);
    vartype_temp := vartype(TheScript.StringData.strings[j]);
    blockwrite(f, vartype_temp, 4);

  end;

  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    vartype_temp := vartype(TheScript.StringData.strings[j]);
    if (vartype_temp = varString) or (vartype_temp = varUString) then
      WriteStringNoLength(f, TheScript.StringData.strings[j])
    else if (vartype_temp = varInteger) then
    begin
      int_temp := TheScript.StringData.strings[j];
      blockwrite(f, int_temp, 4);
    end;
    WriteStringNoLength(f, ' ');
  end;
end;

procedure SaveScript(TheScript: Script; filename: string);
var
  j, i: integer;
  length_temp: integer;
  vartype_temp: integer;
  f: file;
begin
  assignfile(f, filename);
  rewrite(f, 1);
  WriteStringNoLength(f, 'AdventureScript v1.0');
  WriteString(f, TheScript.script_name);
  WriteString(f, TheScript.script_filename);
  WriteString(f, TheScript.script_author);
  blockwrite(f, TheScript.is_boot_script, 1);
  blockwrite(f, TheScript.variablecnt, 4);
  for i := 0 to TheScript.variablecnt - 1 do
  begin

    WriteString(f, TheScript.variables[i].name);
    vartype_temp := vartype(TheScript.variables[i].value);
    blockwrite(f, vartype_temp, 4);
    if vartype_temp <> varNull then
    begin;
      if (vartype_temp = varString) or (vartype_temp = varUString) then
        WriteString(f, TheScript.variables[i].value)
      else

        if (vartype_temp = varInteger) then
        blockwrite(f, TheScript.variables[i].value, 4);
    end;

  end;
  blockwrite(f, TheScript.instruction_count, 4);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockwrite(f, TheScript.instructions[i].inst_type, 4);
    blockwrite(f, TheScript.instructions[i].inst_paramcount, 4);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockwrite(f, TheScript.instructions[i].inst_params[j].data_type, 4);
      TheScript.instructions[i].inst_params[j].stringtableindex :=
        AddToStringTable(TheScript.StringData,
        TheScript.instructions[i].inst_params[j].data);
      blockwrite(f, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockwrite(f, TheScript.StringData.stringcnt, 4);
  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    length_temp := length(TheScript.StringData.strings[j]);
    blockwrite(f, length_temp, 4);
    vartype_temp := vartype(TheScript.StringData.strings[j]);
    blockwrite(f, vartype_temp, 4);

  end;

  for j := 0 to TheScript.StringData.stringcnt - 1 do
  begin
    vartype_temp := vartype(TheScript.StringData.strings[j]);
    if (vartype_temp = varString) or (vartype_temp = varUString) then
      WriteStringNoLength(f, TheScript.StringData.strings[j])
    else

      if (vartype_temp = varInteger) then
      blockwrite(f, TheScript.StringData.strings[j], 4);
    WriteStringNoLength(f, ' ');
  end;
  closefile(f);
end;

function AddInstruction(var TheScript: Script; inst_type: integer): instruction;
begin
  instruction_ended := false;
  instruction_created := true;
  SetLength(TheScript.instructions, TheScript.instruction_count + 1);
  TheScript.instructions[TheScript.instruction_count].inst_type := inst_type;
  result.inst_paramcount := 0;
  SetLength(result.inst_params, 0);
  result := TheScript.instructions[TheScript.instruction_count];
end;

procedure NextInstruction(var TheScript: Script; prev_instruction: instruction);
begin
  // if instruction_created = false then
  // writeln('Warning! NextInstruction() called without creating one first');
  instruction_ended := true;
  instruction_created := false;
  TheScript.instructions[TheScript.instruction_count] := prev_instruction;
  inc(TheScript.instruction_count);
  // writeln('NextInstruction(), previous: '+opcodetostr(prev_instruction.inst_type));
end;

procedure AddParam(var instruction: instruction; param: variant;
  data_type: integer);
begin
  SetLength(instruction.inst_params, instruction.inst_paramcount + 1);
  instruction.inst_params[instruction.inst_paramcount].data_type := data_type;
  instruction.inst_params[instruction.inst_paramcount].data := param;
  inc(instruction.inst_paramcount);
end;

procedure InitScriptData(var TheScript: Script; name: ansistring;
  filename: ansistring; author: ansistring);
var
  u: integer;
begin
  SetLength(TheScript.instructions, 0);
  TheScript.instruction_count := 0;
  setlength(thescript.variables, 0);
  thescript.variablecnt:=0;

  TheScript.script_name := name;
  TheScript.script_filename := filename;
  TheScript.script_author := author;
end;

end.
