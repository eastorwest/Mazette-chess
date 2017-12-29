unit ab;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
  private
    { déclarations privées }
  public
    { déclarations publiques }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

end.

