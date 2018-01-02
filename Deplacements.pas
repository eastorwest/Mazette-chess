// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Deplacements;

interface

uses Graphics, Math, Dialogs, Variables, Fonctions;

function souslefeu(const po, s: integer; const from_generer: boolean): boolean;
procedure coups_noirs(var coups: T_Liste_Coup; const La_position: integer);
procedure coups_blancs(var coups: T_Liste_Coup; const La_position: integer);
function Cases_battues_par_blancs: integer;
function Cases_battues_par_noirs: integer;
procedure PlayMove(const Le_depart, Larrivee, Lefface: integer);
procedure jouertrue(const Le_depart, Larrivee, Lefface: integer);
procedure jouerfalse(const Le_depart, Larrivee, Lefface: integer);
procedure generer_liste_coup(var coups: T_Liste_Coup; const color: boolean);

implementation

function souslefeu(const po, s: integer; const from_generer: boolean): boolean;
var
  li, co, ou, i: integer;
begin
{1:Fou dame
  2:Tour Dame
  4:Cavalier
  8:Pion
  16:Roi
  32:FouDame-
  64:TourDame-}
  if not from_Generer then
    if s = -1 then
      Cases_battues_par_blancs
    else
      Cases_battues_par_noirs;
  if cases_battues[po] = 0 then
  begin
    Souslefeu := False;
    exit;
  end;
  li := po div 8;
  co := po mod 8;
  Souslefeu := True;
  with posit do
    if s = -1 then
    begin
      if cases_battues[po] and 32 = 32 then
      begin
        Ou := po;
        for i := 1 to min(7 - li, 7 - co) do
        begin
          Inc(ou, 9);
          case Cases[ou] of
            Vide: ;
            Reine, Fou: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to min(7 - li, co) do
        begin
          Inc(ou, 7);
          case Cases[ou] of
            Vide: ;
            Reine, Fou: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 64 = 64 then
      begin
        Ou := po;
        for i := 1 to 7 - li do
        begin
          Inc(ou, 8);
          case Cases[ou] of
            Vide: ;
            Reine, Tour: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to 7 - co do
        begin
          Inc(ou, 1);
          case Cases[ou] of
            Vide: ;
            Reine, Tour: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 1 = 1 then
      begin
        Ou := po;
        for i := 1 to min(li, 7 - co) do
        begin
          Inc(ou, -7);
          case Cases[ou] of
            Vide: ;
            Reine, Fou: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to min(li, co) do
        begin
          Inc(ou, -9);
          case Cases[ou] of
            Vide: ;
            Reine, Fou: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 2 = 2 then
      begin
        Ou := po;
        for i := 1 to li do
        begin
          Inc(ou, -8);
          case Cases[ou] of
            Vide: ;
            Reine, Tour: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to co do
        begin
          Inc(ou, -1);
          case Cases[ou] of
            Vide: ;
            Reine, Tour: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 4 = 4 then
        for i := Depart_Cavalier[po] to Arrivee_Cavalier[po] do
          if Cases[po + Deplacement_Cavalier[i]] = Cavalier then
            exit;
      if cases_battues[po] and 8 = 8 then
      begin
        if co < 7 then
          if li < 7 then
            if (Cases[po + 9] = Pion) then
              exit;
        if co > 0 then
          if li < 7 then
            if (Cases[po + 7] = Pion) then
              exit;
      end;
      if cases_battues[po] and 16 = 16 then
        if (Abs(li - (Position_Roi[Blanc] div 8)) < 2) and
          (Abs(co - (Position_Roi[Blanc] mod 8)) < 2) then
          exit;
    end
    else
    begin
      if cases_battues[po] and 1 = 1 then
      begin
        Ou := po;
        for i := 1 to min(li, 7 - co) do
        begin
          Inc(ou, -7);
          case Cases[ou] of
            Vide: ;
            FouNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to min(li, co) do
        begin
          Inc(ou, -9);
          case Cases[ou] of
            Vide: ;
            FouNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 32 = 32 then
      begin
        Ou := po;
        for i := 1 to min(7 - li, 7 - co) do
        begin
          Inc(ou, 9);
          case Cases[ou] of
            Vide: ;
            FouNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to min(7 - li, co) do
        begin
          Inc(ou, 7);
          case Cases[ou] of
            Vide: ;
            FouNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 2 = 2 then
      begin
        Ou := po;
        for i := 1 to li do
        begin
          Inc(ou, -8);
          case Cases[ou] of
            Vide: ;
            TourNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to co do
        begin
          Inc(ou, -1);
          case Cases[ou] of
            Vide: ;
            TourNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 64 = 64 then
      begin
        Ou := po;
        for i := 1 to 7 - li do
        begin
          Inc(ou, 8);
          case Cases[ou] of
            Vide: ;
            TourNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
        Ou := po;
        for i := 1 to 7 - co do
        begin
          Inc(ou, 1);
          case Cases[ou] of
            Vide: ;
            TourNoir, ReineNoir: exit;
            else
              break;
          end;
        end;
      end;
      if cases_battues[po] and 4 = 4 then
        for i := Depart_Cavalier[po] to Arrivee_Cavalier[po] do
          if Cases[po + Deplacement_Cavalier[i]] = CavalierNoir then
            exit;
      if cases_battues[po] and 8 = 8 then
      begin
        if li > 0 then
          if co > 0 then
            if (Cases[po - 9] = PionNoir) then
              exit;
        if li > 0 then
          if co < 7 then
            if (Cases[po - 7] = PionNoir) then
              exit;
      end;
      if cases_battues[po] and 16 = 16 then
        if (Abs(li - (Position_Roi[Noir] div 8)) < 2) and
          (Abs(co - (Position_Roi[Noir] mod 8)) < 2) then
          exit;
    end;
  Souslefeu := False;
end;

procedure coups_noirs(var coups: T_Liste_Coup; const La_position: integer);
var
  i, li, co: integer;
  Sauv_posit: T_echiquier;

  procedure pre_undeplus(const Posi, pre_efface: integer);
  begin
    jouertrue(La_position, posi, Pre_efface);
    if not souslefeu(posit.position_roi[True], -1, True) then
      with Coups do
      begin
        Inc(Nb_pos);
        position[Nb_pos, 1] := La_position;
        position[Nb_pos, 2] := Posi;
        position[Nb_pos, 3] := pre_efface;
      end;
    posit := sauv_posit;
  end;

  procedure Fou_Tour_Dame_Noir(const increment, combien: integer);
  var
    i, dep: integer;
  begin
    dep := La_position;
    with posit do
      for i := 1 to combien do
      begin
        Inc(dep, increment);
        case sign(Cases[dep]) of
          0: pre_undeplus(dep, La_position);
          -1: exit;
          1:
          begin
            pre_undeplus(dep, La_position);
            exit;
          end;
        end;
      end;
  end;

begin
  sauv_posit := posit;
  with posit do
  begin
    li := La_position div 8;
    co := La_position mod 8;
    case Cases[La_position] of
      RoiNoir:
      begin
        for i := Depart_Roi[La_position] to Arrivee_Roi[La_position] do
          if sign(Cases[La_position + Deplacement_Roi[i]]) <> -1 then
            pre_undeplus(La_position + Deplacement_Roi[i], La_position);
        if noir_petit_roque then
          if Cases[7] = TourNoir then
            if Cases[5] = 0 then
              if Cases[6] = 0 then
                if not souslefeu(5, -1, True) then
                  if not souslefeu(La_position, -1, True) then
                    pre_undeplus(6, La_position);
        if noir_grand_roque then
          if Cases[0] = TourNoir then
            if Cases[1] = 0 then
              if Cases[2] = 0 then
                if Cases[3] = 0 then
                  if not souslefeu(3, -1, True) then
                    if not souslefeu(La_position, -1, True) then
                      pre_undeplus(2, La_position);
      end;
      ReineNoir:
      begin
        Fou_Tour_Dame_Noir(9, min(7 - li, 7 - co));
        Fou_Tour_Dame_Noir(7, min(7 - li, co));
        Fou_Tour_Dame_Noir(+8, 7 - li);
        Fou_Tour_Dame_Noir(+1, 7 - co);
        Fou_Tour_Dame_Noir(-7, min(li, 7 - co));
        Fou_Tour_Dame_Noir(-9, min(li, co));
        Fou_Tour_Dame_Noir(-8, li);
        Fou_Tour_Dame_Noir(-1, co);
      end;
      FouNoir:
      begin
        Fou_Tour_Dame_Noir(9, min(7 - li, 7 - co));
        Fou_Tour_Dame_Noir(7, min(7 - li, co));
        Fou_Tour_Dame_Noir(-7, min(li, 7 - co));
        Fou_Tour_Dame_Noir(-9, min(li, co));
      end;
      CavalierNoir:
      begin
        for i := Arrivee_Cavalier[La_position]
          downto Depart_Cavalier[La_position] do
          if sign(Cases[La_position + Deplacement_Cavalier[i]]) <> -1 then
            pre_undeplus(La_position + Deplacement_Cavalier[i], La_position);
      end;
      TourNoir:
      begin
        Fou_Tour_Dame_Noir(+8, 7 - li);
        Fou_Tour_Dame_Noir(+1, 7 - co);
        Fou_Tour_Dame_Noir(-8, li);
        Fou_Tour_Dame_Noir(-1, co);
      end;
      PionNoir: if li < 7 then
        begin
          if Cases[La_position + 8] = 0 then
            pre_undeplus(La_position + 8, La_position); {Case inférieure}
          if li = 1 then
            if Cases[La_position + 8] = 0 then
              if Cases[La_position + 16] = 0 then
                pre_undeplus(La_position + 16, La_position); {2 case au début}
          if co > 0 then
            if Cases[La_position + 7] > 0 then
              pre_undeplus(La_position + 7, La_position); { Prise à gauche}
          if co < 7 then
            if Cases[La_position + 9] > 0 then
              pre_undeplus(La_position + 9, La_position); { prise à droite}
          { prise en passant }
          if dernier <> PasPion then
            if Cases[dernier] > 0 then
              if La_Position >= 32 then
                if La_position <= 39 then
                  if abs(la_position - dernier) = 1 then
                    pre_undeplus(dernier + 8, dernier);
        end;
    end;
  end;
end;

procedure coups_blancs(var coups: T_Liste_Coup; const la_position: integer);
var
  i, li, co: integer;
  Sauv_posit: T_echiquier;

  procedure pre_undeplus(const Posi, pre_efface: integer);
  begin
    jouerfalse(La_position, posi, Pre_efface);
    if not souslefeu(posit.position_roi[False], 1, True) then
      with Coups do
      begin
        Inc(Nb_pos);
        position[Nb_pos, 1] := La_position;
        position[Nb_pos, 2] := Posi;
        position[Nb_pos, 3] := pre_efface;
      end;
    posit := sauv_posit;
  end;

  procedure Fou_Tour_Dame_Blanc(const increment, combien: integer);
  var
    i, dep: integer;
  begin
    dep := La_position;
    with posit do
      for i := 1 to combien do
      begin
        Inc(dep, increment);
        case sign(Cases[dep]) of
          0: pre_undeplus(dep, La_position);
          -1:
          begin
            pre_undeplus(dep, La_position);
            exit;
          end;
          1: exit;
        end;
      end;
  end;

begin
  sauv_posit := posit;
  with posit do
  begin
    li := La_position div 8;
    co := La_position mod 8;
    case Cases[La_position] of
      Pion: if li > 0 then
        begin
          if Cases[La_position - 8] = 0 then
            pre_undeplus(La_position - 8, La_position); {Case supérieure}
          if li = 6 then
            if Cases[La_position - 8] = 0 then
              if Cases[La_position - 16] = 0 then
                pre_undeplus(La_position - 16, La_position); {2 case au début}
          if co > 0 then
            if Cases[La_position - 9] < 0 then
              pre_undeplus(La_position - 9, La_position); { Prise à gauche}
          if co < 7 then
            if Cases[La_position - 7] < 0 then
              pre_undeplus(La_position - 7, La_position); { prise à droite}
          { prise en passant}
          if dernier <> PasPion then
            if Cases[dernier] < 0 then
              if La_Position >= 24 then
                if La_position <= 31 then
                  if abs(la_position - dernier) = 1 then
                    pre_undeplus(dernier - 8, dernier);
        end;
      Tour:
      begin
        Fou_Tour_Dame_Blanc(-8, li);
        Fou_Tour_Dame_Blanc(-1, co);
        Fou_Tour_Dame_Blanc(+8, 7 - li);
        Fou_Tour_Dame_Blanc(+1, 7 - co);
      end;
      Cavalier:
      begin
        for i := Depart_Cavalier[La_position] to Arrivee_Cavalier[La_position] do
          if sign(Cases[La_position + Deplacement_Cavalier[i]]) <> 1 then
            pre_undeplus(La_position + Deplacement_Cavalier[i], La_position);
      end;
      Fou:
      begin
        Fou_Tour_Dame_Blanc(-7, min(li, 7 - co));
        Fou_Tour_Dame_Blanc(-9, min(li, co));
        Fou_Tour_Dame_Blanc(9, min(7 - li, 7 - co));
        Fou_Tour_Dame_Blanc(7, min(7 - li, co));
      end;

      Reine:
      begin
        Fou_Tour_Dame_Blanc(-7, min(li, 7 - co));
        Fou_Tour_Dame_Blanc(-9, min(li, co));
        Fou_Tour_Dame_Blanc(-8, li);
        Fou_Tour_Dame_Blanc(-1, co);
        Fou_Tour_Dame_Blanc(9, min(7 - li, 7 - co));
        Fou_Tour_Dame_Blanc(7, min(7 - li, co));
        Fou_Tour_Dame_Blanc(+1, 7 - co);
        Fou_Tour_Dame_Blanc(+8, 7 - li);
      end;
      Roi:
      begin
        for i := Depart_Roi[La_position] to Arrivee_Roi[La_position] do
          if sign(Cases[La_position + Deplacement_Roi[i]]) <> 1 then
            pre_undeplus(La_position + Deplacement_Roi[i], La_position);
        if blanc_petit_roque then
          if Cases[63] = Tour then
            if Cases[61] = 0 then
              if Cases[62] = 0 then
                if not souslefeu(61, 1, True) then
                  if not souslefeu(La_position, 1, True) then
                    pre_undeplus(62, La_position);
        if blanc_grand_roque then
          if Cases[56] = Tour then
            if Cases[57] = 0 then
              if Cases[58] = 0 then
                if Cases[59] = 0 then
                  if not souslefeu(59, 1, True) then
                    if not souslefeu(La_position, 1, True) then
                      pre_undeplus(58, La_position);
      end;
    end;
  end;
end;

function Cases_battues_par_blancs: integer;
var
  i, li, co, The_position, retour: integer;

  procedure hou(const a, b: byte);
  begin
    cases_battues[a] := cases_battues[a] or b;
    Inc(retour);
  end;

  procedure FTDB(const increment, combien: integer; const pourou: byte);
  var
    i, dep: integer;
  begin
    dep := The_position;
    with posit do
      for i := 1 to combien do
      begin
        Inc(dep, increment);
        hou(dep, pourou);
        if sign(Cases[dep]) = 1 then
          exit;
      end;
  end;

begin
  retour := 0;
  cases_battues := zero;
  with posit do
    for The_position := 63 downto 0 do
      if cases[The_Position] > 0 then
      begin
        li := The_position div 8;
        co := The_position mod 8;
        case Cases[The_position] of
          Pion: if li > 0 then
            begin
              if co > 0 then
                hou(The_position - 9, 8);
              if co < 7 then
                hou(The_position - 7, 8);
            end;
          Tour:
          begin
            FTDB(-8, li, 64);
            FTDB(+8, 7 - li, 2);
            FTDB(-1, co, 64);
            FTDB(+1, 7 - co, 2);
          end;
          Cavalier: for i := Depart_Cavalier[The_position]
              to Arrivee_Cavalier[The_position] do
              hou(The_position + Deplacement_Cavalier[i], 4);
          Fou:
          begin
            FTDB(-7, min(li, 7 - co), 32);
            FTDB(-9, min(li, co), 32);
            FTDB(9, min(7 - li, 7 - co), 1);
            FTDB(7, min(7 - li, co), 1);
          end;
          Reine:
          begin
            FTDB(-7, min(li, 7 - co), 32);
            FTDB(-9, min(li, co), 32);
            FTDB(9, min(7 - li, 7 - co), 1);
            FTDB(7, min(7 - li, co), 1);
            FTDB(-8, li, 64);
            FTDB(+8, 7 - li, 2);
            FTDB(-1, co, 64);
            FTDB(+1, 7 - co, 2);
          end;
          Roi: for i := Depart_Roi[The_position] to Arrivee_Roi[The_position] do
              hou(The_position + Deplacement_Roi[i], 16);
        end;
      end;
  Cases_battues_par_blancs := retour;
end;

function Cases_battues_par_noirs: integer;
var
  i, li, co, The_position, retour: integer;

 {1:Fou dame
  2:Tour Dame
  4:Cavalier
  8:Pion
  16:Roi
  32:FouDame-
  64:TourDame-}

  procedure hou(const a, b: byte);
  begin
    cases_battues[a] := cases_battues[a] or b;
    Inc(retour);
  end;

  procedure FTDN(const increment, combien: integer; const pourou: byte);
  var
    i, dep: integer;
  begin
    dep := The_position;
    with posit do
      for i := 1 to combien do
      begin
        Inc(dep, increment);
        hou(dep, pourou);
        if sign(Cases[dep]) = -1 then
          exit;
      end;
  end;

begin
  retour := 0;
  cases_battues := zero;
  with posit do
    for The_position := 63 downto 0 do
      if cases[The_Position] < 0 then
      begin
        li := The_position div 8;
        co := The_position mod 8;
        case Cases[The_position] of
          PionNoir: if li < 7 then
            begin
              if co > 0 then
                hou(The_position + 7, 8);
              if co < 7 then
                hou(The_position + 9, 8);
            end;
          TourNoir:
          begin
            FTDN(-8, li, 64);
            FTDN(+8, 7 - li, 2);
            FTDN(-1, co, 64);
            FTDN(+1, 7 - co, 2);
          end;
          CavalierNoir: for i :=
              Depart_Cavalier[The_position] to Arrivee_Cavalier[The_position] do
              hou(The_position + Deplacement_Cavalier[i], 4);
          FouNoir:
          begin
            FTDN(-7, min(li, 7 - co), 32);
            FTDN(-9, min(li, co), 32);
            FTDN(9, min(7 - li, 7 - co), 1);
            FTDN(7, min(7 - li, co), 1);
          end;
          ReineNoir:
          begin
            FTDN(-7, min(li, 7 - co), 32);
            FTDN(-9, min(li, co), 32);
            FTDN(9, min(7 - li, 7 - co), 1);
            FTDN(7, min(7 - li, co), 1);
            FTDN(-8, li, 64);
            FTDN(+8, 7 - li, 2);
            FTDN(-1, co, 64);
            FTDN(+1, 7 - co, 2);
          end;
          RoiNoir: for i := Depart_Roi[The_position] to Arrivee_Roi[The_position] do
              hou(The_position + Deplacement_Roi[i], 16);
        end;
      end;
  Cases_battues_par_noirs := retour;
end;

procedure PlayMove(const Le_depart, Larrivee, Lefface: integer);
var
  prise: shortint;
begin
  with posit do
  begin
    prise := Cases[Larrivee];
    case prise of
      pionnoir:
      begin
        Dec(pions_noirs[larrivee mod 8]);
        if pions_noirs[larrivee mod 8] = 1 then
          Dec(total, 20);
      end;
      pion:
      begin
        Dec(pions_blancs[larrivee mod 8]);
        if pions_blancs[larrivee mod 8] = 1 then
          Inc(total, 20);
      end;
    end;
    Dec(total, valeurs_Cases[Cases[Larrivee]]);
    if complexite >= 25 then
    begin
      Dec(total, bonus[Cases[Larrivee], Larrivee]);
      Dec(total, bonus[Cases[Le_depart], Le_depart]);
      Inc(total, bonus[Cases[Le_depart], Larrivee]);
    end
    else
    begin
      Dec(total, bonus_fin[Cases[Larrivee], Larrivee]);
      Dec(total, bonus_fin[Cases[Le_depart], Le_depart]);
      Inc(total, bonus_fin[Cases[Le_depart], Larrivee]);
    end;
    Cases[Larrivee] := Cases[Le_depart];
    Cases[Le_depart] := 0;
    Cases[Lefface] := 0;
    Dernier := PasPion;
    case Cases[Larrivee] of
      PionNoir:
      begin
        if prise <> 0 then
        begin
          Dec(pions_noirs[le_depart mod 8]);
          if pions_noirs[le_depart mod 8] = 1 then
            Dec(total, 20);
          Inc(pions_noirs[larrivee mod 8]);
          if pions_noirs[larrivee mod 8] = 2 then
            Inc(total, 20);
        end;
        if Larrivee >= 56 then
        begin
          Cases[Larrivee] := ReineNoir;
          Dec(pions_noirs[larrivee mod 8]);
          recalcule;
        end
        else if Larrivee - Le_depart = 16 then
          dernier := Larrivee;
      end;
      Pion:
      begin
        if prise <> 0 then
        begin
          Dec(pions_blancs[le_depart mod 8]);
          if pions_blancs[le_depart mod 8] = 1 then
            Inc(total, 20);
          Inc(pions_blancs[larrivee mod 8]);
          if pions_blancs[larrivee mod 8] = 2 then
            Dec(total, 20);
        end;
        if Larrivee <= 7 then
        begin
          Cases[Larrivee] := Reine;
          Inc(pions_blancs[larrivee mod 8]);
          recalcule;
        end
        else if Le_depart - Larrivee = 16 then
          dernier := Larrivee;
      end;
      TourNoir: case Le_depart of
          0: // a8
          begin
            if noir_grand_roque then
              Inc(total, 10);
            noir_grand_roque := False;
          end;
          7: // h8
          begin
            if noir_petit_roque then
              Inc(total, 15);
            noir_petit_roque := False;
          end;
        end;
      Tour: case Le_depart of
          56: // a1
          begin
            if blanc_grand_roque then
              Dec(total, 10);
            blanc_grand_roque := False;
          end;
          63: // h1
          begin
            if blanc_petit_roque then
              Dec(total, 15);
            blanc_petit_roque := False;
          end;
        end;
      RoiNoir:
      begin
        Position_Roi[Noir] := Larrivee;
        if Le_depart = 4 then
        begin
          case Larrivee of
            2:
            begin
              Cases[0] := Vide;
              Cases[3] := TourNoir;
              Roque_noir := True;
              Dec(total, 35);
              if not noir_petit_roque then
                Dec(total, 15);
            end;
            6:
            begin
              Cases[7] := Vide;
              Cases[5] := TourNoir;
              Roque_noir := True;
              Dec(total, 35);
              if not noir_grand_roque then
                Dec(total, 10);
            end;
            else
            begin
              if noir_grand_roque then
                Inc(total, 10);
              if noir_petit_roque then
                Inc(total, 15);
            end;
          end;
          noir_grand_roque := False;
          noir_petit_roque := False;
        end;
      end;
      Roi:
      begin
        Position_Roi[Blanc] := Larrivee;
        if Le_depart = 60 then
        begin
          case Larrivee of
            58:
            begin
              Cases[56] := Vide;
              Cases[59] := Tour;
              Roque_Blanc := True;
              Inc(total, 35);
              if not blanc_petit_roque then
                Inc(total, 15);
            end;
            62:
            begin
              Cases[63] := Vide;
              Cases[61] := Tour;
              Roque_Blanc := True;
              Inc(total, 35);
              if not blanc_grand_roque then
                Inc(total, 10);
            end;
            else
            begin
              if blanc_grand_roque then
                Dec(total, 10);
              if blanc_petit_roque then
                Dec(total, 15);
            end;
          end;
          blanc_grand_roque := False;
          blanc_petit_roque := False;
        end;
      end;
    end;
  end;
end;

procedure jouertrue(const Le_depart, Larrivee, Lefface: integer);
var
  prise: shortint;
begin
  with posit do
  begin
    prise := cases[Larrivee];
    if prise = pion then
    begin
      Dec(pions_blancs[larrivee mod 8]);
      if pions_blancs[larrivee mod 8] = 1 then
        Inc(total, 20);
    end;
    Dec(total, valeurs_Cases[Cases[Larrivee]]);
    if complexite >= 25 then
    begin
      Dec(total, bonus[Cases[Larrivee], Larrivee]);
      Dec(total, bonus[Cases[Le_depart], Le_depart]);
      Inc(total, bonus[Cases[Le_depart], Larrivee]);
    end
    else
    begin
      Dec(total, bonus_fin[Cases[Larrivee], Larrivee]);
      Dec(total, bonus_fin[Cases[Le_depart], Le_depart]);
      Inc(total, bonus_fin[Cases[Le_depart], Larrivee]);
    end;
    Cases[Larrivee] := Cases[Le_depart];
    Cases[Le_depart] := 0;
    Cases[Lefface] := 0;
    Dernier := PasPion;
    case Cases[Larrivee] of
      RoiNoir:
      begin
        Position_Roi[Noir] := Larrivee;
        if Le_depart = 4 then
        begin
          case Larrivee of
            2:
            begin
              Cases[0] := Vide;
              Cases[3] := TourNoir;
              Roque_noir := True;
              Dec(total, 35);
              if not noir_petit_roque then
                Dec(total, 15);
            end;
            6:
            begin
              Cases[7] := Vide;
              Cases[5] := TourNoir;
              Roque_noir := True;
              Dec(total, 35);
              if not noir_grand_roque then
                Dec(total, 10);
            end;
            else
            begin
              if noir_grand_roque then
                Inc(total, 10);
              if noir_petit_roque then
                Inc(total, 15);
            end;
          end;
          noir_grand_roque := False;
          noir_petit_roque := False;
        end;
      end;
      TourNoir: case Le_depart of
          0:
          begin
            if noir_grand_roque then
              Inc(total, 10);
            noir_grand_roque := False;
          end;
          7:
          begin
            if noir_petit_roque then
              Inc(total, 15);
            noir_petit_roque := False;
          end;
        end;
      PionNoir:
      begin
        if prise <> 0 then
        begin
          Dec(pions_noirs[le_depart mod 8]);
          if pions_noirs[le_depart mod 8] = 1 then
            Dec(total, 20);
          Inc(pions_noirs[larrivee mod 8]);
          if pions_noirs[larrivee mod 8] = 2 then
            Inc(total, 20);
        end;
        if Larrivee >= 56 then
        begin
          Cases[Larrivee] := ReineNoir;
          Dec(pions_noirs[larrivee mod 8]);
          recalcule;
        end
        else if Larrivee - Le_depart = 16 then
          dernier := Larrivee;
      end;
    end;
  end;
end;

procedure jouerfalse(const Le_depart, Larrivee, Lefface: integer);
var
  prise: shortint;
begin
  with posit do
  begin
    prise := cases[Larrivee];
    if prise = pionnoir then
    begin
      Dec(pions_noirs[larrivee mod 8]);
      if pions_noirs[larrivee mod 8] = 1 then
        Dec(total, 20);
    end;
    Dec(total, valeurs_Cases[Cases[Larrivee]]);
    if complexite >= 25 then
    begin
      Dec(total, bonus[Cases[Larrivee], Larrivee]);
      Dec(total, bonus[Cases[Le_depart], Le_depart]);
      Inc(total, bonus[Cases[Le_depart], Larrivee]);
    end
    else
    begin
      Dec(total, bonus_fin[Cases[Larrivee], Larrivee]);
      Dec(total, bonus_fin[Cases[Le_depart], Le_depart]);
      Inc(total, bonus_fin[Cases[Le_depart], Larrivee]);
    end;
    Cases[Larrivee] := Cases[Le_depart];
    Cases[Le_depart] := 0;
    Cases[Lefface] := 0;
    Dernier := PasPion;
    case Cases[Larrivee] of
      Pion:
      begin
        if prise <> 0 then
        begin
          Dec(pions_blancs[le_depart mod 8]);
          if pions_blancs[le_depart mod 8] = 1 then
            Inc(total, 20);
          Inc(pions_blancs[larrivee mod 8]);
          if pions_blancs[larrivee mod 8] = 2 then
            Dec(total, 20);
        end;
        if Larrivee <= 7 then
        begin
          Cases[Larrivee] := Reine;
          Inc(pions_blancs[larrivee mod 8]);
          recalcule;
        end
        else if Le_depart - Larrivee = 16 then
          dernier := Larrivee;
      end;
      Tour: case Le_depart of
          56:
          begin
            if blanc_grand_roque then
              Dec(total, 10);
            blanc_grand_roque := False;
          end;
          63:
          begin
            if blanc_petit_roque then
              Dec(total, 15);
            blanc_petit_roque := False;
          end;
        end;
      Roi:
      begin
        Position_Roi[Blanc] := Larrivee;
        if Le_depart = 60 then
        begin
          case Larrivee of
            58:
            begin
              Cases[56] := Vide;
              Cases[59] := Tour;
              Roque_Blanc := True;
              Inc(total, 35);
              if not blanc_petit_roque then
                Inc(total, 15);
            end;
            62:
            begin
              Cases[63] := Vide;
              Cases[61] := Tour;
              Roque_Blanc := True;
              Inc(total, 35);
              if not blanc_grand_roque then
                Inc(total, 10);
            end;
            else
            begin
              if blanc_grand_roque then
                Dec(total, 10);
              if blanc_petit_roque then
                Dec(total, 15);
            end;
          end;
          blanc_grand_roque := False;
          blanc_petit_roque := False;
        end;
      end;
    end;
  end;
end;

procedure generer_liste_coup(var coups: T_Liste_Coup; const color: boolean);
var
  la_position: integer;
begin
  Coups.Nb_Pos := 0;
  with posit do
    case color of
      True:
      begin
        Cases_battues_par_blancs;
        for La_Position := 63 downto 0 do
          if cases[La_Position] < 0 then
            coups_Noirs(coups, La_Position);
      end;
      False:
      begin
        Cases_battues_par_noirs;
        for La_Position := 0 to 63 do
          if cases[La_Position] > 0 then
            coups_blancs(coups, La_Position);
      end;
    end;
end;

end.

