object Form3: TForm3
  Left = 278
  Height = 92
  Top = 467
  Width = 506
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'EPD'
  ClientHeight = 92
  ClientWidth = 506
  Color = clBtnFace
  Position = poScreenCenter
  LCLVersion = '1.8.0.6'
  object Label1: TLabel
    Left = 8
    Height = 15
    Top = 8
    Width = 116
    Caption = 'Enter or copy EPD text'
    ParentColor = False
  end
  object Edit1: TEdit
    Left = 8
    Height = 23
    Top = 25
    Width = 488
    TabOrder = 0
  end
  object Button1: TButton
    Left = 421
    Height = 25
    Top = 56
    Width = 75
    Caption = 'OK'
    OnClick = Button1Click
    TabOrder = 1
  end
  object RadioButton1: TRadioButton
    Left = 8
    Height = 19
    Top = 56
    Width = 72
    Caption = 'computer'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 100
    Height = 19
    Top = 56
    Width = 58
    Caption = 'human'
    TabOrder = 3
  end
end
