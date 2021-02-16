class Animal {
  void Method() { Print("Hello from Animal\n"); }

  void Method1() {
    Print("Animal");
  }

  void AMethod() { Print("not overridden\n"); }
}

class Cow extends Animal {

   void Method() { Print("Hello from Cow"); }

   void Method2() {
      Print("Cow2");
	Method1();
   }
   void Method1() {
    Print("Cow");
  }

   void AMethod() {}
}
class Mew extends Cow {

   void Method() { Print("Hello from Mew."); }

   void Method3() {
	Print("Mew3");
      Method2();
   }
   void Method1() {
      Print("Mew");
   }
}

int main() {
  Cow a;
  Mew m;

  a = new Cow;
  a.Method2();
  m = new Mew;
  a = m;
  a.Method2();
  m.Method3();
  a.Method();
}
