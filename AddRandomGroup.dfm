object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Add Random string group'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 77
    Height = 13
    Caption = 'String group ID:'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 91
    Height = 13
    Caption = 'String group items:'
  end
  object GroupID: TEdit
    Left = 107
    Top = 13
    Width = 520
    Height = 21
    TabOrder = 0
  end
  object StringsList: TMemo
    Left = 24
    Top = 75
    Width = 603
    Height = 174
    TabOrder = 1
  end
  object Button1: TButton
    Left = 472
    Top = 255
    Width = 75
    Height = 36
    Caption = 'Create'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 553
    Top = 255
    Width = 75
    Height = 36
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
