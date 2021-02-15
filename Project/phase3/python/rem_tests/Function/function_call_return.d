bool func1() {
    return false;
}

int func2() {
    return 0;
}

double func3() {
    return 0.1234;
}

string func4(){
    return "hi";
}


int main()  {
    Print(func4());
    Print(func3());
    Print(func2());
    Print(func1());
}