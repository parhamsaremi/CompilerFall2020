class Point {
  int x;
  int y;
  void Init(int x, int y)
  {
     this.x = x;
     this.y = y;
  }
  void PrintSelf()
  {
     Print("[",x,", ",y,"]\n");
  }
  void PrintBoth(Point other)
  {
     PrintSelf();
     other.PrintSelf();
     Print(x, other.x);
  }


  bool equals(Point other) {
    return (x == other.x && y == other.y);
}

}

int main() {
  Point p;
  Point q;

  p = new Point;
  p.Init(1, 2);
  p.PrintSelf();
  q = new Point;
  q.Init(2, 3);
  q.PrintSelf();
  p.PrintBoth(q);
  Print(p.equals(q));
  Print(q.equals(q));
}