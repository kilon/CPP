examples
retrieveSharedValueStep1
	<example>
	| instance fdNumber mmapPointer data struct szName |
	"this is the most importan method, this method maps the file to memmory , which means it loads its contents into memory and associates the memory with the file. PROT_READ means we want to write the memory , PROT_WRITE to write the memory and MAP_SHARED is the most importan because it defines the memory area as shared so we can access it from other application"
	"({109 . 0} asByteArray asString )"
	"This assigns the pointer to our Pharo structure so we can use it to get the contents of the C structure located in the shared memory"
	"struct := CPPStruct pointTo: (mmapPointer getHandle )."
	"data here serves as a convenience array its not necessary we use it just to collect information about the instance, the fd number of the file, the streched size of the file, the adress (point) where the file is mapped to in memory and struct that contains the values of the C struct that we received"
	"Store data to the class so we can use it in the second method"
	"clean up"
	szName := self generateUnicodeFromString: 'MyFileMappingObject'.
	instance := self new.
	fdNumber := self
		openFileMapping_access: self FILE_MAP_ALL_ACCESS
		nameOfMemory: szName.
	mmapPointer := self
		mapViewOfFile_handle: fdNumber
		access: self FILE_MAP_ALL_ACCESS
		bufferSize: 256.
	struct := self readStringUnicode: mmapPointer.
	data := {instance.
	fdNumber.
	mmapPointer.
	szName.
	struct}.
	data inspect.
	ExampleDATA := data.
	self unmapViewOfFile_SharedMemory: mmapPointer.
	self closeHandle: fdNumber.
	^ data