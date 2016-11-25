memory operations
openFileMapping_access: flag nameOfMemory: aName
	"open and gain access to a shared memory that already exist and we know its name"

	| return |
	"pBuf = (LPTSTR)MapViewOfFile(hMapFile,   // handle to map object
FILE_MAP_ALL_ACCESS, 								// read/write permission
,BUF_SIZE);"
	return := self ffiCall: #(void * OpenFileMappingW #(unsignedLong flag , 0 , String aName)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory\' ].
	return inspect.
	^ return