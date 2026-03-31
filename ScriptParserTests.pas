{
  =============================================================================
  ScriptParserTests - Unit Tests for Script Lexer and Parser
  =============================================================================
  
  This unit contains comprehensive unit tests for the new lexer and parser
  implementation. Tests cover:
  - Tokenization (lexer)
  - Parsing (parser)
  - AST generation
  - Error handling
  - Backward compatibility
  
  Run these tests to verify the parser works correctly.
  
  =============================================================================
}
unit ScriptParserTests;

interface

uses
  Classes, SysUtils, Variants, ScriptLexer, ScriptAST, ScriptParser;

type
  {
    TTestCase - Simple test case record
  }
  TTestCase = record
    Name: string;
    Input: string;
    ExpectedTokenType: TTokenType;
    ExpectedValue: string;
  end;

  {
    TParserTestCase - Test case for parser
  }
  TParserTestCase = record
    Name: string;
    Input: string;
    ExpectSuccess: Boolean;
    ExpectedErrors: Integer;
  end;

  {
    TScriptParserTests - Main test class
  }
  TScriptParserTests = class
  private
    FLexer: TScriptLexer;
    FParser: TScriptParser;
    FTestResults: TStringList;
    
    // Helper methods
    function StreamFromString(const Str: string): TMemoryStream;
    procedure RunLexerTest(const TestCase: TTestCase);
    procedure RunParserTest(const TestCase: TParserTestCase);
    procedure LogResult(const TestName: string; Passed: Boolean; 
      const Message: string = '');
    
  public
    constructor Create;
    destructor Destroy; override;
    
    // Test methods
    procedure TestLexerIdentifiers;
    procedure TestLexerNumbers;
    procedure TestLexerStrings;
    procedure TestLexerOperators;
    procedure TestLexerKeywords;
    procedure TestLexerComments;
    
    procedure TestParserSimpleProgram;
    procedure TestParserGlobalVariables;
    procedure TestParserFunction;
    procedure TestParserIfStatement;
    procedure TestParserSwitchStatement;
    procedure TestParserSetVar;
    procedure TestParserRandomChance;
    procedure TestParserExpressions;
    procedure TestParserConditions;
    
    procedure TestParserErrorHandling;
    procedure TestParserMissingSemicolon;
    procedure TestParserMissingParen;
    
    // Run all tests
    procedure RunAllTests;
    function GetResults: TStringList;
  end;

implementation

{ TScriptParserTests }

constructor TScriptParserTests.Create;
begin
  inherited;
  FLexer := TScriptLexer.Create;
  FParser := TScriptParser.Create(FLexer);
  FTestResults := TStringList.Create;
end;

destructor TScriptParserTests.Destroy;
begin
  FLexer.Free;
  FParser.Free;
  FTestResults.Free;
  inherited;
end;

function TScriptParserTests.StreamFromString(const Str: string): TMemoryStream;
var
  Bytes: TBytes;
begin
  Result := TMemoryStream.Create;
  SetLength(Bytes, Length(Str));
  if Length(Str) > 0 then
    Move(Str[1], Bytes[0], Length(Str));
  Result.WriteBuffer(Bytes[0], Length(Str));
  Result.Position := 0;
end;

procedure TScriptParserTests.LogResult(const TestName: string; 
  Passed: Boolean; const Message: string = '');
var
  Status: string;
begin
  if Passed then
    Status := 'PASS'
  else
    Status := 'FAIL';
    
  if Message <> '' then
    FTestResults.Add(Format('[%s] %s: %s', [Status, TestName, Message]))
  else
    FTestResults.Add(Format('[%s] %s', [Status, TestName]));
end;

procedure TScriptParserTests.RunLexerTest(const TestCase: TTestCase);
var
  Stream: TMemoryStream;
  Token: TToken;
begin
  Stream := StreamFromString(TestCase.Input);
  try
    FLexer.SetSourceStream(Stream);
    FLexer.Reset;
    Token := FLexer.GetNextToken;
    
    if Token.TokenType = TestCase.ExpectedTokenType then
    begin
      if (TestCase.ExpectedValue = '') or (Token.Value = TestCase.ExpectedValue) then
        LogResult(TestCase.Name, True)
      else
        LogResult(TestCase.Name, False, 
          Format('Value mismatch: expected "%s", got "%s"', 
            [TestCase.ExpectedValue, Token.Value]));
    end
    else
      LogResult(TestCase.Name, False, 
        Format('Type mismatch: expected %s, got %s', 
          [FLexer.TokenTypeToString(TestCase.ExpectedTokenType), 
           FLexer.TokenTypeToString(Token.TokenType)]));
  finally
    Stream.Free;
  end;
end;

procedure TScriptParserTests.RunParserTest(const TestCase: TParserTestCase);
var
  Stream: TMemoryStream;
  ProgramNode: TProgramNode;
begin
  Stream := StreamFromString(TestCase.Input);
  try
    FLexer.SetSourceStream(Stream);
    ProgramNode := FParser.Parse;
    
    if TestCase.ExpectSuccess then
    begin
      if Assigned(ProgramNode) and not FParser.HasErrors then
        LogResult(TestCase.Name, True)
      else
        LogResult(TestCase.Name, False, 'Parse failed unexpectedly');
    end
    else
    begin
      if FParser.HasErrors and (FParser.GetErrors.Count = TestCase.ExpectedErrors) then
        LogResult(TestCase.Name, True)
      else if FParser.HasErrors then
        LogResult(TestCase.Name, False, 
          Format('Expected %d errors, got %d', 
            [TestCase.ExpectedErrors, FParser.GetErrors.Count]))
      else
        LogResult(TestCase.Name, False, 'Expected parse errors but none occurred');
    end;
    
    ProgramNode.Free;
  finally
    Stream.Free;
  end;
end;

{ Lexer Tests }

procedure TScriptParserTests.TestLexerIdentifiers;
var
  TestCase: TTestCase;
begin
  // Test simple identifier
  TestCase.Name := 'TestLexerIdentifiers_Simple';
  TestCase.Input := 'myVariable';
  TestCase.ExpectedTokenType := ttIdentifier;
  TestCase.ExpectedValue := 'myVariable';
  RunLexerTest(TestCase);
  
  // Test identifier with underscore
  TestCase.Name := 'TestLexerIdentifiers_Underscore';
  TestCase.Input := 'my_variable';
  TestCase.ExpectedTokenType := ttIdentifier;
  TestCase.ExpectedValue := 'my_variable';
  RunLexerTest(TestCase);
  
  // Test identifier starting with underscore
  TestCase.Name := 'TestLexerIdentifiers_StartUnderscore';
  TestCase.Input := '_private';
  TestCase.ExpectedTokenType := ttIdentifier;
  TestCase.ExpectedValue := '_private';
  RunLexerTest(TestCase);
end;

procedure TScriptParserTests.TestLexerNumbers;
var
  TestCase: TTestCase;
begin
  // Test decimal number
  TestCase.Name := 'TestLexerNumbers_Decimal';
  TestCase.Input := '12345';
  TestCase.ExpectedTokenType := ttNumber;
  TestCase.ExpectedValue := '12345';
  RunLexerTest(TestCase);
  
  // Test zero
  TestCase.Name := 'TestLexerNumbers_Zero';
  TestCase.Input := '0';
  TestCase.ExpectedTokenType := ttNumber;
  TestCase.ExpectedValue := '0';
  RunLexerTest(TestCase);
  
  // Test hexadecimal with 0x prefix
  TestCase.Name := 'TestLexerNumbers_Hex0x';
  TestCase.Input := '0xFF';
  TestCase.ExpectedTokenType := ttHexNumber;
  TestCase.ExpectedValue := '0xFF';
  RunLexerTest(TestCase);
end;

procedure TScriptParserTests.TestLexerStrings;
var
  TestCase: TTestCase;
begin
  // Test simple string
  TestCase.Name := 'TestLexerStrings_Simple';
  TestCase.Input := '"hello world"';
  TestCase.ExpectedTokenType := ttString;
  TestCase.ExpectedValue := 'hello world';
  RunLexerTest(TestCase);
  
  // Test empty string
  TestCase.Name := 'TestLexerStrings_Empty';
  TestCase.Input := '""';
  TestCase.ExpectedTokenType := ttString;
  TestCase.ExpectedValue := '';
  RunLexerTest(TestCase);
  
  // Test string with escape sequences
  TestCase.Name := 'TestLexerStrings_Escape';
  TestCase.Input := '"line1\nline2"';
  TestCase.ExpectedTokenType := ttString;
  TestCase.ExpectedValue := 'line1'#13#10'line2';
  RunLexerTest(TestCase);
end;

procedure TScriptParserTests.TestLexerOperators;
var
  TestCase: TTestCase;
begin
  // Test equality
  TestCase.Name := 'TestLexerOperators_EqualEqual';
  TestCase.Input := '==';
  TestCase.ExpectedTokenType := ttEqualEqual;
  TestCase.ExpectedValue := '==';
  RunLexerTest(TestCase);
  
  // Test not equal
  TestCase.Name := 'TestLexerOperators_BangEqual';
  TestCase.Input := '!=';
  TestCase.ExpectedTokenType := ttBangEqual;
  TestCase.ExpectedValue := '!=';
  RunLexerTest(TestCase);
  
  // Test logical AND
  TestCase.Name := 'TestLexerOperators_AndAnd';
  TestCase.Input := '&&';
  TestCase.ExpectedTokenType := ttAndAnd;
  TestCase.ExpectedValue := '&&';
  RunLexerTest(TestCase);
  
  // Test logical OR
  TestCase.Name := 'TestLexerOperators_BarBar';
  TestCase.Input := '||';
  TestCase.ExpectedTokenType := ttBarBar;
  TestCase.ExpectedValue := '||';
  RunLexerTest(TestCase);
  
  // Test comparison operators
  TestCase.Name := 'TestLexerOperators_GreaterEqual';
  TestCase.Input := '>=';
  TestCase.ExpectedTokenType := ttGreaterEqual;
  TestCase.ExpectedValue := '>=';
  RunLexerTest(TestCase);
  
  TestCase.Name := 'TestLexerOperators_LessEqual';
  TestCase.Input := '<=';
  TestCase.ExpectedTokenType := ttLessEqual;
  TestCase.ExpectedValue := '<=';
  RunLexerTest(TestCase);

  // Test variable sigil
  TestCase.Name := 'TestLexerOperators_Dollar';
  TestCase.Input := '$';
  TestCase.ExpectedTokenType := ttDollar;
  TestCase.ExpectedValue := '$';
  RunLexerTest(TestCase);
end;

procedure TScriptParserTests.TestLexerKeywords;
var
  TestCase: TTestCase;
begin
  // Test IF keyword
  TestCase.Name := 'TestLexerKeywords_IF';
  TestCase.Input := 'IF';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'IF';
  RunLexerTest(TestCase);
  
  // Test ELSE keyword
  TestCase.Name := 'TestLexerKeywords_ELSE';
  TestCase.Input := 'ELSE';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'ELSE';
  RunLexerTest(TestCase);
  
  // Test INT keyword
  TestCase.Name := 'TestLexerKeywords_INT';
  TestCase.Input := 'INT';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'INT';
  RunLexerTest(TestCase);
  
  // Test STR keyword
  TestCase.Name := 'TestLexerKeywords_STR';
  TestCase.Input := 'STR';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'STR';
  RunLexerTest(TestCase);
  
  // Test VOID keyword
  TestCase.Name := 'TestLexerKeywords_VOID';
  TestCase.Input := 'VOID';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'VOID';
  RunLexerTest(TestCase);
  
  // Test SETVAR keyword
  TestCase.Name := 'TestLexerKeywords_SETVAR';
  TestCase.Input := 'SETVAR';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'SETVAR';
  RunLexerTest(TestCase);
  
  // Test SWITCH keyword
  TestCase.Name := 'TestLexerKeywords_SWITCH';
  TestCase.Input := 'SWITCH';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'SWITCH';
  RunLexerTest(TestCase);
  
  // Test RANDOMCHANCE keyword
  TestCase.Name := 'TestLexerKeywords_RANDOMCHANCE';
  TestCase.Input := 'RANDOMCHANCE';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'RANDOMCHANCE';
  RunLexerTest(TestCase);
  
  // Test GLOBALVARIABLES keyword
  TestCase.Name := 'TestLexerKeywords_GLOBALVARIABLES';
  TestCase.Input := 'GLOBALVARIABLES';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'GLOBALVARIABLES';
  RunLexerTest(TestCase);
  
  // Test FUNCTIONS keyword
  TestCase.Name := 'TestLexerKeywords_FUNCTIONS';
  TestCase.Input := 'FUNCTIONS';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'FUNCTIONS';
  RunLexerTest(TestCase);
  
  // Test TARGET_NODE keyword
  TestCase.Name := 'TestLexerKeywords_TARGET_NODE';
  TestCase.Input := 'TARGET_NODE';
  TestCase.ExpectedTokenType := ttKeyword;
  TestCase.ExpectedValue := 'TARGET_NODE';
  RunLexerTest(TestCase);
end;

procedure TScriptParserTests.TestLexerComments;
var
  TestCase: TTestCase;
  Stream: TMemoryStream;
  Token: TToken;
begin
  // Test single-line comment
  TestCase.Name := 'TestLexerComments_SingleLine';
  TestCase.Input := '// this is a comment';
  TestCase.ExpectedTokenType := ttEOF;
  TestCase.ExpectedValue := '';
  RunLexerTest(TestCase);
  
  // Test multi-line comment
  TestCase.Name := 'TestLexerComments_MultiLine';
  TestCase.Input := '/* multi line comment */';
  TestCase.ExpectedTokenType := ttEOF;
  TestCase.ExpectedValue := '';
  RunLexerTest(TestCase);
end;

{ Parser Tests }

procedure TScriptParserTests.TestParserSimpleProgram;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserSimpleProgram';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserGlobalVariables;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserGlobalVariables';
  TestCase.Input := 
    'GLOBALVARIABLES:' + #13#10 +
    'VAR myVar = "hello";' + #13#10 +
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserFunction;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserFunction';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'INT myFunction(INT param1, STR param2)' + #13#10 +
    '{' + #13#10 +
    '}' + #13#10;
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserIfStatement;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserIfStatement';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  IF (x == 1)' + #13#10 +
    '  {' + #13#10 +
    '  }' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserSwitchStatement;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserSwitchStatement';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  SWITCH myVar' + #13#10 +
    '  {' + #13#10 +
    '    "case1":' + #13#10 +
    '    {' + #13#10 +
    '    }' + #13#10 +
    '  }' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserSetVar;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserSetVar';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  SETVAR $myVar = "hello";' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserRandomChance;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserRandomChance';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  RANDOMCHANCE(50) SET TARGET_NODE "node_name";' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserExpressions;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserExpressions';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  SETVAR $x = 1 + 2 * 3;' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserConditions;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserConditions';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  IF (x > 0 && y < 10)' + #13#10 +
    '  {' + #13#10 +
    '  }' + #13#10 +
    '}';
  TestCase.ExpectSuccess := True;
  TestCase.ExpectedErrors := 0;
  RunParserTest(TestCase);
end;

{ Error Handling Tests }

procedure TScriptParserTests.TestParserErrorHandling;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserErrorHandling';
  // Missing closing brace
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10;
  TestCase.ExpectSuccess := False;
  TestCase.ExpectedErrors := 1;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserMissingSemicolon;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserMissingSemicolon';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  SETVAR $x = 1' + #13#10 +  // Missing semicolon
    '}';
  TestCase.ExpectSuccess := False;
  TestCase.ExpectedErrors := 1;
  RunParserTest(TestCase);
end;

procedure TScriptParserTests.TestParserMissingParen;
var
  TestCase: TParserTestCase;
begin
  TestCase.Name := 'TestParserMissingParen';
  TestCase.Input := 
    'FUNCTIONS:' + #13#10 +
    'VOID test()' + #13#10 +
    '{' + #13#10 +
    '  IF (x == 1' + #13#10 +  // Missing closing paren
    '  {' + #13#10 +
    '  }' + #13#10 +
    '}';
  TestCase.ExpectSuccess := False;
  TestCase.ExpectedErrors := 1;
  RunParserTest(TestCase);
end;

{ Run All Tests }

procedure TScriptParserTests.RunAllTests;
begin
  FTestResults.Clear;
  
  // Run lexer tests
  TestLexerIdentifiers;
  TestLexerNumbers;
  TestLexerStrings;
  TestLexerOperators;
  TestLexerKeywords;
  TestLexerComments;
  
  // Run parser tests
  TestParserSimpleProgram;
  TestParserGlobalVariables;
  TestParserFunction;
  TestParserIfStatement;
  TestParserSwitchStatement;
  TestParserSetVar;
  TestParserRandomChance;
  TestParserExpressions;
  TestParserConditions;
  
  // Run error handling tests
  TestParserErrorHandling;
  TestParserMissingSemicolon;
  TestParserMissingParen;
end;

function TScriptParserTests.GetResults: TStringList;
begin
  Result := FTestResults;
end;

end.
