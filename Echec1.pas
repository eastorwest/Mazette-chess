// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Echec1;

interface

uses
  {$IFnDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons,
  Variables, Plateau;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Nouvellepartieaveclesblancs1: TMenuItem;
    Niveaux1: TMenuItem;
    Echiquier1: TMenuItem;
    Grand1: TMenuItem;
    rsgrand1: TMenuItem;
    Apropos1: TMenuItem;
    Label4: TLabel;
    Niveau35: TMenuItem;
    OpenDialog1: TOpenDialog;
    niveau40: TMenuItem;
    ourner1: TMenuItem;
    Nouvellepartieaveclesnoirs1: TMenuItem;
    Sauverlapartie1: TMenuItem;
    Chargerunepartie1: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    niveau45: TMenuItem;
    LireEPD1: TMenuItem;
    def0: TBitBtn;
    def: TBitBtn;
    ref: TBitBtn;
    reftt: TBitBtn;
    moyen1: TMenuItem;
    Effacerlesflches1: TMenuItem;
    Niveau50: TMenuItem;
    Stop1: TMenuItem;
    Bleu1: TMenuItem;
    Olive1: TMenuItem;
    Label5: TLabel;
    Niveau55: TMenuItem;
    Niveau60: TMenuItem;
    Niveau65: TMenuItem;
    Timer1: TTimer;
    Outils1: TMenuItem;
    Casesbattuesblancs1: TMenuItem;
    Casesbattuesnoirs1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Nouvellepartieaveclesblancs1Click(Sender: TObject);
    procedure Grand1Click(Sender: TObject);
    procedure rsgrand1Click(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure Niveau35Click(Sender: TObject);
    procedure niveau40Click(Sender: TObject);
    procedure ourner1Click(Sender: TObject);
    procedure Nouvellepartieaveclesnoirs1Click(Sender: TObject);
    procedure Sauverlapartie1Click(Sender: TObject);
    procedure Chargerunepartie1Click(Sender: TObject);
    procedure niveau45Click(Sender: TObject);
    procedure Niveau50Click(Sender: TObject);
    procedure LireEPD1Click(Sender: TObject);
    procedure defClick(Sender: TObject);
    procedure refClick(Sender: TObject);
    procedure def0Click(Sender: TObject);
    procedure refttClick(Sender: TObject);
    procedure moyen1Click(Sender: TObject);
    procedure Effacerlesflches1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Bleu1Click(Sender: TObject);
    procedure Olive1Click(Sender: TObject);
    procedure Niveau55Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Niveau60Click(Sender: TObject);
    procedure Niveau65Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure Casesbattuesblancs1Click(Sender: TObject);
    procedure Casesbattuesnoirs1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Math, IniFiles,
  Deplacements, Fonctions, AB, Promotion, Recherchedecoups, EPD;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EPD_encours := False;
  champ := TStrings.Create;
  randomize;
  Couleur_Fond := 8421376;
  DoubleBuffered := True;
  left := 10;
  top := 10;
  initialisation(posit);
  largeur := 95;
  dessine(posit);
  largeur := 80;
  dessine(posit);
  init_prof := 9;
  Partie_en_cours := False;
  Form1.Label1.Caption := '';
  Nb_Tour := 0;
  Fillchar(zero, sizeof(zero), 0);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  dessine(posit_dessin);
end;

function danslaliste(ca: integer; var ef: integer): boolean;
var
  i: integer;
begin
  for i := 1 to Coups_Possibles.Nb_pos do
    if ca = Coups_Possibles.position[i, 2] then
    begin
      Result := True;
      ef := Coups_Possibles.position[i, 3];
      exit;
    end;
  Result := False;
end;

procedure inc_historique(la, labas, la_ef: integer);
begin
  Combien_hist := Index_hist;
  Inc(Combien_hist);
  Index_hist := Combien_hist;
  with hist_int[Combien_hist] do
  begin
    depart := la;
    arrivee := labas;
    efface := la_ef;
    QuoiDedans := posit.Cases[labas];
  end;
end;

procedure Ordinateur;
var
  i: integer;
  possibles: T_Liste_Coup;
  b, trouve: boolean;
  s: string;
  mouv_str: T_str12;
begin
  form1.Stop1.Visible := True;
  form1.Fichier1.Visible := False;
  form1.Outils1.Visible := False;
  form1.Label5.Caption := '';
  historique := '';
  Posit_dessin := posit;
  enabler(False, False, False, False);
  for i := 1 to min(combien_hist, 20) do
    historique := historique + cartesien(hist_int[i].depart) +
      cartesien(hist_int[i].arrivee);
  Complexite := 0; {Debut:Complexite=88    finale pion : 3 ou 4}
  for i := 0 to 63 do
    case abs(Posit.Cases[i]) of
      6: Inc(complexite, 1);
      5: Inc(complexite, 5);
      3, 4: Inc(complexite, 4);
      2: Inc(complexite, 10);
    end;
  profope := init_prof;
  case complexite of
    0..7: profope := Init_Prof + 2;
    8..30: profope := Init_Prof + 1;
    31..100: Profope := Init_Prof;
  end;
  s := 'Analyse : ' + strint(profope div 2);
  if odd(profope) then
    s := s + '.5';
  s := s + ' coups';
  form1.label4.Caption := s;
  form1.Fichier1.Enabled := False;
  h := GetTickCount;
  Nb_Eval := 0;
  b := suivant(historique, best_depart, best_arrivee);
  if b then
  begin
    best_efface := best_depart;
    Coups_Possibles.Nb_pos := 0;
    if (couleur_ordi and (posit.Cases[best_depart] >= 0)) or
      (not couleur_ordi and (posit.Cases[best_depart] <= 0)) then
      b := False
    else
    begin
      if couleur_Ordi then
        coups_Noirs(coups_possibles, best_depart)
      else
        coups_blancs(coups_possibles, best_depart);
      trouve := False;
      for i := 1 to Coups_Possibles.Nb_pos do
        if Coups_Possibles.position[i, 2] = best_arrivee then
          trouve := True;
      b := trouve;
    end;
  end;
  if not b then
    Recherche(Couleur_Ordi);
  if partie_en_cours then
  begin
    mouv_str := mouv(best_depart, best_arrivee);
    jouer(best_depart, best_arrivee, best_efface);
    Empile_Rep;
    inc_historique(best_depart, best_arrivee, best_efface);
    dessine(posit);
    posit_dessin := posit;
    Marque_Une_Case(best_arrivee div 8, best_arrivee mod 8, Clblue);
    Marque_Une_Case(best_depart div 8, best_depart mod 8, Clblue);
    form1.Label4.Caption := mouv_str;
  end;
  if (couleur_ordi and souslefeu(posit.position_roi[False], 1, False)) or
    (not couleur_ordi and souslefeu(posit.position_roi[True], -1, False)) then
  begin
    form1.label1.Caption := 'Echec';
    generer_liste_coup(coups_possibles, not couleur_ordi);
    possibles := Coups_Possibles;
    if possibles.Nb_pos = 0 then
      ShowMessage('Mat');
  end;
  enabler(True, True, False, False);
  form1.Fichier1.Enabled := True;
  form1.Stop1.Visible := False;
  form1.Fichier1.Visible := True;
  form1.Outils1.Visible := True;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  labas, la_ef: integer;
  promo: boolean;
  li, co: integer;
begin
  if not partie_en_cours then
    exit;
  if Couleur_Ordi xor (not Odd(Index_Hist)) xor (EPD_noir_dabord and
    EPD_encours){ XOR EPD_swap } then
  begin
    ShowMessage('Ce n''est pas votre tour de jouer !');
    exit;
  end;
  if button = mbLeft then
  begin
    if not Coups_en_cours then
    begin
      la := x div largeur + 8 * (y div largeur);
      detourne(li, co, la);
      if ((posit.Cases[la] <= 0) and couleur_Ordi) or
        ((posit.Cases[la] >= 0) and not couleur_Ordi) then
        exit;
      Coups_Possibles.Nb_pos := 0;
      if couleur_Ordi then
      begin
        Cases_battues_par_noirs;
        coups_blancs(coups_possibles, la);
      end
      else
      begin
        Cases_battues_par_blancs;
        coups_Noirs(coups_possibles, la);
      end;
      marque_possible;
      if Coups_Possibles.Nb_pos <> 0 then
        Coups_en_cours := True;
    end
    else
    begin
      enabler(False, False, False, False);
      coups_en_cours := False;
      labas := x div largeur + 8 * (y div largeur);
      detourne(li, co, labas);
      if danslaliste(labas, la_ef) then
      begin
        with posit do
          with form2 do
            if couleur_Ordi then
            begin
              promo := ((labas <= 7) and (Cases[la] = pion));
              jouer(la, labas, la_ef);
              if promo then {promotion pour les blancs}
              begin
                showmodal;
                if RadioButton1.Checked then
                  Cases[labas] := Reine
                else
                if RadioButton2.Checked then
                  Cases[labas] := Tour
                else
                if RadioButton3.Checked then
                  Cases[labas] := Fou
                else
                if RadioButton4.Checked then
                  Cases[labas] := Cavalier;
                recalcule;
              end;
            end
            else
            begin
              promo := ((labas >= 56) and (Cases[la] = pionNoir));
              jouer(la, labas, la_ef);
              if promo then {promotion pour les noirs}
              begin
                showmodal;
                if RadioButton1.Checked then
                  Cases[labas] := ReineNoir
                else
                if RadioButton2.Checked then
                  Cases[labas] := TourNoir
                else
                if RadioButton3.Checked then
                  Cases[labas] := FouNoir
                else
                if RadioButton4.Checked then
                  Cases[labas] := CavalierNoir;
                recalcule;
              end;
            end;
        inc_historique(la, labas, la_ef);
        Empile_Rep;
        dessine(posit);
        Marque_Une_Case(la div 8, la mod 8, Clred);
        Marque_Une_Case(labas div 8, labas mod 8, Clred);
        Ordinateur;
      end
      else
        dessine(posit);
    end;
  end;
  enabler(True, True, False, False);
end;

procedure retire_checked;
begin
  Form1.Niveau35.Checked := False;
  Form1.niveau40.Checked := False;
  Form1.niveau45.Checked := False;
  Form1.Niveau50.Checked := False;
  form1.Niveau55.Checked := False;
  form1.Niveau60.Checked := False;
  form1.Niveau65.Checked := False;
end;

procedure TForm1.Nouvellepartieaveclesblancs1Click(Sender: TObject);
begin
  EPD_encours := False;
  Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
  form1.Label1.Caption := '';
  Couleur_Ordi := True;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 0;
  initialisation(posit);
  dessine(posit);
  Partie_en_cours := True;
end;

procedure TForm1.Nouvellepartieaveclesnoirs1Click(Sender: TObject);
var
  rr, la, labas: integer;
begin
  EPD_encours := False;
  Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
  form1.Label1.Caption := '';
  Couleur_Ordi := False;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 2;
  initialisation(posit);
  rr := random(7) + 1;
  case rr of
    1, 2, 3:
    begin
      la := enchiffre('e2');
      labas := enchiffre('e4');
    end;
    4:
    begin
      la := enchiffre('d2');
      labas := enchiffre('d4');
    end;
    5:
    begin
      la := enchiffre('f2');
      labas := enchiffre('f4');
    end;
    6:
    begin
      la := enchiffre('c2');
      labas := enchiffre('c4');
    end;
    7:
    begin
      la := enchiffre('b2');
      labas := enchiffre('b4');
    end;
  end;
  jouer(la, labas, la);
  dessine(posit);
  inc_historique(la, labas, la);
  Partie_en_cours := True;
end;

procedure TForm1.niveau45Click(Sender: TObject);
begin
  Init_Prof := 9;
  retire_checked;
  niveau45.Checked := True;
end;

procedure TForm1.Grand1Click(Sender: TObject);
begin
  largeur := 60;
  dessine(posit_dessin);
end;

procedure TForm1.rsgrand1Click(Sender: TObject);
begin
  largeur := 95;
  dessine(posit_dessin);
end;

procedure TForm1.Apropos1Click(Sender: TObject);
begin
  AboutBox.showmodal;
end;

procedure TForm1.Niveau35Click(Sender: TObject);
begin
  Init_Prof := 7;
  retire_checked;
  Niveau35.Checked := True;
end;

procedure restitue(jusque: integer);
var
  i: integer;
begin
  for i := 1 to jusque do
  begin
    empile_Rep;
    jouer(hist_int[i].depart, hist_int[i].arrivee, hist_int[i].efface);
    posit.Cases[hist_int[i].arrivee] := hist_int[i].QuoiDedans;
  end;
  dessine(posit);
  posit_dessin := posit;
end;

procedure TForm1.niveau40Click(Sender: TObject);
begin
  Init_Prof := 8;
  retire_checked;
  niveau40.Checked := True;
end;

procedure TForm1.ourner1Click(Sender: TObject);
begin
  Nb_Tour := (Nb_Tour + 1) mod 4;
  dessine(posit_dessin);
end;

procedure TForm1.Sauverlapartie1Click(Sender: TObject);
var
  F: file;
begin
  if SaveDialog1.Execute then
  begin
    nomdefichier := SaveDialog1.Filename;
    if FileExists(nomdefichier) then
      if MessageDlg('Le fichier existe déja, voulez-vous le remplacer ?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        exit;
    assignfile(F, nomdefichier);
    ReWrite(f, 1);
    try
      BlockWrite(f, Couleur_Ordi, SizeOf(Couleur_Ordi));
      BlockWrite(f, Index_hist, SizeOf(Index_hist));
      BlockWrite(f, Combien_hist, SizeOf(Combien_hist));
      BlockWrite(f, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(f);
    end;
  end;
end;

procedure TForm1.Chargerunepartie1Click(Sender: TObject);
var
  f: file;
begin
  if openDialog2.Execute then
  begin
    nomdefichier := OpenDialog2.Filename;
    Index_hist := 0;
    initialisation(posit);
    Partie_en_cours := True;
    ASSIGNfile(F, nomdefichier);
    ReSet(f, 1);
    try
      BlockRead(f, Couleur_Ordi, SizeOf(Couleur_Ordi));
      BlockRead(f, Index_hist, SizeOf(Index_hist));
      BlockRead(f, Combien_hist, SizeOf(Combien_hist));
      BlockRead(f, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(f);
    end;
    if Couleur_Ordi then
      Nb_Tour := 0
    else
      Nb_Tour := 2;
    restitue(Index_hist);
    dessine(posit);
    posit_dessin := posit;
    enabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  end;
end;


procedure TForm1.Niveau50Click(Sender: TObject);
begin
  Init_Prof := 10;
  retire_checked;
  Niveau50.Checked := True;
end;

procedure TForm1.LireEPD1Click(Sender: TObject);
begin
  Form3.showmodal;
  Form3.edit1.SelectAll;
  initialisation(lechiquier);
  if length(form3.edit1.Text) > 0 then
    if EpdToEchiquier(form3.edit1.Text) then
    begin
      Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
      EPD_encours := True;
      EPD_noir_dabord := False;
      EPD_swap := False;
      Combien_hist := 0;
      Index_hist := 0;
      Partie_en_cours := True;
      posit := lechiquier;
      recalcule;
      if couleur_ordi = True then
      begin
        Nb_Tour := 0;
        EPD_noir_dabord := True;
      end
      else
        Nb_Tour := 2;
      dessine(posit);
      if not form3.RadioButton1.Checked then
      begin
        EPD_swap := True;
        couleur_ordi := not couleur_ordi;
      end
      else
        EPD_swap := False;
      if not EPD_swap then
        Ordinateur;
    end;
end;

procedure TForm1.defClick(Sender: TObject);
begin
  if Index_hist < 1 then
    exit;
  Coups_en_cours := False;
  if not EPD_encours then
    initialisation(posit)
  else
    posit := Lechiquier;
  Dec(Index_hist, 1);
  enabler(Index_hist > 0, Index_hist > 0, True, True);
  restitue(Index_Hist);
  posit_dessin := posit;
end;

procedure TForm1.refClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then
    exit;
  Coups_en_cours := False;
  if not EPD_encours then
    initialisation(posit)
  else
    posit := Lechiquier;
  Inc(Index_hist, 1);
  enabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  restitue(Index_Hist);
  posit_dessin := posit;
end;

procedure TForm1.def0Click(Sender: TObject);
begin
  if Index_hist < 1 then
    exit;
  Coups_en_cours := False;
  if not EPD_encours then
    initialisation(posit)
  else
    posit := Lechiquier;
  Index_hist := 0;
  enabler(Index_hist > 0, Index_hist > 0, True, True);
  restitue(Index_Hist);
  posit_dessin := posit;
end;

procedure TForm1.refttClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then
    exit;
  Coups_en_cours := False;
  if not EPD_encours then
    initialisation(posit)
  else
    posit := Lechiquier;
  Index_hist := Combien_hist;
  enabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  restitue(Index_Hist);
  posit_dessin := posit;
end;

procedure TForm1.moyen1Click(Sender: TObject);
begin
  largeur := 80;
  dessine(posit_dessin);
end;

procedure TForm1.Effacerlesflches1Click(Sender: TObject);
begin
  Effacerlesflches1.Checked := not (Effacerlesflches1.Checked);
end;

procedure TForm1.Stop1Click(Sender: TObject);
begin
  stop := True;
end;

procedure change_couleur(de, enca: Tcolor);
var
  li, co, debut: integer;
  ligne: boolean;
begin
  ligne := False;
  form1.Image1.canvas.pen.Color := enca;
  with form1.Image1 do
    for li := 0 to Height do
      for co := 0 to Width do
        with canvas do
        begin
          if pixels[co, li] = de then
          begin
            if not ligne then
            begin
              ligne := True;
              debut := co;
            end;
          end
          else
          begin
            if ligne then
            begin
              ligne := False;
              moveto(debut, li);
              lineTo(co - 1, li);
            end;
          end;
        end;
end;

procedure TForm1.Bleu1Click(Sender: TObject);
begin
  Couleur_Fond := 8421376;
  change_couleur(Clolive, 8421376);
end;

procedure TForm1.Olive1Click(Sender: TObject);
begin
  Couleur_Fond := ClOlive;
  Change_Couleur(8421376, ClOlive);
end;

procedure TForm1.Niveau55Click(Sender: TObject);
begin
  Init_Prof := 11;
  retire_checked;
  Niveau55.Checked := True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  champ.Free;
end;

procedure TForm1.Niveau60Click(Sender: TObject);
begin
  Init_Prof := 12;
  retire_checked;
  Niveau60.Checked := True;
end;

procedure TForm1.Niveau65Click(Sender: TObject);
begin
  Init_Prof := 13;
  retire_checked;
  Niveau65.Checked := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Affiche;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  stop := False;
end;


procedure trace_battues(color: boolean);
var
  la, li, co, oux, ouy, total: integer;

  procedure lignes(x1, y1, X2, Y2: single);
  begin
    with form1.image1.canvas do
    begin
      MoveTo(round(X1), round(Y1));
      LineTo(round(X2), round(Y2));
    end;
  end;

begin

  total := 0;
  if color then
    Cases_battues_par_noirs
  else
    Cases_battues_par_blancs;
  with form1.image1.canvas do
    for la := 0 to 63 do
    begin
      li := La div 8;
      co := La mod 8;
      tourne(li, co);
      oux := round((co + 0.5) * largeur);
      ouy := round((li + 0.5) * largeur);
      {souslefeu(posit.Position_Roi[Blanc], 1, false) }
      if cases_battues[la] <> 0 then
        if (not color and souslefeu(la, -1, False)) or
          (color and souslefeu(la, 1, False))
        then
        begin
          Inc(total);
          lignes(oux - largeur div 3, ouy - largeur div 3, oux +
            largeur div 3, ouy + largeur div 3);
          lignes(oux - largeur div 3, ouy + largeur div 3, oux +
            largeur div 3, ouy - largeur div 3);
        end;
    end;
  ShowMessage(strint(total) + '  cases contrôlées.');
  Dessine(posit);
end;

procedure TForm1.Casesbattuesblancs1Click(Sender: TObject);
begin
  trace_battues(False);
end;

procedure TForm1.Casesbattuesnoirs1Click(Sender: TObject);
begin
  trace_battues(True);
end;

end.
