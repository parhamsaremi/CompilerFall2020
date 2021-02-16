int fib(int n){
	if(n==1)
		return 1;
	if(n==2)
		return 1;
	return fib(n-1)+fib(n-2);
}

void main(){
	int n;
	int ans;

	n = 5;
	ans = fib(n);

	Print(ans);

}
