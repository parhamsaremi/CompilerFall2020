int main()
{
   int i;
  for (i = 0; i < 5; i = i + 1) {
    Print(i);
    if (i == 3) break;
   Print(" yes\n");
  }
}