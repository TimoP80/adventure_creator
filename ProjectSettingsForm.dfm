object Form9: TForm9
  Left = 0
  Top = 0
  Caption = 'Project Setting s'
  ClientHeight = 172
  ClientWidth = 360
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
  object Label1: TLabel
    Left = 24
    Top = 56
    Width = 68
    Height = 13
    Caption = 'Audio volume:'
  end
  object soundvolumelabel: TLabel
    Left = 254
    Top = 56
    Width = 85
    Height = 13
    AutoSize = False
  end
  object audioenabled: TCheckBox
    Left = 32
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Audio supported'
    TabOrder = 0
  end
  object soundvolume: TJvxSlider
    Left = 98
    Top = 47
    Width = 150
    Height = 40
    MaxValue = 128
    TabOrder = 1
    OnChange = soundvolumeChange
  end
  object debugmode: TCheckBox
    Left = 32
    Top = 93
    Width = 129
    Height = 17
    Caption = 'Enable debug mode'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 197
    Top = 139
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 277
    Top = 139
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
