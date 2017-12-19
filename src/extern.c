extern int value;
int ext_func();


static int local_func() {

    return value + ext_func();
}