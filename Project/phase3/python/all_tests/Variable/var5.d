int d;

int main()
{
  int a;
  bool b;
  a = 5 + 20 * 10;
  d = a * a + a * 15 * 3 / 2 - a;
  Print(d * 5 + 10 % 7 * 8 + a);
  b = 5 < 4 * 10 + (0-5) - 100;
  Print(a);
  Print("\n");
  Print(d);
  Print("\n");
  Print(b || (0 != a && 4 == (2 * 2)));
  Print("\n");
  Print(a);
  Print("\n");
  Print(d);
}