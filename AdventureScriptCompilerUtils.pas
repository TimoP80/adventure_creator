unit AdventureScriptCompilerUtils;

interface

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
  OP_FUNCTIONEND= $800D;
  OP_ADD = $800E;
  OP_SUBTRACT = $800F;
  OP_DIVIDE = $8010;
  OP_MULTIPLY = $8011;

  RETURN_TYPE_VOID = $4000;
  RETURN_TYPE_INTEGER = $4001;
  RETURN_TYPE_STRING = $4002;

  DATA_TYPE_PARAMETER = $A001;
  DATA_TYPE_RETURN_TYPE = $A002;
  DATA_TYPE_FUNCTION_NAME = $A003;
  DATA_TYPE_VAR_NAME = $A004;
  DATA_TYPE_REGULARDATA = $A005;
type
  param = record
    data_type: integer;
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
    instructions: array of instruction;
    instruction_count: integer;
  end;

var
  CurrentScript: Script;

function AddInstruction(var TheScript: Script; inst_type: integer): instruction;
procedure NextInstruction(var TheScript: Script);
procedure AddParam(var instruction: instruction; param: variant; data_type: integer);
procedure InitScriptData(var TheScript: Script; name: ansistring; filename: ansistring; author: ansistring);

implementation

function AddInstruction(var TheScript: Script; inst_type: integer): instruction;
begin
  SetLength(TheScript.instructions, TheScript.instruction_count + 1);
  TheScript.instructions[TheScript.instruction_count].inst_type := inst_type;
  result := TheScript.instructions[TheScript.instruction_count];
  end;

procedure NextInstruction(var TheScript: Script);
begin
  inc(TheScript.instruction_count);
end;

procedure AddParam(var instruction: instruction; param: variant; data_type: integer);
begin
  SetLength(instruction.inst_params, instruction.inst_paramcount + 1);
  instruction.inst_params[instruction.inst_paramcount].data_type := data_type;
  instruction.inst_params[instruction.inst_paramcount].data := param;
  inc(instruction.inst_paramcount);
end;

procedure InitScriptData(var TheScript: Script; name: ansistring; filename: ansistring; author: ansistring);
begin
thescript.script_name := name;
thescript.script_filename := filename;
thescript.script_author := author;
end;

end.
