examples
retrieveSharedValueStep2
<example>
"this one is to be triggered after retrieveSharedValueStep1 when we are finished
 with the shared memory and we want to erase it and close the memory mapped file

ExampleDATA here severs as convenience array for storing the return values from 
the call to C function. 

fd -> a number with which the OS identifies the memory mapped file

lseek -> a number that returns the size of the file after we stretched it to its 
finaly size

mmap -> this is the juice, the pointer that points to the first byte of the shared 
memory. The final byte is of the shared memory defined by the size of the file. 

struct -> here we put the values we retrieved from the C struct which was the goal 
of the previous method

ExampleDATA = { CPPBridgeinstance . fd . lseek . mmap . struct}"

"first lets unmpa the file, basically this will disassociate the file with the 
memory area that is assigned to ,meaing the OS will no longer store in that file 
automatically what we change in shared memory"

CPPBridge munmap_data: (ExampleDATA at: 4) filesize: 4000.

"And because we wont be using the file anymore lets close. Remember you still 
have access to the shared memmory. "

CPPBridge  closeFile: (ExampleDATA at: 2).