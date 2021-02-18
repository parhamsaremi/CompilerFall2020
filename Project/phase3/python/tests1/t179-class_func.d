class Class{
	int x;

	int func(int x){
		return 2 * x;	
	}
}

void main(){
	Class c;

	c = new Class;

	c.x = 4;

	Print(c.func());
}

