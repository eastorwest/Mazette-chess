object Form1: TForm1
  Left = 385
  Height = 706
  Top = 198
  Width = 843
  Caption = 'Mazette'
  ClientHeight = 686
  ClientWidth = 843
  Color = clBtnFace
  Constraints.MaxHeight = 900
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Menu = MainMenu1
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  Position = poScreenCenter
  LCLVersion = '1.8.0.6'
  object Image1: TImage
    Left = 0
    Height = 661
    Top = 25
    Width = 843
    Align = alClient
    Constraints.MaxHeight = 1000
    Constraints.MaxWidth = 1000
    OnMouseDown = Image1MouseDown
  end
  object Panel1: TPanel
    Left = 0
    Height = 25
    Top = 0
    Width = 843
    Align = alTop
    ClientHeight = 25
    ClientWidth = 843
    TabOrder = 0
    object Label1: TLabel
      Left = 136
      Height = 13
      Top = 6
      Width = 21
      Caption = '       '
      ParentColor = False
    end
    object Label4: TLabel
      Left = 403
      Height = 1
      Top = 6
      Width = 1
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      ParentColor = False
      ParentFont = False
    end
    object Label5: TLabel
      Left = 552
      Height = 1
      Top = 8
      Width = 1
      ParentColor = False
    end
    object btnFirstMove: TBitBtn
      Left = 0
      Height = 25
      Top = 0
      Width = 33
      Caption = '<<'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      OnClick = btnFirstMoveClick
      ParentFont = False
      TabOrder = 0
    end
    object btnPrevMove: TBitBtn
      Left = 32
      Height = 25
      Top = 0
      Width = 33
      Caption = '<'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      OnClick = btnPrevMoveClick
      ParentFont = False
      TabOrder = 1
    end
    object btnNextMove: TBitBtn
      Left = 64
      Height = 25
      Top = 0
      Width = 33
      Caption = '>'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      OnClick = btnNextMoveClick
      ParentFont = False
      TabOrder = 2
    end
    object btnLastMove: TBitBtn
      Left = 96
      Height = 25
      Top = 0
      Width = 33
      Caption = '>>'
      Enabled = False
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      OnClick = btnLastMoveClick
      ParentFont = False
      TabOrder = 3
    end
  end
  object MainMenu1: TMainMenu
    left = 344
    top = 200
    object miFile: TMenuItem
      Caption = 'File'
      Hint = 'Nouvelle partie'
      object Nouvellepartieaveclesblancs1: TMenuItem
        Caption = 'New game White'
        OnClick = Nouvellepartieaveclesblancs1Click
      end
      object Nouvellepartieaveclesnoirs1: TMenuItem
        Caption = 'New game Black'
        OnClick = Nouvellepartieaveclesnoirs1Click
      end
      object miSaveGame: TMenuItem
        Caption = 'Save game...'
        OnClick = miSaveGameClick
      end
      object miOpenGame: TMenuItem
        Caption = 'Open game...'
        OnClick = miOpenGameClick
      end
      object miExportGame: TMenuItem
        Caption = 'Export game'
        OnClick = miExportGameClick
      end
      object LireEPD1: TMenuItem
        Caption = 'Read EPD'
        OnClick = LireEPD1Click
      end
      object miExit: TMenuItem
        Caption = 'Exit'
        OnClick = miExitClick
      end
    end
    object miStop: TMenuItem
      Caption = 'Stop'
      Visible = False
      OnClick = miStopClick
    end
    object Niveaux1: TMenuItem
      Caption = 'Depth'
      object Niveau35: TMenuItem
        Caption = '3.5 ply    (t = 1)'
        OnClick = Niveau35Click
      end
      object niveau40: TMenuItem
        Caption = '4   ply     (x5)'
        OnClick = niveau40Click
      end
      object niveau45: TMenuItem
        Caption = '4.5 ply    (x40)'
        Checked = True
        OnClick = niveau45Click
      end
      object Niveau50: TMenuItem
        Caption = '5    ply    (x150)'
        OnClick = Niveau50Click
      end
      object Niveau55: TMenuItem
        Caption = '5.5 ply (long!)'
        OnClick = Niveau55Click
      end
      object Niveau60: TMenuItem
        Caption = '6    ply (very long !)'
        OnClick = Niveau60Click
      end
      object Niveau65: TMenuItem
        Caption = '6.5  ply (very very long !)'
        OnClick = Niveau65Click
      end
    end
    object miBoard: TMenuItem
      Caption = 'Board'
      object Grand1: TMenuItem
        Caption = 'Small'
        OnClick = Grand1Click
      end
      object moyen1: TMenuItem
        Caption = 'Medium'
        OnClick = moyen1Click
      end
      object rsgrand1: TMenuItem
        Caption = 'Large'
        OnClick = rsgrand1Click
      end
      object ourner1: TMenuItem
        Caption = 'Rotate'
        OnClick = ourner1Click
      end
      object Effacerlesflches1: TMenuItem
        Caption = 'Delete arrows'
        Checked = True
        OnClick = Effacerlesflches1Click
      end
      object Bleu1: TMenuItem
        Caption = 'Blue'
        OnClick = Bleu1Click
      end
      object Olive1: TMenuItem
        Caption = 'Olive'
        OnClick = Olive1Click
      end
    end
    object Outils1: TMenuItem
      Caption = 'Tools'
      object Casesbattuesblancs1: TMenuItem
        Caption = 'Control squares White'
        OnClick = Casesbattuesblancs1Click
      end
      object Casesbattuesnoirs1: TMenuItem
        Caption = 'Control squares Black'
        OnClick = Casesbattuesnoirs1Click
      end
    end
    object miAbout: TMenuItem
      Caption = 'About'
      OnClick = miAboutClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.*.txt'
    Filter = 'Txte|*.txt'
    left = 144
    top = 216
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = '.*.zet'
    Filter = 'Fichier Mazette|*.zet'
    left = 144
    top = 112
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.*.zet'
    Filter = 'Fichier Mazette (*.zet)|*.zet'
    left = 224
    top = 112
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    left = 592
    top = 208
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '.*.txt'
    Filter = 'ASCII text (*.txt)|*.txt'
    left = 224
    top = 288
  end
end
