object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Choice conditions'
  ClientHeight = 345
  ClientWidth = 539
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
    Height = 297
    Caption = 'Choice conditions'
    TabOrder = 0
    object lbl8: TLabel
      Left = 8
      Top = 24
      Width = 61
      Height = 13
      Caption = 'Condition list'
    end
    object lbl9: TLabel
      Left = 240
      Top = 11
      Width = 75
      Height = 13
      Caption = 'Condiion Name:'
    end
    object lbl10: TLabel
      Left = 240
      Top = 57
      Width = 42
      Height = 13
      Caption = 'Variable:'
    end
    object lbl11: TLabel
      Left = 240
      Top = 156
      Width = 83
      Height = 13
      Caption = 'Parameter value:'
    end
    object Label1: TLabel
      Left = 240
      Top = 110
      Width = 54
      Height = 13
      Caption = 'Evaluation:'
    end
    object lstconditions: TListBox
      Left = 3
      Top = 40
      Width = 209
      Height = 177
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstconditionsClick
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
      Top = 30
      Width = 209
      Height = 21
      TabOrder = 3
      OnClick = cbbcmdClick
      Items.Strings = (
        'VariableValue')
    end
    object cbbvarsel: TComboBox
      Left = 240
      Top = 76
      Width = 209
      Height = 21
      TabOrder = 4
      OnClick = cbbvarselClick
    end
    object mmoparamval: TMemo
      Left = 240
      Top = 175
      Width = 273
      Height = 105
      TabOrder = 5
      OnKeyUp = mmoparamvalKeyUp
    end
    object evallist: TComboBox
      Left = 240
      Top = 129
      Width = 209
      Height = 21
      TabOrder = 6
      OnClick = evallistClick
      Items.Strings = (
        'is equal to'
        'less than or equal to'
        'less than'
        'larger than or equal to'
        'larger than'
        'not equal to')
    end
  end
  object Button1: TButton
    Left = 452
    Top = 311
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
end
