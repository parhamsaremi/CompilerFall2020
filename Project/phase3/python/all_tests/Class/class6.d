class Deck {
	void Shuffle() {Print("Shuffle");}
}

class Player {
	Deck d;
	void Init(Deck dj) { d = dj;}
	Deck GetDeck() { return d;}
}

int main()
{
	Player p;
	p = new Player;
	p.Init(new Deck);
	p.GetDeck().Shuffle();
}