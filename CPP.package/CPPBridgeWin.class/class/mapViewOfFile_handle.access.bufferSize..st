memory operations
mapViewOfFile_handle: aHandle access: flag bufferSize: buff_size
	"opening the file and creating the shared memory is not enough. This maps the file to the shared memory so data in the shared memory is saved to the file every time data is modified"

	| return |
	"pBuf = (LPTSTR)MapViewOfFile(hMapFile,   // handle to map object
		FILE_MAP_ALL_ACCESS, // read/write permission
		0,
		0,
		BUF_SIZE);"
	return := self ffiCall: #(void * MapViewOfFile #(void * aHandle , int flag , 0 , 0 , int buff_size)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return