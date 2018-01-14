// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Recherchedecoups;

interface

uses Variables;

procedure Affiche;
procedure SearchBestMove(const color: boolean; const APosit: T_Echiquier);

implementation

uses
  {$IFnDEF FPC} Windows,  {$ENDIF}
  SysUtils, Dialogs, Forms, Graphics, Math,
  Deplacements, Fonctions, Evaluation, Echec1, Plateau;

procedure Affiche;
begin
  Form1.Label1.Caption := Format('%d evaluations in %s',
    [Nb_Eval,temps({$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF} - h)]);
end;

function feuilletrue(const beta: integer; var ACoups_possibles: T_Liste_Coup; const APosit: T_Echiquier): integer;
const
  impossible = -111111;{ a priori : impossible à avoir }
var
  j, i, Le_Meilleur, cbpb, evalu, perte: integer;
  APosit_Copy: T_echiquier;
begin
  APosit_Copy := APosit;
  Le_Meilleur := -infini;
  evalu := impossible;
  with ACoups_possibles do
    with APosit_Copy do
    begin
      cbpb := Cases_battues_par_blancs(APosit_Copy);
      for j := 63 downto 0 do
        if cases[j] < 0 then
        begin
          Nb_Pos := 0;
          Moves_black(j, APosit_Copy, ACoups_possibles);
          perte := -valeurs_cases[cases[j]] div 3;
          if Nb_Pos <> 0 then
          begin
            for i := 1 to Nb_pos do
            begin
              jouertrue(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
              evalu := evaluer(True, APosit_Copy) - cbpb;
              if cases_battues[position[i, 2]] <> 0 then
                evalu := evalu - perte;
              APosit_Copy := APosit;
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
      if evalu = impossible then
      begin
        if souslefeu(Position_Roi[Noir], -1, False, APosit_Copy) then
          Result := -infini + (profope - 1)
        else
          Result := 0;
        exit;
      end;
      Result := Le_Meilleur;
    end;
end;

function feuillefalse(const beta: integer; var ACoups_possibles: T_Liste_Coup; const APosit: T_echiquier): integer;
const
  impossible = -111111;{ a priori : impossible à avoir }
var
  j, i, Le_Meilleur, cbpn, evalu, perte: integer;
  APosit_Copy: T_echiquier;
begin
  APosit_Copy := APosit;
  Le_Meilleur := -infini;
  evalu := impossible;
  with ACoups_possibles do
    with APosit_Copy do
    begin
      cbpn := Cases_battues_par_noirs(APosit_Copy);
      for j := 0 to 63 do
        if cases[j] > 0 then
        begin
          Nb_Pos := 0;
          Moves_white(j, APosit_Copy, ACoups_possibles);
          perte := valeurs_cases[cases[j]] div 3;
          if Nb_Pos <> 0 then
          begin
            for i := 1 to Nb_pos do
            begin
              jouerfalse(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
              evalu := evaluer(False, APosit_Copy) - cbpn;
              if cases_battues[position[i, 2]] <> 0 then
                evalu := evalu - perte;
              APosit_Copy := APosit;
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
      if evalu = impossible then
      begin
        if souslefeu(Position_Roi[Blanc], 1, False, APosit_Copy) then
          Result := -infini + (profope - 1)
        else
          Result := 0;
        exit;
      end;
      Result := Le_Meilleur;
    end;
end;

function AlphaBeta(const profondeur: integer; alpha: integer;
  const beta: integer; const color: boolean; const APosit: T_Echiquier): integer;
var
  i, evalu, Le_Meilleur: integer;
  tmp: T_Element;
  APosit_Copy: T_echiquier;
  liste_coup: T_Liste_Coup;
begin
  APosit_Copy := APosit;
  GenerateMoveList(color, APosit_Copy, liste_coup);
  if profondeur = 1 then
    if color then
    begin
      Result := feuilletrue(beta, liste_coup, APosit_Copy);
      exit;
    end
    else
    begin
      Result := feuillefalse(beta, liste_coup, APosit_Copy);
      exit;
    end;
  Le_Meilleur := -infini;
  with liste_coup do
    with APosit_Copy do
    begin
      if Nb_pos = 0 then
        if color then
        begin
          if souslefeu(Position_Roi[Noir], -1, False, APosit_Copy) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end
        else
        begin
          if souslefeu(Position_Roi[Blanc], 1, False, APosit_Copy) then
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
        PlayMove(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
        {if color then evalu:=-feuillefalse(-alpha) else evalu:=-feuilletrue(-alpha);}
        evalu := -AlphaBeta(profondeur - 1, -beta, -alpha, not color, APosit_Copy);
        APosit_Copy := APosit;
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
          alpha := Max(alpha, le_meilleur);
        end;
      end;
    end;
  Result := Le_Meilleur;
end;

function negascout(const profondeur, alpha, beta: integer;
  const color: boolean; const APosit: T_Echiquier): integer;
var
  i, j, k, a, b, t: integer;
  APosit_Copy: T_echiquier;
  liste_coup: T_Liste_Coup;
  temp: T_Element;
begin
  if profondeur = 2 then
  begin
    Result := AlphaBeta(profondeur, alpha, beta, color, APosit);
    exit;
  end;
  { max depth 2 }
  if stop then
  begin
    Result := 0;
    exit;
  end;
  APosit_Copy := APosit;
  GenerateMoveList(color, APosit_Copy, liste_coup);
  a := alpha;
  b := beta;
  with liste_coup do
    with APosit_Copy do
    begin
      if Nb_pos = 0 then
        if color then
        begin
          if souslefeu(Position_Roi[Noir], -1, False, APosit_Copy) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end
        else
        begin
          if souslefeu(Position_Roi[Blanc], 1, False, APosit_Copy) then
            Result := -infini + (profope - profondeur)
          else
            Result := 0;
          exit;
        end;
      for i := 1 to Nb_pos do
      begin
        PlayMove(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
        if (profondeur = profope - 1) then
          position[i, 4] := -AlphaBeta(2, -beta, -alpha, not color, APosit_Copy)
        else
          case profondeur of
            3..4: position[i, 4] := evaluer(color, APosit_Copy);
            5..15: position[i, 4] := -AlphaBeta(1, -beta, -alpha, not color, APosit_Copy);
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
        APosit_Copy := APosit;
      end;
      for i := 1 to Nb_pos do
      begin
        Application.ProcessMessages;
        PlayMove(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
        t := -Negascout(profondeur - 1, -b, -a, not color, APosit_Copy);
        if (t > a) then         {modif là !}
        begin
          if (t < beta) and (i > 1) then
            a := -Negascout(profondeur - 1, -beta, -t, not color, APosit_Copy);
          a := max(a, t);
        end;
        APosit_Copy := APosit;
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

procedure SearchBestMove(const color: boolean; const APosit: T_Echiquier);
var
  Le_Meilleur, i, j, k, alpha: integer;
  APosit_Copy: T_echiquier;
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
  PanelEnabler(False, False, False, False);
  la_Pile_1 := 0;
  la_Pile_2 := 0;
  APosit_Copy := APosit;
  APosit_Copy.Total := 0;
  Le_Meilleur := -infini;
  GenerateMoveList(color, APosit_Copy, liste_coup);
  if liste_coup.Nb_pos = 0 then // there is no legal moves in APosit
  begin
    if (color and souslefeu(APosit_Copy.Position_Roi[Noir], -1, False, APosit_Copy)) or
      (not color and souslefeu(APosit_Copy.Position_Roi[Blanc], 1, False, APosit_Copy)) then
      ShowMessage('CheckMate')
    else
      ShowMessage('Nulle');
    IsPlayOn := False;
    exit;
  end;
  h := {$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF};
  Form1.Timer1.Enabled := True;
  with liste_coup do
  begin
    for i := 1 to Nb_pos do
    begin
      PlayMove(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
      position[i, 4] := -negascout(5, -infini, -alpha, not color, APosit_Copy);
      for j := 1 to i - 1 do
        if (position[i, 4] > position[j, 4]) then
        begin
          temp := position[i];
          for k := i downto j + 1 do
            position[k] := position[k - 1];
          position[j] := temp;
          break;
        end;
       APosit_Copy := APosit;
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
          PaintArrow(best_depart, best_arrivee, clGray);
        PaintArrow(position[i, 1], position[i, 2], clBlue);
        if stop then
          exit;
        PlayMove(position[i, 1], position[i, 2], position[i, 3], APosit_Copy);
        t := -negascout(profope - 1, -b, -a, not color, APosit_Copy);
        if (t > a) and (i > 1) then
          a := -negascout(profope - 1, -infini, -t, not color, APosit_Copy);
        a := Max(a, t);
        Nb_Repetition := 0;
        for j := 1 to Taille_Pile_Rep do
          if CompareMem(@APosit_Copy, @La_Pile_Rep[j], 64) then
            Inc(Nb_Repetition);
        if annule then
          if Nb_repetition > 2 then
          begin
            ShowMessage(
              Format('L''ordinateur pouvait annuler en jouant: %s%s',
                [ cartesien(position[i, 1]),cartesien(position[i, 2]) ]));
            if Nb_pos > 1 then
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
            APosit_Copy := APosit;
            break;
          end;
        end;
        APosit_Copy := APosit;
        b := a + 1;
      end;
  end;
  Form1.Timer1.Enabled := False;
  Affiche;
end;

end.

