# Obj Parser and coff Loader

This is a quick and dirty COFF loader (AKA Beacon Object Files). Currently can run un-modified BOF's so it can be used for testing without a CS agent running it. The only exception is that the injection related beacon compatibility functions are just empty.
orignal proj by trustedsec.com


## Parts

- beacon_compatibility: This is the beacon internal functions so that you can load BOF files and run them.
- COFFLoader: This is the actual coff loader, and when built for nix just loads the 64 bit object file and parses it.
- test: This is the example "COFF" file, will build to the COFF file for you when make is called.
- beacon_generate: This is a helper script to build strings/arguments compatible with the beacon_compatibility functions.
