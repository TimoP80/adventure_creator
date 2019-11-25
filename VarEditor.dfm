object Form3: TForm3
  Left = 774
  Top = 281
  Width = 556
  Height = 347
  Caption = 'Variable Editor'
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
    Left = 8
    Top = 16
    Width = 58
    Height = 13
    Caption = 'Variable list:'
  end
  object lbl2: TLabel
    Left = 272
    Top = 32
    Width = 89
    Height = 13
    AutoSize = False
    Caption = 'Variable name'
  end
  object lbl3: TLabel
    Left = 272
    Top = 80
    Width = 89
    Height = 13
    AutoSize = False
    Caption = 'Starting value:'
  end
  object lstvarlist: TListBox
    Left = 8
    Top = 32
    Width = 241
    Height = 225
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstvarlistClick
  end
  object btn1: TButton
    Left = 16
    Top = 264
    Width = 81
    Height = 33
    Caption = 'Add Var'
    TabOrder = 1
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 104
    Top = 264
    Width = 105
    Height = 33
    Caption = 'Delete Var'
    TabOrder = 2
    OnClick = btn2Click
  end
  object edtvarname: TEdit
    Left = 272
    Top = 48
    Width = 249
    Height = 21
    TabOrder = 3
    OnKeyUp = edtvarnameKeyUp
  end
  object edtstartval: TEdit
    Left = 272
    Top = 96
    Width = 249
    Height = 21
    TabOrder = 4
    OnKeyUp = edtstartvalKeyUp
  end
  object btn3: TButton
    Left = 432
    Top = 264
    Width = 97
    Height = 33
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 5
  end
end
