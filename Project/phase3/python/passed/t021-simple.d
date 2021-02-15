int main()
{
   int i;
   i = 3;
   for (i = 0; i < 10; i = i * 2) {
      Print(i);
      i = i + 1;
   }
   Print("yes\n");
   Print(i);
}
