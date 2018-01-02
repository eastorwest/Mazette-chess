// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Plateau;

interface

uses Variables;

procedure detourne(var li, co, la: integer);
procedure tourne(var li, co: integer);
procedure PaintBoard(const p: T_echiquier);

implementation

uses Types, Graphics, Fonctions, Echec1;

type
  profil = array[1..16] of array[1..2] of single;

const
  lep: profil = ((0.2, 0.4), (0.2, 0.3), (0.05, 0.3), (0.05, 0.1),
    (0.1, 0.1), (0.1, -0.1), (-0.1, -0.1), (-0.1, 0.1),
    (-0.05, 0.1), (-0.05, 0.3), (-0.2, 0.3), (-0.2, 0.4), (0, 0),
    (0, 0), (0, 0), (0, 0));
  lat: profil = ((0.3, 0.4), (0.3, 0.3), (0.15, 0.3), (0.15, -0.2),
    (0.3, -0.2), (0.3, -0.4), (0.2, -0.4), (0.2, -0.3),
    (-0.2, -0.3), (-0.2, -0.4), (-0.3, -0.4), (-0.3, -0.2), (-0.15, -0.2),
    (-0.15, 0.3), (-0.3, 0.3), (-0.3, 0.4));
  lec: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0), (0.1, -0.3),
    (0, -0.3), (-0.2, -0.1), (-0.2, 0),
    (0, -0.05), (0, 0.1), (-0.1, 0.3), (-0.3, 0.3), (-0.3, 0.4), (0, 0), (0, 0), (0, 0));
  lef: profil = ((0.3, 0.4), (0.3, 0.3), (0.05, 0.3), (0.05, 0),
    (0.15, -0.15), (0.05, -0.3), (-0.05, -0.3), (-0.15, -0.15),
    (-0.05, 0), (-0.05, 0.3), (-0.3, 0.3), (-0.3, 0.4), (0, 0), (0, 0), (0, 0), (0, 0));
  lar: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0), (0.3, -0.3),
    (0.1, -0.1), (0, -0.3), (-0.1, -0.1),
    (-0.3, -0.3), (-0.2, 0), (-0.2, 0.3), (-0.3, 0.3), (-0.3, 0.4),
    (0, 0), (0, 0), (0, 0));
  ler: profil = ((0.3, 0.4), (0.3, 0.3), (0.2, 0.3), (0.2, 0), (0.3, -0.2),
    (0.2, -0.2), (0, 0), (-0.2, -0.2),
    (-0.3, -0.2), (-0.2, 0), (-0.2, 0.3), (-0.3, 0.3), (-0.3, 0.4),
    (0, 0), (0, 0), (0, 0));

procedure tourne(var li, co: integer);
var
  t, i: integer;
begin
  for i := 1 to Nb_Tour do
  begin
    t := li;
    li := co;
    co := 7 - t;
  end;
end;

procedure detourne(var li, co, la: integer);
var
  t, i: integer;
begin
  li := La div 8;
  co := La mod 8;
  for i := 1 to Nb_Tour do
  begin
    t := co;
    co := li;
    li := 7 - t;
  end;
  la := li * 8 + co;
end;

procedure PaintBoard(const p: T_echiquier);
var
  li, co, choix, la, oux, ouy: integer;
  polygone: array[1..16] of tpoint;

  procedure ligne(x1, y1, X2, Y2: single);
  begin
    with form1.image1.canvas do
    begin
      MoveTo(round(X1), round(Y1));
      LineTo(round(X2), round(Y2));
    end;
  end;

  procedure Trace_Profil(const lax, lay: integer; const qui: Profil; Combien: integer);
  var
    i: integer;
  begin
    for i := 1 to combien do
    begin
      polygone[i].x := lax + round(qui[i, 1] * largeur);
      polygone[i].y := lay + round(qui[i, 2] * largeur);
    end;
    form1.image1.canvas.polygon(Slice(polygone, Combien));
  end;

begin
  Form1.Clientwidth := 8 * largeur;
  Form1.ClientHeight := 8 * largeur + form1.Panel1.Height;
  Form1.Image1.Width := 8 * largeur;
  Form1.Image1.Height := 8 * largeur;
  with form1.image1.canvas do
    for la := 0 to 63 do
    begin
      li := La div 8;
      co := La mod 8;
      tourne(li, co);
      if odd(Nb_Tour) xor odd(li + co) then
        brush.color := Couleur_fond
      else
        brush.color := Couleur_Blanc;
      polygone[1].x := co * largeur;
      polygone[1].y := li * largeur;
      polygone[2].x := co * largeur;
      polygone[2].y := (li + 1) * largeur;
      polygone[3].x := (co + 1) * largeur;
      polygone[3].y := (li + 1) * largeur;
      polygone[4].x := (co + 1) * largeur;
      polygone[4].y := li * largeur;
      Brush.style := bssolid;
      polygon(Slice(polygone, 4));
      oux := round((co + 0.5) * largeur);
      ouy := round((li + 0.5) * largeur);
      if p.Cases[la] < 0 then
      begin
        brush.color := clblack;
        pen.color := clwhite;
      end
      else
      begin
        brush.color := clwhite;
        pen.color := clblack;
      end;
      choix := p.Cases[la];
      case choix of
        PionNoir, Pion: Trace_Profil(oux, ouy, lep, 12);
        TourNoir, Tour: Trace_Profil(oux, ouy, lat, 16);
        CavalierNoir, Cavalier: Trace_Profil(oux, ouy, lec, 13);
        FouNoir, Fou:
        begin
          Trace_Profil(oux, ouy, lef, 12);
          ligne(oux - 0.032 * largeur * 2, ouy - 0.032 * largeur *
            3 - 0.15 * largeur, oux + 0.032 * largeur * 2, ouy + 0.032 * largeur * 3 -
            0.15 * largeur);
        end;
        ReineNoir, Reine: Trace_Profil(oux, ouy, lar, 13);
        RoiNoir, Roi:
        begin
          Trace_Profil(oux, ouy, ler, 13);
          if choix < 0 then
            form1.image1.Canvas.Pen.Color := clWhite
          else
            form1.image1.Canvas.Pen.Color := clBlack;
          Pen.Width := 5;
          ligne(oux, ouy - 0.1 * largeur, oux, ouy - 0.3 * largeur);
          ligne(oux - 0.1 * largeur, ouy - 0.2 * largeur, oux +
            0.1 * largeur, ouy - 0.2 * largeur);
          if choix > 0 then
            form1.image1.Canvas.Pen.Color := clWhite
          else
            form1.image1.Canvas.Pen.Color := clBlack;
          Pen.Width := 3;
          ligne(oux, ouy - 0.1 * largeur, oux, ouy - 0.3 * largeur);
          ligne(oux - 0.1 * largeur, ouy - 0.2 * largeur, oux +
            0.1 * largeur, ouy - 0.2 * largeur);
          Pen.Width := 1;
        end;
      end;
      Brush.style := bsclear;
      pen.color := clgreen;
      pen.color := clblack;
    end;
end;

end.
