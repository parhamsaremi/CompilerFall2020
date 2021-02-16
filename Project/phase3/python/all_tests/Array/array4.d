class Point {
	int x;
	int y;

	void Init(int xVal, int yVal) {
	   x = xVal;
	   y = yVal;
	}
 	void PrintSelf() {
		Print("[", x, ", ", y, "]\n");
	}
}

class Shit {
	Point[] corners;

	void Init(int x, int y, int w, int h) {
		corners = NewArray(2, Point);
		corners[0] = new Point;
		corners[0].Init(x, y);
		corners[1] = new Point;
		corners[1].Init(x +w, y+h);
	}
 	void PrintShit() {
		Print("{\n lower left = ");
		corners[0].PrintSelf();
		Print(" upper right = ");
		corners[1].PrintSelf();
    		Print("}\n");
	}
}

int main()
{
    Shit shit;
	shit = new Shit;
	shit.Init(1, 2, 3, 4);
	shit.PrintSelf();
}
