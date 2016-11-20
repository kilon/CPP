file operations
lSeek_fd: anFd range: aSizeInBytes value: anInteger
"this function will fill a portion range of a file fd with a value "
|return|
return:=self ffiCall: #( int lseek(int anFd, int aSizeInBytes, int anInteger)).
return = -1 ifTrue:[self error:'Error calling lseek'].
^return