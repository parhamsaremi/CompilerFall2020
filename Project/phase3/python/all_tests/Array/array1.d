int main() {
  int[] b;
  bool[] c;
  int[] d;
  string[] s;

  b = NewArray(10, int);
  c = NewArray(20, bool);
  s = NewArray(3, string);

  b[3] = 5;
  c[6] = false;
  d = b;
  s[2] = "sara";

  Print(b[3], b.length(), "\n");
  Print(c[6], c.length(), "\n");
  Print(d[3], d.length(), "\n");
  Print(s[2], s.length(), "\n");
}