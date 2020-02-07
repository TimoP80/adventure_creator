object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Script Editor'
  ClientHeight = 670
  ClientWidth = 1089
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
    Width = 51
    Height = 13
    Caption = 'Script list>'
  end
  object Label2: TLabel
    Left = 383
    Top = 101
    Width = 57
    Height = 13
    Caption = 'Script code:'
  end
  object Label3: TLabel
    Left = 383
    Top = 24
    Width = 61
    Height = 13
    Caption = 'Script Name:'
  end
  object Label4: TLabel
    Left = 383
    Top = 51
    Width = 46
    Height = 13
    Caption = 'Filename:'
  end
  object Label5: TLabel
    Left = 383
    Top = 78
    Width = 37
    Height = 13
    Caption = 'Author:'
  end
  object Label6: TLabel
    Left = 383
    Top = 424
    Width = 100
    Height = 14
    Caption = 'Compiled Data View:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ScriptList: TListBox
    Left = 8
    Top = 24
    Width = 369
    Height = 607
    ItemHeight = 13
    TabOrder = 0
    OnClick = ScriptListClick
  end
  object Button1: TButton
    Left = 8
    Top = 637
    Width = 75
    Height = 25
    Caption = 'New Script'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 637
    Width = 75
    Height = 25
    Caption = 'Delete Script'
    TabOrder = 2
    OnClick = Button2Click
  end
  object SynEdit1: TSynEdit
    Left = 383
    Top = 120
    Width = 697
    Height = 297
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'DejaVu Sans Mono'
    Font.Style = []
    TabOrder = 3
    OnKeyUp = SynEdit1KeyUp
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = False
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Gradient = True
    Gutter.GradientEndColor = clSilver
    Gutter.GradientSteps = 35
    Highlighter = SynCSSyn1
    FontSmoothing = fsmClearType
  end
  object ScriptName: TEdit
    Left = 450
    Top = 21
    Width = 287
    Height = 21
    TabOrder = 4
    OnKeyUp = ScriptNameKeyUp
  end
  object ScriptFilename: TEdit
    Left = 450
    Top = 48
    Width = 287
    Height = 21
    TabOrder = 5
    OnKeyUp = ScriptFilenameKeyUp
  end
  object ScriptAuthor: TEdit
    Left = 450
    Top = 75
    Width = 287
    Height = 21
    TabOrder = 6
    OnKeyUp = ScriptAuthorKeyUp
  end
  object Button3: TButton
    Left = 1006
    Top = 640
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 7
  end
  object Button4: TButton
    Left = 1006
    Top = 73
    Width = 75
    Height = 25
    Caption = 'Run Script'
    TabOrder = 8
    OnClick = Button4Click
  end
  object compileddataview: TMemo
    Left = 383
    Top = 444
    Width = 698
    Height = 187
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object Button5: TButton
    Left = 1006
    Top = 42
    Width = 75
    Height = 25
    Caption = 'Compile Script'
    TabOrder = 10
    OnClick = Button5Click
  end
  object IsBootScript: TCheckBox
    Left = 768
    Top = 24
    Width = 185
    Height = 17
    Caption = 'Execute this script at game start'
    TabOrder = 11
    OnClick = IsBootScriptClick
  end
  object SynCSSyn1: TSynCSSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    IdentifierAttri.Foreground = clBackground
    StringAttri.Foreground = clMaroon
    Left = 800
    Top = 440
  end
  object SynCompletionProposal1: TSynCompletionProposal
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    ShortCut = 16416
    Editor = SynEdit1
    Left = 864
    Top = 56
  end
end
