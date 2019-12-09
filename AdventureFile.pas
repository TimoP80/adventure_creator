
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 9.12.2019 19:37:14                                   }
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
  IXMLCMDTypeList = interface;
  IXMLNodeCommandsType = interface;
  IXMLCommandListType2 = interface;
  IXMLNodeCommandsType2 = interface;
  IXMLChoicesType2 = interface;

{ IXMLAdventureGameType }

  IXMLAdventureGameType = interface(IXMLNode)
    ['{CDD68B1C-5001-4C76-86CB-3C0D261D4F95}']
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
    ['{A5FE9622-1834-4D08-9D99-3B3D902289DE}']
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
    ['{A89A638A-A3D1-4924-AA43-B5176D4618CC}']
    { Property Accessors }
    function Get_Variable(Index: Integer): IXMLVariableType;
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    property Variable[Index: Integer]: IXMLVariableType read Get_Variable; default;
  end;

{ IXMLVariableType }

  IXMLVariableType = interface(IXMLNode)
    ['{1BDADEA7-D379-444A-9B4E-5747418F6534}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLGameNodesType }

  IXMLGameNodesType = interface(IXMLNodeCollection)
    ['{15D696F6-7D0F-427C-9336-2EDECF1428A0}']
    { Property Accessors }
    function Get_Node(Index: Integer): IXMLNodeType;
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    property Node[Index: Integer]: IXMLNodeType read Get_Node; default;
  end;

{ IXMLNodeType }

  IXMLNodeType = interface(IXMLNode)
    ['{7DA6D6B4-5192-45D6-B58C-26ED8927254B}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_DescriptionText: UnicodeString;
    function Get_Choices: IXMLChoicesType;
    function Get_ChoiceCommands: IXMLChoiceCommandsType;
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
    property NodeCommands: IXMLNodeCommandsType read Get_NodeCommands;
    property NodeParent: UnicodeString read Get_NodeParent write Set_NodeParent;
  end;

{ IXMLChoicesType }

  IXMLChoicesType = interface(IXMLNodeCollection)
    ['{9AD324FF-81C6-48AC-ABB3-7AC3BE84DC18}']
    { Property Accessors }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    { Methods & Properties }
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
    property Choice[Index: Integer]: IXMLChoiceType read Get_Choice; default;
  end;

{ IXMLChoiceType }

  IXMLChoiceType = interface(IXMLNode)
    ['{36CED73B-6430-43CA-9698-CE48CBFB10EB}']
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
    ['{BF0B5DF3-C47C-47FE-AE07-A6A25D12B704}']
    { Property Accessors }
    function Get_CommandList(Index: Integer): IXMLCommandListType;
    { Methods & Properties }
    function Add: IXMLCommandListType;
    function Insert(const Index: Integer): IXMLCommandListType;
    property CommandList[Index: Integer]: IXMLCommandListType read Get_CommandList; default;
  end;

{ IXMLCommandListType }

  IXMLCommandListType = interface(IXMLNodeCollection)
    ['{582B3F4B-55E1-45E1-8CB1-7DEC3AAF9C61}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCMDType }

  IXMLCMDType = interface(IXMLNode)
    ['{79AB3EEE-2AA6-4F5F-A54C-F6009F5DE9E8}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Variable: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Variable(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Variable: UnicodeString read Get_Variable write Set_Variable;
  end;

{ IXMLCMDTypeList }

  IXMLCMDTypeList = interface(IXMLNodeCollection)
    ['{9DE6DFCA-D1BF-4187-8772-6E2680294920}']
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;

    function Get_Item(Index: Integer): IXMLCMDType;
    property Items[Index: Integer]: IXMLCMDType read Get_Item; default;
  end;

{ IXMLNodeCommandsType }

  IXMLNodeCommandsType = interface(IXMLNodeCollection)
    ['{37E63915-7DD9-48C0-9AD4-B1CAAC1A4CCD}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCommandListType2 }

  IXMLCommandListType2 = interface(IXMLNode)
    ['{1FC3D7B3-5A89-43CC-9B75-608C313BC3B7}']
  end;

{ IXMLNodeCommandsType2 }

  IXMLNodeCommandsType2 = interface(IXMLNode)
    ['{E93FBBB4-065B-4A86-95ED-104BF92C9E37}']
  end;

{ IXMLChoicesType2 }

  IXMLChoicesType2 = interface(IXMLNode)
    ['{209771D5-98C2-4ECC-A54B-135E14F5A581}']
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
  TXMLCMDTypeList = class;
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

{ TXMLCMDTypeList }

  TXMLCMDTypeList = class(TXMLNodeCollection, IXMLCMDTypeList)
  protected
    { IXMLCMDTypeList }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;

    function Get_Item(Index: Integer): IXMLCMDType;
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

{ TXMLCMDTypeList }

function TXMLCMDTypeList.Add: IXMLCMDType;
begin
  Result := AddItem(-1) as IXMLCMDType;
end;

function TXMLCMDTypeList.Insert(const Index: Integer): IXMLCMDType;
begin
  Result := AddItem(Index) as IXMLCMDType;
end;

function TXMLCMDTypeList.Get_Item(Index: Integer): IXMLCMDType;
begin
  Result := List[Index] as IXMLCMDType;
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