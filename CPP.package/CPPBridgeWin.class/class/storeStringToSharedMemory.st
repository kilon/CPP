examples
storeStringToSharedMemory
	<example>
	| mmapPointer data szName text fm |
	"Make sure you read first comment at retrieveSharedValueStep1
This is the reverse we write a string to the shared memory.
map the Class name to variable c for convenience"
	szName := self generateUnicodeFromString: 'MyFileMappingObject'.
	text := self generateUnicodeFromString: 'This text comes from Pharo with love :)'.
	fm := self
		createFileMapping_handle: self INVALID_HANDLE_VALUE
		access: self PAGE_READWRITE
		bufferSize: 1000
		name: szName.
	mmapPointer := self mapViewOfFile_handle: fm access: self FILE_MAP_ALL_ACCESS bufferSize: 1000.
	self copyMemoryDestination: mmapPointer text: text size: text size + 1.


	"data is a convenience array to display the
results of all our function calls "
	data := {mmapPointer.
	szName.
	text.
	fm}.
	data inspect.
	^ data