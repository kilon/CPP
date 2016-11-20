memory operations
munmap_data: mmapPointer filesize: anInteger
"Unmap fie from memory"
|return|
return:=self ffiCall: #( int mmap ( void * mmapPointer, int anInteger )).
return = -1 ifTrue:[self error:'Error unmapping file from memory'].
^return