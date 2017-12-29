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
    object def0: TBitBtn
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
      OnClick = def0Click
      ParentFont = False
      TabOrder = 0
    end
    object def: TBitBtn
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
      OnClick = defClick
      ParentFont = False
      TabOrder = 1
    end
    object ref: TBitBtn
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
      OnClick = refClick
      ParentFont = False
      TabOrder = 2
    end
    object reftt: TBitBtn
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
      OnClick = refttClick
      ParentFont = False
      TabOrder = 3
    end
  end
  object MainMenu1: TMainMenu
    left = 344
    top = 200
    object Fichier1: TMenuItem
      Caption = 'Fichier'
      Hint = 'Nouvelle partie'
      object Nouvellepartieaveclesblancs1: TMenuItem
        Caption = 'Nouvelle partie avec les blancs'
        OnClick = Nouvellepartieaveclesblancs1Click
      end
      object Nouvellepartieaveclesnoirs1: TMenuItem
        Caption = 'Nouvelle partie avec les noirs'
        OnClick = Nouvellepartieaveclesnoirs1Click
      end
      object Sauverlapartie1: TMenuItem
        Caption = 'Enregistrer sous...'
        OnClick = Sauverlapartie1Click
      end
      object Chargerunepartie1: TMenuItem
        Caption = 'Ouvrir...'
        OnClick = Chargerunepartie1Click
      end
      object LireEPD1: TMenuItem
        Caption = 'Lire EPD'
        OnClick = LireEPD1Click
      end
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      Visible = False
      OnClick = Stop1Click
    end
    object Niveaux1: TMenuItem
      Caption = 'Niveaux'
      object Niveau35: TMenuItem
        Caption = '3.5 coups    (t = 1)'
        OnClick = Niveau35Click
      end
      object niveau40: TMenuItem
        Caption = '4   coups     (x5)'
        OnClick = niveau40Click
      end
      object niveau45: TMenuItem
        Caption = '4.5 coups    (x40)'
        Checked = True
        OnClick = niveau45Click
      end
      object Niveau50: TMenuItem
        Caption = '5    coups    (x150)'
        OnClick = Niveau50Click
      end
      object Niveau55: TMenuItem
        Caption = '5.5 coups (long!)'
        OnClick = Niveau55Click
      end
      object Niveau60: TMenuItem
        Caption = '6    coups (trиs long !)'
        OnClick = Niveau60Click
      end
      object Niveau65: TMenuItem
        Caption = '6.5  coups (trиs trиs long !)'
        OnClick = Niveau65Click
      end
    end
    object Echiquier1: TMenuItem
      Caption = 'Echiquier'
      object Grand1: TMenuItem
        Caption = 'Petit'
        OnClick = Grand1Click
      end
      object moyen1: TMenuItem
        Caption = 'Moyen'
        OnClick = moyen1Click
      end
      object rsgrand1: TMenuItem
        Caption = 'Grand'
        OnClick = rsgrand1Click
      end
      object ourner1: TMenuItem
        Caption = 'Tourner'
        OnClick = ourner1Click
      end
      object Effacerlesflches1: TMenuItem
        Caption = 'Effacer les flкches'
        Checked = True
        OnClick = Effacerlesflches1Click
      end
      object Bleu1: TMenuItem
        Caption = 'Bleu'
        OnClick = Bleu1Click
      end
      object Olive1: TMenuItem
        Caption = 'Olive'
        OnClick = Olive1Click
      end
    end
    object Outils1: TMenuItem
      Caption = 'Outils'
      object Casesbattuesblancs1: TMenuItem
        Caption = 'Cases contrфlйes par les blancs'
        OnClick = Casesbattuesblancs1Click
      end
      object Casesbattuesnoirs1: TMenuItem
        Caption = 'Cases contrфlйes par les noirs'
        OnClick = Casesbattuesnoirs1Click
      end
    end
    object Apropos1: TMenuItem
      Caption = 'A propos'
      OnClick = Apropos1Click
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.*.txt'
    Filter = 'Txte|*.txt'
    left = 240
    top = 224
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = '.*.zet'
    Filter = 'Fichier Mazette|*.zet'
    left = 144
    top = 112
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.*.zet'
    Filter = 'Fichier Mazette|*.zet'
    left = 184
    top = 112
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    left = 592
    top = 208
  end
end
