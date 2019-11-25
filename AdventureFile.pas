
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 24.3.2015 17:06:09                                   }
{       Generated from: C:\CodeProjects\AdventureCreator\AdventureFile.xml   }
{   Settings stored in: C:\CodeProjects\AdventureCreator\AdventureFile.xdb   }
{                                                                            }
{****************************************************************************}

unit AdventureFile;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLAdventureGameType = interface;
  IXMLMetaInfoType = interface;
  IXMLVariablesType = interface;
  IXMLVariableType = interface;
  IXMLVariableTypeList = interface;
  IXMLGameNodesType = interface;
  IXMLNodeType = interface;
  IXMLNodeTypeList = interface;
  IXMLChoicesType = interface;
  IXMLChoiceType = interface;
  IXMLNodeCommandsType = interface;
  IXMLCMDType = interface;

{ IXMLAdventureGameType }

  IXMLAdventureGameType = interface(IXMLNode)
    ['{467F65E7-5C1B-456E-80A7-4BF530FED55A}']
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
    ['{78E616AF-8B2D-4C51-B723-3E522F6D47B8}']
    { Property Accessors }
    function Get_Title: WideString;
    function Get_Author: WideString;
    function Get_Description: WideString;
    procedure Set_Title(Value: WideString);
    procedure Set_Author(Value: WideString);
    procedure Set_Description(Value: WideString);
    { Methods & Properties }
    property Title: WideString read Get_Title write Set_Title;
    property Author: WideString read Get_Author write Set_Author;
    property Description: WideString read Get_Description write Set_Description;
  end;

{ IXMLVariablesType }

  IXMLVariablesType = interface(IXMLNodeCollection)
    ['{BC91E5D7-AC7F-4642-88F9-79FF9578C7C5}']
    { Property Accessors }
    function Get_Variable(Index: Integer): IXMLVariableType;
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    property Variable[Index: Integer]: IXMLVariableType read Get_Variable; default;
  end;

{ IXMLVariableType }

  IXMLVariableType = interface(IXMLNode)
    ['{5E4493EC-74B3-4D63-8E16-66C2E70C8597}']
    { Property Accessors }
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
  end;

{ IXMLVariableTypeList }

  IXMLVariableTypeList = interface(IXMLNodeCollection)
    ['{EC843874-5B56-4690-A979-0887F69A6A04}']
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    function Get_Item(Index: Integer): IXMLVariableType;
    property Items[Index: Integer]: IXMLVariableType read Get_Item; default;
  end;

{ IXMLGameNodesType }

  IXMLGameNodesType = interface(IXMLNodeCollection)
    ['{95CC9A16-BBB6-427C-8F3E-2E28EF8DC55C}']
    { Property Accessors }
    function Get_Node(Index: Integer): IXMLNodeType;
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    property Node[Index: Integer]: IXMLNodeType read Get_Node; default;
  end;

{ IXMLNodeType }

  IXMLNodeType = interface(IXMLNode)
    ['{C9A2B1FE-7745-4B98-AD3F-C291D99072FB}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_DescriptionText: WideString;
    function Get_Choices: IXMLChoicesType;
    function Get_NodeCommands: IXMLNodeCommandsType;
    procedure Set_Name(Value: WideString);
    procedure Set_DescriptionText(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property DescriptionText: WideString read Get_DescriptionText write Set_DescriptionText;
    property Choices: IXMLChoicesType read Get_Choices;
    property NodeCommands: IXMLNodeCommandsType read Get_NodeCommands;
  end;

{ IXMLNodeTypeList }

  IXMLNodeTypeList = interface(IXMLNodeCollection)
    ['{DD69BA34-8268-495E-B623-3987F70D0387}']
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    function Get_Item(Index: Integer): IXMLNodeType;
    property Items[Index: Integer]: IXMLNodeType read Get_Item; default;
  end;

{ IXMLChoicesType }

  IXMLChoicesType = interface(IXMLNodeCollection)
    ['{EF23E767-C72F-4BF9-ABCA-AAADB92B78A7}']
    { Property Accessors }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    { Methods & Properties }
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
    property Choice[Index: Integer]: IXMLChoiceType read Get_Choice; default;
  end;

{ IXMLChoiceType }

  IXMLChoiceType = interface(IXMLNode)
    ['{AE429AE4-E59D-48A6-A91C-153D205BEB4B}']
    { Property Accessors }
    function Get_Addscore: Integer;
    function Get_Endgame: Boolean;
    function Get_Targetnode: WideString;
    procedure Set_Addscore(Value: Integer);
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: WideString);
    { Methods & Properties }
    property Addscore: Integer read Get_Addscore write Set_Addscore;
    property Endgame: Boolean read Get_Endgame write Set_Endgame;
    property Targetnode: WideString read Get_Targetnode write Set_Targetnode;
  end;

{ IXMLNodeCommandsType }

  IXMLNodeCommandsType = interface(IXMLNodeCollection)
    ['{AB78CC46-34B9-4227-9F1E-3E342D27F9D8}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCMDType }

  IXMLCMDType = interface(IXMLNode)
    ['{C8448144-C16C-4014-84AA-25B32F28F190}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Variable: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Variable(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Variable: WideString read Get_Variable write Set_Variable;
  end;

{ Forward Decls }

  TXMLAdventureGameType = class;
  TXMLMetaInfoType = class;
  TXMLVariablesType = class;
  TXMLVariableType = class;
  TXMLVariableTypeList = class;
  TXMLGameNodesType = class;
  TXMLNodeType = class;
  TXMLNodeTypeList = class;
  TXMLChoicesType = class;
  TXMLChoiceType = class;
  TXMLNodeCommandsType = class;
  TXMLCMDType = class;

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
    function Get_Title: WideString;
    function Get_Author: WideString;
    function Get_Description: WideString;
    procedure Set_Title(Value: WideString);
    procedure Set_Author(Value: WideString);
    procedure Set_Description(Value: WideString);
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
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
  end;

{ TXMLVariableTypeList }

  TXMLVariableTypeList = class(TXMLNodeCollection, IXMLVariableTypeList)
  protected
    { IXMLVariableTypeList }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    function Get_Item(Index: Integer): IXMLVariableType;
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
    function Get_Name: WideString;
    function Get_DescriptionText: WideString;
    function Get_Choices: IXMLChoicesType;
    function Get_NodeCommands: IXMLNodeCommandsType;
    procedure Set_Name(Value: WideString);
    procedure Set_DescriptionText(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNodeTypeList }

  TXMLNodeTypeList = class(TXMLNodeCollection, IXMLNodeTypeList)
  protected
    { IXMLNodeTypeList }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    function Get_Item(Index: Integer): IXMLNodeType;
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
    function Get_Addscore: Integer;
    function Get_Endgame: Boolean;
    function Get_Targetnode: WideString;
    procedure Set_Addscore(Value: Integer);
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: WideString);
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

{ TXMLCMDType }

  TXMLCMDType = class(TXMLNode, IXMLCMDType)
  protected
    { IXMLCMDType }
    function Get_Name: WideString;
    function Get_Variable: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Variable(Value: WideString);
  end;

{ Global Functions }

function GetAdventureGame(Doc: IXMLDocument): IXMLAdventureGameType;
function LoadAdventureGame(const FileName: WideString): IXMLAdventureGameType;
function NewAdventureGame: IXMLAdventureGameType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetAdventureGame(Doc: IXMLDocument): IXMLAdventureGameType;
begin
  Result := Doc.GetDocBinding('AdventureGame', TXMLAdventureGameType, TargetNamespace) as IXMLAdventureGameType;
end;

function LoadAdventureGame(const FileName: WideString): IXMLAdventureGameType;
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

function TXMLMetaInfoType.Get_Title: WideString;
begin
  Result := ChildNodes['Title'].Text;
end;

procedure TXMLMetaInfoType.Set_Title(Value: WideString);
begin
  ChildNodes['Title'].NodeValue := Value;
end;

function TXMLMetaInfoType.Get_Author: WideString;
begin
  Result := ChildNodes['Author'].Text;
end;

procedure TXMLMetaInfoType.Set_Author(Value: WideString);
begin
  ChildNodes['Author'].NodeValue := Value;
end;

function TXMLMetaInfoType.Get_Description: WideString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLMetaInfoType.Set_Description(Value: WideString);
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

function TXMLVariableType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLVariableType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

{ TXMLVariableTypeList }

function TXMLVariableTypeList.Add: IXMLVariableType;
begin
  Result := AddItem(-1) as IXMLVariableType;
end;

function TXMLVariableTypeList.Insert(const Index: Integer): IXMLVariableType;
begin
  Result := AddItem(Index) as IXMLVariableType;
end;
function TXMLVariableTypeList.Get_Item(Index: Integer): IXMLVariableType;
begin
  Result := List[Index] as IXMLVariableType;
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
  RegisterChildNode('NodeCommands', TXMLNodeCommandsType);
  inherited;
end;

function TXMLNodeType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLNodeType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLNodeType.Get_DescriptionText: WideString;
begin
  Result := ChildNodes['DescriptionText'].Text;
end;

procedure TXMLNodeType.Set_DescriptionText(Value: WideString);
begin
  ChildNodes['DescriptionText'].NodeValue := Value;
end;

function TXMLNodeType.Get_Choices: IXMLChoicesType;
begin
  Result := ChildNodes['Choices'] as IXMLChoicesType;
end;

function TXMLNodeType.Get_NodeCommands: IXMLNodeCommandsType;
begin
  Result := ChildNodes['NodeCommands'] as IXMLNodeCommandsType;
end;

{ TXMLNodeTypeList }

function TXMLNodeTypeList.Add: IXMLNodeType;
begin
  Result := AddItem(-1) as IXMLNodeType;
end;

function TXMLNodeTypeList.Insert(const Index: Integer): IXMLNodeType;
begin
  Result := AddItem(Index) as IXMLNodeType;
end;
function TXMLNodeTypeList.Get_Item(Index: Integer): IXMLNodeType;
begin
  Result := List[Index] as IXMLNodeType;
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

function TXMLChoiceType.Get_Addscore: Integer;
begin
  Result := AttributeNodes['addscore'].NodeValue;
end;

procedure TXMLChoiceType.Set_Addscore(Value: Integer);
begin
  SetAttribute('addscore', Value);
end;

function TXMLChoiceType.Get_Endgame: Boolean;
begin
  Result := AttributeNodes['endgame'].NodeValue;
end;

procedure TXMLChoiceType.Set_Endgame(Value: Boolean);
begin
  SetAttribute('endgame', Value);
end;

function TXMLChoiceType.Get_Targetnode: WideString;
begin
  Result := AttributeNodes['targetnode'].Text;
end;

procedure TXMLChoiceType.Set_Targetnode(Value: WideString);
begin
  SetAttribute('targetnode', Value);
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

{ TXMLCMDType }

function TXMLCMDType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLCMDType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLCMDType.Get_Variable: WideString;
begin
  Result := AttributeNodes['variable'].Text;
end;

procedure TXMLCMDType.Set_Variable(Value: WideString);
begin
  SetAttribute('variable', Value);
end;

end. 