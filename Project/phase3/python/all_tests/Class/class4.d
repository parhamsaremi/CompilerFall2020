
class B { int z; int GetZ() { return z;}}

void binky(B x) {
    Print("x = ", x.GetZ() , "\n");
}

class X extends B {
 
  void f() {
    z = 3;
    binky(this);
  }

   bool compare(X other)   {
     return this == other;
   }
}

int main() {
  X d;

  d = new X;
  d.f();
  if (d.compare(d)) Print("Same");
  else Print("Different");
} 