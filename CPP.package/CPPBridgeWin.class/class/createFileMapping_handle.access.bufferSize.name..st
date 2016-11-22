memory operations
createFileMapping_handle: aHandle access: flag bufferSize: buff_size name: aName
"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory"
|return|
"CreateFileMapping(
		INVALID_HANDLE_VALUE,    // use paging file
		NULL,                    // default security
		PAGE_READWRITE,          // read/write access
		0,                       // maximum object size (high-order DWORD)
		BUF_SIZE,                // maximum object size (low-order DWORD)
		szName);                 // name of mapping object"
return := self ffiCall: #( void * CreateFileMappingA (void * aHandle , 0 , unsignedLong flag  , 0  , unsignedLong buff_size , String aName )).
return = 16rffffffffffffffff ifTrue: [ self error: 'Error mapping file to memory' ].
^return