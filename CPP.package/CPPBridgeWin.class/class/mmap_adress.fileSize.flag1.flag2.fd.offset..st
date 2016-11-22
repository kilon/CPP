memory operations
mmap_adress: anAddress fileSize: aFileSize flag1: aFlag1 flag2: aFlag2 fd: anFd offset: anOffset
"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory"
|return|
"CreateFileMapping(
		INVALID_HANDLE_VALUE,    // use paging file
		NULL,                    // default security
		PAGE_READWRITE,          // read/write access
		0,                       // maximum object size (high-order DWORD)
		BUF_SIZE,                // maximum object size (low-order DWORD)
		szName);                 // name of mapping object"
return := self ffiCall: #( void * CreateFileMapping (void * handle , 0 , int flag  , 0  , int buf_size , String name )).
return = 16rffffffffffffffff ifTrue: [ self error: 'Error mapping file to memory' ].
^return