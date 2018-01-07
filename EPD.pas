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

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

