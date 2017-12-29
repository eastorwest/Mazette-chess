object Form3: TForm3
  Left = 278
  Height = 115
  Top = 467
  Width = 723
  Caption = 'Form3'
  ClientHeight = 115
  ClientWidth = 723
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.8.0.6'
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 8
    Width = 88
    Caption = 'Enter or copy EPD'
    ParentColor = False
  end
  object Edit1: TEdit
    Left = 2
    Height = 24
    Top = 24
    Width = 713
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    ParentFont = False
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 616
    Height = 33
    Top = 64
    Width = 97
    Caption = 'Back'
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    OnClick = BitBtn1Click
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 2
    Height = 49
    Top = 56
    Width = 129
    ClientHeight = 49
    ClientWidth = 129
    TabOrder = 2
    object RadioButton1: TRadioButton
      Left = 8
      Height = 19
      Top = 8
      Width = 100
      Caption = 'trait а l''ordinateur'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Height = 19
      Top = 24
      Width = 87
      Caption = 'trait а l''humain'
      TabOrder = 1
    end
  end
end
