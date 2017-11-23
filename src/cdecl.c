int func2(int a, int b, int c) {
	return a + b + c;
}

int func1() {
	int a = 0, b = 1, c = 2, d = 0;
	d = func2(a, b, c);
	return d;
}
