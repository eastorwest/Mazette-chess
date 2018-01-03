object Form2: TForm2
  Left = 673
  Height = 147
  Top = 242
  Width = 146
  BorderIcons = []
  Caption = 'Mazette'
  ClientHeight = 147
  ClientWidth = 146
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.8.0.6'
  object rbQueen: TRadioButton
    Left = 48
    Height = 19
    Top = 8
    Width = 52
    Caption = 'Queen'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object rbRook: TRadioButton
    Left = 48
    Height = 19
    Top = 32
    Width = 46
    Caption = 'Rook'
    TabOrder = 1
  end
  object rbBishop: TRadioButton
    Left = 48
    Height = 19
    Top = 56
    Width = 52
    Caption = 'Bishop'
    TabOrder = 2
  end
  object rbKnight: TRadioButton
    Left = 48
    Height = 19
    Top = 80
    Width = 50
    Caption = 'Knight'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 40
    Height = 25
    Top = 110
    Width = 75
    Caption = 'OK'
    OnClick = Button1Click
    TabOrder = 4
  end
end
