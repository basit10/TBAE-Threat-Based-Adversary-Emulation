#include <windows.h>
#include <stdio.h>

int err(const char* errmsg) {

    printf("Error: %s (%u)\n", errmsg, ::GetLastError());
    return 1;
}
unsigned char op[] ="";

int main() {

    LPVOID addr = ::VirtualAlloc(NULL, sizeof(op), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    ::RtlMoveMemory(addr, op, sizeof(op));
    ::EnumWindows((WNDENUMPROC)addr, NULL);

}
