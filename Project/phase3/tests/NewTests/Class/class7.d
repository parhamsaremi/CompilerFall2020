class Cow {
   int Moo(int i, int j, int k, int l, int m, int n) {
	 return i +j + k + l + m + n;
    }

    void Method(int a) {
	if (false) Moo(a, a, a, a, a, a);
      Print(3);
      Print(4);
   }
}

int main()
{
	Cow c;
      c = new Cow;
      c.Method(6);
}