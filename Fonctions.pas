// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Fonctions;

interface

uses Variables;

function mouv(const de, ar: integer; const APosit: T_echiquier): T_str12;
function cartesien(const ca: integer): T_str2;
function enchiffre(const s: T_str2): integer;
function suivant(const s: T_str100; var depart, arrivee: integer): boolean;
function strint(const a: int64): string;
procedure Initialisation(out APosit: T_echiquier);
procedure empile_Rep(const APosit: T_echiquier);
function EpdToEchiquier(s: string; var APosit: T_Echiquier): boolean;
procedure recalcule(var APosit: T_echiquier);
function temps(z: cardinal): string;

implementation

uses {$IFnDEF FPC} Windows,  {$ENDIF}
  Classes, SysUtils, Echec1, Plateau;

function mouv(const de, ar: integer; const APosit: T_echiquier): T_str12;
var
  Quoi, lien: T_str2;
begin
  Result := '';
  with APosit do
  begin
    Quoi := '';
    lien := '';
    case abs(Cases[de]) of
      Roi: Quoi := 'K'; // King
      Reine: Quoi := 'Q'; // Queen
      Tour: Quoi := 'R'; // Rook
      Fou: Quoi := 'B'; // Bishop
      Cavalier: Quoi := 'N'; // Knight
    end;
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
    Result := False;
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
    Result := True;
  end;

begin
  Result := False;
  if cestdedans(1) then
    if ((length(s) < 5) or (CestDedans(5))) then
      Result := True;
end;

function suivant(const s: T_str100; var depart, arrivee: integer): boolean;
var
  i, ar, de, combien_bib: integer;
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
    i := Random(combien_bib) + 1;
    depart := res_dep_int[i];
    arrivee := res_arr_int[i];
    Result := True;
    exit;
  end;
  Result := False;
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
  Result := s;
end;

procedure Initialisation(out APosit: T_echiquier);
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
    Fillchar(pions_noirs, SizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, SizeOf(pions_blancs), 0);
    for i := 0 to 7 do
    begin
      pions_noirs[i] := 1;
      pions_blancs[i] := 1;
    end;
  end;
  recalcule(APosit);
end;

procedure empile_Rep(const APosit: T_echiquier);
var
  i: integer;
begin
  for i := Taille_Pile_Rep downto 2 do
    La_Pile_Rep[i] := La_Pile_Rep[i - 1];
  La_Pile_Rep[1] := APosit;
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

function EpdToEchiquier(s: string; var APosit: T_Echiquier): boolean;
var
  lu: char;
  curseur, ligne, colonne, position, lapiece, i: integer;
  mot: string[128];
  lastr: T_str2;
  la: shortint;
  lechiquier: T_Echiquier;

  function degage_mot(): string;
  begin
    while (length(s) > 0) and (s[1] = ' ') do
      Delete(s, 1, 1);
    if Pos(' ', s) > 0 then
    begin
      Result := Copy(s, 1, Pos(' ', s) - 1);
      Delete(s, 1, Pos(' ', s));
    end
    else
    begin
      Result := s;
      s := '';
    end;
  end;

begin
  Initialisation(lechiquier);
  with lechiquier do     { merci à ?}
  begin
    Result := False;
    mot := degage_mot();
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
        '*': lapiece := Vide;
      end;
      position := colonne + ligne * 8;
      Cases[position] := lapiece;
      if lu <> '/' then
        Inc(colonne);
      if (colonne > 7) then
      begin
        colonne := 0;
        Inc(ligne);
      end;
      Inc(Curseur);
    end;
    mot := degage_mot();
    if mot = '' then
      exit;
    if Pos('w', mot) > 0 then
      couleur_ordi := False; {trait blanc}
    if Pos('b', mot) > 0 then
      couleur_ordi := True; {trait noir}
    mot := degage_mot();
    if mot = '' then
      exit;
    blanc_petit_roque := (Pos('K', mot) > 0);
    blanc_grand_roque := (Pos('Q', mot) > 0);
    noir_petit_roque := (Pos('k', mot) > 0);
    noir_grand_roque := (Pos('q', mot) > 0);
    Fillchar(pions_noirs, SizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, SizeOf(pions_blancs), 0);
    for i := 0 to 63 do
      case Cases[i] of
        Roi: position_roi[blanc] := i;
        Roinoir: position_roi[noir] := i;
        Pion: Inc(pions_blancs[i mod 8]);
        Pionnoir: Inc(pions_noirs[i mod 8]);
      end;
    roque_blanc := not (blanc_petit_roque and blanc_grand_roque) and
      (position_roi[blanc] <> 60);
    roque_noir := not (noir_petit_roque and noir_grand_roque) and
      (position_roi[noir] <> 4);
    mot := degage_mot();
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
    Result := True;
    recalcule(lechiquier);
    APosit := lechiquier;
  end;
end;

procedure recalcule(var APosit: T_echiquier);
var
  I: integer;
begin
  with APosit do
  begin
    Fillchar(pions_noirs, SizeOf(pions_noirs), 0);
    Fillchar(pions_blancs, SizeOf(pions_blancs), 0);
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
  Result := format('%.2dh%.2dmn%.2d.%.1d', [H, M, S, Z]) + 's';
end;

end.
