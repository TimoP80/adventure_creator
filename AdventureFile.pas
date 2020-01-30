
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 30.1.2020 12.17.57                                   }
{       Generated from: C:\CodeProjects\AdventureCreator\AdventureFIle.xml   }
{   Settings stored in: C:\CodeProjects\AdventureCreator\AdventureFIle.xdb   }
{                                                                            }
{****************************************************************************}

unit AdventureFIle;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLAdventureGameType = interface;
  IXMLMetaInfoType = interface;
  IXMLScriptsType = interface;
  IXMLScriptType = interface;
  IXMLScriptTypeList = interface;
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
  IXMLConditionListTypeList = interface;
  IXMLConditionType = interface;
  IXMLConditionTypeList = interface;
  IXMLNodeCommandsType = interface;
  IXMLCommandListType2 = interface;
  IXMLNodeCommandsType2 = interface;
  IXMLChoicesType2 = interface;

{ IXMLAdventureGameType }

  IXMLAdventureGameType = interface(IXMLNode)
    ['{6F3F3EB4-D6E6-4CC6-B0C4-83C764669821}']
    { Property Accessors }
    function Get_MetaInfo: IXMLMetaInfoType;
    function Get_Scripts: IXMLScriptsType;
    function Get_Variables: IXMLVariablesType;
    function Get_GameNodes: IXMLGameNodesType;
    { Methods & Properties }
    property MetaInfo: IXMLMetaInfoType read Get_MetaInfo;
    property Scripts: IXMLScriptsType read Get_Scripts;
    property Variables: IXMLVariablesType read Get_Variables;
    property GameNodes: IXMLGameNodesType read Get_GameNodes;
  end;

{ IXMLMetaInfoType }

  IXMLMetaInfoType = interface(IXMLNode)
    ['{0631964F-7D02-4059-A43D-BDDC36A030AD}']
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

{ IXMLScriptsType }

  IXMLScriptsType = interface(IXMLNodeCollection)
    ['{C7F2196E-0578-49D1-A607-68945AB595C9}']
    { Property Accessors }
    function Get_Script(Index: Integer): IXMLScriptType;
    { Methods & Properties }
    function Add: IXMLScriptType;
    function Insert(const Index: Integer): IXMLScriptType;
    property Script[Index: Integer]: IXMLScriptType read Get_Script; default;
  end;

{ IXMLScriptType }

  IXMLScriptType = interface(IXMLNode)
    ['{BF404000-AF83-4C5D-82F9-A1CE59CEC2B3}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Filename: UnicodeString;
    function Get_Author: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Filename(Value: UnicodeString);
    procedure Set_Author(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Filename: UnicodeString read Get_Filename write Set_Filename;
    property Author: UnicodeString read Get_Author write Set_Author;
  end;

{ IXMLScriptTypeList }

  IXMLScriptTypeList = interface(IXMLNodeCollection)
    ['{9A452C73-CB1A-429A-9F9F-66183982D4BA}']
    { Methods & Properties }
    function Add: IXMLScriptType;
    function Insert(const Index: Integer): IXMLScriptType;

    function Get_Item(Index: Integer): IXMLScriptType;
    property Items[Index: Integer]: IXMLScriptType read Get_Item; default;
  end;

{ IXMLVariablesType }

  IXMLVariablesType = interface(IXMLNodeCollection)
    ['{4018C42D-C5D4-45F1-823F-1265BDABEE9E}']
    { Property Accessors }
    function Get_Variable(Index: Integer): IXMLVariableType;
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    property Variable[Index: Integer]: IXMLVariableType read Get_Variable; default;
  end;

{ IXMLVariableType }

  IXMLVariableType = interface(IXMLNode)
    ['{E5E87014-FADE-4310-80AF-7CED2442AC7F}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLGameNodesType }

  IXMLGameNodesType = interface(IXMLNodeCollection)
    ['{C6757B17-80A4-4E28-9A8C-8B2D3FDBF0AB}']
    { Property Accessors }
    function Get_Node(Index: Integer): IXMLNodeType;
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    property Node[Index: Integer]: IXMLNodeType read Get_Node; default;
  end;

{ IXMLNodeType }

  IXMLNodeType = interface(IXMLNode)
    ['{A68A90A2-1C4E-45F2-89F0-49885058E9C2}']
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
    ['{FFF400C8-CA43-437F-95FB-A2BEC026983C}']
    { Property Accessors }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    { Methods & Properties }
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
    property Choice[Index: Integer]: IXMLChoiceType read Get_Choice; default;
  end;

{ IXMLChoiceType }

  IXMLChoiceType = interface(IXMLNode)
    ['{F2EE675A-0A1C-4A8B-B6AF-61E6C0D64FFB}']
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
    ['{902401F7-4303-4D5D-9819-B4F6A418E012}']
    { Property Accessors }
    function Get_CommandList(Index: Integer): IXMLCommandListType;
    { Methods & Properties }
    function Add: IXMLCommandListType;
    function Insert(const Index: Integer): IXMLCommandListType;
    property CommandList[Index: Integer]: IXMLCommandListType read Get_CommandList; default;
  end;

{ IXMLCommandListType }

  IXMLCommandListType = interface(IXMLNodeCollection)
    ['{F2A3C519-F4A3-4BBF-8568-4BFFDC73D4B2}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCMDType }

  IXMLCMDType = interface(IXMLNode)
    ['{4A1C35A2-E584-47EB-8C7B-883CAC59E912}']
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
    ['{C6B65CF6-D495-4E43-88FD-3DACD072FFE9}']
    { Property Accessors }
    function Get_ConditionList(Index: Integer): IXMLConditionListType;
    { Methods & Properties }
    function Add: IXMLConditionListType;
    function Insert(const Index: Integer): IXMLConditionListType;
    property ConditionList[Index: Integer]: IXMLConditionListType read Get_ConditionList; default;
  end;

{ IXMLConditionListType }

  IXMLConditionListType = interface(IXMLNodeCollection)
    ['{70BFEA0B-7A23-4068-B0D8-BE771279682F}']
    { Property Accessors }
    function Get_Condition(Index: Integer): IXMLConditionType;
    { Methods & Properties }
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;
    property Condition[Index: Integer]: IXMLConditionType read Get_Condition; default;
  end;

{ IXMLConditionListTypeList }

  IXMLConditionListTypeList = interface(IXMLNodeCollection)
    ['{8076646F-ADA9-4B01-914E-80666BA96C60}']
    { Methods & Properties }
    function Add: IXMLConditionListType;
    function Insert(const Index: Integer): IXMLConditionListType;

    function Get_Item(Index: Integer): IXMLConditionListType;
    property Items[Index: Integer]: IXMLConditionListType read Get_Item; default;
  end;

{ IXMLConditionType }

  IXMLConditionType = interface(IXMLNode)
    ['{169FDBF9-1624-4413-AEB9-1216F5A19378}']
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
    ['{83F6FB01-FC7E-429B-A8E9-DB6B531A5DD8}']
    { Methods & Properties }
    function Add: IXMLConditionType;
    function Insert(const Index: Integer): IXMLConditionType;

    function Get_Item(Index: Integer): IXMLConditionType;
    property Items[Index: Integer]: IXMLConditionType read Get_Item; default;
  end;

{ IXMLNodeCommandsType }

  IXMLNodeCommandsType = interface(IXMLNodeCollection)
    ['{C54DD272-5B39-4CFE-9994-CFF8DC14C10B}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCommandListType2 }

  IXMLCommandListType2 = interface(IXMLNode)
    ['{B854B081-05EB-4C0A-9486-DDD718C02F64}']
  end;

{ IXMLNodeCommandsType2 }

  IXMLNodeCommandsType2 = interface(IXMLNode)
    ['{C563AF47-28DD-44D5-9014-5ACAF5D45E9A}']
  end;

{ IXMLChoicesType2 }

  IXMLChoicesType2 = interface(IXMLNode)
    ['{09B6565D-2760-4D9B-A914-5C760FC974C2}']
  end;

{ Forward Decls }

  TXMLAdventureGameType = class;
  TXMLMetaInfoType = class;
  TXMLScriptsType = class;
  TXMLScriptType = class;
  TXMLScriptTypeList = class;
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
  TXMLConditionListTypeList = class;
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
    function Get_Scripts: IXMLScriptsType;
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

{ TXMLScriptsType }

  TXMLScriptsType = class(TXMLNodeCollection, IXMLScriptsType)
  protected
    { IXMLScriptsType }
    function Get_Script(Index: Integer): IXMLScriptType;
    function Add: IXMLScriptType;
    function Insert(const Index: Integer): IXMLScriptType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLScriptType }

  TXMLScriptType = class(TXMLNode, IXMLScriptType)
  protected
    { IXMLScriptType }
    function Get_Name: UnicodeString;
    function Get_Filename: UnicodeString;
    function Get_Author: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Filename(Value: UnicodeString);
    procedure Set_Author(Value: UnicodeString);
  end;

{ TXMLScriptTypeList }

  TXMLScriptTypeList = class(TXMLNodeCollection, IXMLScriptTypeList)
  protected
    { IXMLScriptTypeList }
    function Add: IXMLScriptType;
    function Insert(const Index: Integer): IXMLScriptType;

    function Get_Item(Index: Integer): IXMLScriptType;
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

{ TXMLConditionListTypeList }

  TXMLConditionListTypeList = class(TXMLNodeCollection, IXMLConditionListTypeList)
  protected
    { IXMLConditionListTypeList }
    function Add: IXMLConditionListType;
    function Insert(const Index: Integer): IXMLConditionListType;

    function Get_Item(Index: Integer): IXMLConditionListType;
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

uses Xml.xmlutil;

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
  RegisterChildNode('Scripts', TXMLScriptsType);
  RegisterChildNode('Variables', TXMLVariablesType);
  RegisterChildNode('GameNodes', TXMLGameNodesType);
  inherited;
end;

function TXMLAdventureGameType.Get_MetaInfo: IXMLMetaInfoType;
begin
  Result := ChildNodes['MetaInfo'] as IXMLMetaInfoType;
end;

function TXMLAdventureGameType.Get_Scripts: IXMLScriptsType;
begin
  Result := ChildNodes['Scripts'] as IXMLScriptsType;
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

{ TXMLScriptsType }

procedure TXMLScriptsType.AfterConstruction;
begin
  RegisterChildNode('Script', TXMLScriptType);
  ItemTag := 'Script';
  ItemInterface := IXMLScriptType;
  inherited;
end;

function TXMLScriptsType.Get_Script(Index: Integer): IXMLScriptType;
begin
  Result := List[Index] as IXMLScriptType;
end;

function TXMLScriptsType.Add: IXMLScriptType;
begin
  Result := AddItem(-1) as IXMLScriptType;
end;

function TXMLScriptsType.Insert(const Index: Integer): IXMLScriptType;
begin
  Result := AddItem(Index) as IXMLScriptType;
end;

{ TXMLScriptType }

function TXMLScriptType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLScriptType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLScriptType.Get_Filename: UnicodeString;
begin
  Result := AttributeNodes['filename'].Text;
end;

procedure TXMLScriptType.Set_Filename(Value: UnicodeString);
begin
  SetAttribute('filename', Value);
end;

function TXMLScriptType.Get_Author: UnicodeString;
begin
  Result := AttributeNodes['author'].Text;
end;

procedure TXMLScriptType.Set_Author(Value: UnicodeString);
begin
  SetAttribute('author', Value);
end;

{ TXMLScriptTypeList }

function TXMLScriptTypeList.Add: IXMLScriptType;
begin
  Result := AddItem(-1) as IXMLScriptType;
end;

function TXMLScriptTypeList.Insert(const Index: Integer): IXMLScriptType;
begin
  Result := AddItem(Index) as IXMLScriptType;
end;

function TXMLScriptTypeList.Get_Item(Index: Integer): IXMLScriptType;
begin
  Result := List[Index] as IXMLScriptType;
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

{ TXMLConditionListTypeList }

function TXMLConditionListTypeList.Add: IXMLConditionListType;
begin
  Result := AddItem(-1) as IXMLConditionListType;
end;

function TXMLConditionListTypeList.Insert(const Index: Integer): IXMLConditionListType;
begin
  Result := AddItem(Index) as IXMLConditionListType;
end;

function TXMLConditionListTypeList.Get_Item(Index: Integer): IXMLConditionListType;
begin
  Result := List[Index] as IXMLConditionListType;
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