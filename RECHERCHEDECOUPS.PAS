unit recherchedecoups;
interface
procedure Affiche;
procedure Recherche(const color: boolean);

implementation
uses windows, SysUtils, variables, deplacements, dialogs, fonctions, evaluation, forms, echec1, math, Graphics, plateau;


function feuilletrue(const beta: integer): integer;
var j,i,Le_Meilleur, cbpb, evalu,perte:integer;
  encours: T_echiquier;
  
begin
  encours := Posit;
  Le_Meilleur := -infini;
  evalu:=-111111; { a priori : impossible à avoir }
  with coups_possibles do with posit do
    begin
      cbpb:=Cases_battues_par_blancs;
      for j :=  63 downto 0 do if cases[j ] < 0 then
      begin
        Nb_Pos := 0;
        coups_Noirs(coups_possibles,j);
        perte:=-valeurs_cases[cases[j]] div 3;
        if Nb_Pos <> 0 then
        begin
          for i := 1 to Nb_pos do
          begin
            jouertrue(position[i, 1], position[i, 2], position[i, 3]);
            evalu := evaluer(true)-cbpb;
            if cases_battues[position[i, 2]]<>0 then evalu:=evalu-perte;
            Posit := encours;
            if evalu > Le_Meilleur then
            begin
              Le_Meilleur := evalu;
              if Le_Meilleur >= beta then
              begin
                feuilletrue := Le_Meilleur;
                exit;
              end;
            end;
          end;
        end;
      end;
      if evalu=-111111 then
      begin
        if souslefeu(Position_Roi[Noir], -1, false) then feuilletrue := -infini + (profope - 1) else feuilletrue := 0;
        exit;
      end;
      feuilletrue := Le_Meilleur;
      exit;
    end;
end;

function feuillefalse(const beta: integer): integer;
var j, i,Le_Meilleur,cbpn,evalu,perte:integer;
    encours: T_echiquier;
begin
  encours := Posit;
  Le_Meilleur := -infini;
  evalu:=-111111;
  with coups_possibles do with posit do
  begin
    cbpn:=Cases_battues_par_noirs;
    for j := 0 to 63 do if cases[j] > 0 then
    begin
      Nb_Pos := 0;
      coups_blancs(coups_possibles,j);
      perte:=valeurs_cases[cases[j]] div 3;
      if Nb_Pos <> 0 then
      begin
        for i := 1 to Nb_pos do
        begin
          jouerfalse(position[i, 1], position[i, 2], position[i, 3]);
          evalu := evaluer(false)-cbpn;
          if cases_battues[position[i, 2]]<>0 then evalu:=evalu-perte;
          Posit := encours;
          if evalu > Le_Meilleur then
          begin
            Le_Meilleur := evalu;
            if Le_Meilleur >= beta then
            begin
              feuillefalse := Le_Meilleur;
              exit;
            end;
          end;
        end;
      end;
    end;
    if evalu=-111111 then
    begin
      if souslefeu(Position_Roi[Blanc], 1, false) then feuillefalse := -infini + (profope - 1) else feuillefalse := 0;
      exit;
    end;
    feuillefalse := Le_Meilleur;
    exit;
  end;
end;

procedure Affiche;
begin
  Form1.Label1.caption := strint(Nb_Eval) + ' Evaluations en : '+temps(GetTickCount - h);
end;

function AlphaBeta(const profondeur: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var i,evalu, Le_Meilleur:integer;
  tmp: T_Element;
  encours: T_echiquier;
  liste_coup:T_Liste_Coup;
begin
  if profondeur = 1 then if color then begin alphabeta := feuilletrue(beta); exit; end else begin alphabeta := feuillefalse(beta); exit; end;
  encours := Posit;
  Le_Meilleur := -infini;
  generer_liste_coup(liste_coup,color);
  with liste_coup do with posit do
  begin
    if Nb_pos = 0 then if color then
      begin
        if souslefeu(Position_Roi[Noir], -1, false) then AlphaBeta := -infini + (profope - profondeur) else AlphaBeta := 0;
        exit;
      end else
      begin
        if souslefeu(Position_Roi[Blanc], 1, false) then AlphaBeta := -infini + (profope - profondeur) else AlphaBeta := 0;
        exit;
      end;
      for i := 1 to Nb_pos do if La_Pile_1 = position[i, 1] then if La_Pile_2 = position[i, 2] then
      begin
        tmp := position[i];
        position[i]:=position[1];
        {for j := i downto 2 do position[j] := position[j - 1];}
        position[1] := tmp;
        Break;
      end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      {if color then evalu:=-feuillefalse(-alpha) else evalu:=-feuilletrue(-alpha);}
      evalu := -AlphaBeta(profondeur - 1, -beta, -alpha, not color);
      Posit := encours;
      if evalu > Le_Meilleur then
      begin
        Le_Meilleur := evalu;
        if Le_Meilleur >= beta then
        begin
          AlphaBeta := Le_Meilleur;
          La_Pile_1 := position[i, 1];
          La_Pile_2:= position[i, 2];
          exit;
        end;
        alpha := max(alpha, le_meilleur);
      end;
    end;
  end;
  AlphaBeta := Le_Meilleur;
end;

function negascout(const profondeur,alpha,beta: integer; const color: boolean): integer;
var i,j,k, a, b, t: integer;
  encours: T_echiquier;
  liste_coup:T_Liste_Coup;
  temp:T_Element;
begin
  if profondeur = 2 then  begin Negascout := alphabeta(profondeur, alpha, beta,color); exit; end;
  {appelé à LA PROFONDEUR 2 seulement}    
  if stop then begin Negascout :=0;exit;end;
  encours := Posit;
  generer_liste_coup(liste_coup,color);
  a := alpha; b := beta;
  with liste_coup do with posit do
  begin
    if Nb_pos = 0 then if color then
    begin
      if souslefeu(Position_Roi[Noir], -1, false) then Negascout := -infini + (profope - profondeur) else Negascout := 0;
      exit;
    end else
    begin
      if souslefeu(Position_Roi[Blanc], 1, false) then Negascout := -infini + (profope - profondeur) else Negascout := 0;
      exit;
    end;
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      if (profondeur = profope-1)  then position[i, 4] := -AlphaBeta(2, -beta, -alpha, not color) else
      case profondeur of
              3..4:position[i, 4] := evaluer(color);
             5..15:position[i, 4] := -AlphaBeta(1, -beta, -alpha, not color);
      end;
      for j:=1 to min(i-1,6) do if  (position[i,4]  > position[j,4]) then
      begin
        temp:=position[i];
        for k:=i downto j+1 do position[k]:=position[k-1];
        position[j]:=temp;
        break;
      end;
      Posit := encours;
    end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(profondeur - 1, -b, -a, not color);
      if (t > a) then         {modif là !}
      begin
        if (t < beta) and (i > 1) then a := -Negascout(profondeur - 1, -beta, -t, not color);
        a := max(a, t);
      end;
      Posit := encours;
      if a >= beta then
      begin
        Negascout := a;
        exit;
      end;
      b := a + 1;
    end;
  end;
  Negascout := a;
end;

procedure Recherche(const color: boolean);
var Le_Meilleur, i, j,k ,alpha: integer;
  encours: T_echiquier;
  annule: boolean;
  a, b, t: integer;
  liste_coup:T_Liste_Coup;
  temp:T_Element;
begin
  annule := true; alpha := -infini; stop := false; a := alpha; b := infini;
  enabler(false, false, false, false);
  posit.Total := 0;
  la_Pile_1:= 0;
  la_Pile_2:=0;
  encours := posit;
  Le_Meilleur := -infini;
  generer_liste_coup(liste_coup,color);
  if liste_coup.Nb_pos = 0 then
  begin
    if (color and souslefeu(posit.Position_Roi[Noir], -1, false)) or (not color and souslefeu(posit.Position_Roi[Blanc], 1, false)) then
    begin
      showmessage('Mat !');
      partie_en_cours := false;
    end else
    begin
      showmessage('Nulle');
      encours := posit;
      partie_en_cours := false;
    end;
    exit;
  end;
  h := GetTickCount;
  form1.Timer1.Enabled:=true;
  with liste_coup do
  begin
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := - negascout(5, -infini, -alpha, not color);
      for j:=1 to i-1 do if  (position[i,4]  > position[j,4]) then
      begin
        temp:=position[i];
        for k:=i downto j+1 do position[k]:=position[k-1];
        position[j]:=temp;
        break;
      end;
      posit := encours;
    end;
    dessine(posit_dessin);
    if Nb_pos=1 then
    begin
      best_depart := position[1, 1];
      best_arrivee := position[1, 2];
      best_efface := position[1, 3];
    end else
    for i := 1 to Nb_pos do
    begin
      Affiche;
      if form1.Effacerlesflches1.checked then dessine(posit_dessin);
      If i>1 then  fleche(best_depart, best_arrivee,clgray);
      fleche(position[i, 1], position[i, 2],clBlue);
      if stop then exit;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(profope - 1, -b, -a, not color);
      if (t > a) and (i > 1) then a := -Negascout(profope - 1, -infini, -t, not color);
      a := max(a, t);
      Nb_Repetition := 0;
      for j := 1 to Taille_Pile_Rep do if compareMem(@encours, @La_Pile_Rep[j], 64) then Inc(Nb_Repetition);
      if annule then if Nb_repetition > 2 then
        begin
          showmessage('L''ordinateur pouvait annuler en jouant : ' + cartesien(position[i, 1]) + cartesien(position[i, 2]));
          if nb_pos > 1 then a := -infini;
          nb_repetition := 0;
          annule := false;
        end;
      if a > Le_Meilleur then
      begin
        Le_Meilleur := a;
        best_depart := position[i, 1];
        best_arrivee := position[i, 2];
        best_efface := position[i, 3];
        if (le_meilleur > infini - 20) then begin posit := encours; break; end;
      end;
      posit := encours;
      b := a + 1;
    end;
  end;
  form1.Timer1.Enabled:=false;
  Affiche;
end;

end.

