object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Choice conditions'
  ClientHeight = 299
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 3
    Top = 8
    Width = 529
    Height = 283
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
      Width = 51
      Height = 13
      Caption = 'Command:'
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
    object lstcommands: TListBox
      Left = 8
      Top = 40
      Width = 209
      Height = 177
      ItemHeight = 13
      TabOrder = 0
    end
    object btn8: TButton
      Left = 9
      Top = 223
      Width = 57
      Height = 25
      Caption = 'Add'
      TabOrder = 1
    end
    object btn9: TButton
      Left = 72
      Top = 224
      Width = 57
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
    end
    object cbbcmd: TComboBox
      Left = 240
      Top = 30
      Width = 209
      Height = 21
      TabOrder = 3
      Items.Strings = (
        'SetVar'
        'DisplayMessage'
        'DisplayMessageDirect'
        'IncreaseVar'
        'DecreaseVar'
        'TextPrompt')
    end
    object cbbvarsel: TComboBox
      Left = 240
      Top = 76
      Width = 209
      Height = 21
      TabOrder = 4
    end
    object mmoparamval: TMemo
      Left = 240
      Top = 175
      Width = 273
      Height = 105
      TabOrder = 5
    end
    object evallist: TComboBox
      Left = 240
      Top = 129
      Width = 209
      Height = 21
      TabOrder = 6
      Items.Strings = (
        'is equal to'
        'less than or equal to'
        'less than'
        'larger than or equal to'
        'larger than'
        'not equal to')
    end
  end
end
