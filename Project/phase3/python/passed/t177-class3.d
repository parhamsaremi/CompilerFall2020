class Base {
	bool b;
}

class Derived extends Base{
	int x;
}

void main(){
	Derived c;
	c = new Derived;
	
	c.x = 2;
	c.b = true;

	Print(c.x);
	Print(c.b);
}

