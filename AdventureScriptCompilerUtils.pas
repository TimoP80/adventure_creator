unit AdventureScriptCompilerUtils;

interface

uses Classes, Sysutils, Variants, FileIOFunctions;

const
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

  RETURN_TYPE_VOID = $4000;
  RETURN_TYPE_INTEGER = $4001;
  RETURN_TYPE_STRING = $4002;

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
  Script = record
    script_name: ansistring;
    script_filename: ansistring;
    script_author: ansistring;
    stringdata: stringtable;

    instructions: array of instruction;
    instruction_count: integer;
  end;

var
  CurrentScript: Script;
  TestScript: script;
  instruction_created: boolean;
  instruction_ended: boolean;
  built_in_functions: TStrings;

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
procedure LoadScriptFromAGF(var f: file;var TheScript: Script);

implementation


procedure RunScript (TheScript: Script);
var i: integer;
begin

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
  built_in_functions := TStringlist.create;
  built_in_functions.add('GotoXY');
  built_in_functions.add('ClrScr');
  built_in_functions.add('TextColor');
  built_in_functions.add('TextBackground');
  built_in_functions.add('RandomFromList');
  built_in_functions.add('DisplayMessage');
  built_in_functions.add('WaitForKeyPress');
  built_in_functions.add('Random');
  built_in_functions.add('ExecuteRandomChance');
  built_in_functions.add('ReadInput');
  built_in_functions.add('Return');
end;

function ParamTypeToStr(paramtype: integer): string;
begin
  case paramtype of
    DATA_TYPE_PARAMETER:
      result := 'DATA_TYPE_PARAMETER';
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
     result:='OP_IF_CONNECTOR';

  else
    result := 'OP_UNKNOWN ('+format('%0.4x',[opcode])+')';
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
  if (vartype(str) = VarInteger) or (vartype(str) = VarWord) then
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
    setlength(stringtbl.strings, stringtbl.stringcnt + 1);
    if (data_type = varString) or (data_type = varUString) then
      stringtbl.strings[stringtbl.stringcnt] := strdata
    else
      stringtbl.strings[stringtbl.stringcnt] := intdata;

    result := stringtbl.stringcnt;
    inc(stringtbl.stringcnt);
  end
  else
  begin
    result := GetStringIndex(stringtbl, strdata);
  end;
end;


procedure LoadScriptFromAGF(var f: file;var TheScript: Script);
var
  j, i: integer;
  lengths: array of integer;
  lengthcnt: integer;
  vartypes: array of integer;
  vartypecnt: integer;
  stringtemp: ansistring;
  length_temp: integer;
  vartype_temp: integer;
begin
  ReadHeader(F, 'AdventureScript v1.0');
  ReadString(F, TheScript.script_name);
  ReadString(F, TheScript.script_filename);
  ReadString(F, TheScript.script_author);
 // writeln('Load script: '+thescript.script_name+' ('+thescript.script_filename+')');
  blockread(F, TheScript.instruction_count, 4);
  setlength(TheScript.instructions, TheScript.instruction_count + 1);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockread(F, TheScript.instructions[i].inst_type, 4);
    blockread(F, TheScript.instructions[i].inst_paramcount, 4);
    setlength(TheScript.instructions[i].inst_params,
      TheScript.instructions[i].inst_paramcount + 1);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockread(F, TheScript.instructions[i].inst_params[j].data_type, 4);

      blockread(F, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockread(F, TheScript.stringdata.stringcnt, 4);
  lengthcnt := TheScript.stringdata.stringcnt;
  vartypecnt := TheScript.stringdata.stringcnt;
  setlength(lengths, lengthcnt + 1);
  setlength(vartypes, vartypecnt + 1);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    blockread(F, length_temp, 4);
    lengths[j] := length_temp;
    blockread(F, vartype_temp, 4);
    vartypes[j] := vartype_temp;

  end;
  setlength(thescript.stringdata.strings, TheScript.stringdata.stringcnt+1);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    vartype_temp := vartypes[j];
    if (vartype_temp = varString) or (vartype_temp = varUString) then
    begin
      ReadStringWithLength(F, lengths[j], stringtemp);
       TheScript.stringdata.strings[j] := varastype(stringtemp, varstring);
    end
    else

      if (vartype_temp = VarInteger) then
    begin
      blockread(F, TheScript.stringdata.strings[j], 4);
    end;
    ReadHeader(F, ' ');
  end;

  for i := 0 to TheScript.instruction_count - 1 do
  begin
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      TheScript.instructions[i].inst_params[j].data :=
        TheScript.stringdata.strings[TheScript.instructions[i].inst_params[j]
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
  F: file;
begin
  assignfile(F, filename);
  reset(F, 1);
  ReadHeader(F, 'AdventureScript v1.0');
  ReadString(F, TheScript.script_name);
  ReadString(F, TheScript.script_filename);
  ReadString(F, TheScript.script_author);
  blockread(F, TheScript.instruction_count, 4);
  setlength(TheScript.instructions, TheScript.instruction_count + 1);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockread(F, TheScript.instructions[i].inst_type, 4);
    blockread(F, TheScript.instructions[i].inst_paramcount, 4);
    setlength(TheScript.instructions[i].inst_params,
      TheScript.instructions[i].inst_paramcount + 1);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockread(F, TheScript.instructions[i].inst_params[j].data_type, 4);

      blockread(F, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockread(F, TheScript.stringdata.stringcnt, 4);
  lengthcnt := TheScript.stringdata.stringcnt;
  vartypecnt := TheScript.stringdata.stringcnt;
  setlength(lengths, lengthcnt + 1);
  setlength(vartypes, vartypecnt + 1);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    blockread(F, length_temp, 4);
    lengths[j] := length_temp;
    blockread(F, vartype_temp, 4);
    vartypes[j] := vartype_temp;

  end;
  setlength(thescript.stringdata.strings, TheScript.stringdata.stringcnt+1);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    vartype_temp := vartypes[j];
    if (vartype_temp = varString) or (vartype_temp = varUString) then
    begin
      ReadStringWithLength(F, lengths[j], stringtemp);
       TheScript.stringdata.strings[j] := varastype(stringtemp, varstring);
    end
    else

      if (vartype_temp = VarInteger) then
    begin
      blockread(F, TheScript.stringdata.strings[j], 4);
    end;
    ReadHeader(F, ' ');
  end;

  for i := 0 to TheScript.instruction_count - 1 do
  begin
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      TheScript.instructions[i].inst_params[j].data :=
        TheScript.stringdata.strings[TheScript.instructions[i].inst_params[j]
        .stringtableindex];
    end;

  end;

  closefile(F);
end;

procedure SaveScriptToAGF(var f: file; TheScript: Script);
var
  j, i: integer;
  length_temp: integer;
  vartype_temp: integer;
begin
  WriteStringNoLength(F, 'AdventureScript v1.0');
  WriteString(F, TheScript.script_name);
  WriteString(F, TheScript.script_filename);
  WriteString(F, TheScript.script_author);
  blockwrite(F, TheScript.instruction_count, 4);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockwrite(F, TheScript.instructions[i].inst_type, 4);
    blockwrite(F, TheScript.instructions[i].inst_paramcount, 4);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockwrite(F, TheScript.instructions[i].inst_params[j].data_type, 4);
      TheScript.instructions[i].inst_params[j].stringtableindex :=
        AddToStringTable(TheScript.stringdata,
        TheScript.instructions[i].inst_params[j].data);
      blockwrite(F, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockwrite(F, TheScript.stringdata.stringcnt, 4);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    length_temp := length(TheScript.stringdata.strings[j]);
    blockwrite(F, length_temp, 4);
    vartype_temp := vartype(TheScript.stringdata.strings[j]);
    blockwrite(F, vartype_temp, 4);

  end;

  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    vartype_temp := vartype(TheScript.stringdata.strings[j]);
    if (vartype_temp = varString) or (vartype_temp = varUString) then
      WriteStringNoLength(F, TheScript.stringdata.strings[j])
    else

      if (vartype_temp = VarInteger) then
      blockwrite(F, TheScript.stringdata.strings[j], 4);
    WriteStringNoLength(F, ' ');
  end;
end;


procedure SaveScript(TheScript: Script; filename: string);
var
  j, i: integer;
  length_temp: integer;
  vartype_temp: integer;
  F: file;
begin
  assignfile(F, filename);
  rewrite(F, 1);
  WriteStringNoLength(F, 'AdventureScript v1.0');
  WriteString(F, TheScript.script_name);
  WriteString(F, TheScript.script_filename);
  WriteString(F, TheScript.script_author);
  blockwrite(F, TheScript.instruction_count, 4);
  for i := 0 to TheScript.instruction_count - 1 do
  begin

    blockwrite(F, TheScript.instructions[i].inst_type, 4);
    blockwrite(F, TheScript.instructions[i].inst_paramcount, 4);
    for j := 0 to TheScript.instructions[i].inst_paramcount - 1 do
    begin
      blockwrite(F, TheScript.instructions[i].inst_params[j].data_type, 4);
      TheScript.instructions[i].inst_params[j].stringtableindex :=
        AddToStringTable(TheScript.stringdata,
        TheScript.instructions[i].inst_params[j].data);
      blockwrite(F, TheScript.instructions[i].inst_params[j]
        .stringtableindex, 4);
    end;
  end;
  blockwrite(F, TheScript.stringdata.stringcnt, 4);
  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    length_temp := length(TheScript.stringdata.strings[j]);
    blockwrite(F, length_temp, 4);
    vartype_temp := vartype(TheScript.stringdata.strings[j]);
    blockwrite(F, vartype_temp, 4);

  end;

  for j := 0 to TheScript.stringdata.stringcnt - 1 do
  begin
    vartype_temp := vartype(TheScript.stringdata.strings[j]);
    if (vartype_temp = varString) or (vartype_temp = varUString) then
      WriteStringNoLength(F, TheScript.stringdata.strings[j])
    else

      if (vartype_temp = VarInteger) then
      blockwrite(F, TheScript.stringdata.strings[j], 4);
    WriteStringNoLength(F, ' ');
  end;
  closefile(F);
end;

function AddInstruction(var TheScript: Script; inst_type: integer): instruction;
begin
  instruction_ended := false;
  instruction_created := true;
  setlength(TheScript.instructions, TheScript.instruction_count + 1);
  TheScript.instructions[TheScript.instruction_count].inst_type := inst_type;
  result.inst_paramcount := 0;
  setlength(result.inst_params, 0);
  result := TheScript.instructions[TheScript.instruction_count];
end;

procedure NextInstruction(var TheScript: Script; prev_instruction: instruction);
begin
  if instruction_created = false then
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
  setlength(instruction.inst_params, instruction.inst_paramcount + 1);
  instruction.inst_params[instruction.inst_paramcount].data_type := data_type;
  instruction.inst_params[instruction.inst_paramcount].data := param;
  inc(instruction.inst_paramcount);
end;

procedure InitScriptData(var TheScript: Script; name: ansistring;
  filename: ansistring; author: ansistring);
begin
 thescript.instruction_count := 0;
  TheScript.script_name := name;
  TheScript.script_filename := filename;
  TheScript.script_author := author;
end;

end.
