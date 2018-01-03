// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Promotion;

interface

uses
  {$IFnDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    rbQueen: TRadioButton;
    rbRook: TRadioButton;
    rbBishop: TRadioButton;
    rbKnight: TRadioButton;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Variables;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if rbQueen.Checked then
    ModalResult := Reine
  else
  if rbRook.Checked then
    ModalResult := Tour
  else
  if rbBishop.Checked then
    ModalResult := Fou
  else
  if rbKnight.Checked then
    ModalResult := Cavalier;
end;

end.

