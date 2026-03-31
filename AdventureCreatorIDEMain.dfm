object Form1: TForm1
  Left = 237
  Top = 129
  Caption = 'Adventure Creator 1.0 IDE - [Untitled]'
  ClientHeight = 800
  ClientWidth = 1280
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object mm1: TMainMenu
    Left = 480
    Top = 136
    object File1: TMenuItem
      Caption = '&File'
      object NewFile1: TMenuItem
        Caption = '&New'
        Shortcut = 16449
        OnClick = NewAdventureFile1Click
      end
      object OpenFile1: TMenuItem
        Caption = '&Open...'
        Shortcut = 16465
        OnClick = LoadAdventureFile1Click
      end
      object SaveFile1: TMenuItem
        Caption = '&Save'
        Shortcut = 16483
        OnClick = SaveAdventureFile1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As...'
        Shortcut = 16451
        OnClick = SaveAdventureFile1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Metadata1: TMenuItem
        Caption = '&Edit Metadata...'
        OnClick = Metadata1Click
      end
      object Compileadventure1: TMenuItem
        Caption = '&Compile Adventure...'
        Shortcut = 16469
        OnClick = Compileadventure1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'E&xit'
        Shortcut = 32878
        OnClick = Quit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Undo1: TMenuItem
        Caption = '&Undo'
        Shortcut = 32774
      end
      object Redo1: TMenuItem
        Caption = '&Redo'
        Shortcut = 32802
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Caption = 'Cu&t'
        Shortcut = 32772
      end
      object Copy1: TMenuItem
        Caption = '&Copy'
        Shortcut = 32767
      end
      object Paste1: TMenuItem
        Caption = '&Paste'
        Shortcut = 32780
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object ToggleNodePanel1: TMenuItem
        Caption = '&Node Tree Panel'
        Checked = True
        OnClick = ToggleNodePanel1Click
      end
      object ToggleChoicePanel1: TMenuItem
        Caption = '&Choices Panel'
        Checked = True
        OnClick = ToggleChoicePanel1Click
      end
      object ToggleCommandPanel1: TMenuItem
        Caption = '&Commands Panel'
        Checked = True
        OnClick = ToggleCommandPanel1Click
      end
      object ToggleMessages1: TMenuItem
        Caption = '&Messages Panel'
        Checked = True
        OnClick = ToggleMessages1Click
      end
    end
    object Tools1: TMenuItem
      Caption = '&Tools'
      object Variables1: TMenuItem
        Caption = '&Variables...'
        Shortcut = 16456
        OnClick = Variables1Click
      end
      object ValidateNodes2: TMenuItem
        Caption = '&Validate Nodes'
        Shortcut = 16454
        OnClick = ValidateNodes1Click
      end
      object ShowNodeLinks2: TMenuItem
        Caption = 'S&how Node Links'
        OnClick = ShowNodeLinks1Click
      end
      object Scripts1: TMenuItem
        Caption = '&Scripts...'
        Shortcut = 16453
        OnClick = Scripts1Click
      end
      object Compilersettings1: TMenuItem
        Caption = '&Project Settings...'
        OnClick = Compilersettings1Click
      end
      object Additionalfiles1: TMenuItem
        Caption = '&Additional Files...'
        OnClick = Additionalfiles1Click
      end
      object Audiodevices1: TMenuItem
        Caption = '&Audio Devices...'
        OnClick = Audiodevices1Click
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Help2: TMenuItem
        Caption = '&Help Contents'
        Shortcut = 112
      end
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
    end
  end
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 1280
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = 8206041
    ParentBackground = False
    TabOrder = 0
    object tbNew: TToolButton
      Left = 4
      Top = 4
      Width = 40
      Height = 40
      Caption = 'New'
      ImageIndex = 0
      OnClick = tbNewClick
    end
    object tbOpen: TToolButton
      Left = 44
      Top = 4
      Width = 40
      Height = 40
      Caption = 'Open'
      ImageIndex = 1
      OnClick = tbOpenClick
    end
    object tbSave: TToolButton
      Left = 84
      Top = 4
      Width = 40
      Height = 40
      Caption = 'Save'
      ImageIndex = 2
      OnClick = tbSaveClick
    end
    object tbSep1: TToolButton
      Left = 124
      Top = 4
      Width = 8
      Height = 40
      Style = tbsSeparator
    end
    object tbCompile: TToolButton
      Left = 132
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Compile'
      ImageIndex = 3
      OnClick = tbCompileClick
    end
    object tbSep2: TToolButton
      Left = 192
      Top = 4
      Width = 8
      Height = 40
      Style = tbsSeparator
    end
    object tbAddNode: TToolButton
      Left = 200
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Add Node'
      ImageIndex = 4
      OnClick = btn1Click
    end
    object tbDeleteNode: TToolButton
      Left = 260
      Top = 4
      Width = 70
      Height = 40
      Caption = 'Delete'
      ImageIndex = 5
      OnClick = btn2Click
    end
    object tbSep3: TToolButton
      Left = 330
      Top = 4
      Width = 8
      Height = 40
      Style = tbsSeparator
    end
    object tbAddChoice: TToolButton
      Left = 338
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Add Choice'
      ImageIndex = 6
      OnClick = btnAddChoiceClick
    end
    object tbDeleteChoice: TToolButton
      Left = 398
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Del Choice'
      ImageIndex = 7
      OnClick = btnDeleteChoiceClick
    end
    object tbSep4: TToolButton
      Left = 458
      Top = 4
      Width = 8
      Height = 40
      Style = tbsSeparator
    end
    object tbValidate: TToolButton
      Left = 466
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Validate'
      ImageIndex = 8
      OnClick = tbValidateClick
    end
    object tbScripts: TToolButton
      Left = 526
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Scripts'
      ImageIndex = 9
      OnClick = tbScriptsClick
    end
    object tbVariables: TToolButton
      Left = 586
      Top = 4
      Width = 60
      Height = 40
      Caption = 'Variables'
      ImageIndex = 10
      OnClick = tbVariablesClick
    end
  end
  object pnlNodeTree: TPanel
    Left = 0
    Top = 48
    Width = 280
    Height = 520
    Align = alLeft
    BevelOuter = bvRaised
    Color = 9027869
    ParentBackground = False
    TabOrder = 1
    object lblNodes: TLabel
      Left = 8
      Top = 8
      Width = 50
      Height = 16
      Caption = 'Nodes:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object nodes_tree: TTreeView
      Left = 8
      Top = 28
      Width = 264
      Height = 400
      Align = alTop
      Indent = 19
      TabOrder = 0
      OnClick = nodes_treeClick
    end
    object btnAddNode: TButton
      Left = 8
      Top = 440
      Width = 80
      Height = 28
      Caption = 'Add Node'
      TabOrder = 1
      OnClick = btn1Click
    end
    object btnDeleteNode: TButton
      Left = 96
      Top = 440
      Width = 80
      Height = 28
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btn2Click
    end
    object btnCloneNode: TButton
      Left = 184
      Top = 440
      Width = 80
      Height = 28
      Caption = 'Clone'
      TabOrder = 3
      OnClick = btnCloneNodeClick
    end
  end
  object pnlNodeEditor: TPanel
    Left = 280
    Top = 48
    Width = 1000
    Height = 180
    Align = alCustom
    BevelOuter = bvRaised
    Color = 9362482
    ParentBackground = False
    TabOrder = 2
    object lblNodeName: TLabel
      Left = 12
      Top = 12
      Width = 80
      Height = 16
      Caption = 'Node Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtnodename: TEdit
      Left = 12
      Top = 32
      Width = 300
      Height = 24
      TabOrder = 0
    end
    object lblNodeParent: TLabel
      Left = 330
      Top = 12
      Width = 80
      Height = 16
      Caption = 'Parent Node:'
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object node_parent: TComboBox
      Left = 330
      Top = 32
      Width = 200
      Height = 24
      TabOrder = 1
      OnClick = node_parentClick
    end
    object lblNodeDescription: TLabel
      Left = 12
      Top = 64
      Width = 120
      Height = 16
      Caption = 'Node Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object mmonodetext: TMemo
      Left = 12
      Top = 84
      Width = 600
      Height = 80
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Consolas'
      ParentFont = False
      TabOrder = 2
      OnKeyUp = mmonodetextKeyUp
    end
    object chkendgame: TCheckBox
      Left = 630
      Top = 32
      Width = 200
      Height = 20
      Caption = 'End Game Node'
      TabOrder = 3
    end
    object btnApplyChanges: TButton
      Left = 630
      Top = 84
      Width = 120
      Height = 32
      Caption = 'Apply Changes'
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btnApplyChangesClick
    end
    object lblNewNodeName: TLabel
      Left = 630
      Top = 130
      Width = 90
      Height = 16
      Caption = 'New Node Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object newnodename: TEdit
      Left = 630
      Top = 148
      Width = 160
      Height = 24
      TabOrder = 5
    end
    object btnCreateNode: TButton
      Left = 800
      Top = 146
      Width = 80
      Height = 28
      Caption = 'Create'
      TabOrder = 6
      OnClick = btnCreateNodeClick
    end
  end
  object pnlChoices: TPanel
    Left = 280
    Top = 228
    Width = 580
    Height = 340
    Align = alCustom
    BevelOuter = bvRaised
    Color = 9027869
    ParentBackground = False
    TabOrder = 3
    object lblChoices: TLabel
      Left = 8
      Top = 8
      Width = 60
      Height = 16
      Caption = 'Choices:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lstchoicelist: TListBox
      Left = 8
      Top = 28
      Width = 280
      Height = 150
      ItemHeight = 16
      TabOrder = 0
      OnClick = lstchoicelistClick
      OnMouseUp = lstchoicelistMouseUp
    end
    object btnAddChoice: TButton
      Left = 8
      Top = 188
      Width = 80
      Height = 26
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddChoiceClick
    end
    object btnInsertChoice: TButton
      Left = 96
      Top = 188
      Width = 80
      Height = 26
      Caption = 'Insert'
      TabOrder = 2
      OnClick = btn5Click
    end
    object btnDeleteChoice: TButton
      Left = 184
      Top = 188
      Width = 80
      Height = 26
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteChoiceClick
    end
    object lblChoiceText: TLabel
      Left = 304
      Top = 8
      Width = 80
      Height = 16
      Caption = 'Choice Text:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtchoicetext: TEdit
      Left = 304
      Top = 28
      Width = 268
      Height = 24
      TabOrder = 4
      OnKeyUp = edtchoicetextKeyUp
    end
    object lblTargetNode: TLabel
      Left = 304
      Top = 60
      Width = 80
      Height = 16
      Caption = 'Target Node:'
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object cbbchoicenodelist: TComboBox
      Left = 304
      Top = 80
      Width = 200
      Height = 24
      TabOrder = 5
      OnClick = cbbchoicenodelistClick
    end
    object lblChoiceScore: TLabel
      Left = 304
      Top = 112
      Width = 80
      Height = 16
      Caption = 'Score:'
      Font.Charset = DEFAULT_CHARSET
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object edtchoicescore: TEdit
      Left = 304
      Top = 132
      Width = 80
      Height = 24
      TabOrder = 6
      OnKeyUp = edtchoicescoreKeyUp
    end
    object chkChoiceEndGame: TCheckBox
      Left = 304
      Top = 168
      Width = 200
      Height = 20
      Caption = 'End Game'
      TabOrder = 7
      OnClick = chkendgameClick
    end
    object chkChoiceWinGame: TCheckBox
      Left = 304
      Top = 192
      Width = 200
      Height = 20
      Caption = 'Win Game'
      TabOrder = 8
      OnClick = gamewinnerClick
    end
    object btnEditChoiceConditions: TButton
      Left = 8
      Top = 224
      Width = 130
      Height = 26
      Caption = 'Edit Conditions...'
      TabOrder = 9
      OnClick = btnEditChoiceConditionsClick
    end
    object btnEditChoiceCommands: TButton
      Left = 148
      Top = 224
      Width = 130
      Height = 26
      Caption = 'Edit Commands...'
      TabOrder = 10
      OnClick = btnEditChoiceCommandsClick
    end
  end
  object pnlCommands: TPanel
    Left = 860
    Top = 228
    Width = 420
    Height = 340
    Align = alCustom
    BevelOuter = bvRaised
    Color = 9027869
    ParentBackground = False
    TabOrder = 4
    object grpCommands: TGroupBox
      Left = 8
      Top = 8
      Width = 404
      Height = 324
      Caption = 'Node Commands'
      TabOrder = 0
      object lblCommandList: TLabel
        Left = 12
        Top = 24
        Width = 80
        Height = 16
        Caption = 'Command List:'
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lstcommands: TListBox
        Left = 12
        Top = 44
        Width = 180
        Height = 180
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
        OnClick = lstcommandsClick
      end
      object btnAddCommand: TButton
        Left = 12
        Top = 230
        Width = 60
        Height = 24
        Caption = 'Add'
        TabOrder = 1
        OnClick = btnAddCommandClick
      end
      object btnDeleteCommand: TButton
        Left = 80
        Top = 230
        Width = 60
        Height = 24
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnDeleteCommandClick
      end
      object lblCommand: TLabel
        Left = 208
        Top = 24
        Width = 70
        Height = 16
        Caption = 'Command:'
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbbcmd: TComboBox
        Left = 208
        Top = 44
        Width = 180
        Height = 24
        TabOrder = 3
        OnClick = cbbcmdClick
        Items.Strings = (
          'SetVar'
          'DisplayMessage'
          'DisplayMessageDirect'
          'IncreaseVar'
          'DecreaseVar'
          'TextPrompt'
          'RandomNumber'
          'SetRandomMin'
          'SetRandomMax'
          'ExecuteRandom'
          'RunScript'
          'PlaySound')
      end
      object lblVariable: TLabel
        Left = 208
        Top = 76
        Width = 60
        Height = 16
        Caption = 'Variable:'
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -12
        Font.Name = 'Segoe UI'
        ParentFont = False
      end
      object cbbvarsel: TComboBox
        Left = 208
        Top = 96
        Width = 180
        Height = 24
        TabOrder = 4
        OnClick = cbbvarselClick
      end
      object lblParameterValue: TLabel
        Left = 208
        Top = 128
        Width = 100
        Height = 16
        Caption = 'Parameter Value:'
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -12
        Font.Name = 'Segoe UI'
        ParentFont = False
      end
      object mmoparamval: TMemo
        Left = 208
        Top = 148
        Width = 180
        Height = 80
        Font.Charset = DEFAULT_CHARSET
        Font.Height = -12
        Font.Name = 'Consolas'
        ParentFont = False
        TabOrder = 5
        OnKeyUp = mmoparamvalKeyUp
      end
      object ScriptSelector: TComboBox
        Left = 208
        Top = 148
        Width = 180
        Height = 24
        TabOrder = 6
        Text = 'ScriptSelector'
        Visible = False
        OnClick = ScriptSelectorClick
      end
      object lblScriptSelector: TLabel
        Left = 208
        Top = 128
        Width = 80
        Height = 16
        Caption = 'Script:'
        Visible = False
      end
      object ScriptSelectorMain: TComboBox
        Left = 208
        Top = 96
        Width = 180
        Height = 24
        TabOrder = 7
        Visible = False
        OnClick = ScriptSelectorClick
      end
    end
  end
  object pnlMessages: TPanel
    Left = 0
    Top = 568
    Width = 1280
    Height = 200
    Align = alCustom
    BevelOuter = bvRaised
    Color = 9362482
    ParentBackground = False
    TabOrder = 5
    object lblMessages: TLabel
      Left = 8
      Top = 8
      Width = 70
      Height = 16
      Caption = 'Messages:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClearMessages: TButton
      Left = 1180
      Top = 4
      Width = 80
      Height = 24
      Caption = 'Clear'
      TabOrder = 0
    end
    object mmomessages: TMemo
      Left = 8
      Top = 28
      Width = 1264
      Height = 164
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Consolas'
      ParentFont = False
      TabOrder = 1
      ReadOnly = True
    end
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 768
    Width = 1280
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    Color = 6908265
    ParentBackground = False
    TabOrder = 6
    object lblStatus: TLabel
      Left = 8
      Top = 8
      Width = 150
      Height = 16
      Caption = 'Ready'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object lblNodeCount: TLabel
      Left = 300
      Top = 8
      Width = 80
      Height = 16
      Caption = 'Nodes: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object lblScriptCount: TLabel
      Left = 400
      Top = 8
      Width = 80
      Height = 16
      Caption = 'Scripts: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
    end
    object lblCurrentTime: TLabel
      Left = 1200
      Top = 8
      Width = 70
      Height = 16
      Caption = '00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      ParentFont = False
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
    Top = 128
  end
  object DataReader: TXMLDocument
    Left = 240
    Top = 120
    DOMVendorDesc = 'MSXML'
  end
end
