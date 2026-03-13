{
  =============================================================================
  ScriptAST - Abstract Syntax Tree Node Definitions
  =============================================================================
  
  This unit defines the AST node types for representing parsed Adventure
  Scripting Language code. The AST provides an intermediate representation
  that can be processed by interpreters or compilers.
  
  Node Types:
  -----------
  - ProgramNode: Root node containing global variables and functions
  - VariableDeclNode: Variable declaration with optional initializer
  - FunctionNode: Function definition with parameters and body
  - ParameterNode: Function parameter declaration
  - StatementNode: Base for all statement types
  - IfStatementNode: If-else conditional statement
  - SwitchStatementNode: Switch-case statement
  - CaseLabelNode: Individual switch case label
  - SetVarStatementNode: Variable assignment statement
  - ExpressionStatementNode: Expression as a statement
  - BlockNode: Compound statement (code block)
  - ExpressionNode: Base for all expression types
  - BinaryOpNode: Binary operation (arithmetic, logical)
  - UnaryOpNode: Unary operation
  - IdentifierNode: Variable/function reference
  - LiteralNode: Literal values (number, string)
  - FunctionCallNode: Function call expression
  - RandomChanceNode: Random chance statement
  - ConditionNode: Condition for if/switch statements
  
  =============================================================================
}
unit ScriptAST;

interface

uses
  Classes, SysUtils, Variants;

type
  {
    TASTNodeType - Enumeration of all AST node types
  }
  TASTNodeType = (
    ntProgram,
    ntVariableDecl,
    ntFunction,
    ntParameter,
    ntStatement,
    ntIfStatement,
    ntSwitchStatement,
    ntCaseLabel,
    ntSetVarStatement,
    ntExpressionStatement,
    ntBlock,
    ntRandomChance,
    ntExpression,
    ntBinaryOp,
    ntUnaryOp,
    ntIdentifier,
    ntLiteral,
    ntFunctionCall,
    ntCondition
  );

  {
    TBinaryOperator - Binary operators supported in expressions
  }
  TBinaryOperator = (
    opAdd,
    opSubtract,
    opMultiply,
    opDivide,
    opEqual,
    opNotEqual,
    opGreater,
    opGreaterEqual,
    opLess,
    opLessEqual,
    opAnd,
    opOr
  );

  {
    TUnaryOperator - Unary operators
  }
  TUnaryOperator = (
    opMinus,
    opNot
  );

  {
    TVariableType - Variable types
  }
  TVariableType = (
    vtInt,
    vtString,
    vtVoid
  );

  {
    TConditionOperator - Comparison operators for conditions
  }
  TConditionOperator = (
    coEquals,
    coNotEquals,
    coGreater,
    coGreaterEqual,
    coLess,
    coLessEqual
  );

  {
    TASTNode - Base class for all AST nodes
  }
  TASTNode = class
  private
    FNodeType: TASTNodeType;
    FLine: Integer;
    FColumn: Integer;
  public
    constructor Create(NodeType: TASTNodeType; Line, Column: Integer);
    destructor Destroy; override;
    
    property NodeType: TASTNodeType read FNodeType;
    property Line: Integer read FLine;
    property Column: Integer read FColumn;
  end;

  {
    TExpressionNode - Base class for all expressions
  }
  TExpressionNode = class(TASTNode)
  public
    constructor Create(NodeType: TASTNodeType; Line, Column: Integer);
  end;

  {
    TStatementNode - Base class for all statements
  }
  TStatementNode = class(TASTNode)
  public
    constructor Create(NodeType: TASTNodeType; Line, Column: Integer);
  end;

  {
    TLiteralNode - Represents literal values (numbers, strings)
  }
  TLiteralNode = class(TExpressionNode)
  private
    FValue: Variant;
    FLiteralType: TVariableType;
  public
    constructor Create(Value: Variant; LiteralType: TVariableType; Line, Column: Integer);
    
    property Value: Variant read FValue;
    property LiteralType: TVariableType read FLiteralType;
  end;

  {
    TIdentifierNode - Represents variable or function references
  }
  TIdentifierNode = class(TExpressionNode)
  private
    FName: string;
  public
    constructor Create(const Name: string; Line, Column: Integer);
    
    property Name: string read FName;
  end;

  {
    TBinaryOpNode - Binary operation expression
  }
  TBinaryOpNode = class(TExpressionNode)
  private
    FOperator: TBinaryOperator;
    FLeft: TExpressionNode;
    FRight: TExpressionNode;
  public
    constructor Create(Operator: TBinaryOperator; Left, Right: TExpressionNode; 
      Line, Column: Integer);
    destructor Destroy; override;
    
    property Operator: TBinaryOperator read FOperator;
    property Left: TExpressionNode read FLeft;
    property Right: TExpressionNode read FRight;
  end;

  {
    TUnaryOpNode - Unary operation expression
  }
  TUnaryOpNode = class(TExpressionNode)
  private
    FOperator: TUnaryOperator;
    FOperand: TExpressionNode;
  public
    constructor Create(Operator: TUnaryOperator; Operand: TExpressionNode; 
      Line, Column: Integer);
    destructor Destroy; override;
    
    property Operator: TUnaryOperator read FOperator;
    property Operand: TExpressionNode read FOperand;
  end;

  {
    TFunctionCallNode - Function call expression
  }
  TFunctionCallNode = class(TExpressionNode)
  private
    FFunctionName: string;
    FArguments: TList;
  public
    constructor Create(const FunctionName: string; Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddArgument(Arg: TExpressionNode);
    property FunctionName: string read FFunctionName;
    property Arguments: TList read FArguments;
  end;

  {
    TConditionNode - Condition for if statements
  }
  TConditionNode = class(TASTNode)
  private
    FVariable: string;
    FOperator: TConditionOperator;
    FValue: TExpressionNode;
    FConnector: TConditionNode;  // For chaining conditions with AND/OR
    FIsAnd: Boolean;
  public
    constructor Create(const Variable: string; Operator: TConditionOperator;
      Value: TExpressionNode; Line, Column: Integer);
    destructor Destroy; override;
    
    procedure SetConnector(IsAnd: Boolean; Connector: TConditionNode);
    
    property Variable: string read FVariable;
    property Operator: TConditionOperator read FOperator;
    property Value: TExpressionNode read FValue;
    property Connector: TConditionNode read FConnector;
    property IsAnd: Boolean read FIsAnd;
  end;

  {
    TExpressionStatementNode - Expression as a statement
  }
  TExpressionStatementNode = class(TStatementNode)
  private
    FExpression: TExpressionNode;
  public
    constructor Create(Expression: TExpressionNode; Line, Column: Integer);
    destructor Destroy; override;
    
    property Expression: TExpressionNode read FExpression;
  end;

  {
    TSetVarStatementNode - Variable assignment statement
  }
  TSetVarStatementNode = class(TStatementNode)
  private
    FVariableName: string;
    FValue: TExpressionNode;
  public
    constructor Create(const VariableName: string; Value: TExpressionNode; 
      Line, Column: Integer);
    destructor Destroy; override;
    
    property VariableName: string read FVariableName;
    property Value: TExpressionNode read FValue;
  end;

  {
    TRandomChanceNode - Random chance statement
    RANDOMCHANCE(probability) SET TARGET_NODE "node_name"
  }
  TRandomChanceNode = class(TStatementNode)
  private
    FProbability: Integer;
    FTargetNode: string;
  public
    constructor Create(Probability: Integer; const TargetNode: string; 
      Line, Column: Integer);
    
    property Probability: Integer read FProbability;
    property TargetNode: string read FTargetNode;
  end;

  {
    TCaseLabelNode - Individual case in switch statement
  }
  TCaseLabelNode = class(TASTNode)
  private
    FLabelValue: string;
    FStatements: TList;
  public
    constructor Create(const LabelValue: string; Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddStatement(Stmt: TStatementNode);
    
    property LabelValue: string read FLabelValue;
    property Statements: TList read FStatements;
  end;

  {
    TSwitchStatementNode - Switch statement
  }
  TSwitchStatementNode = class(TStatementNode)
  private
    FVariable: string;
    FCases: TList;
  public
    constructor Create(const Variable: string; Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddCase(ACase: TCaseLabelNode);
    
    property Variable: string read FVariable;
    property Cases: TList read FCases;
  end;

  {
    TIfStatementNode - If-else conditional statement
  }
  TIfStatementNode = class(TStatementNode)
  private
    FCondition: TConditionNode;
    FThenBranch: TList;
    FElseBranch: TList;
    FElseIfs: TList;  // List of (Condition, ThenBranch) pairs
  public
    constructor Create(Condition: TConditionNode; Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddThenStatement(Stmt: TStatementNode);
    procedure AddElseStatement(Stmt: TStatementNode);
    procedure AddElseIf(Condition: TConditionNode);
    
    property Condition: TConditionNode read FCondition;
    property ThenBranch: TList read FThenBranch;
    property ElseBranch: TList read FElseBranch;
    property ElseIfs: TList read FElseIfs;
  end;

  {
    TBlockNode - Block of statements (compound statement)
  }
  TBlockNode = class(TStatementNode)
  private
    FStatements: TList;
  public
    constructor Create(Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddStatement(Stmt: TStatementNode);
    
    property Statements: TList read FStatements;
  end;

  {
    TParameterNode - Function parameter
  }
  TParameterNode = class(TASTNode)
  private
    FParamType: TVariableType;
    FName: string;
  public
    constructor Create(ParamType: TVariableType; const Name: string; 
      Line, Column: Integer);
    
    property ParamType: TVariableType read FParamType;
    property Name: string read FName;
  end;

  {
    TVariableDeclNode - Variable declaration
  }
  TVariableDeclNode = class(TASTNode)
  private
    FVarType: TVariableType;
    FName: string;
    FInitializer: TExpressionNode;
  public
    constructor Create(VarType: TVariableType; const Name: string; 
      Initializer: TExpressionNode; Line, Column: Integer);
    destructor Destroy; override;
    
    property VarType: TVariableType read FVarType;
    property Name: string read FName;
    property Initializer: TExpressionNode read FInitializer;
  end;

  {
    TFunctionNode - Function definition
  }
  TFunctionNode = class(TASTNode)
  private
    FReturnType: TVariableType;
    FName: string;
    FParameters: TList;
    FBody: TBlockNode;
  public
    constructor Create(ReturnType: TVariableType; const Name: string; 
      Line, Column: Integer);
    destructor Destroy; override;
    
    procedure AddParameter(Param: TParameterNode);
    procedure SetBody(Body: TBlockNode);
    
    property ReturnType: TVariableType read FReturnType;
    property Name: string read FName;
    property Parameters: TList read FParameters;
    property Body: TBlockNode read FBody;
  end;

  {
    TProgramNode - Root node of the AST
  }
  TProgramNode = class(TASTNode)
  private
    FGlobalVariables: TList;
    FFunctions: TList;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure AddGlobalVariable(VarDecl: TVariableDeclNode);
    procedure AddFunction(Func: TFunctionNode);
    
    property GlobalVariables: TList read FGlobalVariables;
    property Functions: TList read FFunctions;
  end;

  {
    TAstVisitor - Base class for AST visitors
  }
  TASTVisitor = class
  public
    procedure VisitProgram(Node: TProgramNode); virtual; abstract;
    procedure VisitVariableDecl(Node: TVariableDeclNode); virtual; abstract;
    procedure VisitFunction(Node: TFunctionNode); virtual; abstract;
    procedure VisitParameter(Node: TParameterNode); virtual; abstract;
    procedure VisitBlock(Node: TBlockNode); virtual; abstract;
    procedure VisitIfStatement(Node: TIfStatementNode); virtual; abstract;
    procedure VisitSwitchStatement(Node: TSwitchStatementNode); virtual; abstract;
    procedure VisitCaseLabel(Node: TCaseLabelNode); virtual; abstract;
    procedure VisitSetVarStatement(Node: TSetVarStatementNode); virtual; abstract;
    procedure VisitRandomChance(Node: TRandomChanceNode); virtual; abstract;
    procedure VisitExpressionStatement(Node: TExpressionStatementNode); virtual; abstract;
    procedure VisitBinaryOp(Node: TBinaryOpNode); virtual; abstract;
    procedure VisitUnaryOp(Node: TUnaryOpNode); virtual; abstract;
    procedure VisitIdentifier(Node: TIdentifierNode); virtual; abstract;
    procedure VisitLiteral(Node: TLiteralNode); virtual; abstract;
    procedure VisitFunctionCall(Node: TFunctionCallNode); virtual; abstract;
    procedure VisitCondition(Node: TConditionNode); virtual; abstract;
  end;

  // Helper functions
  function BinaryOperatorToStr(Operator: TBinaryOperator): string;
  function UnaryOperatorToStr(Operator: TUnaryOperator): string;
  function ConditionOperatorToStr(Operator: TConditionOperator): string;
  function VariableTypeToStr(VarType: TVariableType): string;

implementation

{ TASTNode }

constructor TASTNode.Create(NodeType: TASTNodeType; Line, Column: Integer);
begin
  inherited Create;
  FNodeType := NodeType;
  FLine := Line;
  FColumn := Column;
end;

destructor TASTNode.Destroy;
begin
  inherited;
end;

{ TExpressionNode }

constructor TExpressionNode.Create(NodeType: TASTNodeType; Line, Column: Integer);
begin
  inherited Create(NodeType, Line, Column);
end;

{ TStatementNode }

constructor TStatementNode.Create(NodeType: TASTNodeType; Line, Column: Integer);
begin
  inherited Create(NodeType, Line, Column);
end;

{ TLiteralNode }

constructor TLiteralNode.Create(Value: Variant; LiteralType: TVariableType; 
  Line, Column: Integer);
begin
  inherited Create(ntLiteral, Line, Column);
  FValue := Value;
  FLiteralType := LiteralType;
end;

{ TIdentifierNode }

constructor TIdentifierNode.Create(const Name: string; Line, Column: Integer);
begin
  inherited Create(ntIdentifier, Line, Column);
  FName := Name;
end;

{ TBinaryOpNode }

constructor TBinaryOpNode.Create(Operator: TBinaryOperator; 
  Left, Right: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntBinaryOp, Line, Column);
  FOperator := Operator;
  FLeft := Left;
  FRight := Right;
end;

destructor TBinaryOpNode.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited;
end;

{ TUnaryOpNode }

constructor TUnaryOpNode.Create(Operator: TUnaryOperator; 
  Operand: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntUnaryOp, Line, Column);
  FOperator := Operator;
  FOperand := Operand;
end;

destructor TUnaryOpNode.Destroy;
begin
  FOperand.Free;
  inherited;
end;

{ TFunctionCallNode }

constructor TFunctionCallNode.Create(const FunctionName: string; 
  Line, Column: Integer);
begin
  inherited Create(ntFunctionCall, Line, Column);
  FFunctionName := FunctionName;
  FArguments := TList.Create;
end;

destructor TFunctionCallNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FArguments.Count - 1 do
    TObject(FArguments[I]).Free;
  FArguments.Free;
  inherited;
end;

procedure TFunctionCallNode.AddArgument(Arg: TExpressionNode);
begin
  FArguments.Add(Arg);
end;

{ TConditionNode }

constructor TConditionNode.Create(const Variable: string; 
  Operator: TConditionOperator; Value: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntCondition, Line, Column);
  FVariable := Variable;
  FOperator := Operator;
  FValue := Value;
  FConnector := nil;
  FIsAnd := False;
end;

destructor TConditionNode.Destroy;
begin
  FValue.Free;
  FConnector.Free;
  inherited;
end;

procedure TConditionNode.SetConnector(IsAnd: Boolean; Connector: TConditionNode);
begin
  FIsAnd := IsAnd;
  FConnector := Connector;
end;

{ TSetVarStatementNode }

constructor TSetVarStatementNode.Create(const VariableName: string; 
  Value: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntSetVarStatement, Line, Column);
  FVariableName := VariableName;
  FValue := Value;
end;

destructor TSetVarStatementNode.Destroy;
begin
  FValue.Free;
  inherited;
end;

{ TRandomChanceNode }

constructor TRandomChanceNode.Create(Probability: Integer; 
  const TargetNode: string; Line, Column: Integer);
begin
  inherited Create(ntRandomChance, Line, Column);
  FProbability := Probability;
  FTargetNode := TargetNode;
end;

{ TCaseLabelNode }

constructor TCaseLabelNode.Create(const LabelValue: string; 
  Line, Column: Integer);
begin
  inherited Create(ntCaseLabel, Line, Column);
  FLabelValue := LabelValue;
  FStatements := TList.Create;
end;

destructor TCaseLabelNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FStatements.Count - 1 do
    TObject(FStatements[I]).Free;
  FStatements.Free;
  inherited;
end;

procedure TCaseLabelNode.AddStatement(Stmt: TStatementNode);
begin
  FStatements.Add(Stmt);
end;

{ TSwitchStatementNode }

constructor TSwitchStatementNode.Create(const Variable: string; 
  Line, Column: Integer);
begin
  inherited Create(ntSwitchStatement, Line, Column);
  FVariable := Variable;
  FCases := TList.Create;
end;

destructor TSwitchStatementNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FCases.Count - 1 do
    TObject(FCases[I]).Free;
  FCases.Free;
  inherited;
end;

procedure TSwitchStatementNode.AddCase(ACase: TCaseLabelNode);
begin
  FCases.Add(ACase);
end;

{ TIfStatementNode }

constructor TIfStatementNode.Create(Condition: TConditionNode; 
  Line, Column: Integer);
begin
  inherited Create(ntIfStatement, Line, Column);
  FCondition := Condition;
  FThenBranch := TList.Create;
  FElseBranch := TList.Create;
  FElseIfs := TList.Create;
end;

destructor TIfStatementNode.Destroy;
var
  I: Integer;
begin
  FCondition.Free;
  for I := 0 to FThenBranch.Count - 1 do
    TObject(FThenBranch[I]).Free;
  FThenBranch.Free;
  for I := 0 to FElseBranch.Count - 1 do
    TObject(FElseBranch[I]).Free;
  FElseBranch.Free;
  FElseIfs.Free;
  inherited;
end;

procedure TIfStatementNode.AddThenStatement(Stmt: TStatementNode);
begin
  FThenBranch.Add(Stmt);
end;

procedure TIfStatementNode.AddElseStatement(Stmt: TStatementNode);
begin
  FElseBranch.Add(Stmt);
end;

procedure TIfStatementNode.AddElseIf(Condition: TConditionNode);
begin
  FElseIfs.Add(Condition);
end;

{ TExpressionStatementNode }

constructor TExpressionStatementNode.Create(Expression: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntExpressionStatement, Line, Column);
  FExpression := Expression;
end;

destructor TExpressionStatementNode.Destroy;
begin
  FExpression.Free;
  inherited;
end;

{ TBlockNode }

constructor TBlockNode.Create(Line, Column: Integer);
begin
  inherited Create(ntBlock, Line, Column);
  FStatements := TList.Create;
end;

destructor TBlockNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FStatements.Count - 1 do
    TObject(FStatements[I]).Free;
  FStatements.Free;
  inherited;
end;

procedure TBlockNode.AddStatement(Stmt: TStatementNode);
begin
  FStatements.Add(Stmt);
end;

{ TParameterNode }

constructor TParameterNode.Create(ParamType: TVariableType; 
  const Name: string; Line, Column: Integer);
begin
  inherited Create(ntParameter, Line, Column);
  FParamType := ParamType;
  FName := Name;
end;

{ TVariableDeclNode }

constructor TVariableDeclNode.Create(VarType: TVariableType; 
  const Name: string; Initializer: TExpressionNode; Line, Column: Integer);
begin
  inherited Create(ntVariableDecl, Line, Column);
  FVarType := VarType;
  FName := Name;
  FInitializer := Initializer;
end;

destructor TVariableDeclNode.Destroy;
begin
  FInitializer.Free;
  inherited;
end;

{ TFunctionNode }

constructor TFunctionNode.Create(ReturnType: TVariableType; 
  const Name: string; Line, Column: Integer);
begin
  inherited Create(ntFunction, Line, Column);
  FReturnType := ReturnType;
  FName := Name;
  FParameters := TList.Create;
  FBody := nil;
end;

destructor TFunctionNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FParameters.Count - 1 do
    TObject(FParameters[I]).Free;
  FParameters.Free;
  FBody.Free;
  inherited;
end;

procedure TFunctionNode.AddParameter(Param: TParameterNode);
begin
  FParameters.Add(Param);
end;

procedure TFunctionNode.SetBody(Body: TBlockNode);
begin
  FBody := Body;
end;

{ TProgramNode }

constructor TProgramNode.Create;
begin
  inherited Create(ntProgram, 1, 1);
  FGlobalVariables := TList.Create;
  FFunctions := TList.Create;
end;

destructor TProgramNode.Destroy;
var
  I: Integer;
begin
  for I := 0 to FGlobalVariables.Count - 1 do
    TObject(FGlobalVariables[I]).Free;
  FGlobalVariables.Free;
  for I := 0 to FFunctions.Count - 1 do
    TObject(FFunctions[I]).Free;
  FFunctions.Free;
  inherited;
end;

procedure TProgramNode.AddGlobalVariable(VarDecl: TVariableDeclNode);
begin
  FGlobalVariables.Add(VarDecl);
end;

procedure TProgramNode.AddFunction(Func: TFunctionNode);
begin
  FFunctions.Add(Func);
end;

{ Helper functions }

function BinaryOperatorToStr(Operator: TBinaryOperator): string;
begin
  case Operator of
    opAdd: Result := '+';
    opSubtract: Result := '-';
    opMultiply: Result := '*';
    opDivide: Result := '/';
    opEqual: Result := '==';
    opNotEqual: Result := '!=';
    opGreater: Result := '>';
    opGreaterEqual: Result := '>=';
    opLess: Result := '<';
    opLessEqual: Result := '<=';
    opAnd: Result := '&&';
    opOr: Result := '||';
  else
    Result := '?';
  end;
end;

function UnaryOperatorToStr(Operator: TUnaryOperator): string;
begin
  case Operator of
    opMinus: Result := '-';
    opNot: Result := '!';
  else
    Result := '?';
  end;
end;

function ConditionOperatorToStr(Operator: TConditionOperator): string;
begin
  case Operator of
    coEquals: Result := '==';
    coNotEquals: Result := '!=';
    coGreater: Result := '>';
    coGreaterEqual: Result := '>=';
    coLess: Result := '<';
    coLessEqual: Result := '<=';
  else
    Result := '?';
  end;
end;

function VariableTypeToStr(VarType: TVariableType): string;
begin
  case VarType of
    vtInt: Result := 'INT';
    vtString: Result := 'STR';
    vtVoid: Result := 'VOID';
  else
    Result := '?';
  end;
end;

end.
