class Goone
{
   void AddCow(Cow cow) {
      cow.Method1();
    }
}


int main() {
  Cow a;
  Pishi p;
  Cow[] c;
  Goone g;

  c = NewArray(1, Cow);
  g = new Goone;
  a = new Cow;
  a.Init(24);
  a.Method2();
  p = new Pishi;
  p.Init(33);
  a = p;
  a.Method2();
  p.Method2();
  p.Method3();
  g.AddCow(a);
  g.AddCow(p);
}

class Pishi extends Cow {
   void Method3() {
	Print("Pishi3");
      Method2();
   }
   void Method1() {
      Print("Pishi");
	PrintSelf();
   }
}

class Animal {
  int num1;
   void Init(int n) { num1 = n; }

	void Method1() {
	    Print("Animal");
	    PrintSelf();
	  }	
	  void PrintSelf()
	{
	  Print("num1 = ", num1, "\n");
	}	
}

class Cow extends Animal {
   void Method2() {
      Print("Cow2");
	  Method1();
   }
   void Method1() {
      Print("Cow");
      PrintSelf();
  }
}





