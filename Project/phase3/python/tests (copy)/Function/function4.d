void SayHi() {
	int c;

      c = 15;
      if (false)
	    return;
      c = c - (c* c);
      Print(2*c, c);
}
int one(int a, int b)
{
	SayHi();
	return (a-1)*b+1;
}

int two(int c, bool b)
{
	int d;
	c = one(c, 3);
      d = one(4, 5);
	Print(c, d, "\n");
      b = c < d;
      if (b)
		return c*d;
      else
		return c/d;
}

int three(int a)
{
	int b;
	int c;

	b = 3 * a;
	c = two(b, b == 3);
      b = two(c, b == 3);
	Print(b, c, "\n");
}

int main()
{
	int i;
	for (i = 0; i < 4; i = i + 1) {
		three(i*10);
	}
}





