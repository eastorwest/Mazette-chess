// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Fonctions;

interface

uses Graphics, Variables;

function mouv(const de, ar: integer): T_str12;
procedure enabler(const def0b, defb, refb, refttb: boolean);
function cartesien(const ca: integer): T_str2;
function enchiffre(const s: T_str2): integer;
function suivant(const s: T_str100; var depart, arrivee: integer): boolean;
function strg5(a: single): string;
procedure Mark_Square(li, co: integer; c: Tcolor);
procedure marque_possible;
function strint(const a: int64): string;
procedure Initialisation(var APosit: T_echiquier);
procedure empile_Rep;
procedure Fleche(const dela, alabas: integer; const couleur: TColor);
procedure ecrire(la: integer; s: string);
function EpdToEchiquier(s: string): boolean;
procedure recalcule(var APosit: T_echiquier);
function temps(z: cardinal): string;


implementation

uses {$IFnDEF FPC} Windows,  {$ENDIF}
  Forms, Dialogs, Classes, SysUtils, Echec1, Plateau;

function mouv(const de, ar: integer): T_str12;
var
  Quoi, lien: T_str2;
begin
  Result := '';
  with posit do
  begin
    Quoi := '';
    lien := '';
    if abs(Cases[de]) = Roi then
      Quoi := 'K' // King
    else
    if abs(Cases[de]) = Reine then
      Quoi := 'Q' // Queen
    else
    if abs(Cases[de]) = Tour then
      Quoi := 'R' // Rook
    else
    if abs(Cases[de]) = Fou then
      Quoi := 'B' // Bishop
    else
    if abs(Cases[de]) = Cavalier then
      Quoi := 'N' // Knight
    else
      Quoi := '';
    if Cases[ar] <> Vide then
      lien := 'x'
    else
      lien := '-';
    // Castling
    if ((Cases[de] = Roi) and (de = 60) and (ar = 62)) or
    ((Cases[de] = RoiNoir) and (de = 4) and (ar = 6)) then
    begin
      Result := 'O-O';
      exit;
    end;
    if ( (Cases[de] = Roi) and (de = 60) and (ar = 58) ) or
    ((Cases[de] = RoiNoir) and (de = 4) and (ar = 2)) then
    begin
      Result := 'O-O-O';
      exit;
    end;
    Result := Quoi + cartesien(de) + lien + cartesien(ar);
  end;
end;

procedure enabler(const def0b, defb, refb, refttb: boolean);
begin
  with form1 do
  begin
    btnFirstMove.Enabled := def0b;
    btnPrevMove.Enabled := defb;
    btnNextMove.Enabled := refb;
    btnLastMove.Enabled := refttb;
  end;
end;

function cartesien(const ca: integer): T_str2;
const
  ab: string = 'abcdefgh';
  unde: string = '87654321';
var
  s: T_str2;
begin
  s := 'xx';
  s[1] := ab[(ca mod 8) + 1];
  s[2] := unde[(ca div 8) + 1];
  Result := s;
end;

function enchiffre(const s: T_str2): integer;
begin
  if (length(s) <> 2) or (pos(s[1], 'abcdefgh') = 0) or (pos(s[2], '12345678') = 0) then
  begin
    Result := -1;
    exit;
  end;
  Result := (pos(s[2], '87654321') - 1) * 8 + (pos(s[1], 'abcdefgh') - 1);
end;

procedure delay;
var
  hh: integer;
begin
  hh := {$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF};
  while {$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF} - hh < 5 do ;
end;

function dedans(const s, laboite: string): boolean;

  function cestdedans(const dou: integer): boolean;
  var
    i, j, Nbcou, Nbdanscou: integer;
    ilyest: boolean;
    cou, danscou: array[1..20] of T_Str4;
  begin
    cestdedans := False;
    i := dou;
    Nbcou := 0;
    while i < length(laboite) do
    begin
      Inc(NbCou);
      cou[NbCou] := copy(laboite, i, 4);
      Inc(i, 8);
    end;
    i := dou;
    Nbdanscou := 0;
    while i < length(s) do
    begin
      Inc(NbdansCou);
      Danscou[NbdansCou] := copy(s, i, 4);
      Inc(i, 8);
    end;
    for i := 1 to NbDansCou do
    begin
      Ilyest := False;
      for j := 1 to NbCou do
        if cou[j] = dansCou[i] then
          Ilyest := True;
      if not Ilyest then
        exit;
    end;
    cestdedans := True;
  end;

begin
  Result := False;
  if cestdedans(1) then
    if ((length(s) < 5) or (CestDedans(5))) then
      Result := True;
end;

function suivant(const s: T_str100; var depart, arrivee: integer): boolean;
var
  i, ar, de: integer;
  test: string;
begin
  combien_bib := 0;
  i := 1;
  while (i <= 14536) do
  begin
    test := '';
    while debut[i] <> 100 do
    begin
      test := test + cartesien(debut[i]) + cartesien(debut[i + 1]);
      Inc(i, 2);
    end;
    Inc(i);
    if dedans(s, copy(test, 1, length(s))) then
      if length(test) >= length(s) + 4 then
      begin
        de := enchiffre(copy(test, 1 + length(s), 2));
        ar := enchiffre(copy(test, 1 + length(s) + 2, 2));
        if (ar >= 0) and (ar <= 63) and (de >= 0) and (de <= 63) then
          if combien_bib < 1500 then
          begin
            Inc(combien_bib);
            res_dep_int[combien_bib] := de;
            res_arr_int[combien_bib] := ar;
          end;
      end;
  end;

  if combien_bib > 0 then
  begin
    i := random(combien_bib) + 1;
    depart := res_dep_int[i];
    arrivee := res_arr_int[i];
    Result := True;
    exit;
  end;
  Result := False;
end;

function strg5(a: single): string;
var
  s: string;
begin
  str(a: 7: 5, s);
  if a = 0 then
    s := '0';
  if pos('.', s) <> 0 then
    while s[length(s)] = '0' do
      Delete(s, length(s), 1);
  if s[length(s)] = '.' then
    Delete(s, length(s), 1);
  Strg5 := s;
end;

procedure Mark_Square(li, co: integer; c: Tcolor);
begin
  with form1.image1.canvas do
  begin
    tourne(li, co);
    Pen.Color := c;
    Pen.Width := 3;
    Rectangle(co * largeur, li * largeur, (co + 1) * largeur, (li + 1) * largeur);
    Pen.Color := clblack;
    Pen.Width := 1;
  end;
end;

procedure marque_possible;
var
  i: integer;
begin
  for i := 1 to Coups_Possibles.Nb_pos do
    Mark_Square(Coups_Possibles.position[i, 2] div 8,
      Coups_Possibles.position[i, 2] mod 8, ClRed);
end;

function strint(const a: int64): string;
var
  s1, s: string;
  i, compteur: integer;
begin
  str(a, s1);
  s := '';
  compteur := -(length(s1) mod 3);
  for i := 1 to length(s1) do
  begin
    if compteur = 0 then
      s := s + ' ';
    s := s + s1[i];
    Inc(compteur);
    if compteur > 0 then
      compteur := compteur mod 3;
  end;
  strint := s;
end;

procedure Initialisation(var APosit: T_echiquier);
var
  i: integer;
begin
  with APosit do
  begin
    blanc_petit_roque := True;
    blanc_grand_roque := True;
    noir_petit_roque := True;
    noir_grand_roque := True;
    Roque_Blanc := False;
    Roque_noir := False;
    Dernier := PasPion;
    Cases := Depart;
    Position_Roi[Blanc] := 60;
    Position_Roi[Noir] := 4;
    Total := 0;
    Fillchar(pions_noirs, sizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, sizeOf(pions_blancs), 0);
    for i := 0 to 7 do
    begin
      pions_noirs[i] := 1;
      pions_blancs[i] := 1;
    end;
  end;
end;

procedure empile_Rep;
var
  i: integer;
begin
  for i := Taille_Pile_Rep downto 2 do
    La_Pile_Rep[i] := La_Pile_Rep[i - 1];
  La_Pile_Rep[1] := Posit;
end;

procedure Fleche(const dela, alabas: integer; const couleur: TColor);
var
  Norme, cX, cY: single;
  Ax, Ay, Bx, By, li, co: integer;
begin
  li := deLa div 8;
  co := deLa mod 8;
  tourne(li, co);
  Ax := round((co + 0.5) * largeur);
  Ay := round((li + 0.5) * largeur);
  li := alabas div 8;
  co := alabas mod 8;
  tourne(li, co);
  Bx := round((co + 0.5) * largeur);
  By := round((li + 0.5) * largeur);
  Norme := SQRT((BX - AX) * (BX - AX) + (BY - AY) * (BY - AY));
  if (Norme = 0) then
    Exit;
  cX := (BX - AX) / Norme;
  cY := (BY - AY) / Norme;
  with form1.image1.canvas do
  begin
    Pen.Width := 3;
    Pen.Color := couleur;
    MoveTo(AX, AY);
    LineTo(BX, BY);
    MoveTo(BX, BY);
    LineTo(Round(BX - cX * 30 + cY * 8), Round(BY - cY * 30 - cX * 8));
    MoveTo(BX, BY);
    LineTo(Round(BX - cX * 30 - cY * 8), Round(BY - cY * 30 + cX * 8));
    pen.color := clblack;
    Pen.Width := 1;
  end;
end;

procedure ecrire(la: integer; s: string);
var
  li, co: integer;
begin
  li := La div 8;
  co := La mod 8;
  tourne(li, co);
  with form1.image1.canvas do
    textout(round((co + 0.75) * largeur), round((li + 0.75) * largeur), s);
end;

procedure extraireMots(s: string; into: TStrings);    {  merci à Bloon  }
var
  i, n: integer;
  currentWord: string;
const
  sep: TSysCharSet = [' '];
begin
  into.Clear;
  n := length(s);
  i := 1;
  while (i <= n) do
  begin
    currentWord := '';
    { on saute les séparateurs  }
    while (i <= n) and (s[i] in sep) do
      Inc(i);
    { récupération du mot courant  }
    while (i <= n) and not (s[i] in sep) do
    begin
      currentWord := currentWord + s[i];
      Inc(i);
    end;
    if (currentWord <> '') then
      into.Add(currentWord);
  end;
end;

function EpdToEchiquier(s: string): boolean;
var
  lu: char;
  curseur, ligne, colonne, position, lapiece, i: integer;
  mot: string[128];
  lastr: T_str2;
  la: shortint;

  function degage_mot: string;
  begin
    while (length(s) > 0) and (s[1] = ' ') do
      Delete(s, 1, 1);
    if pos(' ', s) > 0 then
    begin
      degage_mot := Copy(s, 1, Pos(' ', s) - 1);
      Delete(s, 1, pos(' ', s));
    end
    else
    begin
      degage_mot := s;
      s := '';
    end;
  end;

begin
  with lechiquier do     { merci à ?}
  begin
    EpdToEchiquier := False;
    mot := degage_mot;
    if mot = '' then
      exit;
    curseur := 1;
    while (curseur <= Length(mot)) do
    begin
      case mot[curseur] of
        '1': mot[curseur] := '*';
        '2':
        begin
          mot[curseur] := '*';
          Insert('*', mot, curseur);
        end;
        '3':
        begin
          mot[curseur] := '*';
          Insert('**', mot, curseur);
        end;
        '4':
        begin
          mot[curseur] := '*';
          Insert('***', mot, curseur);
        end;
        '5':
        begin
          mot[curseur] := '*';
          Insert('****', mot, curseur);
        end;
        '6':
        begin
          mot[curseur] := '*';
          Insert('*****', mot, curseur);
        end;
        '7':
        begin
          mot[curseur] := '*';
          Insert('******', mot, curseur);
        end;
        '8':
        begin
          mot[curseur] := '*';
          Insert('*******', mot, curseur);
        end;
      end;
      Inc(Curseur);
    end;
    curseur := 1;
    ligne := 0;
    colonne := 0;
    while (curseur <= Length(mot)) do
    begin
      lu := mot[curseur];
      case lu of
        'p': lapiece := PionNoir;
        'n': lapiece := CavalierNoir;
        'b': lapiece := FouNoir;
        'r': lapiece := TourNoir;
        'q': lapiece := ReineNoir;
        'k': lapiece := RoiNoir;
        'P': lapiece := Pion;
        'N': lapiece := Cavalier;
        'B': lapiece := Fou;
        'R': lapiece := Tour;
        'Q': lapiece := Reine;
        'K': lapiece := Roi;
        '*': lapiece := vide;
      end;
      position := colonne + ligne * 8;
      cases[position] := lapiece;
      if lu <> '/' then
        Inc(colonne);
      if (colonne > 7) then
      begin
        colonne := 0;
        Inc(ligne);
      end;
      Inc(Curseur);
    end;
    mot := degage_mot;
    if mot = '' then
      exit;
    if pos('w', mot) > 0 then
      couleur_ordi := False; {trait blanc}
    if pos('b', mot) > 0 then
      couleur_ordi := True;{trait noir}
    mot := degage_mot;
    if mot = '' then
      exit;
    blanc_petit_roque := (Pos('K', mot) > 0);
    blanc_grand_roque := (Pos('Q', mot) > 0);
    noir_petit_roque := (Pos('k', mot) > 0);
    noir_grand_roque := (Pos('q', mot) > 0);
    Fillchar(pions_noirs, sizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, sizeOf(pions_blancs), 0);
    for i := 0 to 63 do
      case cases[i] of
        roi: position_roi[blanc] := i;
        roinoir: position_roi[noir] := i;
        pion: Inc(pions_blancs[i mod 8]);
        pionnoir: Inc(pions_noirs[i mod 8]);
      end;
    roque_blanc := not (blanc_petit_roque and blanc_grand_roque) and
      (position_roi[blanc] <> 60);
    roque_noir := not (noir_petit_roque and noir_grand_roque) and
      (position_roi[noir] <> 4);
    mot := degage_mot;
    if mot = '' then
      exit;
    dernier := 0;
    if (mot <> '-') then
    begin
      lastr := 'aa';
      lastr[1] := mot[1];
      lastr[2] := mot[2];
      la := enchiffre(lastr);
      if la >= 36 then
        Dec(la, 8)
      else
        Inc(la, 8);
      dernier := la;
    end;
    EpdToEchiquier := True;
    posit := lechiquier;
    PaintBoard(posit);
  end;
end;

procedure recalcule(var APosit: T_echiquier);
var
  I: integer;
begin
  with APosit do
  begin
    Fillchar(pions_noirs, sizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, sizeOf(pions_blancs), 0);
    total := 0;
    for i := 0 to 63 do
    begin
      Inc(total, valeurs_Cases[cases[i]]);
      Inc(total, bonus[Cases[i], i]);
      if Cases[i] = pion then
        Inc(pions_blancs[i mod 8]);
      if Cases[i] = pionnoir then
        Inc(pions_noirs[i mod 8]);
    end;
    for i := 0 to 7 do
    begin
      if pions_blancs[i] = 2 then
        Dec(total, 20);
      if pions_noirs[i] = 2 then
        Inc(total, 20);
    end;
  end;
end;

function temps(z: cardinal): string;  { merci à ? }
var
  s, m, h: cardinal;
begin
  S := (Z div 1000) mod 60;
  M := (Z div 60000) mod 60;
  H := (Z div 3600000);
  Z := (Z mod 1000) div 100;
  temps := format('%.2dh%.2dmn%.2d.%.1d', [H, M, S, Z]) + 's';
end;

end.
