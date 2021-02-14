class Cow {
	Cow Init() { Print("Moo"); return null;}
}

class Mew {
     void Init() { Cow b; b =  new Cow.Init(); }
}
    

int main()
{
	(new Mew).Init();
}