program Mazette;
// Auteur Montero-Ribas
uses
  Forms,
  ECHEC1 in 'ECHEC1.PAS' {Form1},
  VARIABLES in 'VARIABLES.PAS',
  EVALUATION in 'EVALUATION.PAS',
  FONCTIONS in 'FONCTIONS.PAS',
  DEPLACEMENTS in 'DEPLACEMENTS.PAS',
  PLATEAU in 'PLATEAU.PAS',
  RECHERCHEDECOUPS in 'RECHERCHEDECOUPS.PAS',
  AB in 'AB.PAS' {AboutBox},
  PROMOTION in 'PROMOTION.PAS' {Form2},
  EPD in 'EPD.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mazette';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

