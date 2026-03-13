(* 
  =============================================================================
  ScriptLexer - Lexical Analyzer for Adventure Scripting Language
  =============================================================================
  
  This unit implements a clean, modular lexer for the Adventure Scripting
  Language. It provides:
  - Distinct token types with meaningful names
  - Comprehensive line and column tracking
  - Support for comments (both single-line and multi-line)
  - Error handling with position information
  
  Grammar documented in external documentation.
  =============================================================================
*)
unit ScriptLexer;

interface

uses
  Classes, SysUtils;

type
  {
    TTokenType - Enumeration of all possible token types in the language
    Each token type corresponds to a lexical element in the source code
  }
  TTokenType = (
    ttEOF,              // End of file
    ttIdentifier,        // Variable/function names
    ttNumber,            // Decimal numbers
    ttHexNumber,         // Hexadecimal numbers ($ followed by hex digits)
    ttString,            // String literals ("...")
    ttChar,              // Character literals ('...')
    ttKeyword,           // Reserved keywords
    
    // Operators
    ttEqualEqual,        // ==
    ttBangEqual,        // !=
    ttGreater,           // >
    ttGreaterEqual,     // >=
    ttLessEqual,         // <=
    ttLess,              // <
    ttAndAnd,            // &&
    ttBarBar,            // ||
    ttPlus,              // +
    ttMinus,             // -
    ttSlash,             // /
    ttStar,              // *
    ttEqual,             // =
    ttColon,             // :
    ttSemicolon,         // ;
    ttComma,             // ,
    ttLParen,            // (
    ttRParen,            // )
    ttLBrace,            // {
    ttRBrace,            // }
    ttDollar,            // $
    
    // Special
    ttUnknown            // Unknown/invalid token
  );

  {
    TToken - Represents a single token with its type, value, and position
  }
  TToken = record
    TokenType: TTokenType;
    Value: string;
    Line: Integer;
    Column: Integer;
    Position: Integer;   // Position in source stream
  end;

  {
    TKeywordTable - Maps keyword strings to their token types
  }
  TKeywordEntry = record
    Keyword: string;
    TokenType: TTokenType;
  end;

  {
    TScriptLexer - The main lexer class
    Provides tokenization of the Adventure Scripting Language
  }
  TScriptLexer = class
  private
    FSourceStream: TMemoryStream;
    FCurrentChar: Char;
    FBufferPosition: Integer;
    FSourceLength: Integer;
    FCurrentLine: Integer;
    FCurrentColumn: Integer;
    FTokenStartLine: Integer;
    FTokenStartColumn: Integer;
    FTokenStartPosition: Integer;
    FLastChar: Char;
    
    // Keyword table
    FKeywords: array of TKeywordEntry;
    
    procedure InitializeKeywords;
    function IsKeyword(const AToken: string): TTokenType;
    function IsLetter(Ch: Char): Boolean;
    function IsDigit(Ch: Char): Boolean;
    function IsHexDigit(Ch: Char): Boolean;
    function IsAlphanumeric(Ch: Char): Boolean;
    procedure ReadChar;
    procedure SkipWhitespace;
    procedure SkipComment;
    function ReadString(Quote: Char): string;
    function ReadNumber: string;
    function ReadHexNumber: string;
    function ReadIdentifier: string;

  public
    constructor Create;
    destructor Destroy; override;
    
    procedure SetSourceStream(Stream: TMemoryStream);
    procedure Reset;
    
    function GetNextToken: TToken;
    function PeekToken: TToken;
    
    // Helper functions
    function TokenToString(Token: TToken): string;
    function TokenTypeToString(TokenType: TTokenType): string;
    
    // Property access
    property CurrentLine: Integer read FCurrentLine;
    property CurrentColumn: Integer read FCurrentColumn;
  end;

  {
    EScriptLexerException - Custom exception for lexer errors
  }
  EScriptLexerException = class(Exception)
  private
    FLine: Integer;
    FColumn: Integer;
  public
    constructor Create(const Msg: string; Line, Column: Integer);
    property Line: Integer read FLine;
    property Column: Integer read FColumn;
  end;

implementation

{ TScriptLexer }

constructor TScriptLexer.Create;
begin
  inherited;
  FSourceStream := TMemoryStream.Create;
  FCurrentLine := 1;
  FCurrentColumn := 1;
  FBufferPosition := 0;
  FSourceLength := 0;
  InitializeKeywords;
end;

destructor TScriptLexer.Destroy;
begin
  FSourceStream.Free;
  inherited;
end;

procedure TScriptLexer.InitializeKeywords;
begin
  // Initialize keyword table - must match grammar keywords
  SetLength(FKeywords, 13);
  FKeywords[0].Keyword := 'GLOBALVARIABLES';
  FKeywords[0].TokenType := ttKeyword;
  FKeywords[1].Keyword := 'FUNCTIONS';
  FKeywords[1].TokenType := ttKeyword;
  FKeywords[2].Keyword := 'VAR';
  FKeywords[2].TokenType := ttKeyword;
  FKeywords[3].Keyword := 'INT';
  FKeywords[3].TokenType := ttKeyword;
  FKeywords[4].Keyword := 'STR';
  FKeywords[4].TokenType := ttKeyword;
  FKeywords[5].Keyword := 'VOID';
  FKeywords[5].TokenType := ttKeyword;
  FKeywords[6].Keyword := 'IF';
  FKeywords[6].TokenType := ttKeyword;
  FKeywords[7].Keyword := 'ELSE';
  FKeywords[7].TokenType := ttKeyword;
  FKeywords[8].Keyword := 'SWITCH';
  FKeywords[8].TokenType := ttKeyword;
  FKeywords[9].Keyword := 'SET';
  FKeywords[9].TokenType := ttKeyword;
  FKeywords[10].Keyword := 'SETVAR';
  FKeywords[10].TokenType := ttKeyword;
  FKeywords[11].Keyword := 'RANDOMCHANCE';
  FKeywords[11].TokenType := ttKeyword;
  FKeywords[12].Keyword := 'TARGET_NODE';
  FKeywords[12].TokenType := ttKeyword;
end;

function TScriptLexer.IsKeyword(const AToken: string): TTokenType;
var
  I: Integer;
  UpperToken: string;
begin
  Result := ttIdentifier;
  UpperToken := UpperCase(AToken);
  
  // Check the keyword table
  for I := 0 to Length(FKeywords) - 1 do
  begin
    if FKeywords[I].Keyword = UpperToken then
    begin
      Result := FKeywords[I].TokenType;
      Exit;
    end;
  end;
end;

function TScriptLexer.IsLetter(Ch: Char): Boolean;
begin
  Result := ((Ch >= 'a') and (Ch <= 'z')) or 
            ((Ch >= 'A') and (Ch <= 'Z')) or 
            (Ch = '_');
end;

function TScriptLexer.IsDigit(Ch: Char): Boolean;
begin
  Result := (Ch >= '0') and (Ch <= '9');
end;

function TScriptLexer.IsHexDigit(Ch: Char): Boolean;
begin
  Result := IsDigit(Ch) or 
            ((Ch >= 'a') and (Ch <= 'f')) or 
            ((Ch >= 'A') and (Ch <= 'F'));
end;

function TScriptLexer.IsAlphanumeric(Ch: Char): Boolean;
begin
  Result := IsLetter(Ch) or IsDigit(Ch);
end;

procedure TScriptLexer.SetSourceStream(Stream: TMemoryStream);
begin
  if Assigned(Stream) then
  begin
    FSourceStream := Stream;
    FSourceLength := FSourceStream.Size;
  end
  else
  begin
    // Nil stream passed - clear the internal stream
    FSourceStream.Clear;
    FSourceLength := 0;
  end;
  Reset;
end;

procedure TScriptLexer.Reset;
begin
  FBufferPosition := 0;
  FCurrentLine := 1;
  FCurrentColumn := 1;
  FLastChar := #0;
  
  if FSourceLength > 0 then
    ReadChar
  else
    FCurrentChar := #0;
end;

procedure TScriptLexer.ReadChar;
begin
  FLastChar := FCurrentChar;
  
  if FBufferPosition >= FSourceLength then
  begin
    FCurrentChar := #0;
    Exit;
  end;
  
  FSourceStream.Seek(FBufferPosition, soFromBeginning);
  FSourceStream.Read(FCurrentChar, 1);
  
  // Handle line endings
  if (FCurrentChar = #13) or ((FCurrentChar = #10) and (FLastChar <> #13)) then
  begin
    Inc(FCurrentLine);
    FCurrentColumn := 1;
  end
  else
    Inc(FCurrentColumn);
    
  Inc(FBufferPosition);
end;

procedure TScriptLexer.SkipWhitespace;
begin
  while (FCurrentChar <> #0) and 
        ((FCurrentChar = ' ') or 
         (FCurrentChar = #9) or 
         (FCurrentChar = #10) or 
         (FCurrentChar = #13)) do
  begin
    // Handle line ending
    if (FCurrentChar = #10) or (FCurrentChar = #13) then
    begin
      // Skip but don't treat as whitespace for line counting
      ReadChar;
      Continue;
    end;
    ReadChar;
  end;
end;

procedure TScriptLexer.SkipComment;
begin
  // Mark start of comment
  FTokenStartLine := FCurrentLine;
  FTokenStartColumn := FCurrentColumn;
  
  ReadChar; // Skip /
  
  if FCurrentChar = '/' then
  begin
    // Single-line comment: // ...
    while (FCurrentChar <> #0) and (FCurrentChar <> #10) and (FCurrentChar <> #13) do
      ReadChar;
  end
  else if FCurrentChar = '*' then
  begin
    // Multi-line comment: /* ... */
    ReadChar;
    while FCurrentChar <> #0 do
    begin
      if FCurrentChar = '*' then
      begin
        ReadChar;
        if FCurrentChar = '/' then
        begin
          ReadChar;
          Break;
        end;
      end
      else
        ReadChar;
    end;
  end;
end;

function TScriptLexer.ReadString(Quote: Char): string;
var
  StartLine, StartCol: Integer;
begin
  Result := '';
  StartLine := FCurrentLine;
  StartCol := FCurrentColumn;
  
  ReadChar; // Skip opening quote
  
  while (FCurrentChar <> #0) and (FCurrentChar <> Quote) do
  begin
    if FCurrentChar = '\' then
    begin
      ReadChar;
      case FCurrentChar of
        'n': Result := Result + #13#10;
        't': Result := Result + #9;
        '\': Result := Result + '\';
        '"': Result := Result + '"';
        'r': Result := Result + #13;
      else
        Result := Result + FCurrentChar;
      end;
    end
    else
      Result := Result + FCurrentChar;
      
    ReadChar;
  end;
  
  // Skip closing quote
  if FCurrentChar = Quote then
    ReadChar;
end;

function TScriptLexer.ReadNumber: string;
begin
  Result := '';
  
  while IsDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    ReadChar;
  end;
  
  // Check for hexadecimal prefix
  if (Result = '0') and (FCurrentChar = 'X') then
  begin
    Result := Result + FCurrentChar;
    ReadChar;
    while IsHexDigit(FCurrentChar) do
    begin
      Result := Result + FCurrentChar;
      ReadChar;
    end;
  end
  // Check for decimal point
  else if FCurrentChar = '.' then
  begin
    Result := Result + FCurrentChar;
    ReadChar;
    while IsDigit(FCurrentChar) do
    begin
      Result := Result + FCurrentChar;
      ReadChar;
    end;
  end;
end;

function TScriptLexer.ReadHexNumber: string;
begin
  Result := '';
  
  ReadChar; // Skip $
  
  while IsHexDigit(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    ReadChar;
  end;
end;

function TScriptLexer.ReadIdentifier: string;
begin
  Result := '';
  
  while IsAlphanumeric(FCurrentChar) do
  begin
    Result := Result + FCurrentChar;
    ReadChar;
  end;
end;

function TScriptLexer.GetNextToken: TToken;
var
  TokenValue: string;
begin
  // Skip whitespace and comments
  repeat
    FTokenStartLine := FCurrentLine;
    FTokenStartColumn := FCurrentColumn;
    FTokenStartPosition := FBufferPosition;
    
    SkipWhitespace;
    
    if FCurrentChar = '/' then
    begin
      // Check for comment
      ReadChar;
      if (FCurrentChar = '/') or (FCurrentChar = '*') then
      begin
        SkipComment;
        Continue;
      end
      else
      begin
        // Not a comment, put back the character
        Dec(FBufferPosition);
        FCurrentChar := '/';
        Break;
      end;
    end
    else
      Break;
  until False;
  
  // Initialize result
  Result.TokenType := ttUnknown;
  Result.Value := '';
  Result.Line := FTokenStartLine;
  Result.Column := FTokenStartColumn;
  Result.Position := FTokenStartPosition;
  
  // End of file
  if FCurrentChar = #0 then
  begin
    Result.TokenType := ttEOF;
    Exit;
  end;
  
  // Identifier or keyword
  if IsLetter(FCurrentChar) then
  begin
    TokenValue := ReadIdentifier;
    Result.Value := TokenValue;
    Result.TokenType := IsKeyword(TokenValue);
    if Result.TokenType = ttIdentifier then
      Result.TokenType := ttIdentifier;
    Exit;
  end;
  
  // Number
  if IsDigit(FCurrentChar) then
  begin
    TokenValue := ReadNumber;
    Result.Value := TokenValue;
    
    // Check if it's a hex number (0x...)
    if (Length(TokenValue) > 1) and (TokenValue[1] = '0') and 
       (UpCase(TokenValue[2]) = 'X') then
      Result.TokenType := ttHexNumber
    else
      Result.TokenType := ttNumber;
    Exit;
  end;
  
  // Hex number with $ prefix
  if FCurrentChar = '$' then
  begin
    TokenValue := '$' + ReadHexNumber;
    Result.Value := TokenValue;
    Result.TokenType := ttHexNumber;
    Exit;
  end;
  
  // String
  if FCurrentChar = '"' then
  begin
    Result.Value := ReadString('"');
    Result.TokenType := ttString;
    Exit;
  end;
  
  // Character
  if FCurrentChar = '''' then
  begin
    Result.Value := ReadString('''');
    Result.TokenType := ttChar;
    Exit;
  end;
  
  // Two-character operators
  case FCurrentChar of
    '=':
      begin
        ReadChar;
        if FCurrentChar = '=' then
        begin
          Result.TokenType := ttEqualEqual;
          Result.Value := '==';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttEqual;
          Result.Value := '=';
        end;
        Exit;
      end;
    '!':
      begin
        ReadChar;
        if FCurrentChar = '=' then
        begin
          Result.TokenType := ttBangEqual;
          Result.Value := '!=';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttUnknown;
          Result.Value := '!';
        end;
        Exit;
      end;
    '>':
      begin
        ReadChar;
        if FCurrentChar = '=' then
        begin
          Result.TokenType := ttGreaterEqual;
          Result.Value := '>=';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttGreater;
          Result.Value := '>';
        end;
        Exit;
      end;
    '<':
      begin
        ReadChar;
        if FCurrentChar = '=' then
        begin
          Result.TokenType := ttLessEqual;
          Result.Value := '<=';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttLess;
          Result.Value := '<';
        end;
        Exit;
      end;
    '&':
      begin
        ReadChar;
        if FCurrentChar = '&' then
        begin
          Result.TokenType := ttAndAnd;
          Result.Value := '&&';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttUnknown;
          Result.Value := '&';
        end;
        Exit;
      end;
    '|':
      begin
        ReadChar;
        if FCurrentChar = '|' then
        begin
          Result.TokenType := ttBarBar;
          Result.Value := '||';
          ReadChar;
        end
        else
        begin
          Result.TokenType := ttUnknown;
          Result.Value := '|';
        end;
        Exit;
      end;
  end;
  
  // Single-character tokens
  Result.Value := FCurrentChar;
  case FCurrentChar of
    '+': Result.TokenType := ttPlus;
    '-': Result.TokenType := ttMinus;
    '/': Result.TokenType := ttSlash;
    '*': Result.TokenType := ttStar;
    ':': Result.TokenType := ttColon;
    ';': Result.TokenType := ttSemicolon;
    ',': Result.TokenType := ttComma;
    '(': Result.TokenType := ttLParen;
    ')': Result.TokenType := ttRParen;
    '{': Result.TokenType := ttLBrace;
    '}': Result.TokenType := ttRBrace;
    '$': Result.TokenType := ttDollar;
  else
    Result.TokenType := ttUnknown;
  end;
  
  ReadChar;
end;

function TScriptLexer.PeekToken: TToken;
var
  SavedPosition: Integer;
  SavedLine, SavedColumn: Integer;
  SavedChar: Char;
begin
  // Save current state
  SavedPosition := FBufferPosition;
  SavedLine := FCurrentLine;
  SavedColumn := FCurrentColumn;
  SavedChar := FCurrentChar;
  
  // Get next token
  Result := GetNextToken;
  
  // Restore state
  FBufferPosition := SavedPosition;
  FCurrentLine := SavedLine;
  FCurrentColumn := SavedColumn;
  FCurrentChar := SavedChar;
end;

function TScriptLexer.TokenToString(Token: TToken): string;
begin
  Result := Format('Token(%s, "%s", Line: %d, Col: %d)',
    [TokenTypeToString(Token.TokenType), Token.Value, Token.Line, Token.Column]);
end;

function TScriptLexer.TokenTypeToString(TokenType: TTokenType): string;
begin
  case TokenType of
    ttEOF: Result := 'EOF';
    ttIdentifier: Result := 'Identifier';
    ttNumber: Result := 'Number';
    ttHexNumber: Result := 'HexNumber';
    ttString: Result := 'String';
    ttChar: Result := 'Char';
    ttKeyword: Result := 'Keyword';
    ttEqualEqual: Result := 'EqualEqual';
    ttBangEqual: Result := 'BangEqual';
    ttGreater: Result := 'Greater';
    ttGreaterEqual: Result := 'GreaterEqual';
    ttLessEqual: Result := 'LessEqual';
    ttLess: Result := 'Less';
    ttAndAnd: Result := 'AndAnd';
    ttBarBar: Result := 'BarBar';
    ttPlus: Result := 'Plus';
    ttMinus: Result := 'Minus';
    ttSlash: Result := 'Slash';
    ttStar: Result := 'Star';
    ttEqual: Result := 'Equal';
    ttColon: Result := 'Colon';
    ttSemicolon: Result := 'Semicolon';
    ttComma: Result := 'Comma';
    ttLParen: Result := 'LParen';
    ttRParen: Result := 'RParen';
    ttLBrace: Result := 'LBrace';
    ttRBrace: Result := 'RBrace';
    ttDollar: Result := 'Dollar';
    ttUnknown: Result := 'Unknown';
  else
    Result := 'Unknown';
  end;
end;

{ EScriptLexerException }

constructor EScriptLexerException.Create(const Msg: string; Line, Column: Integer);
begin
  inherited Create(Format('%s (Line: %d, Column: %d)', [Msg, Line, Column]));
  FLine := Line;
  FColumn := Column;
end;

end.
