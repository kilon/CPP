copying
copyMemoryDestination: aDestination text: aText size: aSize
	"we copy byte by byte to memory"

	"CopyMemory((PVOID)pBuf, szMsg, (_tcslen(szMsg) * sizeof(TCHAR)));"

	self ffiCall: #(void * memcpy #(void * aDestination , String aText , unsignedShort aSize)) module: NtDll