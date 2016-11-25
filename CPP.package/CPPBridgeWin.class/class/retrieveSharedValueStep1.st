examples
retrieveSharedValueStep1
	<example>
	| mmapPointer data struct szName fm |
	"In this method we read a string from the shared memory.
	Windows wants unicode strings , pharo unicode strings are incompatible because they use one byte per unicode character while Windows uses 2 bytes per unicode character. In this example we dont map any file to memory , this is a way to access shared memory without saving the data back to the file or opening the file. If you want the data saved to the file from the the shared memory look at how storeStringToSharedMemory does this and modify your code accordingly"
	"This is the name of the mapping of the memory"
	szName := self generateUnicodeFromString: 'MyFileMappingObject'.
	"We gain access to the area of memory that is file mapped and  shared"
	fm := self openFileMapping_access: self FILE_MAP_ALL_ACCESS nameOfMemory: szName.
	"We map the same area of memory to a file"
	mmapPointer := self mapViewOfFile_handle: fm access: self FILE_MAP_ALL_ACCESS bufferSize: 256.
	"struct here is just a string that has been shared between the process "
	struct := self readStringUnicode: mmapPointer.
	"print all C++ pointers that we got , together with the unicode strings"
	data := {fm.
	mmapPointer.
	szName.
	struct}.
	data inspect.
	ExampleDATA := data.
	self unmapViewOfFile_SharedMemory: mmapPointer.
	self closeHandle: fm.
	^ data