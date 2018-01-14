// Auteur Montero-Ribas
// Logiciel sous license GNU GPL

unit Echec1;

interface

uses
  {$IFnDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Menus, Buttons, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnStop: TBitBtn;
    ColorDialog1: TColorDialog;
    Image1: TImage;
    miBoardSize: TMenuItem;
    miBoardCustomColor: TMenuItem;
    miBoardColor: TMenuItem;
    miExportGame: TMenuItem;
    miExit: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    Nouvellepartieaveclesblancs1: TMenuItem;
    miDepth: TMenuItem;
    miBoard: TMenuItem;
    miSmallBoard: TMenuItem;
    miLargeBoard: TMenuItem;
    miAbout: TMenuItem;
    Label4: TLabel;
    miPly7: TMenuItem;
    OpenDialog1: TOpenDialog;
    miPly8: TMenuItem;
    miRotate: TMenuItem;
    Nouvellepartieaveclesnoirs1: TMenuItem;
    miSaveGame: TMenuItem;
    miOpenGame: TMenuItem;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    miPly9: TMenuItem;
    miReadEPD: TMenuItem;
    btnFirstMove: TBitBtn;
    btnPrevMove: TBitBtn;
    btnNextMove: TBitBtn;
    btnLastMove: TBitBtn;
    miMediumBoard: TMenuItem;
    Effacerlesflches1: TMenuItem;
    miPly10: TMenuItem;
    miTeal: TMenuItem;
    miOlive: TMenuItem;
    miPly11: TMenuItem;
    miPly12: TMenuItem;
    miPly13: TMenuItem;
    SaveDialog2: TSaveDialog;
    Timer1: TTimer;
    miTools: TMenuItem;
    Casesbattuesblancs1: TMenuItem;
    Casesbattuesnoirs1: TMenuItem;
    procedure btnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Image1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure miBoardCustomColorClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miExportGameClick(Sender: TObject);
    procedure Nouvellepartieaveclesblancs1Click(Sender: TObject);
    procedure miSmallBoardClick(Sender: TObject);
    procedure miMediumBoardClick(Sender: TObject);
    procedure miLargeBoardClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miPly7Click(Sender: TObject);
    procedure miPly8Click(Sender: TObject);
    procedure miPly9Click(Sender: TObject);
    procedure miPly10Click(Sender: TObject);
    procedure miPly11Click(Sender: TObject);
    procedure miPly12Click(Sender: TObject);
    procedure miPly13Click(Sender: TObject);
    procedure miRotateClick(Sender: TObject);
    procedure Nouvellepartieaveclesnoirs1Click(Sender: TObject);
    procedure miSaveGameClick(Sender: TObject);
    procedure miOpenGameClick(Sender: TObject);
    procedure miReadEPDClick(Sender: TObject);
    procedure btnPrevMoveClick(Sender: TObject);
    procedure btnNextMoveClick(Sender: TObject);
    procedure btnFirstMoveClick(Sender: TObject);
    procedure btnLastMoveClick(Sender: TObject);
    procedure Effacerlesflches1Click(Sender: TObject);
    procedure miTealClick(Sender: TObject);
    procedure miOliveClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Casesbattuesblancs1Click(Sender: TObject);
    procedure Casesbattuesnoirs1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure PanelEnabler(const btn1, btn2, btn3, btn4: boolean);

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Variables, Plateau, Deplacements, Fonctions, AB, Promotion, Recherchedecoups, EPD;

var
  ASquare: integer; // first square of the human move

function Min(const a,b: integer): integer;
begin
  if a < b then Result := a
           else Result := b;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EPD_encours := False;
  Randomize;
  Couleur_Fond := clTeal;
  DoubleBuffered := True;
  largeur := 80;
  Initialisation(Posit);
  InitPos := Posit;
  posit_dessin := Posit;
  PaintBoard(posit_dessin);
  init_prof := 9;
  IsPlayOn := False;
  Form1.Label1.Caption := '';
  Nb_Tour := 0;
  Fillchar(zero, SizeOf(zero), 0);
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  stop := True;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  PaintBoard(posit_dessin);
end;

function InMoveList(const ca: integer; const AMoveList: T_Liste_Coup; var ef: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 1 to AMoveList.Nb_pos do
    if ca = AMoveList.position[i, 2] then
    begin
      ef := AMoveList.position[i, 3];
      Result := True;
      exit;
    end;
end;

procedure inc_historique(const la, labas, la_ef: integer; const APosit: T_echiquier);
begin
  Combien_hist := Index_hist;
  Inc(Combien_hist);
  Index_hist := Combien_hist;
  with hist_int[Combien_hist] do
  begin
    depart := la;
    arrivee := labas;
    efface := la_ef;
    QuoiDedans := APosit.Cases[labas];
  end;
end;

procedure Computer;
var
  i: integer;
  b: boolean;
  historique, sMove: string;
begin
  //Form1.miStop.Visible := True;
  //Form1.miFile.Enabled := False;
  //Form1.miFile.Visible := False;
  //Form1.miTools.Visible := False;
  Form1.btnStop.Enabled := True;
  historique := '';
  Posit_dessin := Posit;
  PanelEnabler(False, False, False, False);
  for i := 1 to Min(combien_hist, 20) do
    historique := historique + cartesien(hist_int[i].depart) +
      cartesien(hist_int[i].arrivee);
  Complexite := 0; {Debut:Complexite=88    finale pion : 3 ou 4}
  for i := 0 to 63 do
    case abs(Posit.Cases[i]) of
      Pion: Inc(complexite, 1);
      Tour: Inc(complexite, 5);
      Fou, Cavalier: Inc(complexite, 4);
      Reine: Inc(complexite, 10);
    end;
  profope := Init_prof;
  case complexite of
    0..7: profope := Init_Prof + 2;
    8..30: profope := Init_Prof + 1;
    31..100: Profope := Init_Prof;
  end;
  Form1.Label4.Caption := Format('Analyse: %d plies',[profope]);
  h := {$IFnDEF FPC} GetTickCount {$ELSE} GetTickCount64 {$ENDIF};
  Nb_Eval := 0;
  b := suivant(historique, best_depart, best_arrivee);
  if b then
  begin
    best_efface := best_depart;
    Coups_Possibles.Nb_pos := 0;
    if (Couleur_ordi and (Posit.Cases[best_depart] >= 0)) or
      (not Couleur_ordi and (Posit.Cases[best_depart] <= 0)) then
      b := False
    else
    begin
      if Couleur_Ordi then
        Moves_black(best_depart, Posit, Coups_Possibles)
      else
        Moves_white(best_depart, Posit, Coups_Possibles);
      b := InMoveList(best_arrivee, Coups_Possibles, i);
    end;
  end;
  if not b then
    SearchBestMove(Couleur_Ordi, Posit);
  if IsPlayOn then
  begin
    sMove := mouv(best_depart, best_arrivee, Posit);
    PlayMove(best_depart, best_arrivee, best_efface, Posit);
    Empile_Rep(Posit);
    inc_historique(best_depart, best_arrivee, best_efface, Posit);
    posit_dessin := Posit;
    PaintBoard(posit_dessin);
    Mark_Square(best_arrivee div 8, best_arrivee mod 8, clBlue);
    Mark_Square(best_depart div 8, best_depart mod 8, clBlue);
    Form1.Label4.Caption := sMove;
  end;
  if (Couleur_ordi and souslefeu(Posit.position_roi[False], 1, False, Posit)) or
    (not Couleur_ordi and souslefeu(Posit.position_roi[True], -1, False, Posit)) then
  begin
    Form1.Label1.Caption := 'Echec';
    GenerateMoveList(not Couleur_ordi, Posit, Coups_Possibles);
    if Coups_Possibles.Nb_pos = 0 then
      ShowMessage('CheckMate');
  end;
  PanelEnabler(True, True, False, False);
  //Form1.miFile.Enabled := True;
  //Form1.miStop.Visible := False;
  //Form1.miFile.Visible := True;
  //Form1.miTools.Visible := True;
  Form1.btnStop.Enabled := False;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  labas, la_ef: integer;
  promo: boolean;
  li, co: integer;
begin
  if Button = mbLeft then
  begin
    if not IsPlayOn then
      exit;
    if Couleur_Ordi xor (not Odd(Index_Hist)) xor (EPD_noir_dabord and
      EPD_encours){ XOR EPD_swap } then
    begin
      ShowMessage('It is not your turn to play move !');
      exit;
    end;
    if not IsMoveInput then
    begin
      ASquare := x div largeur + 8 * (y div largeur);
      detourne(li, co, ASquare);
      if ((Posit.Cases[ASquare] <= 0) and Couleur_Ordi) or
        ((Posit.Cases[ASquare] >= 0) and not Couleur_Ordi) then
        exit;
      Coups_Possibles.Nb_pos := 0;
      if Couleur_Ordi then
      begin
        Cases_battues_par_noirs(Posit);
        Moves_white(ASquare, Posit, Coups_Possibles);
      end
      else
      begin
        Cases_battues_par_blancs(Posit);
        Moves_black(ASquare, Posit, Coups_Possibles);
      end;
      Mark_MoveList(Coups_Possibles, clRed);
      if Coups_Possibles.Nb_pos <> 0 then
        IsMoveInput := True;
    end
    else
    begin
      PanelEnabler(False, False, False, False);
      IsMoveInput := False;
      labas := x div largeur + 8 * (y div largeur);
      detourne(li, co, labas);
      if InMoveList(labas, Coups_Possibles, la_ef) then
      begin
        if Couleur_Ordi then
          promo := ((labas <= 7) and (Posit.Cases[ASquare] = pion))
        else
          promo := ((labas >= 56) and (Posit.Cases[ASquare] = pionNoir));
        PlayMove(ASquare, labas, la_ef, Posit);
        if promo then {promotion pawn}
        begin
          Posit.Cases[labas] := (1 - 2*ord(not Couleur_Ordi))*Form2.ShowModal;
          recalcule(Posit);
        end;
        inc_historique(ASquare, labas, la_ef, Posit);
        Empile_Rep(Posit);
        PaintBoard(Posit);
        Mark_Square(ASquare div 8, ASquare mod 8, ClRed);
        Mark_Square(labas div 8, labas mod 8, ClRed);
        Computer;
      end
      else
        PaintBoard(Posit);
    end;
    PanelEnabler(True, True, False, False);
  end;
end;

procedure TForm1.Image1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta > 0 then
    btnPrevMoveClick(Sender)
  else
    btnNextMoveClick(Sender);
end;

procedure TForm1.miBoardCustomColorClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    Couleur_Fond := ColorDialog1.Color;
    PaintBoard(posit_dessin);
  end;
end;

procedure TForm1.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.miExportGameClick(Sender: TObject);
var
  F: TextFile;
  i: Integer;
  AMoveSList: TStringList;
  ATempPosit: T_Echiquier;
  AFileName: string;
begin
  if SaveDialog2.Execute then
  begin
    AFileName := SaveDialog2.Filename;
    if FileExists(AFileName) then
      if MessageDlg('File already exists. Do you wish to replace it ?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        exit;

    ATempPosit := InitPos;

    AMoveSList := TStringList.Create;
    for i := Low(hist_int) to Combien_hist do // max plies
    begin
      AMoveSList.Add(mouv(hist_int[i].depart, hist_int[i].arrivee, ATempPosit));

      PlayMove(hist_int[i].depart, hist_int[i].arrivee, hist_int[i].efface, ATempPosit);
      ATempPosit.Cases[hist_int[i].arrivee] := hist_int[i].QuoiDedans;
    end;

    AssignFile(F, AFileName);
    ReWrite(F);
    try
      for i := 0 to AMoveSList.Count-1 do
        if i mod 2 = 0 then
          Write(F, IntToStr(i div 2 + 1)+'. '+AMoveSList[i]+' ')
        else
          WriteLn(F, AMoveSList[i]);
    finally
      CloseFile(F);
    end;
    AMoveSList.Free;
  end;
end;

procedure TForm1.Nouvellepartieaveclesblancs1Click(Sender: TObject);
begin
  EPD_encours := False;
  Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
  Label1.Caption := '';
  Couleur_Ordi := True;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 0;
  Initialisation(Posit);
  InitPos := Posit;
  posit_dessin := Posit;
  PaintBoard(posit_dessin);
  IsPlayOn := True;
end;

procedure TForm1.Nouvellepartieaveclesnoirs1Click(Sender: TObject);
var
  rr, la, labas: integer;
begin
  EPD_encours := False;
  Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
  Label1.Caption := '';
  Couleur_Ordi := False;
  Combien_hist := 0;
  Index_hist := 0;
  Nb_Tour := 2;
  Initialisation(Posit);
  InitPos := Posit;
  rr := Random(7) + 1;
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
  PlayMove(la, labas, la, Posit);
  posit_dessin := Posit;
  PaintBoard(posit_dessin);
  inc_historique(la, labas, la, Posit);
  IsPlayOn := True;
end;

procedure TForm1.miSmallBoardClick(Sender: TObject);
begin
  largeur := 60;
  PaintBoard(posit_dessin);
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miMediumBoardClick(Sender: TObject);
begin
  largeur := 80;
  PaintBoard(posit_dessin);
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miLargeBoardClick(Sender: TObject);
begin
  largeur := 95;
  PaintBoard(posit_dessin);
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miAboutClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TForm1.miPly7Click(Sender: TObject);
begin
  Init_Prof := 7;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly8Click(Sender: TObject);
begin
  Init_Prof := 8;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly9Click(Sender: TObject);
begin
  Init_Prof := 9;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly10Click(Sender: TObject);
begin
  Init_Prof := 10;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly11Click(Sender: TObject);
begin
  Init_Prof := 11;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly12Click(Sender: TObject);
begin
  Init_Prof := 12;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miPly13Click(Sender: TObject);
begin
  Init_Prof := 13;
  (Sender as TMenuItem).Checked := True;
end;

procedure TForm1.miRotateClick(Sender: TObject);
begin
  Nb_Tour := (Nb_Tour + 2) mod 4;
  PaintBoard(posit_dessin);
end;

procedure TForm1.miSaveGameClick(Sender: TObject);
var
  F: file;
  AFileName: string;
begin
  if SaveDialog1.Execute then
  begin
    AFileName := SaveDialog1.Filename;
    if FileExists(AFileName) then
      if MessageDlg('File already exists. Do you wish to replace it ?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        exit;
    AssignFile(F, AFileName);
    ReWrite(F, 1);
    try
      BlockWrite(F, Couleur_Ordi, SizeOf(Couleur_Ordi));
      BlockWrite(F, Index_hist, SizeOf(Index_hist));
      BlockWrite(F, Combien_hist, SizeOf(Combien_hist));
      BlockWrite(F, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(F);
    end;
  end;
end;

procedure restitue(const jusque: integer);
var
  i: integer;
begin
  for i := 1 to jusque do
  begin
    empile_Rep(Posit);
    PlayMove(hist_int[i].depart, hist_int[i].arrivee, hist_int[i].efface, Posit);
    Posit.Cases[hist_int[i].arrivee] := hist_int[i].QuoiDedans;
  end;
  posit_dessin := Posit;
  PaintBoard(posit_dessin);
end;

procedure TForm1.miOpenGameClick(Sender: TObject);
var
  F: file;
  AFileName: string;
begin
  if OpenDialog2.Execute then
  begin
    AFileName := OpenDialog2.Filename;
    Index_hist := 0;
    Initialisation(Posit);
    IsPlayOn := True;
    AssignFile(F, AFileName);
    Reset(F, 1);
    try
      BlockRead(F, Couleur_Ordi, SizeOf(Couleur_Ordi));
      BlockRead(F, Index_hist, SizeOf(Index_hist));
      BlockRead(F, Combien_hist, SizeOf(Combien_hist));
      BlockRead(F, hist_int[1], Combien_hist * SizeOf(hist_int[1]));
    finally
      Closefile(F);
    end;
    if Couleur_Ordi then
      Nb_Tour := 0
    else
      Nb_Tour := 2;
    restitue(Index_hist);
    posit_dessin := posit;
    PaintBoard(posit_dessin);
    PanelEnabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  end;
end;

procedure TForm1.miReadEPDClick(Sender: TObject);
begin
  Form3.ShowModal;
  if length(Form3.edit1.Text) > 0 then
    if EpdToEchiquier(Form3.edit1.Text, Posit) then
    begin
      Fillchar(La_Pile_Rep, SizeOf(La_Pile_Rep), 0);
      InitPos := Posit;
      EPD_encours := True;
      EPD_noir_dabord := couleur_ordi;
      EPD_swap := False;
      Combien_hist := 0;
      Index_hist := 0;
      IsPlayOn := True;
      if couleur_ordi = True then
        Nb_Tour := 0
      else
        Nb_Tour := 2;
      posit_dessin := Posit;
      PaintBoard(posit_dessin);
      EPD_swap := not Form3.RadioButton1.Checked;
      if not Form3.RadioButton1.Checked then
        couleur_ordi := not couleur_ordi;
      if not EPD_swap then
        Computer;
    end;
end;

procedure TForm1.btnPrevMoveClick(Sender: TObject);
begin
  if Index_hist < 1 then
    exit;
  IsMoveInput := False;
  Posit := InitPos;
  Dec(Index_hist, 1);
  PanelEnabler(Index_hist > 0, Index_hist > 0, True, True);
  restitue(Index_Hist);
end;

procedure TForm1.btnNextMoveClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then
    exit;
  IsMoveInput := False;
  Posit := InitPos;
  Inc(Index_hist, 1);
  PanelEnabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  restitue(Index_Hist);
end;

procedure TForm1.btnFirstMoveClick(Sender: TObject);
begin
  if Index_hist < 1 then
    exit;
  IsMoveInput := False;
  Posit := InitPos;
  Index_hist := 0;
  PanelEnabler(Index_hist > 0, Index_hist > 0, True, True);
  restitue(Index_Hist);
end;

procedure TForm1.btnLastMoveClick(Sender: TObject);
begin
  if Index_hist > Combien_hist - 1 then
    exit;
  IsMoveInput := False;
  Posit := InitPos;
  Index_hist := Combien_hist;
  PanelEnabler(True, True, (Index_hist < Combien_hist), (Index_hist < Combien_hist));
  restitue(Index_Hist);
end;

procedure TForm1.Effacerlesflches1Click(Sender: TObject);
begin
  Effacerlesflches1.Checked := not (Effacerlesflches1.Checked);
end;

procedure TForm1.miTealClick(Sender: TObject);
begin
  Couleur_Fond := clTeal;
  PaintBoard(posit_dessin);
end;

procedure TForm1.miOliveClick(Sender: TObject);
begin
  Couleur_Fond := clOlive;
  PaintBoard(posit_dessin);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Affiche;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  stop := False;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

end;

procedure trace_battues(const Acolor: boolean);
var
  la, li, co, oux, ouy, total: integer;

  procedure lignes(const X1, Y1, X2, Y2: single);
  begin
    with Form1.image1.canvas do
    begin
      MoveTo(Round(X1), Round(Y1));
      LineTo(Round(X2), Round(Y2));
    end;
  end;

begin
  total := 0;
  if Acolor then
    Cases_battues_par_noirs(Posit)
  else
    Cases_battues_par_blancs(Posit);
  with Form1.image1.canvas do
    for la := 0 to 63 do
    begin
      li := La div 8;
      co := La mod 8;
      tourne(li, co);
      oux := Round((co + 0.5) * largeur);
      ouy := Round((li + 0.5) * largeur);
      {souslefeu(Posit.Position_Roi[Blanc], 1, false) }
      if cases_battues[la] <> 0 then
        if (not Acolor and souslefeu(la, -1, False, Posit)) or
          (Acolor and souslefeu(la, 1, False, Posit))
        then
        begin
          Inc(total);
          lignes(oux - largeur div 3, ouy - largeur div 3, oux +
            largeur div 3, ouy + largeur div 3);
          lignes(oux - largeur div 3, ouy + largeur div 3, oux +
            largeur div 3, ouy - largeur div 3);
        end;
    end;
  ShowMessage(Format('%d control squares.', [total]));
  PaintBoard(posit_dessin);
end;

procedure TForm1.Casesbattuesblancs1Click(Sender: TObject);
begin
  trace_battues(False);
end;

procedure TForm1.Casesbattuesnoirs1Click(Sender: TObject);
begin
  trace_battues(True);
end;

procedure PanelEnabler(const btn1, btn2, btn3, btn4: boolean);
begin
  with Form1 do
  begin
    btnFirstMove.Enabled := btn1;
    btnPrevMove.Enabled := btn2;
    btnNextMove.Enabled := btn3;
    btnLastMove.Enabled := btn4;
  end;
end;

end.
