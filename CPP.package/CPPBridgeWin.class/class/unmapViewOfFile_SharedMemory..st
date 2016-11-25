memory operations
unmapViewOfFile_SharedMemory: aPointerToSharedMemory
	| return |
	"BOOL WINAPI UnmapViewOfFile(
  _In_ LPCVOID lpBaseAddress // pointet to shared memory 
);               "
	return := self ffiCall: #(bool UnmapViewOfFile #(void * aPointerToSharedMemory)).
	return value = 0
		ifTrue: [ self error: 'Error mapping file to memory' ].
	^ return