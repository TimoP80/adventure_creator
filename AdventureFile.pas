
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 10.12.2019 20:36:14                                  }
{       Generated from: C:\CodeProjects\AdventureCreator\AdventureFIle.xml   }
{   Settings stored in: C:\CodeProjects\AdventureCreator\AdventureFIle.xdb   }
{                                                                            }
{****************************************************************************}

unit AdventureFIle;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLAdventureGameType = interface;
  IXMLMetaInfoType = interface;
  IXMLVariablesType = interface;
  IXMLVariableType = interface;
  IXMLGameNodesType = interface;
  IXMLNodeType = interface;
  IXMLChoicesType = interface;
  IXMLChoiceType = interface;
  IXMLChoiceCommandsType = interface;
  IXMLCommandListType = interface;
  IXMLCMDType = interface;
  IXMLChoiceConditionsType = interface;
  IXMLConditionListType = interface;
  IXMLConditionType = interface;
  IXMLConditionTypeList = interface;
  IXMLNodeCommandsType = interface;
  IXMLCommandListType2 = interface;
  IXMLNodeCommandsType2 = interface;
  IXMLChoicesType2 = interface;

{ IXMLAdventureGameType }

  IXMLAdventureGameType = interface(IXMLNode)
    ['{5D74B49C-FAAD-4390-800F-BD0544D4DA42}']
    { Property Accessors }
    function Get_MetaInfo: IXMLMetaInfoType;
    function Get_Variables: IXMLVariablesType;
    function Get_GameNodes: IXMLGameNodesType;
    { Methods & Properties }
    property MetaInfo: IXMLMetaInfoType read Get_MetaInfo;
    property Variables: IXMLVariablesType read Get_Variables;
    property GameNodes: IXMLGameNodesType read Get_GameNodes;
  end;

{ IXMLMetaInfoType }

  IXMLMetaInfoType = interface(IXMLNode)
    ['{C49BC07A-9078-48C5-B68A-01D0B46230E6}']
    { Property Accessors }
    function Get_Title: UnicodeString;
    function Get_Author: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Author(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Title: UnicodeString read Get_Title write Set_Title;
    property Author: UnicodeString read Get_Author write Set_Author;
    property Description: UnicodeString read Get_Description write Set_Description;
  end;

{ IXMLVariablesType }

  IXMLVariablesType = interface(IXMLNodeCollection)
    ['{2D6C5771-DDE3-45C4-852E-53D77182AA25}']
    { Property Accessors }
    function Get_Variable(Index: Integer): IXMLVariableType;
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    property Variable[Index: Integer]: IXMLVariableType read Get_Variable; default;
  end;

{ IXMLVariableType }

  IXMLVariableType = interface(IXMLNode)
    ['{55521F90-775D-4B92-825B-DA6FFB822C7E}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLGameNodesType }

  IXMLGameNodesType = interface(IXMLNodeCollection)
    ['{B7AFD2BA-4387-4733-A3E3-8AB047D2821F}']
    { Property Accessors }
    function Get_Node(Index: Integer): IXMLNodeType;
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    property Node[Index: Integer]: IXMLNodeType read Get_Node; default;
  end;

{ IXMLNodeType }

  IXMLNodeType = interface(IXMLNode)
    ['{9E57DDBA-0A4F-4442-AC89-D02891B898AA}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_DescriptionText: UnicodeString;
    function Get_Choices: IXMLChoicesType;
    function Get_ChoiceCommands: IXMLChoiceCommandsType;
    function Get_ChoiceConditions: IXMLChoiceConditionsType;
    function Get_NodeCommands: IXMLNodeCommandsType;
    function Get_NodeParent: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_DescriptionText(Value: UnicodeString);
    procedure Set_NodeParent(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property DescriptionText: UnicodeString read Get_DescriptionText write Set_DescriptionText;
    property Choices: IXMLChoicesType read Get_Choices;
    property ChoiceCommands: IXMLChoiceCommandsType read Get_ChoiceCommands;
    property ChoiceConditions: IXMLChoiceConditionsType read Get_ChoiceConditions;
    property NodeCommands: IXMLNodeCommandsType read Get_NodeCommands;
    property NodeParent: UnicodeString read Get_NodeParent write Set_NodeParent;
  end;

{ IXMLChoicesType }

  IXMLChoicesType = interface(IXMLNodeCollection)
    ['{6B75B55D-97D0-4499-982A-EC0BF4CD775B}']
    { Property Accessors }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    { Methods & Properties }
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
    property Choice[Index: Integer]: IXMLChoiceType read Get_Choice; default;
  end;

{ IXMLChoiceType }

  IXMLChoiceType = interface(IXMLNode)
    ['{3AD02461-0E92-44AB-A96A-0AB1822BF8DF}']
    { Property Accessors }
    function Get_Endgame: Boolean;
    function Get_Targetnode: UnicodeString;
    function Get_Addscore: Integer;
    function Get_Wingame: Boolean;
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: UnicodeString);
    procedure Set_Addscore(Value: Integer);
    procedure Set_Wingame(Value: Boolean);
    { Methods & Properties }
    property Endgame: Boolean read Get_Endgame write Set_Endgame;
    property Targetnode: UnicodeString read Get_Targetnode write Set_Targetnode;
    property Addscore: Integer read Get_Addscore write Set_Addscore;
    property Wingame: Boolean read Get_Wingame write Set_Wingame;
  end;

{ IXMLChoiceCommandsType }

  IXMLChoiceCommandsType = interface(IXMLNodeCollection)
    ['{79C36040-5D8E-4D0C-81B0-E169C18627E2}']
    { Property Accessors }
    function Get_CommandList(Index: Integer): IXMLCommandListType;
    { Methods & Properties }
    function Add: IXMLCommandListType;
    function Insert(const Index: Integer): IXMLCommandListType;
    property CommandList[Index: Integer]: IXMLCommandListType read Get_CommandList; default;
  end;

{ IXMLCommandListType }

  IXMLCommandListType = interface(IXMLNodeCollection)
    ['{7908D697-E6BD-4489-B42B-F0FE47F72FD3}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCMDType }

  IXMLCMDType = interface(IXMLNode)
    ['{C1FAE828-21A1-4CAF-9C2E-CF5E9E7F9D6F}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Variable: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Variable(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Variable: UnicodeString read Get_Variable write Set_Variable;
  end;

{ IXMLChoiceConditionsType }

  IXMLChoiceConditionsType = interface(IXMLNodeCollection)
    ['{72A7A7BC-9288-434D-A8B6-FEAE68651A27}']
    { Property Accessors }
    function Get_ConditionList(Index: Integer): IXMLConditionListType;
    { Methods & Properties }
    function Add: IXMLConditionListType;
    function Insert(const Index: Integer): IXMLConditionListType;
    property ConditionList[Index: Integer]: IXMLConditionListType read Get_ConditionList; default;
  end;

{ IXMLConditionListType }

  IXMLConditionListType = interface(IXMLNodeCollection)
    ['{264F26AF-968F-42CA-A5C0-4DE9F92FD0B4}']
    { Property Accessors }
    function Get_Condition(Index: Integer): IXMLConditionType;
    { Methods & Properties }
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;
    property Condition[Index: Integer]: IXMLConditionType read Get_Condition; default;
  end;

{ IXMLConditionType }

  IXMLConditionType = interface(IXMLNode)
    ['{ED63C469-DEF7-4E52-8433-D41F5F529DF7}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Varname: UnicodeString;
    function Get_Eval: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Varname(Value: UnicodeString);
    procedure Set_Eval(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Varname: UnicodeString read Get_Varname write Set_Varname;
    property Eval: UnicodeString read Get_Eval write Set_Eval;
  end;

{ IXMLConditionTypeList }

  IXMLConditionTypeList = interface(IXMLNodeCollection)
    ['{DA4A6A04-53E5-4A4B-9F9A-E2D25A9A6CDC}']
    { Methods & Properties }
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;

    function Get_Item(Index: Integer): IXMLConditionType;
    property Items[Index: Integer]: IXMLConditionType read Get_Item; default;
  end;

{ IXMLNodeCommandsType }

  IXMLNodeCommandsType = interface(IXMLNodeCollection)
    ['{3AAC5D50-4C20-44AC-886D-D7C8B88D8B3C}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCommandListType2 }

  IXMLCommandListType2 = interface(IXMLNode)
    ['{0D899FB0-48E0-493E-A910-98DD2867194D}']
  end;

{ IXMLNodeCommandsType2 }

  IXMLNodeCommandsType2 = interface(IXMLNode)
    ['{351727AA-6058-49B1-9B8F-0C96EF84FA10}']
  end;

{ IXMLChoicesType2 }

  IXMLChoicesType2 = interface(IXMLNode)
    ['{394A20B2-341D-4F33-8F46-2754A78788AC}']
  end;

{ Forward Decls }

  TXMLAdventureGameType = class;
  TXMLMetaInfoType = class;
  TXMLVariablesType = class;
  TXMLVariableType = class;
  TXMLGameNodesType = class;
  TXMLNodeType = class;
  TXMLChoicesType = class;
  TXMLChoiceType = class;
  TXMLChoiceCommandsType = class;
  TXMLCommandListType = class;
  TXMLCMDType = class;
  TXMLChoiceConditionsType = class;
  TXMLConditionListType = class;
  TXMLConditionType = class;
  TXMLConditionTypeList = class;
  TXMLNodeCommandsType = class;
  TXMLCommandListType2 = class;
  TXMLNodeCommandsType2 = class;
  TXMLChoicesType2 = class;

{ TXMLAdventureGameType }

  TXMLAdventureGameType = class(TXMLNode, IXMLAdventureGameType)
  protected
    { IXMLAdventureGameType }
    function Get_MetaInfo: IXMLMetaInfoType;
    function Get_Variables: IXMLVariablesType;
    function Get_GameNodes: IXMLGameNodesType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMetaInfoType }

  TXMLMetaInfoType = class(TXMLNode, IXMLMetaInfoType)
  protected
    { IXMLMetaInfoType }
    function Get_Title: UnicodeString;
    function Get_Author: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Author(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
  end;

{ TXMLVariablesType }

  TXMLVariablesType = class(TXMLNodeCollection, IXMLVariablesType)
  protected
    { IXMLVariablesType }
    function Get_Variable(Index: Integer): IXMLVariableType;
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVariableType }

  TXMLVariableType = class(TXMLNode, IXMLVariableType)
  protected
    { IXMLVariableType }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
  end;

{ TXMLGameNodesType }

  TXMLGameNodesType = class(TXMLNodeCollection, IXMLGameNodesType)
  protected
    { IXMLGameNodesType }
    function Get_Node(Index: Integer): IXMLNodeType;
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNodeType }

  TXMLNodeType = class(TXMLNode, IXMLNodeType)
  protected
    { IXMLNodeType }
    function Get_Name: UnicodeString;
    function Get_DescriptionText: UnicodeString;
    function Get_Choices: IXMLChoicesType;
    function Get_ChoiceCommands: IXMLChoiceCommandsType;
    function Get_ChoiceConditions: IXMLChoiceConditionsType;
    function Get_NodeCommands: IXMLNodeCommandsType;
    function Get_NodeParent: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_DescriptionText(Value: UnicodeString);
    procedure Set_NodeParent(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLChoicesType }

  TXMLChoicesType = class(TXMLNodeCollection, IXMLChoicesType)
  protected
    { IXMLChoicesType }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLChoiceType }

  TXMLChoiceType = class(TXMLNode, IXMLChoiceType)
  protected
    { IXMLChoiceType }
    function Get_Endgame: Boolean;
    function Get_Targetnode: UnicodeString;
    function Get_Addscore: Integer;
    function Get_Wingame: Boolean;
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: UnicodeString);
    procedure Set_Addscore(Value: Integer);
    procedure Set_Wingame(Value: Boolean);
  end;

{ TXMLChoiceCommandsType }

  TXMLChoiceCommandsType = class(TXMLNodeCollection, IXMLChoiceCommandsType)
  protected
    { IXMLChoiceCommandsType }
    function Get_CommandList(Index: Integer): IXMLCommandListType;
    function Add: IXMLCommandListType;
    function Insert(const Index: Integer): IXMLCommandListType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCommandListType }

  TXMLCommandListType = class(TXMLNodeCollection, IXMLCommandListType)
  protected
    { IXMLCommandListType }
    function Get_CMD(Index: Integer): IXMLCMDType;
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCMDType }

  TXMLCMDType = class(TXMLNode, IXMLCMDType)
  protected
    { IXMLCMDType }
    function Get_Name: UnicodeString;
    function Get_Variable: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Variable(Value: UnicodeString);
  end;

{ TXMLChoiceConditionsType }

  TXMLChoiceConditionsType = class(TXMLNodeCollection, IXMLChoiceConditionsType)
  protected
    { IXMLChoiceConditionsType }
    function Get_ConditionList(Index: Integer): IXMLConditionListType;
    function Add: IXMLConditionListType;
    function Insert(const Index: Integer): IXMLConditionListType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConditionListType }

  TXMLConditionListType = class(TXMLNodeCollection, IXMLConditionListType)
  protected
    { IXMLConditionListType }
    function Get_Condition(Index: Integer): IXMLConditionType;
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConditionType }

  TXMLConditionType = class(TXMLNode, IXMLConditionType)
  protected
    { IXMLConditionType }
    function Get_Name: UnicodeString;
    function Get_Varname: UnicodeString;
    function Get_Eval: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Varname(Value: UnicodeString);
    procedure Set_Eval(Value: UnicodeString);
  end;

{ TXMLConditionTypeList }

  TXMLConditionTypeList = class(TXMLNodeCollection, IXMLConditionTypeList)
  protected
    { IXMLConditionTypeList }
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;

    function Get_Item(Index: Integer): IXMLConditionType;
  end;

{ TXMLNodeCommandsType }

  TXMLNodeCommandsType = class(TXMLNodeCollection, IXMLNodeCommandsType)
  protected
    { IXMLNodeCommandsType }
    function Get_CMD(Index: Integer): IXMLCMDType;
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCommandListType2 }

  TXMLCommandListType2 = class(TXMLNode, IXMLCommandListType2)
  protected
    { IXMLCommandListType2 }
  end;

{ TXMLNodeCommandsType2 }

  TXMLNodeCommandsType2 = class(TXMLNode, IXMLNodeCommandsType2)
  protected
    { IXMLNodeCommandsType2 }
  end;

{ TXMLChoicesType2 }

  TXMLChoicesType2 = class(TXMLNode, IXMLChoicesType2)
  protected
    { IXMLChoicesType2 }
  end;

{ Global Functions }

function GetAdventureGame(Doc: IXMLDocument): IXMLAdventureGameType;
function LoadAdventureGame(const FileName: string): IXMLAdventureGameType;
function NewAdventureGame: IXMLAdventureGameType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetAdventureGame(Doc: IXMLDocument): IXMLAdventureGameType;
begin
  Result := Doc.GetDocBinding('AdventureGame', TXMLAdventureGameType, TargetNamespace) as IXMLAdventureGameType;
end;

function LoadAdventureGame(const FileName: string): IXMLAdventureGameType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('AdventureGame', TXMLAdventureGameType, TargetNamespace) as IXMLAdventureGameType;
end;

function NewAdventureGame: IXMLAdventureGameType;
begin
  Result := NewXMLDocument.GetDocBinding('AdventureGame', TXMLAdventureGameType, TargetNamespace) as IXMLAdventureGameType;
end;

{ TXMLAdventureGameType }

procedure TXMLAdventureGameType.AfterConstruction;
begin
  RegisterChildNode('MetaInfo', TXMLMetaInfoType);
  RegisterChildNode('Variables', TXMLVariablesType);
  RegisterChildNode('GameNodes', TXMLGameNodesType);
  inherited;
end;

function TXMLAdventureGameType.Get_MetaInfo: IXMLMetaInfoType;
begin
  Result := ChildNodes['MetaInfo'] as IXMLMetaInfoType;
end;

function TXMLAdventureGameType.Get_Variables: IXMLVariablesType;
begin
  Result := ChildNodes['Variables'] as IXMLVariablesType;
end;

function TXMLAdventureGameType.Get_GameNodes: IXMLGameNodesType;
begin
  Result := ChildNodes['GameNodes'] as IXMLGameNodesType;
end;

{ TXMLMetaInfoType }

function TXMLMetaInfoType.Get_Title: UnicodeString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLMetaInfoType.Set_Title(Value: UnicodeString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLMetaInfoType.Get_Author: UnicodeString;
begin
  Result := ChildNodes['Author'].Text;
end;

procedure TXMLMetaInfoType.Set_Author(Value: UnicodeString);
begin
  ChildNodes['Author'].NodeValue := Value;
end;

function TXMLMetaInfoType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLMetaInfoType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

{ TXMLVariablesType }

procedure TXMLVariablesType.AfterConstruction;
begin
  RegisterChildNode('Variable', TXMLVariableType);
  ItemTag := 'Variable';
  ItemInterface := IXMLVariableType;
  inherited;
end;

function TXMLVariablesType.Get_Variable(Index: Integer): IXMLVariableType;
begin
  Result := List[Index] as IXMLVariableType;
end;

function TXMLVariablesType.Add: IXMLVariableType;
begin
  Result := AddItem(-1) as IXMLVariableType;
end;

function TXMLVariablesType.Insert(const Index: Integer): IXMLVariableType;
begin
  Result := AddItem(Index) as IXMLVariableType;
end;

{ TXMLVariableType }

function TXMLVariableType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLVariableType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

{ TXMLGameNodesType }

procedure TXMLGameNodesType.AfterConstruction;
begin
  RegisterChildNode('Node', TXMLNodeType);
  ItemTag := 'Node';
  ItemInterface := IXMLNodeType;
  inherited;
end;

function TXMLGameNodesType.Get_Node(Index: Integer): IXMLNodeType;
begin
  Result := List[Index] as IXMLNodeType;
end;

function TXMLGameNodesType.Add: IXMLNodeType;
begin
  Result := AddItem(-1) as IXMLNodeType;
end;

function TXMLGameNodesType.Insert(const Index: Integer): IXMLNodeType;
begin
  Result := AddItem(Index) as IXMLNodeType;
end;

{ TXMLNodeType }

procedure TXMLNodeType.AfterConstruction;
begin
  RegisterChildNode('Choices', TXMLChoicesType);
  RegisterChildNode('ChoiceCommands', TXMLChoiceCommandsType);
  RegisterChildNode('ChoiceConditions', TXMLChoiceConditionsType);
  RegisterChildNode('NodeCommands', TXMLNodeCommandsType);
  inherited;
end;

function TXMLNodeType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLNodeType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLNodeType.Get_DescriptionText: UnicodeString;
begin
  Result := ChildNodes['DescriptionText'].Text;
end;

procedure TXMLNodeType.Set_DescriptionText(Value: UnicodeString);
begin
  ChildNodes['DescriptionText'].NodeValue := Value;
end;

function TXMLNodeType.Get_Choices: IXMLChoicesType;
begin
  Result := ChildNodes['Choices'] as IXMLChoicesType;
end;

function TXMLNodeType.Get_ChoiceCommands: IXMLChoiceCommandsType;
begin
  Result := ChildNodes['ChoiceCommands'] as IXMLChoiceCommandsType;
end;

function TXMLNodeType.Get_ChoiceConditions: IXMLChoiceConditionsType;
begin
  Result := ChildNodes['ChoiceConditions'] as IXMLChoiceConditionsType;
end;

function TXMLNodeType.Get_NodeCommands: IXMLNodeCommandsType;
begin
  Result := ChildNodes['NodeCommands'] as IXMLNodeCommandsType;
end;

function TXMLNodeType.Get_NodeParent: UnicodeString;
begin
  Result := ChildNodes['NodeParent'].Text;
end;

procedure TXMLNodeType.Set_NodeParent(Value: UnicodeString);
begin
  ChildNodes['NodeParent'].NodeValue := Value;
end;

{ TXMLChoicesType }

procedure TXMLChoicesType.AfterConstruction;
begin
  RegisterChildNode('Choice', TXMLChoiceType);
  ItemTag := 'Choice';
  ItemInterface := IXMLChoiceType;
  inherited;
end;

function TXMLChoicesType.Get_Choice(Index: Integer): IXMLChoiceType;
begin
  Result := List[Index] as IXMLChoiceType;
end;

function TXMLChoicesType.Add: IXMLChoiceType;
begin
  Result := AddItem(-1) as IXMLChoiceType;
end;

function TXMLChoicesType.Insert(const Index: Integer): IXMLChoiceType;
begin
  Result := AddItem(Index) as IXMLChoiceType;
end;

{ TXMLChoiceType }

function TXMLChoiceType.Get_Endgame: Boolean;
begin
  Result := AttributeNodes['endgame'].NodeValue;
end;

procedure TXMLChoiceType.Set_Endgame(Value: Boolean);
begin
  SetAttribute('endgame', Value);
end;

function TXMLChoiceType.Get_Targetnode: UnicodeString;
begin
  Result := AttributeNodes['targetnode'].Text;
end;

procedure TXMLChoiceType.Set_Targetnode(Value: UnicodeString);
begin
  SetAttribute('targetnode', Value);
end;

function TXMLChoiceType.Get_Addscore: Integer;
begin
  Result := AttributeNodes['addscore'].NodeValue;
end;

procedure TXMLChoiceType.Set_Addscore(Value: Integer);
begin
  SetAttribute('addscore', Value);
end;

function TXMLChoiceType.Get_Wingame: Boolean;
begin
  Result := AttributeNodes['wingame'].NodeValue;
end;

procedure TXMLChoiceType.Set_Wingame(Value: Boolean);
begin
  SetAttribute('wingame', Value);
end;

{ TXMLChoiceCommandsType }

procedure TXMLChoiceCommandsType.AfterConstruction;
begin
  RegisterChildNode('CommandList', TXMLCommandListType);
  ItemTag := 'CommandList';
  ItemInterface := IXMLCommandListType;
  inherited;
end;

function TXMLChoiceCommandsType.Get_CommandList(Index: Integer): IXMLCommandListType;
begin
  Result := List[Index] as IXMLCommandListType;
end;

function TXMLChoiceCommandsType.Add: IXMLCommandListType;
begin
  Result := AddItem(-1) as IXMLCommandListType;
end;

function TXMLChoiceCommandsType.Insert(const Index: Integer): IXMLCommandListType;
begin
  Result := AddItem(Index) as IXMLCommandListType;
end;

{ TXMLCommandListType }

procedure TXMLCommandListType.AfterConstruction;
begin
  RegisterChildNode('CMD', TXMLCMDType);
  ItemTag := 'CMD';
  ItemInterface := IXMLCMDType;
  inherited;
end;

function TXMLCommandListType.Get_CMD(Index: Integer): IXMLCMDType;
begin
  Result := List[Index] as IXMLCMDType;
end;

function TXMLCommandListType.Add: IXMLCMDType;
begin
  Result := AddItem(-1) as IXMLCMDType;
end;

function TXMLCommandListType.Insert(const Index: Integer): IXMLCMDType;
begin
  Result := AddItem(Index) as IXMLCMDType;
end;

{ TXMLCMDType }

function TXMLCMDType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLCMDType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLCMDType.Get_Variable: UnicodeString;
begin
  Result := AttributeNodes['variable'].Text;
end;

procedure TXMLCMDType.Set_Variable(Value: UnicodeString);
begin
  SetAttribute('variable', Value);
end;

{ TXMLChoiceConditionsType }

procedure TXMLChoiceConditionsType.AfterConstruction;
begin
  RegisterChildNode('ConditionList', TXMLConditionListType);
  ItemTag := 'ConditionList';
  ItemInterface := IXMLConditionListType;
  inherited;
end;

function TXMLChoiceConditionsType.Get_ConditionList(Index: Integer): IXMLConditionListType;
begin
  Result := List[Index] as IXMLConditionListType;
end;

function TXMLChoiceConditionsType.Add: IXMLConditionListType;
begin
  Result := AddItem(-1) as IXMLConditionListType;
end;

function TXMLChoiceConditionsType.Insert(const Index: Integer): IXMLConditionListType;
begin
  Result := AddItem(Index) as IXMLConditionListType;
end;

{ TXMLConditionListType }

procedure TXMLConditionListType.AfterConstruction;
begin
  RegisterChildNode('Condition', TXMLConditionType);
  ItemTag := 'Condition';
  ItemInterface := IXMLConditionType;
  inherited;
end;

function TXMLConditionListType.Get_Condition(Index: Integer): IXMLConditionType;
begin
  Result := List[Index] as IXMLConditionType;
end;

function TXMLConditionListType.Add: IXMLConditionType;
begin
  Result := AddItem(-1) as IXMLConditionType;
end;

function TXMLConditionListType.Insert(const Index: Integer): IXMLConditionType;
begin
  Result := AddItem(Index) as IXMLConditionType;
end;

{ TXMLConditionType }

function TXMLConditionType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['Name'].Text;
end;

procedure TXMLConditionType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('Name', Value);
end;

function TXMLConditionType.Get_Varname: UnicodeString;
begin
  Result := AttributeNodes['varname'].Text;
end;

procedure TXMLConditionType.Set_Varname(Value: UnicodeString);
begin
  SetAttribute('varname', Value);
end;

function TXMLConditionType.Get_Eval: UnicodeString;
begin
  Result := AttributeNodes['eval'].Text;
end;

procedure TXMLConditionType.Set_Eval(Value: UnicodeString);
begin
  SetAttribute('eval', Value);
end;

{ TXMLConditionTypeList }

function TXMLConditionTypeList.Add: IXMLConditionType;
begin
  Result := AddItem(-1) as IXMLConditionType;
end;

function TXMLConditionTypeList.Insert(const Index: Integer): IXMLConditionType;
begin
  Result := AddItem(Index) as IXMLConditionType;
end;

function TXMLConditionTypeList.Get_Item(Index: Integer): IXMLConditionType;
begin
  Result := List[Index] as IXMLConditionType;
end;

{ TXMLNodeCommandsType }

procedure TXMLNodeCommandsType.AfterConstruction;
begin
  RegisterChildNode('CMD', TXMLCMDType);
  ItemTag := 'CMD';
  ItemInterface := IXMLCMDType;
  inherited;
end;

function TXMLNodeCommandsType.Get_CMD(Index: Integer): IXMLCMDType;
begin
  Result := List[Index] as IXMLCMDType;
end;

function TXMLNodeCommandsType.Add: IXMLCMDType;
begin
  Result := AddItem(-1) as IXMLCMDType;
end;

function TXMLNodeCommandsType.Insert(const Index: Integer): IXMLCMDType;
begin
  Result := AddItem(Index) as IXMLCMDType;
end;

{ TXMLCommandListType2 }

{ TXMLNodeCommandsType2 }

{ TXMLChoicesType2 }

end.