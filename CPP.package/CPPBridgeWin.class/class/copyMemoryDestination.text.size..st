copying
copyMemoryDestination: aDestination text: aText size: aSize
	"mmap is responsible for mapping the memory to be shared to a file fd that is used to store the shared memory\"

	"CopyMemory((PVOID)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));"

	self
		ffiCall: #( void * memcpy #(void * aDestination , String aText , unsignedShort aSize))
		module: NtDll