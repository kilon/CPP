initialisation
initialize
" set here the default values for the flags used by open() and mmap"
PROT_READ := 1.   "Allow me to read the file mapped memory"
PROT_WRITE := 2.  "Allow me to write to the file mapped memory"
MAP_SHARED := 1.  "Allow me to share the file mapped memory"
O_RDWR := 2.      "Allow me to read and write the file "
O_CREAT := 512.   "Create the file if does not exist"
O_TRUNC := 1024.
FILEMODE:= 384.
ExampleDATA :={0} "Data used by example methods"
