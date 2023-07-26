```bash
make -C BaseTools
. edksetup.sh
 build --cmd-len=64436 -DDEBUG_ON_SERIAL_PORT=TRUE -t GCC5 -a X64 -p OvmfPkg/OvmfPkgX64.dsc
```
