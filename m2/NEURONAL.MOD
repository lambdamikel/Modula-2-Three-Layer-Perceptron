MODULE Neuronal;

(* Algorithmus aus "E. Rich/K. Night: Artificial Intelligence" *)
(* Implementiert und Umgebung von Michael Wessel, Januar 1994  *)

FROM InOut     IMPORT Read, ReadInt, WriteInt, WriteString, Write, WriteLn;
FROM RealInOut IMPORT ReadReal, WriteReal;
FROM MathLib0  IMPORT exp;
FROM Lib       IMPORT RAND;
FROM Graph     IMPORT InitVGA, TextMode, GraphMode, Plot, Line;

(* maximal 10 Output-Units, 20 Hidden-Units und 8x8=64 Input-Units *)

TYPE net = RECORD
             Input  : ARRAY[0..64] OF REAL;         (* Level d. Input-Units *)
             Hidden : ARRAY[0..20] OF REAL;         (* Level d. Hidden-Units *)
             Output : ARRAY[1..10] OF REAL;         (* Level d. Output-Units *)
             Goal   : ARRAY[1..10] OF REAL;         (* verlangter Output *)
             w1     : ARRAY[0..64],[1..20] OF REAL; (* Gewichte Input->Hidden *)
             w2     : ARRAY[0..20],[1..10] OF REAL; (* Gewichte Hidden->Output *)
           END;

     matrix = ARRAY[1..10],[1..64+10] OF REAL;

VAR netz : net;
    InOut : matrix;                 (* zu lernende Muster, 10 Stk. † 8*8 max *)
    a, b, c, px, py, anz : INTEGER; (* a=px*py, Input, b= Hidden, c= Output  *)
    epoche, maxepoche, i : INTEGER; (* anz = 1..10 Muster, epoche, i: ZÑhler *)
    muster, npro         : INTEGER; (* Muster = akt. Muster, npro f. Protok. *)
    n : REAL;                       (* Lernrate                              *)
    xpos : CARDINAL;                (* Grafikcursorposi.                     *)

(* Jedes Kantengewicht wird mit Random zw. -0.1 und 0.1 initialisiert *)

PROCEDURE RandInit(VAR netz : net);
VAR i, j : INTEGER;
BEGIN
  (* Init der Input->Hidden-Kanten *)
  FOR i:=0 TO a DO
    FOR j:=1 TO b DO
      netz.w1[i,j]:=-0.1+RAND()/5.0;
    END;
  END;
  (* Init der Hidden->Output-Kanten *)
  FOR i:=0 TO b DO
    FOR j:=1 TO c DO
      netz.w2[i,j]:=-0.1+RAND()/5.0;
    END;
  END;
END RandInit;

(* berechnet den Output des Input-Layers *)

PROCEDURE OutputOfInput(VAR netz : net);
VAR i,j : INTEGER;
    sum : REAL;
BEGIN
  FOR j:=1 TO b DO
    sum:=0.0;
    FOR i:=0 TO a DO
      sum:=sum+netz.w1[i,j]*netz.Input[i];
    END;
    netz.Hidden[j]:=1.0/(1.0+exp(-sum));
  END;
END OutputOfInput;

(* berechnet den Output des Hidden-Layers *)

PROCEDURE OutputOfHidden(VAR netz : net);
VAR i,j : INTEGER;
    sum : REAL;
BEGIN
  OutputOfInput(netz);
  FOR j:=1 TO c DO
    sum:=0.0;
    FOR i:=0 TO b DO
      sum:=sum+netz.w2[i,j]*netz.Hidden[i];
    END;
    netz.Output[j]:=1.0/(1.0+exp(-sum));
  END;
END OutputOfHidden;

(* berechnet den Fehler der Output-Unit "j" durch Vergleich des aktuellen
   Outputs mit dem verlangten Output *)

PROCEDURE ErrOfOutput(j : INTEGER; VAR netz : net):REAL;
BEGIN
  RETURN(netz.Output[j]*(1.0-netz.Output[j])*(netz.Goal[j]-netz.Output[j]));
END ErrOfOutput;

(* berechnet den Fehler der Hidden-Unit "j" *)

PROCEDURE ErrOfHidden(j : INTEGER; VAR netz : net):REAL;
VAR i : INTEGER;
    sum : REAL;
BEGIN
  sum:=0.0;
  FOR i:=1 TO c DO
    sum:=sum+ErrOfOutput(i,netz)*netz.w2[j,i];
  END;
  RETURN(netz.Hidden[j]*(1.0-netz.Hidden[j])*sum);
END ErrOfHidden;

(* verÑndere die Kantengewichte des Netzes *)

PROCEDURE Adjust(VAR netz : net);
VAR i, j : INTEGER;
BEGIN
  (* verÑndere die Gewichte der Hidden->Output-Kanten *)
  FOR i:=0 TO b DO
    FOR j:=1 TO c DO
      netz.w2[i,j]:=netz.w2[i,j]+n*ErrOfOutput(j,netz)*netz.Hidden[i];
    END;
  END;
  (* verÑndere die Gewichte der Input->Hidden-Kanten *)
  FOR i:=0 TO a DO
    FOR j:=1 TO b DO
      netz.w1[i,j]:=netz.w1[i,j]+n*ErrOfHidden(j,netz)*netz.Input[i];
    END;
  END;
END Adjust;

(* berechnet den Output des Netzes beim Input "muster" *)

PROCEDURE Calculate(VAR netz : net; VAR InOut : matrix; muster : INTEGER);
VAR i : INTEGER;
BEGIN
  FOR i:=1 TO a DO netz.Input[i]:=InOut[muster,i];   END;
  FOR i:=1 TO c DO  netz.Goal[i]:=InOut[muster,i+a]; END;
  OutputOfInput(netz);
  OutputOfHidden(netz);
END Calculate;

(* Berechnet und zeigt an *)

PROCEDURE SendtoNet(VAR netz : net; VAR InOut : matrix; VAR muster : INTEGER);
VAR i : INTEGER;
BEGIN
  Calculate(netz,InOut,muster);
  WriteLn;
  WriteString("Netz: ");
  FOR i:=1 TO c DO
    IF (netz.Output[i]>0.5) THEN Write(CHR(254)); ELSE WriteString("_"); END;
  END;
END SendtoNet;

(* Zeige den Lernproze· grafisch an *)

PROCEDURE GraphDisplay(VAR netz : net; VAR xpos : CARDINAL);
VAR i, muster : INTEGER;
    y : REAL;
BEGIN
  FOR muster:=1 TO anz DO
    Calculate(netz,InOut,muster);
    Adjust(netz);
    FOR i:=1 TO c DO
      y:=470.0/(FLOAT(anz))*(FLOAT(muster))-netz.Output[i]*460.0/FLOAT(anz);
      Plot(xpos,TRUNC(y),i);
      y:=470.0/(FLOAT(anz))*(FLOAT(muster))-InOut[muster,i+a]*460.0/FLOAT(anz);
      Plot(xpos,TRUNC(y),i);
    END;
  END;
  INC(xpos);
END GraphDisplay;

(* Grafik bereitstellen *)

PROCEDURE GraphInit();
VAR i, y : INTEGER;
BEGIN
  InitVGA;
  GraphMode;
END GraphInit;

(* schaltet Farben *)

PROCEDURE Gelb();
BEGIN
  Write(CHR(27));
  WriteString("[1;33;40m");
END Gelb;

PROCEDURE Rot();
BEGIN
  Write(CHR(27));
  WriteString("[0;35;1m");
END Rot;

PROCEDURE Invers();
BEGIN
  Write(CHR(27));
  WriteString("[0;34;1m");
END Invers;

(* der Array-Editor *)

PROCEDURE Editor(VAR arr : matrix; VAR muster : INTEGER);
VAR w, i, ii, x, y : INTEGER;
    key : CHAR;
BEGIN
  x:=1; y:=1;
  LOOP
    Write(CHR(27)); WriteString("[1;1H");
    Gelb;
    WriteString("Tastatur: 4, 6, 8, 2, 5; 'e' zum Beenden, '+ -' zum Musterwechseln,");
    WriteLn;
    WriteString("--------- 's' 'sendet' Muster zum Netz, 'l' lîscht gesamtes Muster.");
    WriteLn;
    Rot;
    WriteLn;
    WriteString("Muster-Nr.: "); WriteInt(muster,1);
    WriteString("           ");
    WriteLn; WriteLn;

    FOR i:=1 TO py DO
      IF (i=1) THEN
        Rot;
        Write(CHR(201));
        FOR ii:=1 TO px DO Write(CHR(205)); END;
        Write(CHR(187));
      END;
      WriteLn;
      FOR ii:=1 TO px DO
        IF (ii=1) THEN Rot; Write(CHR(186)); END;
        IF (i=y) AND (ii=x) THEN Invers; ELSE Gelb; END;
        w:=TRUNC(arr[muster,ii+(i-1)*px]);
        IF w=1 THEN Write(CHR(219)) ELSE
          IF (i=y) AND (ii=x) THEN Write(CHR(158))
          ELSE Write(" "); END; END;
        Gelb;
        IF (ii=px) THEN Rot; Write(CHR(186)); END;
      END;
      IF (i=py) THEN
        Rot;
        WriteLn;
        Write(CHR(200));
        FOR ii:=1 TO px DO Write(CHR(205)); END;
        Write(CHR(188));
      END;
    END;
    WriteLn;
    WriteString(" ---> ");

    FOR i:=1 TO c DO
      IF (y=py+1) AND (x=i) THEN Invers; ELSE Gelb; END;
      w:=TRUNC(arr[muster,a+i]);
      IF w=1 THEN Write(CHR(254)) ELSE
        IF (y=py+1) AND (x=i) THEN Write(CHR(158)); ELSE Write("_"); END;
      END;
    END;
    WriteLn;

    Gelb;
    Read(key);
    key:=CAP(key);
    CASE key OF
      '4' : IF x>1 THEN DEC(x); END; |
      '6' : IF ((y=py+1) AND (x<c)) OR ((y#py+1) AND (x<px)) THEN INC(x); END; |
      '8' : IF y>1 THEN
              DEC(y);
              IF (y=py) AND (x>px) THEN x:=px; END; END; |
      '2' : IF y<(py+1) THEN
              INC(y);
              IF (y=py+1) AND (x>c) THEN x:=c; END; END; |
      '5' : IF (y=0) THEN arr[muster,a+x]:=1.0-arr[muster,a+x]; ELSE
                          arr[muster,x+(y-1)*px]:=1.0-arr[muster,x+(y-1)*px];
                          END; |
      '+' : IF (muster<anz) THEN INC(muster); END; |
      '-' : IF (muster>1)   THEN DEC(muster); END; |
      'S' : Rot; SendtoNet(netz,InOut,muster); |
      'L' : FOR i:=1 TO a+c DO InOut[muster,i]:=0.0; END; |
      'E' : EXIT;
    END;
  END;
END Editor;

(* Backpropagation-Start *)

BEGIN

  (* Laufzeit-Eingaben *)

  REPEAT
    TextMode;
    Rot;
    WriteString("Neuronales Netz. Implementiert v. Michael Wessel, 1/94.");
    WriteLn;
    WriteString("-------------------------------------------------------");
    WriteLn; WriteLn; Gelb;
    WriteString("Wieviele Muster soll das Netz erkennen, (1.. 10)? ");
    ReadInt(anz);
  UNTIL (anz>0) AND (anz<11);

  REPEAT
    WriteLn;
    WriteString("Welches X-Format sollen die Muster haben, (1.. 8)? ");
    ReadInt(px);
  UNTIL (px>0) AND (px<9);
  REPEAT
    WriteLn;
    WriteString("Welches Y-Format sollen die Muster haben, (1.. 8)? ");
    ReadInt(py);
  UNTIL (py>0) AND (py<9);
  a:=px*py;

  LOOP
    WriteLn;
    WriteString("Wieviele Output-Units soll das Netz haben, (1.. 10)? ");
    ReadInt(c);
    IF (c>0) AND (c<11) THEN EXIT; END;
  END;

  REPEAT
    WriteLn;
    WriteString("Wieviele Hidden-Units soll das Netz haben, (1.. 20)? ");
    ReadInt(b);
  UNTIL (b>0) AND (b<21);

  WriteLn;
  WriteString("öber wieviele Epochen soll gelernt werden? ");
  ReadInt(maxepoche);
  WriteLn;
  WriteString("Protokoll alle 'n' Schritte (0=keines), n=");
  ReadInt(npro);
  LOOP
    WriteLn;
    WriteString("Wie hoch soll die Lernrate sein (0.. 1)? ");
    ReadReal(n);
    IF (n>=0.0) AND (n<=1.0) THEN EXIT; END;
  END;

  (* Init *)

  netz.Input[0]:=1.0;
  netz.Hidden[0]:=1.0;
  RandInit(netz);

  FOR muster:=1 TO anz DO
    FOR i:=1 TO a+c DO
      InOut[muster,i]:=0.0;
    END;
    InOut[muster,a+muster]:=1.0;
  END;

  (* lege die zu lernenden Muster fest *)
  (* A -> 1000 *)
  InOut[1,8]:=1.0;  InOut[1,12]:=1.0; InOut[1,14]:=1.0; InOut[1,16]:=1.0;
  InOut[1,20]:=1.0; InOut[1,21]:=1.0; InOut[1,22]:=1.0; InOut[1,23]:=1.0;
  InOut[1,24]:=1.0; InOut[1,25]:=1.0; InOut[1,26]:=1.0; InOut[1,30]:=1.0;
  InOut[1,31]:=1.0; InOut[1,35]:=1.0; InOut[1,36]:=1.0; InOut[1,40]:=1.0;

  (* B -> 0100 *)
  InOut[2,6]:=1.0;  InOut[2,7]:=1.0;  InOut[2,8]:=1.0;  InOut[2,11]:=1.0;
  InOut[2,14]:=1.0; InOut[2,16]:=1.0; InOut[2,19]:=1.0; InOut[2,21]:=1.0;
  InOut[2,22]:=1.0; InOut[2,23]:=1.0; InOut[2,26]:=1.0; InOut[2,29]:=1.0;
  InOut[2,31]:=1.0; InOut[2,34]:=1.0; InOut[2,36]:=1.0; InOut[2,37]:=1.0;
  InOut[2,38]:=1.0;

  (* F -> 0010 *)
  InOut[3,6]:=1.0;  InOut[3,7]:=1.0;  InOut[3,8]:=1.0;  InOut[3,9]:=1.0;
  InOut[3,11]:=1.0; InOut[3,16]:=1.0; InOut[3,17]:=1.0; InOut[3,18]:=1.0;
  InOut[3,21]:=1.0; InOut[3,26]:=1.0; InOut[3,31]:=1.0; InOut[3,36]:=1.0;

  (* R -> 0001 *)
  InOut[4,6]:=1.0;  InOut[4,7]:=1.0;  InOut[4,8]:=1.0;  InOut[4,11]:=1.0;
  InOut[4,14]:=1.0; InOut[4,16]:=1.0; InOut[4,19]:=1.0; InOut[4,22]:=1.0;
  InOut[4,21]:=1.0; InOut[4,23]:=1.0; InOut[4,26]:=1.0; InOut[4,27]:=1.0;
  InOut[4,31]:=1.0; InOut[4,33]:=1.0; InOut[4,36]:=1.0; InOut[4,39]:=1.0;

  (* Beginn des Trainings, biete dem Netz alle Muster an,
     lerne Åber viele Epochen *)

  muster:=1;
  TextMode;
  Editor(InOut,muster);
  GraphInit; xpos:=0;

  FOR epoche:=0 TO maxepoche DO
    IF (npro#0) AND ((epoche MOD npro)=0) THEN
      GraphDisplay(netz,xpos);
    ELSE
      FOR muster:=1 TO anz DO
        Calculate(netz,InOut,muster);
        Adjust(netz);
      END;
    END;
  END;
  FOR i:=1 TO 3 DO Write(CHR(7)); END;
  ReadInt(i);

  (* Ende des Trainings *)

  muster:=1;
  TextMode;
  Editor(InOut,muster);

END Neuronal.