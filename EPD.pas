// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit EPD;

interface

uses
  {$IFnDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Buttons, ExtCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

