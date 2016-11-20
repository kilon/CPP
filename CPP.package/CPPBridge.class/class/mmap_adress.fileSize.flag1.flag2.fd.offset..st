memory operations
mmap_adress: anAddress fileSize: aFileSize flag1: aFlag1 flag2: aFlag2 fd: anFd offset: anOffset
"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory"
|return|

return := self ffiCall: #( void * mmap ( int anAddress , int aFileSize , int aFlag1 , int aFlag2 , int anFd , int anOffset )).
return = 16rffffffffffffffff ifTrue: [ self error: 'Error mapping file to memory' ].
^return