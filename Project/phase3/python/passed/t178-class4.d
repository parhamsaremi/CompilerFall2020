class Base {
	bool b;
}

class Derived extends Base{
	int x;
}

void main(){
	Derived d;
	Base b;
	
	d = new Derived;
	
	b = new Base;

	d.x = 2;
	d.b = true;

	b.b = false;

	Print(d.x);
	Print(d.b);
	Print(b.b);
}

