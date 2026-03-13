(* 
  =============================================================================
  AdventureScript - Backward Compatibility Wrapper
  =============================================================================
  
  This unit provides backward compatibility with the original CoCo/R generated
  parser. It wraps the new modular parser (ScriptLexer, ScriptAST, ScriptParser)
  to provide the same interface as the original implementation.
  
  =============================================================================
*)
unit AdventureScript;

interface

uses
  Variants, SysUtils, AdventureScriptCompilerUtils, Classes, CocoBase,
  ScriptLexer, ScriptParser;

type
  {
    EAdventureScript - Exception class for script errors
  }
  EAdventureScript = class(Exception);

  {
    TAdventureScriptScanner - Scanner class for backward compatibility
    Now wraps the new ScriptLexer
  }
  TAdventureScriptScanner = class(TCocoRScanner)
  private
    FLexer: TScriptLexer;
    FLastCommentList: TCommentList;
    FSrcStream: TMemoryStream;
    FCurrentSymbol: Integer;
    FNextSymbol: Integer;
    FStoreError: TErrorProc;
    FOnStatusUpdate: TStatusUpdateProc;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Get(var sym: Integer); override;
    procedure NextCh; override;
    procedure _Reset;
    
    property CurrentSymbol: Integer read FCurrentSymbol;
    property NextSymbol: Integer read FNextSymbol;
    property OnStatusUpdate: TStatusUpdateProc read FOnStatusUpdate write FOnStatusUpdate;
    property ScannerError: TErrorProc read FStoreError write FStoreError;
    property SrcStream: TMemoryStream read FSrcStream;
  end;

  {
    TAdventureScript - Main parser class
    Provides backward compatibility with original CoCo/R generated code
  }
  TAdventureScript = class(TCocoRGrammar)
  private
    FLexer: TScriptLexer;
    FParser: TScriptParser;
    FOutputStream: TMemoryStream;
    
  protected
    procedure Get; override;
    function ErrorStr(const ErrorCode: Integer; const Data: ansistring): ansistring; override;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    procedure Execute;
    function GetScanner: TAdventureScriptScanner;
    procedure Parse;
    
    property ErrorList;
    property ListStream;
    property SourceStream;
    property Successful;
    
  published
    property AfterGet;
    property AfterParse;
    property AfterGenList;
    property BeforeGenList;
    property BeforeParse;
    property ClearSourceStream;
    property GenListWhen;
    property SourceFileName;
    
    property OnCustomError;
    property OnError;
    property OnFailure;
    property OnStatusUpdate;
    property OnSuccess;
  end;

implementation

var
  name_temp: ansistring;
  return_type_temp: Integer;
  instruction_temp: instruction;

{ TAdventureScriptScanner }

constructor TAdventureScriptScanner.Create;
begin
  inherited Create;
  FLexer := TScriptLexer.Create;
  FLastCommentList := TCommentList.Create;
  FSrcStream := TMemoryStream.Create;
end;

destructor TAdventureScriptScanner.Destroy;
begin
  FLexer.Free;
  FLastCommentList.Free;
  FSrcStream.Free;
  inherited;
end;

procedure TAdventureScriptScanner._Reset;
begin
  FSrcStream.Position := 0;
  FLexer.SetSourceStream(FSrcStream);
  FLexer.Reset;
  FCurrentSymbol := 0;
  FNextSymbol := 0;
end;

procedure TAdventureScriptScanner.NextCh;
begin
  // Handled by new lexer
end;

procedure TAdventureScriptScanner.Get(var sym: Integer);
var
  Token: TToken;
begin
  if not Assigned(FLexer) then
  begin
    sym := 0;
    Exit;
  end;
  
  Token := FLexer.GetNextToken;
  
  case Token.TokenType of
    ttEOF: sym := 0;
    ttIdentifier: sym := 1;
    ttNumber: sym := 2;
    ttHexNumber: sym := 3;
    ttString: sym := 4;
    ttChar: sym := 5;
    ttEqualEqual: sym := 8;
    ttBangEqual: sym := 9;
    ttGreater: sym := 10;
    ttGreaterEqual: sym := 11;
    ttLessEqual: sym := 12;
    ttLess: sym := 13;
    ttRParen: sym := 14;
    ttAndAnd: sym := 15;
    ttBarBar: sym := 16;
    ttLBrace: sym := 18;
    ttRBrace: sym := 19;
    ttComma: sym := 26;
    ttPlus: sym := 27;
    ttMinus: sym := 28;
    ttSlash: sym := 29;
    ttStar: sym := 30;
    ttDollar: sym := 32;
    ttEqual: sym := 33;
    ttColon: sym := 34;
    ttSemicolon: sym := 36;
    ttLParen: sym := 14;
    ttKeyword:
      begin
        if UpperCase(Token.Value) = 'IF' then sym := 17
        else if UpperCase(Token.Value) = 'GLOBALVARIABLES' then sym := 39
        else if UpperCase(Token.Value) = 'FUNCTIONS' then sym := 40
        else if UpperCase(Token.Value) = 'ELSE' then sym := 20
        else if UpperCase(Token.Value) = 'INT' then sym := 21
        else if UpperCase(Token.Value) = 'STR' then sym := 22
        else if UpperCase(Token.Value) = 'RANDOMCHANCE' then sym := 23
        else if UpperCase(Token.Value) = 'SET' then sym := 24
        else if UpperCase(Token.Value) = 'TARGET_NODE' then sym := 25
        else if UpperCase(Token.Value) = 'SETVAR' then sym := 31
        else if UpperCase(Token.Value) = 'SWITCH' then sym := 35
        else if UpperCase(Token.Value) = 'VOID' then sym := 37
        else if UpperCase(Token.Value) = 'VAR' then sym := 38
        else sym := 1;
      end;
  else
    sym := 41;
  end;
  
  FCurrentSymbol := sym;
end;

{ TAdventureScript }

constructor TAdventureScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLexer := TScriptLexer.Create;
  FParser := TScriptParser.Create(FLexer);
  FOutputStream := TMemoryStream.Create;
  Scanner := TAdventureScriptScanner.Create;
end;

destructor TAdventureScript.Destroy;
begin
  FLexer.Free;
  FParser.Free;
  FOutputStream.Free;
  inherited;
end;

procedure TAdventureScript.Get;
begin
  // Legacy - handled in Execute
end;

function TAdventureScript.ErrorStr(const ErrorCode: Integer; 
  const Data: ansistring): ansistring;
begin
  case ErrorCode of
    0: Result := 'EOF expected';
    1: Result := 'identifier expected';
    2: Result := 'number expected';
    3: Result := 'hexnumber expected';
    4: Result := 'string expected';
    5: Result := 'char expected';
    6: Result := 'library expected';
    7: Result := '"(" expected';
    8: Result := '"==" expected';
    9: Result := '"!=" expected';
    10: Result := '">" expected';
    11: Result := '">=" expected';
    12: Result := '"<=" expected';
    13: Result := '"<" expected';
    14: Result := '")" expected';
    15: Result := '"&&" expected';
    16: Result := '"|" expected';
    17: Result := '"IF" expected';
    18: Result := '"{" expected';
    19: Result := '"}" expected';
    20: Result := '"ELSE" expected';
    21: Result := '"INT" expected';
    22: Result := '"STR" expected';
    23: Result := '"RANDOMCHANCE" expected';
    24: Result := '"SET" expected';
    25: Result := '"TARGET_NODE" expected';
    26: Result := '"," expected';
    27: Result := '"+" expected';
    28: Result := '"-" expected';
    29: Result := '"/" expected';
    30: Result := '"*" expected';
    31: Result := '"SETVAR" expected';
    32: Result := '"$" expected';
    33: Result := '"=" expected';
    34: Result := '":" expected';
    35: Result := '"SWITCH" expected';
    36: Result := '";" expected';
    37: Result := '"VOID" expected';
    38: Result := '"VAR" expected';
    39: Result := '"GLOBALVARIABLES" expected';
    40: Result := '"FUNCTIONS" expected';
    41: Result := 'not expected';
    42: Result := 'invalid VariableDefinition';
    43: Result := 'invalid FuncDefinition';
    44: Result := 'invalid CaseLabel';
    45: Result := 'invalid SetVar';
    46: Result := 'invalid Expression';
    47: Result := 'invalid RegularData';
    48: Result := 'invalid Param';
    49: Result := 'invalid FunctionParam';
    50: Result := 'invalid FunctionParam';
    51: Result := 'invalid Command';
    52: Result := 'invalid Condition';
    53: Result := 'invalid Condition';
  else
    if Assigned(OnCustomError) then
      Result := OnCustomError(Self, ErrorCode, Data)
    else
    begin
      Result := ansistring('Error: ' + IntToStr(ErrorCode));
      if Trim(string(Data)) > '' then
        Result := Result + ansistring(' (' + string(Data) + ')');
    end;
  end;
end;

procedure TAdventureScript.Execute;
var
  ScriptPtr: PScript;
begin
  ClearErrors;
  ListStream.Clear;
  
  if Trim(string(SourceFileName)) <> '' then
  begin
    GetScanner.SrcStream.Clear;
    GetScanner.SrcStream.LoadFromFile(string(SourceFileName));
  end;
  
  GetScanner.ScannerError := StoreError;
  
  DoBeforeParse;
  
  try
    // Use the scanner's lexer which is properly initialized in _Reset
    GetScanner._Reset;
    // Parser uses its own FLexer - make sure it's set up
    FLexer.SetSourceStream(GetScanner.SrcStream);
    
    // Point to the global CurrentScript
    ScriptPtr := @CurrentScript;
    FParser.Parse(ScriptPtr);
    
  except
    on E: Exception do
    begin
      SynError(999);
    end;
  end;
  
  DoAfterParse;
  
  if (GenListWhen = glAlways) or ((GenListWhen = glOnError) and (ErrorList.Count > 0)) then
    GenerateListing;
    
  if ClearSourceStream then
    GetScanner.SrcStream.Clear;
    
  ListStream.Position := 0;
  
  if Successful and Assigned(OnSuccess) then
    OnSuccess(Self);
    
  if (not Successful) and Assigned(OnFailure) then
    OnFailure(Self, ErrorList.Count);
end;

function TAdventureScript.GetScanner: TAdventureScriptScanner;
begin
  Result := Scanner as TAdventureScriptScanner;
end;

procedure TAdventureScript.Parse;
begin
  Execute;
end;

end.
