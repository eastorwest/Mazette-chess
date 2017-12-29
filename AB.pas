// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit AB;

interface

uses
  {$IFnDEF FPC}
  Windows,
  {$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

end.

