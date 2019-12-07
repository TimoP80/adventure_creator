object Form2: TForm2
  Left = 798
  Top = 501
  Caption = 'Game metadata'
  ClientHeight = 274
  ClientWidth = 409
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
  object lbl1: TLabel
    Left = 16
    Top = 24
    Width = 24
    Height = 13
    Caption = 'Title:'
  end
  object lbl2: TLabel
    Left = 16
    Top = 56
    Width = 37
    Height = 13
    Caption = 'Author:'
  end
  object lbl3: TLabel
    Left = 16
    Top = 80
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object edttitle: TEdit
    Left = 64
    Top = 16
    Width = 329
    Height = 21
    TabOrder = 0
    OnKeyUp = edttitleKeyUp
  end
  object edtauthor: TEdit
    Left = 64
    Top = 48
    Width = 329
    Height = 21
    TabOrder = 1
    OnKeyUp = edtauthorKeyUp
  end
  object mmodescription: TMemo
    Left = 16
    Top = 96
    Width = 377
    Height = 137
    TabOrder = 2
    OnKeyUp = mmodescriptionKeyUp
  end
  object btn1: TButton
    Left = 312
    Top = 240
    Width = 81
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
end
