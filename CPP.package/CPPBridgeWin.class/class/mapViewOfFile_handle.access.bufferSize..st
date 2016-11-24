memory operations
mapViewOfFile_handle: aHandle access: flag bufferSize: buff_size
	"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory"

	| return |
	"pBuf = (LPTSTR)MapViewOfFile(hMapFile,   // handle to map object
		FILE_MAP_ALL_ACCESS, // read/write permission
		0,
		0,
		BUF_SIZE);"
	return := self
		ffiCall:
			#(void * MapViewOfFile #(void * aHandle , int flag , 0 , 0 , int buff_size)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return