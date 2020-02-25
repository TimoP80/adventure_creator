object Form10: TForm10
  Left = 0
  Top = 0
  Caption = 'Additional files'
  ClientHeight = 557
  ClientWidth = 997
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
    Left = 624
    Top = 24
    Width = 26
    Height = 13
    Caption = 'Path:'
  end
  object Label2: TLabel
    Left = 624
    Top = 70
    Width = 46
    Height = 13
    Caption = 'Filename:'
  end
  object Label3: TLabel
    Left = 624
    Top = 116
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object Label4: TLabel
    Left = 8
    Top = 10
    Width = 36
    Height = 13
    Caption = 'File list:'
  end
  object Label5: TLabel
    Left = 624
    Top = 162
    Width = 28
    Height = 13
    Caption = 'Type:'
  end
  object Label6: TLabel
    Left = 624
    Top = 210
    Width = 66
    Height = 13
    Caption = 'File to import:'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 29
    Width = 601
    Height = 489
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object Button1: TButton
    Left = 8
    Top = 524
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 524
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 2
    OnClick = Button2Click
  end
  object filepath: TEdit
    Left = 624
    Top = 43
    Width = 355
    Height = 21
    TabOrder = 3
    OnKeyUp = filepathKeyUp
  end
  object filename: TEdit
    Left = 624
    Top = 89
    Width = 355
    Height = 21
    TabOrder = 4
    OnKeyUp = filenameKeyUp
  end
  object filedesc: TEdit
    Left = 624
    Top = 135
    Width = 355
    Height = 21
    TabOrder = 5
    OnKeyUp = filedescKeyUp
  end
  object Button3: TButton
    Left = 914
    Top = 524
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 6
  end
  object Button5: TButton
    Left = 904
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Import file'
    TabOrder = 7
    OnClick = Button5Click
  end
  object JvFilenameEdit1: TJvFilenameEdit
    Left = 624
    Top = 229
    Width = 355
    Height = 21
    TabOrder = 8
    Text = ''
  end
  object typeselector: TComboBox
    Left = 624
    Top = 181
    Width = 355
    Height = 21
    TabOrder = 9
    OnClick = typeselectorClick
    Items.Strings = (
      'audio'
      'text'
      'xml')
  end
end
