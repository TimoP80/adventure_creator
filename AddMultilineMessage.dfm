object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Add Multiline message'
  ClientHeight = 419
  ClientWidth = 710
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
  object Label2: TLabel
    Left = 14
    Top = 8
    Width = 74
    Height = 13
    Caption = 'Message items:'
  end
  object StringsList: TMemo
    Left = 14
    Top = 27
    Width = 689
    Height = 339
    TabOrder = 0
  end
  object Button1: TButton
    Left = 546
    Top = 372
    Width = 75
    Height = 36
    Caption = 'Create'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 627
    Top = 372
    Width = 75
    Height = 36
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object LineDelay: TCheckBox
    Left = 14
    Top = 381
    Width = 139
    Height = 17
    Caption = 'Add delay to each line'
    TabOrder = 3
    OnClick = LineDelayClick
  end
  object DelayAmount: TEdit
    Left = 144
    Top = 379
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 4
  end
end
