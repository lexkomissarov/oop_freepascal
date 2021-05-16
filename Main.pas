uses Crt, Graph, Module; //Ракета
const
   PathToDrivers = '\TP\BGI';
type
	NodePtr = ^Node;
	Node = record
		Item : PointPtr;
		Next : NodePtr;
	end;

	ListPtr = ^List;
	List = object
		Nodes : NodePtr;
		constructor Init;
		destructor Done; virtual;
		procedure Add(Item : PointPtr);
		procedure Drag(DragBy : integer);
		procedure Show;
		procedure Hide;
	end;

var
	GraphDriver : integer;
	GraphMode : integer;
	Temp : String;
	AList : List;
 	PRec:RectanglePtr;
	PTri : TrianglePtr;
	PCircle : CirclePtr;
	RootNode : NodePtr;

procedure OutTextLn(TheText : string);
begin
	OutText(TheText);
	MoveTo(0, GetY+100);
end;

procedure HeapStatus(StatusMessage : string);
begin
	OutTextLn(StatusMessage+Temp);
end;

constructor List.Init;
begin
	Nodes := nil;
end;

destructor List.Done;
var
	N : NodePtr;
begin
	while Nodes <> nil do
	begin
		N := Nodes;
		Nodes := N^.next;
		Dispose(N^.Item, Done);
		Dispose(N);
	end;
end;

procedure List.Show;
var Top : NodePtr;
begin
	Top := Nodes;
	while Top <> nil do
	begin
		Top^.Item^.Show;
		Top := Top^.next;
	end;
end;

procedure List.Hide;
var Top : NodePtr;
begin
	Top := Nodes;
	while Top <> nil do
	begin
		Top^.Item^.Hide;
		Top := Top^.next;
	end;
	ClearViewPort;
end;

procedure List.Add(Item : PointPtr);
var
	N : NodePtr;
begin
	New(N);
	N^.Item := Item;
	N^.Next := Nodes;
	Nodes := N;
end;

procedure List.Drag(DragBy : integer);
var top : NodePtr;
	DeltaX, DeltaY : integer;
	FigureX, FigureY : integer;
begin
	Show;
	while GetDelta(DeltaX, DeltaY) do
	begin
		Top := Nodes;
		Hide;
		while Top <> nil do
		begin
			FigureX := Top^.Item^.GetX;
			FigureY := Top^.Item^.GetY;
			FigureX := FigureX + (DeltaX * DragBy);
			FigureY := FigureY + (DeltaY * DragBy);
			Top^.Item^.MoveTo(FigureX, FigureY);
			Top := Top^.Next;
		end;
	end;
end;

begin
	DetectGraph(GraphDriver, GraphMode);
	InitGraph(GraphDriver, GraphMode, PathToDrivers);
	if GraphResult <> GrOK then
	begin
		writeln(GraphErrorMsg(GraphDriver));
		if GraphDriver = grFileNotFound then
		begin
			writeln('in ', PathToDrivers,
			'. Modify this program''s "PathToDrivers"');
			writeln('constant tp specify the actual location of this file.');
			writeln;
		end;
		writeln('Press Enter...');
		readln;
		Halt(1);
	end;

	AList.Init;
	AList.Add(New(CirclePtr, Init(230, 230, 45, 15))); //Белый круг (окно)
	AList.Add(New(CirclePtr, Init(230, 230, 50, 4))); //Красный круг (обводка окна)
        AList.Add(New(TrianglePtr, Init(150, 130, 160, True, 4))); //Красный треугольник(башня)
        AList.Add(New(TrianglePtr, Init(105, 500, 90, True, 4))); //Красный треугольник(левый двигатель)
        AList.Add(New(TrianglePtr, Init(265, 500, 90, True, 4))); //Красный треугольник(правый двигатель)
        AList.Add(New(RectanglePtr, Init(150, 130, 310, 450, 1))); //Синий прямоугольник (корпус)
	AList.Drag(5);
	AList.Done;
	CloseGraph;
end.
