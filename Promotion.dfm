object Form2: TForm2
  Left = 673
  Top = 242
  Width = 194
  Height = 172
  Caption = 'Mazette'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RadioButton1: TRadioButton
    Left = 48
    Top = 8
    Width = 57
    Height = 17
    Caption = 'Reine ?'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 48
    Top = 32
    Width = 49
    Height = 17
    Caption = 'Tour ?'
    TabOrder = 1
  end
  object RadioButton3: TRadioButton
    Left = 48
    Top = 56
    Width = 57
    Height = 17
    Caption = 'Fou ?'
    TabOrder = 2
  end
  object RadioButton4: TRadioButton
    Left = 48
    Top = 80
    Width = 73
    Height = 17
    Caption = 'Cavalier ?'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 40
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Valider'
    TabOrder = 4
    OnClick = Button1Click
  end
end
