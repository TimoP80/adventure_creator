object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'ChoiceCommands'
  ClientHeight = 311
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 3
    Top = 8
    Width = 529
    Height = 257
    Caption = 'Choice commands:'
    TabOrder = 0
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
        'DisplayMessageDirect'
        'IncreaseVar'
        'DecreaseVar'
        'TextPrompt'
        'RandomNumber'
        'SetRandomMin'
        'SetRandomMax'
        'ExecuteRandom'
        'RunScript')
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
      Top = 139
      Width = 273
      Height = 102
      TabOrder = 5
      OnKeyUp = mmoparamvalKeyUp
    end
    object ScriptSelector: TComboBox
      Left = 240
      Top = 139
      Width = 273
      Height = 21
      TabOrder = 6
      Text = 'ScriptSelector'
      Visible = False
      OnClick = ScriptSelectorClick
    end
  end
  object Button1: TButton
    Left = 457
    Top = 271
    Width = 75
    Height = 32
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
end
