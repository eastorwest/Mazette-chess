object Form3: TForm3
  Left = 600
  Top = 314
  Width = 915
  Height = 174
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 158
    Height = 13
    Caption = 'Entrez ou collez une cha'#238'ne EPD'
  end
  object Edit1: TEdit
    Left = 0
    Top = 24
    Width = 713
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 616
    Top = 64
    Width = 97
    Height = 33
    Caption = 'Retour'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 56
    Width = 129
    Height = 49
    TabOrder = 2
    object RadioButton1: TRadioButton
      Left = 8
      Top = 8
      Width = 113
      Height = 17
      Caption = 'trait '#224' l'#39'ordinateur'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 24
      Width = 113
      Height = 17
      Caption = 'trait '#224' l'#39'humain'
      TabOrder = 1
    end
  end
end
