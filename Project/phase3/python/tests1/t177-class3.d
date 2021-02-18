class Class {
	int x;
	bool b;

	int func(){
		Print(this.x);
	}

}

void main(){
	Class c;
	c = new Class;
	
	c.x = 2;
	c.b = true;

	c.func();
}

