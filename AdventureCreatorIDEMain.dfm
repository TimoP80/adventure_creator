object Form1: TForm1
  Left = 237
  Top = 129
  Caption = 'Adventure Creator 1.0 IDE'
  ClientHeight = 770
  ClientWidth = 1120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 20
    Width = 34
    Height = 13
    Caption = 'Nodes:'
  end
  object lbl2: TLabel
    Left = 328
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Node name:'
  end
  object lbl3: TLabel
    Left = 328
    Top = 216
    Width = 37
    Height = 13
    Caption = 'Choices'
  end
  object lbl4: TLabel
    Left = 364
    Top = 351
    Width = 59
    Height = 13
    Caption = 'Choice text:'
  end
  object lbl5: TLabel
    Left = 327
    Top = 379
    Width = 96
    Height = 13
    Caption = 'Choice target node:'
  end
  object lbl6: TLabel
    Left = 328
    Top = 48
    Width = 103
    Height = 13
    Caption = 'Node text description'
  end
  object lbl7: TLabel
    Left = 328
    Top = 408
    Width = 153
    Height = 13
    AutoSize = False
    Caption = 'Score award for this choice:'
  end
  object Label1: TLabel
    Left = 667
    Top = 381
    Width = 87
    Height = 13
    Caption = 'Create new node:'
  end
  object Label2: TLabel
    Left = 952
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Node parent:'
  end
  object mmonodetext: TMemo
    Left = 328
    Top = 64
    Width = 777
    Height = 145
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyUp = mmonodetextKeyUp
  end
  object lstchoicelist: TListBox
    Left = 328
    Top = 232
    Width = 777
    Height = 81
    ItemHeight = 13
    TabOrder = 1
    OnClick = lstchoicelistClick
  end
  object edtchoicetext: TEdit
    Left = 432
    Top = 352
    Width = 673
    Height = 21
    TabOrder = 2
    OnKeyUp = edtchoicetextKeyUp
  end
  object btn1: TButton
    Left = 8
    Top = 632
    Width = 89
    Height = 33
    Caption = 'Add node'
    TabOrder = 3
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 104
    Top = 632
    Width = 89
    Height = 33
    Caption = 'Delete node'
    TabOrder = 4
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 328
    Top = 320
    Width = 121
    Height = 25
    Caption = 'Add choice'
    TabOrder = 5
    OnClick = btn3Click
  end
  object btn4: TButton
    Left = 584
    Top = 320
    Width = 121
    Height = 25
    Caption = 'Delete choice'
    TabOrder = 6
    OnClick = btn4Click
  end
  object cbbchoicenodelist: TComboBox
    Left = 432
    Top = 376
    Width = 217
    Height = 21
    TabOrder = 7
    OnClick = cbbchoicenodelistClick
  end
  object edtnodename: TEdit
    Left = 328
    Top = 24
    Width = 505
    Height = 21
    TabOrder = 8
  end
  object chkendgame: TCheckBox
    Left = 328
    Top = 448
    Width = 233
    Height = 25
    Caption = 'This choice causes the game to end'
    TabOrder = 9
    OnClick = chkendgameClick
  end
  object btn5: TButton
    Left = 208
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Init booleans'
    TabOrder = 10
    OnClick = btn5Click
  end
  object btn6: TButton
    Left = 840
    Top = 24
    Width = 89
    Height = 25
    Caption = 'Apply changes'
    TabOrder = 11
    OnClick = btn6Click
  end
  object mmomessages: TMemo
    Left = 8
    Top = 672
    Width = 1105
    Height = 89
    TabOrder = 12
  end
  object edtchoicescore: TEdit
    Left = 328
    Top = 424
    Width = 105
    Height = 21
    TabOrder = 13
    OnKeyUp = edtchoicescoreKeyUp
  end
  object btn7: TButton
    Left = 456
    Top = 320
    Width = 121
    Height = 25
    Caption = 'Insert choice'
    TabOrder = 14
    OnClick = btn7Click
  end
  object grp1: TGroupBox
    Left = 567
    Top = 409
    Width = 529
    Height = 257
    Caption = 'Node commands:'
    TabOrder = 15
    object lbl8: TLabel
      Left = 8
      Top = 24
      Width = 67
      Height = 13
      Caption = 'Command list:'
    end
    object lbl9: TLabel
      Left = 240
      Top = 24
      Width = 51
      Height = 13
      Caption = 'Command:'
    end
    object lbl10: TLabel
      Left = 240
      Top = 72
      Width = 42
      Height = 13
      Caption = 'Variable:'
    end
    object lbl11: TLabel
      Left = 240
      Top = 120
      Width = 83
      Height = 13
      Caption = 'Parameter value:'
    end
    object lstcommands: TListBox
      Left = 8
      Top = 40
      Width = 209
      Height = 177
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstcommandsClick
    end
    object btn8: TButton
      Left = 9
      Top = 223
      Width = 57
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = btn8Click
    end
    object btn9: TButton
      Left = 72
      Top = 224
      Width = 57
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btn9Click
    end
    object cbbcmd: TComboBox
      Left = 240
      Top = 40
      Width = 209
      Height = 21
      TabOrder = 3
      OnClick = cbbcmdClick
      Items.Strings = (
        'SetVar'
        'DisplayMessage'
        'WaitForKeyPress'
        'IncreaseVar'
        'DecreaseVar')
    end
    object cbbvarsel: TComboBox
      Left = 240
      Top = 88
      Width = 209
      Height = 21
      TabOrder = 4
      OnClick = cbbvarselClick
    end
    object mmoparamval: TMemo
      Left = 240
      Top = 136
      Width = 273
      Height = 105
      TabOrder = 5
      OnKeyUp = mmoparamvalKeyUp
    end
  end
  object newnodename: TEdit
    Left = 760
    Top = 379
    Width = 129
    Height = 21
    TabOrder = 16
  end
  object Button1: TButton
    Left = 895
    Top = 379
    Width = 66
    Height = 24
    Caption = 'Create'
    TabOrder = 17
    OnClick = Button1Click
  end
  object node_parent: TComboBox
    Left = 951
    Top = 27
    Width = 154
    Height = 21
    TabOrder = 18
    OnClick = node_parentClick
  end
  object nodes_tree: TTreeView
    Left = 8
    Top = 39
    Width = 305
    Height = 583
    Indent = 19
    TabOrder = 19
    OnClick = nodes_treeClick
  end
  object DataReader: TXMLDocument
    Left = 240
    Top = 120
    DOMVendorDesc = 'MSXML'
  end
  object mm1: TMainMenu
    Left = 480
    Top = 136
    object File1: TMenuItem
      Caption = 'File'
      object NewAdventureFile1: TMenuItem
        Caption = 'New AdventureFile'
        OnClick = NewAdventureFile1Click
      end
      object LoadAdventureFile1: TMenuItem
        Caption = 'Load AdventureFile'
        OnClick = LoadAdventureFile1Click
      end
      object SaveAdventureFile1: TMenuItem
        Caption = 'Save AdventureFile'
        OnClick = SaveAdventureFile1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Metadata1: TMenuItem
        Caption = 'Edit Metadata'
        OnClick = Metadata1Click
      end
      object CompiletoBinary1: TMenuItem
        Caption = 'Compile to Binary'
        OnClick = CompiletoBinary1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'Quit'
        OnClick = Quit1Click
      end
    end
    object ools1: TMenuItem
      Caption = 'Tools'
      object Variables1: TMenuItem
        Caption = 'Variables'
        OnClick = Variables1Click
      end
      object ValidateNodes1: TMenuItem
        Caption = 'Validate Nodes'
        OnClick = ValidateNodes1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
  object dlgOpen1: TOpenDialog
    Filter = 'Adventure XML Files (*.xml)|*.xml'
    Left = 664
    Top = 32
  end
  object dlgSave1: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'Adventure XML Files (*.xml)|*.xml'
    Left = 656
    Top = 88
  end
  object dlgSave2: TSaveDialog
    DefaultExt = 'agf'
    Filter = 'Adventure Game Files (*.agf)|*.agf'
    Left = 472
    Top = 72
  end
end
