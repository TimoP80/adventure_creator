(* 
  =============================================================================
  ScriptParser - Recursive Descent Parser for Adventure Scripting Language
  =============================================================================
  
  This unit implements a clean, maintainable recursive descent parser for the
  Adventure Scripting Language that generates bytecode directly.
  
  Grammar documented in external documentation.
  =============================================================================
*)
unit ScriptParser;

interface

uses
  Classes, SysUtils, Variants, ScriptLexer, AdventureScriptCompilerUtils;

type
  {
    PScript - Pointer to Script record
  }
  PScript = ^Script;

  {
    EScriptParserException - Custom exception for parser errors
  }
  EScriptParserException = class(Exception)
  private
    FLine: Integer;
    FColumn: Integer;
    FExpected: string;
    FFound: string;
  public
    constructor Create(const Msg: string; Line, Column: Integer);
    constructor CreateExpected(const Expected, Found: string; Line, Column: Integer);
    constructor CreateUnexpected(const Found: string; Line, Column: Integer);
    
    property Line: Integer read FLine;
    property Column: Integer read FColumn;
    property Expected: string read FExpected;
    property Found: string read FFound;
  end;

  {
    TScriptParser - Main parser class
    Implements recursive descent parsing for the Adventure Scripting Language
    Generates bytecode directly using AdventureScriptCompilerUtils
  }
  TScriptParser = class
  private
    FLexer: TScriptLexer;
    FCurrentToken: TToken;
    FErrors: TStringList;
    FHaveErrors: Boolean;
    FCurrentScript: PScript;  // Pointer to the script for bytecode generation
    FLastInstruction: instruction;  // Last instruction for parameter addition
    
    // Helper methods
    procedure Advance;
    function Expect(TokenType: TTokenType): TToken;
    function Check(TokenType: TTokenType): Boolean;
    procedure Error(const Msg: string);
    procedure ErrorExpected(const Expected: string);
    
    // Bytecode generation helpers
    function EmitInstruction(Opcode: Integer): instruction;
    procedure EmitParam(Param: Variant; DataType: Integer);
    procedure FinishInstruction(Instr: instruction);
    
    // Parse methods for each grammar rule
    procedure ParseProgram;
    procedure ParseGlobalVariables;
    procedure ParseVariableDeclaration;
    procedure ParseFunction;
    procedure ParseParameter;
    function ParseType: Integer;
    procedure ParseBlock;
    procedure ParseStatement;
    procedure ParseFunctionCallOrAssignment;
    procedure ParseIfStatement;
    procedure ParseSwitchStatement;
    procedure ParseCaseLabel;
    procedure ParseSetVarStatement;
    procedure ParseRandomChanceStatement;
    procedure ParseCondition;
    procedure ParseFunctionCall(const Name: string);
    procedure ParseFunctionArgument;
    procedure EmitExpressionOperator(TokenType: TTokenType);
    function ParseExpression: Integer;  // Returns data type
    function ParseTerm: Integer;
    function ParseFactor: Integer;
    function ParseValue: Integer;

  public
    constructor Create(Lexer: TScriptLexer);
    destructor Destroy; override;
    
    procedure Parse(Script: PScript);
    function GetErrors: TStringList;
    function HasErrors: Boolean;
    
    // Utility functions
    function ParseStringLiteral(const Str: string): string;
  end;

implementation

{ EScriptParserException }

constructor EScriptParserException.Create(const Msg: string; Line, Column: Integer);
begin
  inherited Create(Format('%s (Line: %d, Column: %d)', [Msg, Line, Column]));
  FLine := Line;
  FColumn := Column;
  FExpected := '';
  FFound := '';
end;

constructor EScriptParserException.CreateExpected(const Expected, Found: string; 
  Line, Column: Integer);
begin
  inherited Create(Format('Expected %s but found %s (Line: %d, Column: %d)', 
    [Expected, Found, Line, Column]));
  FLine := Line;
  FColumn := Column;
  FExpected := Expected;
  FFound := Found;
end;

constructor EScriptParserException.CreateUnexpected(const Found: string; 
  Line, Column: Integer);
begin
  inherited Create(Format('Unexpected token: %s (Line: %d, Column: %d)', 
    [Found, Line, Column]));
  FLine := Line;
  FColumn := Column;
  FExpected := '';
  FFound := Found;
end;

{ TScriptParser }

constructor TScriptParser.Create(Lexer: TScriptLexer);
begin
  inherited Create;
  FLexer := Lexer;
  FErrors := TStringList.Create;
  FHaveErrors := False;
  FCurrentScript := nil;
end;

destructor TScriptParser.Destroy;
begin
  FErrors.Free;
  inherited;
end;

procedure TScriptParser.Advance;
begin
  FCurrentToken := FLexer.GetNextToken;
end;

function TScriptParser.Expect(TokenType: TTokenType): TToken;
begin
  if FCurrentToken.TokenType = TokenType then
  begin
    Result := FCurrentToken;
    Advance;
  end
  else
  begin
    ErrorExpected(FLexer.TokenTypeToString(TokenType));
    Result := FCurrentToken;
  end;
end;

function TScriptParser.Check(TokenType: TTokenType): Boolean;
begin
  Result := FCurrentToken.TokenType = TokenType;
end;

procedure TScriptParser.Error(const Msg: string);
begin
  FHaveErrors := True;
  FErrors.Add(Format('Error at Line %d, Column %d: %s', 
    [FCurrentToken.Line, FCurrentToken.Column, Msg]));
end;

procedure TScriptParser.ErrorExpected(const Expected: string);
begin
  FHaveErrors := True;
  FErrors.Add(Format('Error at Line %d, Column %d: Expected %s but found %s (%s)', 
    [FCurrentToken.Line, FCurrentToken.Column, Expected, 
     FCurrentToken.Value, FLexer.TokenTypeToString(FCurrentToken.TokenType)]));
end;

function TScriptParser.EmitInstruction(Opcode: Integer): instruction;
begin
  if Assigned(FCurrentScript) then
    FLastInstruction := AddInstruction(FCurrentScript^, Opcode)
  else
  begin
    FLastInstruction.inst_type := Opcode;
    FLastInstruction.inst_paramcount := 0;
  end;
  Result := FLastInstruction;
end;

procedure TScriptParser.EmitParam(Param: Variant; DataType: Integer);
begin
  if Assigned(FCurrentScript) then
    AddParam(FLastInstruction, Param, DataType);
end;

procedure TScriptParser.FinishInstruction(Instr: instruction);
begin
  if Assigned(FCurrentScript) then
    NextInstruction(FCurrentScript^, FLastInstruction);
end;

procedure TScriptParser.EmitExpressionOperator(TokenType: TTokenType);
var
  Instr: instruction;
begin
  case TokenType of
    ttPlus:
      Instr := EmitInstruction(OP_ADD);
    ttMinus:
      Instr := EmitInstruction(OP_SUBTRACT);
    ttStar:
      Instr := EmitInstruction(OP_MULTIPLY);
    ttSlash:
      Instr := EmitInstruction(OP_DIVIDE);
  else
    Exit;
  end;

  FinishInstruction(Instr);
end;

procedure TScriptParser.Parse(Script: PScript);
begin
  FHaveErrors := False;
  FErrors.Clear;
  FCurrentScript := Script;
  
  // Get first token
  Advance;
  
  ParseProgram;
end;

procedure TScriptParser.ParseProgram;
var
  Instr: instruction;
begin
  try
    // Parse optional global variables section
    if Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'GLOBALVARIABLES') then
    begin
      Advance;  // Consume GLOBALVARIABLES
      Expect(ttColon);
      ParseGlobalVariables;
    end;
    
    // Parse functions section
    if Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'FUNCTIONS') then
    begin
      Advance;  // Consume FUNCTIONS
      Expect(ttColon);
    end;
    
    // Parse functions
    while not FHaveErrors and ((Check(ttKeyword) and 
           ((UpperCase(FCurrentToken.Value) = 'INT') or 
            (UpperCase(FCurrentToken.Value) = 'STR') or 
            (UpperCase(FCurrentToken.Value) = 'VOID'))) or 
           Check(ttIdentifier)) do
    begin
      ParseFunction;
    end;
    
  except
    on E: Exception do
      if not FHaveErrors then
        Error(E.Message);
  end;
end;

procedure TScriptParser.ParseGlobalVariables;
begin
  // Parse VAR keyword
  if Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'VAR') then
  begin
    Advance;  // Consume VAR
    
    // Parse first variable declaration
    ParseVariableDeclaration;
    
    // Parse additional variable declarations
    while not FHaveErrors and Check(ttIdentifier) do
    begin
      ParseVariableDeclaration;
    end;
  end;
end;

procedure TScriptParser.ParseVariableDeclaration;
var
  VarName: string;
  Instr: instruction;
begin
  if not Check(ttIdentifier) then
    Exit;
  
  VarName := FCurrentToken.Value;
  
  // Add variable to script at parse time
  if Assigned(FCurrentScript) then
    AddVariable(FCurrentScript^, VarName);
  
  // Emit set variable instruction for the bytecode
  Instr := EmitInstruction(OP_SETVAR);
  EmitParam(VarName, DATA_TYPE_VAR_NAME);
  FinishInstruction(Instr);
  
  Advance;  // Consume identifier
  
  // Check for initializer
  if Check(ttEqual) then
  begin
    Advance;  // Consume =
    
    // Parse the expression (this will emit the value as bytecode)
    ParseExpression;
    
    // Emit end of instruction
    Instr := EmitInstruction(OP_ENDINSTRUCTION);
    FinishInstruction(Instr);
  end;
  
  // Expect semicolon
  Expect(ttSemicolon);
end;

procedure TScriptParser.ParseFunction;
var
  ReturnType: Integer;
  FuncName: string;
  Instr: instruction;
begin
  // Parse return type
  ReturnType := ParseType;
  
  // Parse function name
  if not Check(ttIdentifier) then
  begin
    ErrorExpected('function name');
    Exit;
  end;
  
  FuncName := FCurrentToken.Value;
  
  // Emit function definition
  Instr := EmitInstruction(OP_FUNCTIONDEF);
  EmitParam(FuncName, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
  
  Instr := EmitInstruction(OP_FUNCTIONBEGIN);
  FinishInstruction(Instr);
  
  Advance;  // Consume function name
  
  // Expect opening parenthesis
  Expect(ttLParen);
  
  // Parse parameters
  while not FHaveErrors and not Check(ttRParen) do
  begin
    ParseParameter;
    
    if Check(ttComma) then
      Advance  // Consume ,
    else
      Break;
  end;
  
  // Expect closing parenthesis
  Expect(ttRParen);
  
  // Parse function body
  ParseBlock;
  
  Instr := EmitInstruction(OP_FUNCTIONEND);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseParameter;
var
  ParamType: Integer;
  ParamName: string;
  Instr: instruction;
begin
  // Parse parameter type
  ParamType := ParseType;
  
  // Parse parameter name
  if not Check(ttIdentifier) then
  begin
    ErrorExpected('parameter name');
    Exit;
  end;
  
  ParamName := FCurrentToken.Value;
  
  // Emit function parameter instruction
  Instr := EmitInstruction(OP_FUNCTION_PARAMS);
  EmitParam(ParamName, ParamType);
  FinishInstruction(Instr);
  
  Advance;  // Consume parameter name
end;

function TScriptParser.ParseType: Integer;
begin
  Result := COMPARE_MODE_STRING;  // Default
  
  if Check(ttKeyword) then
  begin
    if UpperCase(FCurrentToken.Value) = 'INT' then
    begin
      Advance;
      Result := COMPARE_MODE_INTEGER;
    end
    else if UpperCase(FCurrentToken.Value) = 'STR' then
    begin
      Advance;
      Result := COMPARE_MODE_STRING;
    end
    else if UpperCase(FCurrentToken.Value) = 'VOID' then
    begin
      Advance;
      Result := -1;
    end;
  end;
end;

procedure TScriptParser.ParseBlock;
var
  Instr: instruction;
begin
  // Expect opening brace
  Expect(ttLBrace);
  
  // Parse statements
  while not FHaveErrors and not Check(ttRBrace) and not Check(ttEOF) do
  begin
    ParseStatement;
  end;
  
  // Expect closing brace
  Expect(ttRBrace);
end;

procedure TScriptParser.ParseStatement;
begin
  if Check(ttKeyword) then
  begin
    if UpperCase(FCurrentToken.Value) = 'IF' then
      ParseIfStatement
    else if UpperCase(FCurrentToken.Value) = 'SWITCH' then
      ParseSwitchStatement
    else if UpperCase(FCurrentToken.Value) = 'SETVAR' then
      ParseSetVarStatement
    else if UpperCase(FCurrentToken.Value) = 'RANDOMCHANCE' then
      ParseRandomChanceStatement
    else
      Error('Invalid statement');
  end
  else if Check(ttIdentifier) then
  begin
    // Could be function call or variable - need to look ahead
    // Save current position
    ParseFunctionCallOrAssignment;
  end;
  
  // If we got a statement that requires semicolon, consume it
  if Check(ttSemicolon) then
    Advance;  // Consume ;
end;

procedure TScriptParser.ParseFunctionCallOrAssignment;
var
  Name: string;
  Instr: instruction;
begin
  if not Check(ttIdentifier) then
    Exit;
  
  Name := FCurrentToken.Value;
  Advance;  // Consume identifier
  
  if Check(ttLParen) then
  begin
    ParseFunctionCall(Name);
  end
  else if Check(ttDollar) then
  begin
    // It's a variable assignment (SETVAR $name = ...)
    // Re-emit the variable name since we consumed it
    Instr := EmitInstruction(OP_SETVAR);
    EmitParam(Name, DATA_TYPE_VAR_NAME);
    FinishInstruction(Instr);
    
    // Expect equals
    Expect(ttEqual);
    
    // Parse expression
    ParseExpression;
    
    // End instruction
    Instr := EmitInstruction(OP_ENDINSTRUCTION);
    FinishInstruction(Instr);
  end
  else
  begin
    // Just an expression statement (e.g., function call without semicolon in wrong place)
    Error('Expected function call or variable assignment');
  end;
end;

procedure TScriptParser.ParseIfStatement;
var
  Instr: instruction;
begin
  // Expect IF
  if not (Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'IF')) then
  begin
    ErrorExpected('IF keyword');
    Exit;
  end;
  Advance;  // Consume IF
  
  // Expect opening parenthesis
  Expect(ttLParen);
  
  // Parse condition
  ParseCondition;
  
  // Expect closing parenthesis
  Expect(ttRParen);
  
  // Emit IF instruction
  Instr := EmitInstruction(OP_IF);
  FinishInstruction(Instr);
  
  // Parse then branch
  ParseBlock;
  
  // Check for else or else if
  while Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'ELSE') do
  begin
    Advance;  // Consume ELSE
    
    if Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'IF') then
    begin
      // Else if
      Advance;  // Consume IF
      Expect(ttLParen);
      ParseCondition;
      Expect(ttRParen);
      
      Instr := EmitInstruction(OP_IF_CHAINED);
      FinishInstruction(Instr);
      
      ParseBlock;
    end
    else
    begin
      // Else branch
      Instr := EmitInstruction(OP_IF_ELSE);
      FinishInstruction(Instr);
      
      ParseBlock;
      Break;
    end;
  end;
end;

procedure TScriptParser.ParseSwitchStatement;
var
  Variable: string;
  Instr: instruction;
begin
  // Expect SWITCH
  if not (Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'SWITCH')) then
  begin
    ErrorExpected('SWITCH keyword');
    Exit;
  end;
  Advance;  // Consume SWITCH
  
  // Parse switch variable
  if not Check(ttIdentifier) then
  begin
    ErrorExpected('switch variable');
    Exit;
  end;
  
  Variable := FCurrentToken.Value;
  
  // Emit switch variable
  Instr := EmitInstruction(OP_SWITCH_VAR);
  EmitParam(Variable, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
  
  Advance;  // Consume variable
  
  // Emit switch begin
  Instr := EmitInstruction(OP_SWITCH_BEGIN);
  FinishInstruction(Instr);
  
  // Expect opening brace
  Expect(ttLBrace);
  
  // Parse case labels
  while not FHaveErrors and not Check(ttRBrace) and not Check(ttEOF) do
  begin
    ParseCaseLabel;
  end;
  
  // Expect closing brace
  Expect(ttRBrace);
  
  // Emit switch end
  Instr := EmitInstruction(OP_SWITCH_END);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseCaseLabel;
var
  LabelValue: string;
  Instr: instruction;
begin
  // Parse case label value (string, number, or identifier)
  if not (Check(ttString) or Check(ttNumber) or Check(ttIdentifier)) then
  begin
    ErrorExpected('case label');
    Exit;
  end;
  
  LabelValue := FCurrentToken.Value;
  
  // Emit case label
  Instr := EmitInstruction(OP_SWITCH_LABEL);
  if Check(ttNumber) then
    EmitParam(StrToIntDef(LabelValue, 0), COMPARE_MODE_INTEGER)
  else
    EmitParam(LabelValue, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
  
  Advance;  // Consume label value
  
  // Expect colon
  Expect(ttColon);
  
  // Emit label code begin
  Instr := EmitInstruction(OP_SWITCH_LABEL_CODE_BEGIN);
  FinishInstruction(Instr);
  
  // Expect opening brace
  Expect(ttLBrace);
  
  // Parse statements in case
  while not FHaveErrors and not Check(ttRBrace) and not Check(ttEOF) do
  begin
    ParseStatement;
  end;
  
  // Expect closing brace
  Expect(ttRBrace);
  
  // Emit label code end
  Instr := EmitInstruction(OP_SWITCH_LABEL_CODE_END);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseSetVarStatement;
var
  VarName: string;
  Instr: instruction;
begin
  // Check for SETVAR keyword
  if Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'SETVAR') then
    Advance  // Consume SETVAR
  else if not Check(ttIdentifier) then
  begin
    ErrorExpected('SETVAR or identifier');
    Exit;
  end;
  
  // Expect dollar sign
  Expect(ttDollar);
  
  // Expect variable name
  if not Check(ttIdentifier) then
  begin
    ErrorExpected('variable name');
    Exit;
  end;
  
  VarName := FCurrentToken.Value;
  
  // Emit set variable instruction
  Instr := EmitInstruction(OP_SETVAR);
  EmitParam(VarName, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
  
  Advance;  // Consume variable name
  
  // Expect equals sign
  Expect(ttEqual);
  
  // Parse expression
  ParseExpression;

  Instr := EmitInstruction(OP_ENDINSTRUCTION);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseRandomChanceStatement;
var
  Probability: Integer;
  TargetNode: string;
  Instr: instruction;
begin
  // Expect RANDOMCHANCE
  if not (Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'RANDOMCHANCE')) then
  begin
    ErrorExpected('RANDOMCHANCE');
    Exit;
  end;
  Advance;  // Consume RANDOMCHANCE
  
  // Expect opening parenthesis
  Expect(ttLParen);
  
  // Parse probability
  if not Check(ttNumber) then
  begin
    ErrorExpected('probability number');
    Exit;
  end;
  
  Probability := StrToIntDef(FCurrentToken.Value, 0);
  Advance;  // Consume number
  
  // Expect closing parenthesis
  Expect(ttRParen);
  
  // Expect SET
  if not (Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'SET')) then
  begin
    ErrorExpected('SET');
    Exit;
  end;
  Advance;  // Consume SET
  
  // Expect TARGET_NODE
  if not (Check(ttKeyword) and (UpperCase(FCurrentToken.Value) = 'TARGET_NODE')) then
  begin
    ErrorExpected('TARGET_NODE');
    Exit;
  end;
  Advance;  // Consume TARGET_NODE
  
  // Expect target node string
  if not Check(ttString) then
  begin
    ErrorExpected('target node string');
    Exit;
  end;
  
  TargetNode := ParseStringLiteral(FCurrentToken.Value);
  Advance;  // Consume string
  
  // Emit random chance instruction
  Instr := EmitInstruction(OP_RANDOMCHANCE);
  EmitParam(Probability, COMPARE_MODE_INTEGER);
  EmitParam(TargetNode, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseCondition;
var
  Variable: string;
  ConditionType: Integer;
  Instr: instruction;
begin
  // Parse variable name
  if not Check(ttIdentifier) then
  begin
    ErrorExpected('condition variable');
    Exit;
  end;
  
  Variable := FCurrentToken.Value;
  Advance;  // Consume variable
  
  // Parse operator
  ConditionType := COMPARE_MODE_STRING;
  case FCurrentToken.TokenType of
    ttEqualEqual: ConditionType := COMPARE_MODE_INTEGER;
    ttBangEqual: ConditionType := COMPARE_MODE_INTEGER;
    ttGreater: ConditionType := COMPARE_MODE_INTEGER;
    ttGreaterEqual: ConditionType := COMPARE_MODE_INTEGER;
    ttLess: ConditionType := COMPARE_MODE_INTEGER;
    ttLessEqual: ConditionType := COMPARE_MODE_INTEGER;
  else
    ErrorExpected('comparison operator');
  end;
  Advance;  // Consume operator
  
  // Emit condition instruction
  Instr := EmitInstruction(OP_CONDITION);
  EmitParam(Variable, COMPARE_MODE_STRING);
  FinishInstruction(Instr);
  
  // Parse value
  ParseValue;
  
  // Check for chained conditions (ANDAND or OROR)
  while Check(ttAndAnd) or Check(ttBarBar) do
  begin
    // Consume ANDAND or BARBAR
    Advance;
    
    Instr := EmitInstruction(OP_IF_CONNECTOR);
    if Check(ttAndAnd) then
      EmitParam('AND', COMPARE_MODE_STRING)
    else
      EmitParam('OR', COMPARE_MODE_STRING);
    FinishInstruction(Instr);
    
    // Parse next condition
    if Check(ttIdentifier) then
    begin
      Variable := FCurrentToken.Value;
      Advance;
    end;
    
    // Parse operator
    ConditionType := COMPARE_MODE_STRING;
    case FCurrentToken.TokenType of
      ttEqualEqual: ConditionType := COMPARE_MODE_INTEGER;
      ttBangEqual: ConditionType := COMPARE_MODE_INTEGER;
      ttGreater: ConditionType := COMPARE_MODE_INTEGER;
      ttGreaterEqual: ConditionType := COMPARE_MODE_INTEGER;
      ttLess: ConditionType := COMPARE_MODE_INTEGER;
      ttLessEqual: ConditionType := COMPARE_MODE_INTEGER;
    end;
    Advance;  // Consume operator
    
    // Emit condition instruction
    Instr := EmitInstruction(OP_CONDITION);
    EmitParam(Variable, COMPARE_MODE_STRING);
    FinishInstruction(Instr);
    
    // Parse value
    ParseValue;
  end;
  
  // Emit end condition list
  Instr := EmitInstruction(OP_END_CONDITIONLIST);
  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseFunctionCall(const Name: string);
var
  Instr: instruction;
begin
  Instr := EmitInstruction(OP_FUNCTIONCALL);
  EmitParam(Name, DATA_TYPE_FUNCTION_NAME);

  Expect(ttLParen);
  while not FHaveErrors and not Check(ttRParen) do
  begin
    ParseFunctionArgument;
    if Check(ttComma) then
      Advance
    else if not Check(ttRParen) then
      ErrorExpected('"," or ")"');
  end;
  Expect(ttRParen);

  FinishInstruction(Instr);
end;

procedure TScriptParser.ParseFunctionArgument;
begin
  if Check(ttDollar) then
  begin
    Advance;
    if not Check(ttIdentifier) then
    begin
      ErrorExpected('variable name');
      Exit;
    end;

    EmitParam(FCurrentToken.Value, DATA_TYPE_PARAMETER_VARIABLEREF);
    Advance;
    Exit;
  end;

  case FCurrentToken.TokenType of
    ttIdentifier:
      begin
        EmitParam(FCurrentToken.Value, DATA_TYPE_PARAMETER_VARIABLEREF);
        Advance;
      end;

    ttNumber:
      begin
        EmitParam(StrToIntDef(FCurrentToken.Value, 0), DATA_TYPE_PARAMETER_INT);
        Advance;
      end;

    ttString:
      begin
        EmitParam(ParseStringLiteral(FCurrentToken.Value),
          DATA_TYPE_PARAMETER_STRING);
        Advance;
      end;

  else
    ErrorExpected('function argument');
  end;
end;

function TScriptParser.ParseExpression: Integer;
var
  OperatorToken: TTokenType;
begin
  Result := ParseTerm;
  
  while Check(ttPlus) or Check(ttMinus) do
  begin
    OperatorToken := FCurrentToken.TokenType;
    Advance;  // Consume operator
    ParseTerm;
    EmitExpressionOperator(OperatorToken);
    Result := COMPARE_MODE_INTEGER;
  end;
end;

function TScriptParser.ParseTerm: Integer;
var
  OperatorToken: TTokenType;
begin
  Result := ParseFactor;
  
  while Check(ttStar) or Check(ttSlash) do
  begin
    OperatorToken := FCurrentToken.TokenType;
    Advance;  // Consume operator
    ParseFactor;
    EmitExpressionOperator(OperatorToken);
    Result := COMPARE_MODE_INTEGER;
  end;
end;

function TScriptParser.ParseFactor: Integer;
var
  IdentifierName: string;
  Instr: instruction;
begin
  Result := COMPARE_MODE_STRING;
  
  case FCurrentToken.TokenType of
    ttIdentifier:
      begin
        IdentifierName := FCurrentToken.Value;
        Advance;  // Consume identifier
        
        // Check if it is a function call
        if Check(ttLParen) then
        begin
          ParseFunctionCall(IdentifierName);
        end
        else
        begin
          // Variable reference
          Instr := EmitInstruction(OP_EXPRESSIONDATA);
          EmitParam(IdentifierName, COMPARE_MODE_STRING);
          FinishInstruction(Instr);
        end;
      end;
      
    ttNumber:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(StrToIntDef(FCurrentToken.Value, 0), COMPARE_MODE_INTEGER);
        FinishInstruction(Instr);
        Result := COMPARE_MODE_INTEGER;
        Advance;
      end;
      
    ttString:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(ParseStringLiteral(FCurrentToken.Value), COMPARE_MODE_STRING);
        FinishInstruction(Instr);
        Result := COMPARE_MODE_STRING;
        Advance;
      end;
      
    ttLParen:
      begin
        Advance;  // Consume (
        Result := ParseExpression;
        Expect(ttRParen);
      end;
      
    ttMinus:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(0, COMPARE_MODE_INTEGER);
        FinishInstruction(Instr);
        Advance;  // Consume -
        Result := ParseFactor;
        EmitExpressionOperator(ttMinus);
        Result := COMPARE_MODE_INTEGER;
      end;
      
  else
    Error('Invalid expression');
  end;
end;

function TScriptParser.ParseValue: Integer;
var
  Instr: instruction;
begin
  Result := COMPARE_MODE_STRING;
  
  case FCurrentToken.TokenType of
    ttIdentifier:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(FCurrentToken.Value, COMPARE_MODE_STRING);
        FinishInstruction(Instr);
        Advance;
      end;
      
    ttNumber:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(StrToIntDef(FCurrentToken.Value, 0), COMPARE_MODE_INTEGER);
        FinishInstruction(Instr);
        Result := COMPARE_MODE_INTEGER;
        Advance;
      end;
      
    ttString:
      begin
        Instr := EmitInstruction(OP_EXPRESSIONDATA);
        EmitParam(ParseStringLiteral(FCurrentToken.Value), COMPARE_MODE_STRING);
        FinishInstruction(Instr);
        Result := COMPARE_MODE_STRING;
        Advance;
      end;
        
  else
    ErrorExpected('value');
  end;
end;

function TScriptParser.GetErrors: TStringList;
begin
  Result := FErrors;
end;

function TScriptParser.HasErrors: Boolean;
begin
  Result := FHaveErrors;
end;

function TScriptParser.ParseStringLiteral(const Str: string): string;
var
  Index: Integer;
begin
  Result := '';
  
  // Skip quotes
  Index := 2;
  while Index <= Length(Str) - 1 do
  begin
    if Str[Index] = '\' then
    begin
      Inc(Index);
      case Str[Index] of
        'n': Result := Result + #13#10;
        't': Result := Result + #9;
        '\': Result := Result + '\';
        '"': Result := Result + '"';
      else
        Result := Result + Str[Index];
      end;
    end
    else
      Result := Result + Str[Index];
    Inc(Index);
  end;
end;

end.
