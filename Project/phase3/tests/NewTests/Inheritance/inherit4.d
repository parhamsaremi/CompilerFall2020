class Animal {
  void Method1() {
    Print("Animal");
  }
}

class Khar extends Animal {
   void Method1() {
    Print("Khar");
  }
}
class khar extends Khar {
   void Method1() {
      Print("khar");
   }
}

int main() {
  Animal a;
  a = new Animal;
  a.Method1();
  a = new Khar;
  a.Method1();
  a = new khar;
  a.Method1();
}
