object Form11: TForm11
  Left = 0
  Top = 0
  Caption = 'Audio devices'
  ClientHeight = 469
  ClientWidth = 820
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
    Left = 8
    Top = 8
    Width = 52
    Height = 13
    Caption = 'Device list:'
  end
  object devicename: TLabel
    Left = 384
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Device name:'
  end
  object Label2: TLabel
    Left = 383
    Top = 62
    Width = 67
    Height = 13
    Caption = 'Device driver:'
  end
  object Label3: TLabel
    Left = 384
    Top = 112
    Width = 29
    Height = 13
    Caption = 'Flags:'
  end
  object ListBox1: TListBox
    Left = 8
    Top = 27
    Width = 369
    Height = 398
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object Close: TButton
    Left = 737
    Top = 432
    Width = 75
    Height = 29
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 1
  end
  object edtdevicename: TEdit
    Left = 383
    Top = 35
    Width = 429
    Height = 21
    TabOrder = 2
  end
  object edtdevicedriver: TEdit
    Left = 383
    Top = 81
    Width = 418
    Height = 21
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 383
    Top = 131
    Width = 177
    Height = 17
    Caption = 'BASS_DEVICE_ENABLED'
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 383
    Top = 153
    Width = 177
    Height = 26
    Caption = 'BASS_DEVICE_INIT'
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 383
    Top = 177
    Width = 177
    Height = 26
    Caption = 'BASS_DEVICE_DEFAULT'
    TabOrder = 6
  end
end
