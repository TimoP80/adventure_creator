
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 6.12.2019 21:28:42                                   }
{       Generated from: C:\CodeProjects\AdventureCreator\AdventureFile.xdb   }
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
  IXMLGameNodesType = interface;
  IXMLNodeType = interface;
  IXMLChoicesType = interface;
  IXMLChoiceType = interface;
  IXMLNodeCommandsType = interface;
  IXMLCMDType = interface;

{ IXMLAdventureGameType }

  IXMLAdventureGameType = interface(IXMLNode)
    ['{BCB6A624-AD4D-4ECB-9AEB-2EF73BCE030C}']
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
    ['{D9EF9C77-5F7C-44E4-8F59-FF8F81B47769}']
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
    ['{DDC81247-B528-4B41-9C06-2CD8B8A97D56}']
    { Property Accessors }
    function Get_Variable(Index: Integer): IXMLVariableType;
    { Methods & Properties }
    function Add: IXMLVariableType;
    function Insert(const Index: Integer): IXMLVariableType;
    property Variable[Index: Integer]: IXMLVariableType read Get_Variable; default;
  end;

{ IXMLVariableType }

  IXMLVariableType = interface(IXMLNode)
    ['{A00FFB18-2B58-4E6C-A8DD-ACB9833A4CA7}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLGameNodesType }

  IXMLGameNodesType = interface(IXMLNodeCollection)
    ['{BB34B454-3C40-44DE-90AE-256F90330684}']
    { Property Accessors }
    function Get_Node(Index: Integer): IXMLNodeType;
    { Methods & Properties }
    function Add: IXMLNodeType;
    function Insert(const Index: Integer): IXMLNodeType;
    property Node[Index: Integer]: IXMLNodeType read Get_Node; default;
  end;

{ IXMLNodeType }

  IXMLNodeType = interface(IXMLNode)
    ['{C0FE64E7-A654-4818-A5E7-8A19D5292729}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_DescriptionText: UnicodeString;
    function Get_NodeParent: UnicodeString;
    function Get_Choices: IXMLChoicesType;
    function Get_NodeCommands: IXMLNodeCommandsType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_DescriptionText(Value: UnicodeString);
    procedure Set_NodeParent(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property DescriptionText: UnicodeString read Get_DescriptionText write Set_DescriptionText;
    property NodeParent: UnicodeString read Get_NodeParent write Set_NodeParent;
    property Choices: IXMLChoicesType read Get_Choices;
    property NodeCommands: IXMLNodeCommandsType read Get_NodeCommands;
  end;

{ IXMLChoicesType }

  IXMLChoicesType = interface(IXMLNodeCollection)
    ['{416467C9-3383-4505-ACCF-9CA5D215CAC9}']
    { Property Accessors }
    function Get_Choice(Index: Integer): IXMLChoiceType;
    { Methods & Properties }
    function Add: IXMLChoiceType;
    function Insert(const Index: Integer): IXMLChoiceType;
    property Choice[Index: Integer]: IXMLChoiceType read Get_Choice; default;
  end;

{ IXMLChoiceType }

  IXMLChoiceType = interface(IXMLNode)
    ['{1540EB81-32FF-43DE-AF78-DFF5A681C8A4}']
    { Property Accessors }
    function Get_Addscore: Integer;
    function Get_Endgame: Boolean;
    function Get_Targetnode: UnicodeString;
    procedure Set_Addscore(Value: Integer);
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: UnicodeString);
    { Methods & Properties }
    property Addscore: Integer read Get_Addscore write Set_Addscore;
    property Endgame: Boolean read Get_Endgame write Set_Endgame;
    property Targetnode: UnicodeString read Get_Targetnode write Set_Targetnode;
  end;

{ IXMLNodeCommandsType }

  IXMLNodeCommandsType = interface(IXMLNodeCollection)
    ['{12F91326-CBC5-4F11-81A0-3C2C357D49AF}']
    { Property Accessors }
    function Get_CMD(Index: Integer): IXMLCMDType;
    { Methods & Properties }
    function Add: IXMLCMDType;
    function Insert(const Index: Integer): IXMLCMDType;
    property CMD[Index: Integer]: IXMLCMDType read Get_CMD; default;
  end;

{ IXMLCMDType }

  IXMLCMDType = interface(IXMLNode)
    ['{117E20E3-2E4C-417E-8E81-3228DBCA1E10}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Variable: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Variable(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Variable: UnicodeString read Get_Variable write Set_Variable;
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
    function Get_NodeParent: UnicodeString;
    function Get_Choices: IXMLChoicesType;
    function Get_NodeCommands: IXMLNodeCommandsType;
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
    function Get_Addscore: Integer;
    function Get_Endgame: Boolean;
    function Get_Targetnode: UnicodeString;
    procedure Set_Addscore(Value: Integer);
    procedure Set_Endgame(Value: Boolean);
    procedure Set_Targetnode(Value: UnicodeString);
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
    function Get_Name: UnicodeString;
    function Get_Variable: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Variable(Value: UnicodeString);
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

function TXMLNodeType.Get_NodeParent: UnicodeString;
begin
  Result := ChildNodes['NodeParent'].Text;
end;

procedure TXMLNodeType.Set_NodeParent(Value: UnicodeString);
begin
  ChildNodes['NodeParent'].NodeValue := Value;
end;

function TXMLNodeType.Get_Choices: IXMLChoicesType;
begin
  Result := ChildNodes['Choices'] as IXMLChoicesType;
end;

function TXMLNodeType.Get_NodeCommands: IXMLNodeCommandsType;
begin
  Result := ChildNodes['NodeCommands'] as IXMLNodeCommandsType;
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

function TXMLChoiceType.Get_Targetnode: UnicodeString;
begin
  Result := AttributeNodes['targetnode'].Text;
end;

procedure TXMLChoiceType.Set_Targetnode(Value: UnicodeString);
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

end.