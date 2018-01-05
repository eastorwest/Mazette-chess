// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Recherchedecoups;

interface

procedure Affiche;
procedure Recherche(const color: boolean);

implementation

uses
  {$IFnDEF FPC} Windows,  {$ENDIF}
  SysUtils, Dialogs, Forms, Graphics, Math,
  Variables, Deplacements, Fonctions,
  Evaluation, Echec1, Plateau;

function feuilletrue(const beta: integer): integer;
var
  j, i, Le_Meilleur, cbpb, evalu, perte: integer;
  encours: T_echiquier;
begin
  encours := Posit;
  Le_Meilleur := -infini;
  evalu := -111111; { a priori : impossible à avoir }
  with coups_possibles do
    with posit do
    begin
      cbpb := Cases_battues_par_blancs;
      for j := 63 downto 0 do
        if cases[j] < 0 then
        begin
          Nb_Pos := 0;
          Moves_black(coups_possibles, j, Posit);
          perte := -valeurs_cases[cases[j]] div 3;
          if Nb_Pos <> 0 then
          begin
            for i := 1 to Nb_pos do
            begin
              jouertrue(position[i, 1], position[i, 2], position[i, 3], Posit);
              evalu := evaluer(True) - cbpb;
              if cases_battues[position[i, 2]] <> 0 then
                evalu := evalu - perte;
              Posit := encours;
              if evalu > Le_Meilleur then
              begin
                Le_Meilleur := evalu;
                if Le_Meilleur >= beta then
                begin
                  Result := Le_Meilleur;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if evalu = -111111 then
      begin
        if souslefeu(Position_Roi[Noir], -1, False) then
          Result := -infini + (profope - 1)
        else
          Result := 0;
        exit;
      end;
      Result := Le_Meilleur;
      exit;
    end;
end;

function feuillefalse(const beta: integer): integer;
var
  j, i, Le_Meilleur, cbpn, evalu, perte: integer;
  encours: T_echiquier;
begin
  encours := Posit;
  Le_Meilleur := -infini;
  evalu := -111111;
  with coups_possibles do
    with posit do
    begin
      cbpn := Cases_battues_par_noirs;
      for j := 0 to 63 do
        if cases[j] > 0 then
        begin
          Nb_Pos := 0;
          Moves_white(coups_possibles, j, Posit);
          perte := valeurs_cases[cases[j]] div 3;
          if Nb_Pos <> 0 then
          begin
            for i := 1 to Nb_pos do
            begin
              jouerfalse(position[i, 1], position[i, 2], position[i, 3], Posit);
              evalu := evaluer(False) - cbpn;
              if cases_battues[position[i, 2]] <> 0 then
                evalu := evalu - perte;
              Posit := encours;
              if evalu > Le_Meilleur then
              begin
                Le_Meilleur := evalu;
                if Le_Meilleur >= beta then
                begin
                  Result := Le_Meilleur;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if evalu = -111111 then
      begin
        if souslefeu(Position_Roi[Blanc], 1, False) then
          Result := -infini + (profope - 1)
        else
          Result := 0;
        exit;
      end;
      Result := Le_Meilleur;
      exit;
    end;
end;

procedure Affiche;
begin
  Form1.Label1.Caption := strint(Nb_Eval) + ' Evaluations en : ' +
    temps({$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF} - h);
end;

function AlphaBeta(const profondeur: integer; alpha: integer;
  const beta: integer; const color: boolean): integer;
var
  i, evalu, Le_Meilleur: integer;
  tmp: T_Element;
  encours: T_echiquier;
  liste_coup: T_Liste_Coup;
begin
  if profondeur = 1 then
    if color then
    begin
      Result := feuilletrue(beta);
      exit;
    end
    else
    begin
      Result := feuillefalse(beta);
      exit;
    end;
  encours := Posit;
  Le_Meilleur := -infini;
  generer_liste_coup(liste_coup, color);
  with liste_coup do
    with posit do
    begin
      if Nb_pos = 0 then
        if color then
        begin
          if souslefeu(Position_Roi[Noir], -1, False) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end
        else
        begin
          if souslefeu(Position_Roi[Blanc], 1, False) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end;
      for i := 1 to Nb_pos do
        if La_Pile_1 = position[i, 1] then
          if La_Pile_2 = position[i, 2] then
          begin
            tmp := position[i];
            position[i] := position[1];
            {for j := i downto 2 do position[j] := position[j - 1];}
            position[1] := tmp;
            Break;
          end;
      for i := 1 to Nb_pos do
      begin
        Application.ProcessMessages;
        PlayMove(position[i, 1], position[i, 2], position[i, 3], Posit);
        {if color then evalu:=-feuillefalse(-alpha) else evalu:=-feuilletrue(-alpha);}
        evalu := -AlphaBeta(profondeur - 1, -beta, -alpha, not color);
        Posit := encours;
        if evalu > Le_Meilleur then
        begin
          Le_Meilleur := evalu;
          if Le_Meilleur >= beta then
          begin
            Result := Le_Meilleur;
            La_Pile_1 := position[i, 1];
            La_Pile_2 := position[i, 2];
            exit;
          end;
          alpha := max(alpha, le_meilleur);
        end;
      end;
    end;
  Result := Le_Meilleur;
end;

function negascout(const profondeur, alpha, beta: integer;
  const color: boolean): integer;
var
  i, j, k, a, b, t: integer;
  encours: T_echiquier;
  liste_coup: T_Liste_Coup;
  temp: T_Element;
begin
  if profondeur = 2 then
  begin
    Result := AlphaBeta(profondeur, alpha, beta, color);
    exit;
  end;
  {appelé à LA PROFONDEUR 2 seulement}
  if stop then
  begin
    Result := 0;
    exit;
  end;
  encours := Posit;
  generer_liste_coup(liste_coup, color);
  a := alpha;
  b := beta;
  with liste_coup do
    with posit do
    begin
      if Nb_pos = 0 then
        if color then
        begin
          if souslefeu(Position_Roi[Noir], -1, False) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end
        else
        begin
          if souslefeu(Position_Roi[Blanc], 1, False) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end;
      for i := 1 to Nb_pos do
      begin
        PlayMove(position[i, 1], position[i, 2], position[i, 3], Posit);
        if (profondeur = profope - 1) then
          position[i, 4] := -AlphaBeta(2, -beta, -alpha, not color)
        else
          case profondeur of
            3..4: position[i, 4] := evaluer(color);
            5..15: position[i, 4] := -AlphaBeta(1, -beta, -alpha, not color);
          end;
        for j := 1 to Min(i - 1, 6) do
          if (position[i, 4] > position[j, 4]) then
          begin
            temp := position[i];
            for k := i downto j + 1 do
              position[k] := position[k - 1];
            position[j] := temp;
            break;
          end;
        Posit := encours;
      end;
      for i := 1 to Nb_pos do
      begin
        Application.ProcessMessages;
        PlayMove(position[i, 1], position[i, 2], position[i, 3], Posit);
        t := -Negascout(profondeur - 1, -b, -a, not color);
        if (t > a) then         {modif là !}
        begin
          if (t < beta) and (i > 1) then
            a := -Negascout(profondeur - 1, -beta, -t, not color);
          a := max(a, t);
        end;
        Posit := encours;
        if a >= beta then
        begin
          Result := a;
          exit;
        end;
        b := a + 1;
      end;
    end;
  Result := a;
end;

procedure Recherche(const color: boolean);
var
  Le_Meilleur, i, j, k, alpha: integer;
  encours: T_echiquier;
  annule: boolean;
  a, b, t: integer;
  liste_coup: T_Liste_Coup;
  temp: T_Element;
begin
  annule := True;
  alpha := -infini;
  stop := False;
  a := alpha;
  b := infini;
  enabler(False, False, False, False);
  Posit.Total := 0;
  la_Pile_1 := 0;
  la_Pile_2 := 0;
  encours := Posit;
  Le_Meilleur := -infini;
  generer_liste_coup(liste_coup, color);
  if liste_coup.Nb_pos = 0 then
  begin
    if (color and souslefeu(Posit.Position_Roi[Noir], -1, False)) or
      (not color and souslefeu(Posit.Position_Roi[Blanc], 1, False)) then
    begin
      ShowMessage('CheckMate !');
      partie_en_cours := False;
    end
    else
    begin
      ShowMessage('Nulle');
      encours := Posit;
      partie_en_cours := False;
    end;
    exit;
  end;
  h := {$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF};
  Form1.Timer1.Enabled := True;
  with liste_coup do
  begin
    for i := 1 to Nb_pos do
    begin
      PlayMove(position[i, 1], position[i, 2], position[i, 3],Posit);
      position[i, 4] := -negascout(5, -infini, -alpha, not color);
      for j := 1 to i - 1 do
        if (position[i, 4] > position[j, 4]) then
        begin
          temp := position[i];
          for k := i downto j + 1 do
            position[k] := position[k - 1];
          position[j] := temp;
          break;
        end;
      Posit := encours;
    end;
    PaintBoard(posit_dessin);
    if Nb_pos = 1 then
    begin
      best_depart := position[1, 1];
      best_arrivee := position[1, 2];
      best_efface := position[1, 3];
    end
    else
      for i := 1 to Nb_pos do
      begin
        Affiche;
        if Form1.Effacerlesflches1.Checked then
          PaintBoard(posit_dessin);
        if i > 1 then
          fleche(best_depart, best_arrivee, clgray);
        fleche(position[i, 1], position[i, 2], clBlue);
        if stop then
          exit;
        PlayMove(position[i, 1], position[i, 2], position[i, 3],Posit);
        t := -Negascout(profope - 1, -b, -a, not color);
        if (t > a) and (i > 1) then
          a := -Negascout(profope - 1, -infini, -t, not color);
        a := Max(a, t);
        Nb_Repetition := 0;
        for j := 1 to Taille_Pile_Rep do
          if CompareMem(@encours, @La_Pile_Rep[j], 64) then
            Inc(Nb_Repetition);
        if annule then
          if Nb_repetition > 2 then
          begin
            ShowMessage(
              Format('L''ordinateur pouvait annuler en jouant: %s%s',
                [ cartesien(position[i, 1]),cartesien(position[i, 2]) ]));
            if nb_pos > 1 then
              a := -infini;
            nb_repetition := 0;
            annule := False;
          end;
        if a > Le_Meilleur then
        begin
          Le_Meilleur := a;
          best_depart := position[i, 1];
          best_arrivee := position[i, 2];
          best_efface := position[i, 3];
          if (le_meilleur > infini - 20) then
          begin
            Posit := encours;
            break;
          end;
        end;
        Posit := encours;
        b := a + 1;
      end;
  end;
  Form1.Timer1.Enabled := False;
  Affiche;
end;

end.

