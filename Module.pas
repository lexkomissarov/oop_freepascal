unit Module;

interface
uses Graph, Crt;

type

Location = object
	X, Y : integer;
	procedure Init(InitX, InitY : integer);
	function GetX : integer;
	function GetY : integer;
end;

PointPtr = ^Point;
Point = object(Location)
	Color : Word;
	Visible : boolean;
	constructor Init(InitX, InitY : integer; InitColor : Word);
	destructor Done; virtual;
	procedure Show; virtual;
	procedure Hide; virtual;
	function IsVisible : boolean;
	procedure MoveTo(NewX, NewY : integer);
	procedure Drag(DragBy : integer); virtual;
end;

TrianglePtr = ^Triangle;

Triangle = object(Point)
	side : integer;
	up : boolean;
	constructor Init(InitX, InitY, InitSide : integer; InitUp : boolean; InitColor : word);
	procedure Show; virtual;
end;

CirclePtr = ^Circle;

Circle = object (Point)
	Radius : integer;
	constructor Init(InitX, InitY : integer; InitRadius : integer; InitColor : Word);
	procedure Show; virtual;
end;

RectanglePtr = ^Rectangle;

Rectangle = object(Point)
width, height: integer;
constructor Init(InitX, InitY, InitX1, InitY1:integer; InitColor: word);
procedure Show; virtual;
procedure Hide; virtual;
end;

function GetDelta(var DeltaX : integer; var DeltaY : integer) : boolean;

implementation

procedure Location.Init(InitX, InitY : integer);
begin
	X := InitX;
	Y := InitY;
end;

function Location.GetX : integer;
begin
	GetX := X;
end;

function Location.GetY :integer;
begin
	GetY := Y;
end;

constructor Point.Init(InitX, InitY : integer; InitColor : Word);
begin
	Location.Init(InitX, InitY);
	Color := InitColor;
	Visible := False;
end;

destructor Point.Done;
begin
	Hide;
end;

procedure Point.Show;
begin
	Graph.SetColor(Color);
	Visible := True;
	PutPixel(X, Y, GetColor);
end;

procedure Point.Hide;
begin
	Visible := False;
end;

function Point.IsVisible : boolean;
begin
	IsVisible := Visible;
end;

procedure Point.MoveTo(NewX, NewY : integer);
begin
	X := NewX;
	Y := NewY;
	Show;
end;

function GetDelta(var DeltaX : integer; var DeltaY : integer) : boolean;
var
	KeyChar : char;
	Quit : Boolean;
begin
	DeltaX := 0; DeltaY := 0;
	GetDelta := True;
	repeat
		KeyChar := ReadKey;
		Quit := True;
		case Ord(KeyChar) of
			0: begin
				KeyChar := ReadKey;
				case Ord(KeyChar) of
					72: DeltaY := -1;
					80: DeltaY := 1;
					75: DeltaX := -1;
					77: DeltaX := 1;
					else Quit := False;
				end;
			end;
		13: GetDelta := False;
	else Quit := False;
	end;
	until Quit;
end;

procedure Point.Drag(DragBy : integer);
var
	DeltaX, DeltaY : integer;
	FigureX, FigureY : integer;
begin
	Show;
	FigureX := GetX;
	FigureY := GetY;
	while GetDelta(DeltaX, DeltaY) do
	begin
		FigureX := FigureX + (DeltaX * DragBy);
		FigureY := FigureY + (DEltaY * DragBy);
		MoveTo(FigureX, FigureY);
	end;
end;

constructor Rectangle.Init(InitX, InitY, InitX1, InitY1: integer; InitColor: word);
begin
   width:= InitX1-InitX;
   height:=InitY1-InitY;
   Point.Init(InitX, InitY, InitColor);
end;
procedure Rectangle.Show;
begin
   Graph.SetColor(Color);
   Visible:=True;
   Graph.Rectangle(X,Y,X+width, Y+height);
   SetFillStyle(SolidFill, Color);
   Bar(X,Y,X+width, Y+height);
end;
procedure Rectangle.Hide;
begin
   Graph.SetColor(Color);
   SetFillStyle(SolidFill,Color);
   Bar(X,Y,X+width,Y+height);
   Visible:=False;
end;

constructor Triangle.Init(InitX, InitY, InitSide : integer; InitUp : boolean; InitColor : word);
begin
   side := InitSide;
   up := InitUp;
   Point.Init(InitX, InitY, InitColor);
end;
procedure Triangle.Show;
var Points : array[1..4] of PointType;
begin
	Points[1].x := X;
	Points[1].y := Y;
	Points[2].x := Round(X + side/2);
	if up then
		Points[2].y := Round(Y - side * sqrt(3) / 2)
	else
		Points[2].y := Round(Y + side * sqrt(3) / 2);
	Points[3].x := X + side;
	Points[3].y := Y;
	Points[4].x := X;
	Points[4].y := Y;
	Graph.SetColor(Color);
	Visible := True;
	SetFillStyle(SolidFill, Color);
	Graph.FillPoly(4, Points);
end;

constructor Circle.Init(InitX, InitY : integer; InitRadius : integer; InitColor : Word);
begin
	Point.Init(InitX, InitY, InitColor);
	Radius := InitRadius;
end;

procedure Circle.Show;
begin
    Graph.SetColor(Color);
    Visible := True;
    SetFillStyle(SolidFill, Color);
	FillEllipse(X, Y, Radius, Radius);
	Graph.SetColor(0);
end;
end.
