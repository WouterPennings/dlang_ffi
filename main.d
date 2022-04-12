import core.stdc.stdio;
import core.stdc.stdlib;
import core.sys.posix.dlfcn;

extern (C) void print(char*);

int function(char*) GetFunc(void* lib, scope const(char*) functionName) {
    int function(char*) fn = cast(int function(char*)) dlsym(lib, functionName);
    char* error = dlerror();
    if (error)
    {
        fprintf(stderr, "dlsym error: %s\n", error);
        exit(1);
    }
    return fn;
}

void* OpenDLL(scope const(char*) libName) {
    void* lh = dlopen(libName, RTLD_LAZY);
    if (!lh)
    {
        fprintf(stderr, "dlopen error: %s\n", dlerror());
        exit(1);
    }

    return lh;
}

int main() {
    void* lh = OpenDLL("./rust_lib.so");
    GetFunc(lh, "print")(cast(char*) "hello");

    return 0;
}