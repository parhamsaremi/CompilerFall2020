class Class{
	int x;

	int func(int a){
		return 2 * a;	
	}
}

void main(){
	Class c;

	c = new Class;

	c.x = 4;

	Print(c.func(8));
}

