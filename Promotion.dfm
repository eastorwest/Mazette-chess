object Form2: TForm2
  Left = 673
  Height = 152
  Top = 242
  Width = 150
  Caption = 'Mazette'
  ClientHeight = 152
  ClientWidth = 150
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.8.0.6'
  object RadioButton1: TRadioButton
    Left = 48
    Height = 19
    Top = 8
    Width = 52
    Caption = 'Queen'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 48
    Height = 19
    Top = 32
    Width = 46
    Caption = 'Rook'
    TabOrder = 1
  end
  object RadioButton3: TRadioButton
    Left = 48
    Height = 19
    Top = 56
    Width = 52
    Caption = 'Bishop'
    TabOrder = 2
  end
  object RadioButton4: TRadioButton
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
