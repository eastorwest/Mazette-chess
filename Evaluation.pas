// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Evaluation;

interface

function evaluer(const cote: boolean): integer;

implementation

uses SysUtils, Math, Variables;

function evaluer(const cote: boolean): integer;
var
  retour: integer;

begin
  Inc(Nb_Eval);
  with posit do
  begin
    retour := 0;
    if complexite >= 25 then
    begin
      if Roque_Noir then
        case position_roi[Noir] of
          0..2:
          begin
            if (cases[8] = pionnoir) or (cases[16] = pionnoir) then
              Dec(retour, 6);
            if (cases[9] = pionnoir) or (cases[17] = pionnoir) then
              Dec(retour, 6);
            if (cases[10] = pionnoir) or (cases[18] = pionnoir) then
              Dec(retour, 6);
          end;
          5, 6:
          begin
            if (Cases[14] = PionNoir) or (cases[22] = pionnoir) then
              Dec(retour, 6);
            if (Cases[15] = PionNoir) or (cases[23] = pionnoir) then
              Dec(retour, 6);
          end;
        end;
      if Roque_Blanc then
        case position_roi[blanc] of
          56..58:
          begin
            if (cases[48] = pion) or (cases[40] = pion) then
              Inc(retour, 6);
            if (cases[49] = pion) or (cases[41] = pion) then
              Inc(retour, 6);
            if (cases[50] = pion) or (cases[42] = pion) then
              Inc(retour, 6);
          end;
          62, 63:
          begin
            if (cases[54] = pion) or (cases[46] = pion) then
              Inc(retour, 6);
            if (cases[55] = pion) or (cases[47] = pion) then
              Inc(retour, 6);
          end;
        end;
    end;
    if pions_blancs[1] = 0 then
    begin
      if pions_blancs[0] <> 0 then
        Dec(retour, 10); {isole}
      if pions_noirs[0] <> 0 then
        Dec(retour, 10); {passe}
      if (pions_blancs[3] = 0) then
      begin
        if pions_blancs[2] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[2] <> 0 then
          Dec(retour, 10); {passe}
      end;
    end;
    if pions_noirs[1] = 0 then
    begin
      if pions_noirs[0] <> 0 then
        Inc(retour, 10); {isole}
      if pions_blancs[0] <> 0 then
        Inc(retour, 10); {passe}
      if (pions_noirs[3] = 0) then
      begin
        if pions_noirs[2] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[2] <> 0 then
          Inc(retour, 10); {passe}
      end;
    end;


    if pions_blancs[6] = 0 then
    begin
      if (pions_blancs[4] = 0) then
      begin
        if pions_blancs[5] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[5] <> 0 then
          Dec(retour, 10); {passe}
      end;
      if pions_blancs[7] <> 0 then
        Dec(retour, 10); {isole}
      if pions_noirs[7] <> 0 then
        Dec(retour, 10); {passe}
    end;
    if pions_noirs[6] = 0 then
    begin
      if (pions_noirs[4] = 0) then
      begin
        if pions_noirs[5] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[5] <> 0 then
          Inc(retour, 10); {passe}
      end;
      if pions_noirs[7] <> 0 then
        Inc(retour, 10); {isole}
      if pions_blancs[7] <> 0 then
        Inc(retour, 10); {passe}
    end;

    if pions_blancs[2] = 0 then
    begin
      if (pions_blancs[0] = 0) then
      begin
        if pions_blancs[1] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[1] <> 0 then
          Dec(retour, 10); {passe}
      end;
      if (pions_blancs[4] = 0) then
      begin
        if pions_blancs[3] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[3] <> 0 then
          Dec(retour, 10); {passe}
      end;
    end;
    if pions_noirs[2] = 0 then
    begin
      if (pions_noirs[0] = 0) then
      begin
        if pions_noirs[1] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[1] <> 0 then
          Inc(retour, 10); {passe}
      end;
      if (pions_noirs[4] = 0) then
      begin
        if pions_noirs[3] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[3] <> 0 then
          Inc(retour, 10); {passe}
      end;
    end;
    if pions_blancs[5] = 0 then
    begin
      if (pions_blancs[3] = 0) then
      begin
        if pions_blancs[4] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[4] <> 0 then
          Dec(retour, 10); {passe}
      end;
      if (pions_blancs[7] = 0) then
      begin
        if pions_blancs[6] <> 0 then
          Dec(retour, 10); {isole}
        if pions_noirs[6] <> 0 then
          Dec(retour, 10); {passe}
      end;
    end;
    if pions_noirs[5] = 0 then
    begin
      if (pions_noirs[3] = 0) then
      begin
        if pions_noirs[4] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[4] <> 0 then
          Inc(retour, 10); {passe}
      end;
      if (pions_noirs[7] = 0) then
      begin
        if pions_noirs[6] <> 0 then
          Inc(retour, 10); {isole}
        if pions_blancs[6] <> 0 then
          Inc(retour, 10); {passe}
      end;
    end;
    Inc(retour, total);
  end;
  if cote then
    Result := -retour
  else
    Result := retour;
end;

end.
