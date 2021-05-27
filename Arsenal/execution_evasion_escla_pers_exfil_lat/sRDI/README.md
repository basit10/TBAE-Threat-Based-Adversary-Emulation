# No signature updates till now...sRDI - Shellcode Reflective DLL Injection
sRDI allows for the conversion of DLL files to position independent shellcode. It attempts to be a fully functional PE loader supporting proper section permissions, TLS callbacks, and sanity checks. It can be thought of as a shellcode PE loader strapped to a packed DLL.
Functionality is accomplished via two components:
- C project which compiles a PE loader implementation (RDI) to shellcode
- Conversion code which attaches the DLL, RDI, and user data together with a bootstrap



**The DLL does not need to be compiled with RDI, however the technique  is cross compatiable.**


#### Convert DLL to shellcode using python
```python
from ShellcodeRDI import *

dll = open("TestDLL_x86.dll", 'rb').read()
shellcode = ConvertToShellcode(dll)
```

#### Load DLL into memory using C# loader
```
DotNetLoader.exe TestDLL_x64.dll
```

#### Convert DLL with python script and load with Native EXE
```
python ConvertToShellcode.py TestDLL_x64.dll
NativeLoader.exe TestDLL_x64.bin
```

## Building
This project is built using Visual Studio 2019 (v142) and Windows SDK 10. The python script is written using Python 3.

The Python and Powershell scripts are located at:
- `Python\ConvertToShellcode.py`
- `PowerShell\ConvertTo-Shellcode.ps1`

After building the project, the other binaries will be located at:
- `bin\NativeLoader.exe`
- `bin\DotNetLoader.exe`
- `bin\TestDLL_<arch>.dll`
- `bin\ShellcodeRDI_<arch>.bin`


## Alternatives
If you find my code disgusting, or just looking for an alternative memory-PE loader project, check out some of these:

- https://github.com/fancycode/MemoryModule - Probably one of the cleanest PE loaders out there, great reference.
- https://github.com/TheWover/donut - Want to convert .NET assemblies? Or how about JScript?
- https://github.com/hasherezade/pe_to_shellcode - Generates a polymorphic PE+shellcode hybrids.
- https://github.com/DarthTon/Blackbone - Large library with many memory hacking/hooking primitives.

## Credits
The basis of this project is derived from ["Improved Reflective DLL Injection" from Dan Staples](https://disman.tl/2015/01/30/an-improved-reflective-dll-injection-technique.html) which itself is derived from the original project by [Stephen Fewer](https://github.com/stephenfewer/ReflectiveDLLInjection). 

The project framework for compiling C code as shellcode is taken from [Mathew Graeber's reasearch "PIC_BindShell"](http://www.exploit-monday.com/2013/08/writing-optimized-windows-shellcode-in-c.html)
