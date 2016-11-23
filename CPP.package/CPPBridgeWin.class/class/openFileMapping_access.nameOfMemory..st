memory operations
openFileMapping_access: flag nameOfMemory: aName
	"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory\"

	| return |
	"pBuf = (LPTSTR)MapViewOfFile(hMapFile,   // handle to map object
FILE_MAP_ALL_ACCESS, 								// read/write permission
,BUF_SIZE);"
	return := self ffiCall: #(void * OpenFileMappingW #(unsignedLong flag , 0 , String aName)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory\' ].
		return inspect.
	^ return