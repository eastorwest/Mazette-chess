// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

program Mazette;

uses
  {$IFDEF FPC}
    {$IFDEF UNIX}
      {$IFDEF UseCThreads} cthreads, {$ENDIF}
    {$ENDIF}
    Interfaces, // this includes the LCL widgetset
  {$ENDIF}
  Forms,
  Echec1 in 'Echec1.pas' {Form1},
  Variables in 'Variables.pas',
  Evaluation in 'Evaluation.pas',
  Fonctions in 'Fonctions.pas',
  Deplacements in 'Deplacements.pas',
  Plateau in 'Plateau.pas',
  Recherchedecoups in 'Recherchedecoups.pas',
  AB in 'AB.pas' {AboutBox},
  Promotion in 'Promotion.pas' {Form2},
  EPD in 'EPD.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

