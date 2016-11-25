examples
storeStringToSharedMemory
	<example>
	| mmapPointer data szName text fm fh uPath mmerror fhError fmError |
	"In this method, we write a string to the shared memory.
	Windows wants unicode strings , pharo unicode strings are incompatible because they use one byte per unicode character while Windows uses 2 bytes per unicode character. In the case unlike retrieveSharedValue, we open a file or create if it does not exist, this file will be mapped to the shared memory that means any change in the shared memory will be stores to this file. This way this file can act similar to Pharo image, storing live state."
	"Unicode string for the name of the file, its accessed from the Pharo folder that the image is located. "
	uPath := self generateUnicodeFromString: 'mmap.bin'.
	"Unicode string name of the shared memory"
	szName := self generateUnicodeFromString: 'MyFileMappingObject'.
	"The unicode string we want to store to the shared memory. Bare in mind that in this case you can dont need to store it as Unicode or for it to be even a string, we could have a byte array or a serialized pharo object to byte, sky is the limit."
	text := self generateUnicodeFromString: 'This text comes again 12 from Pharo with love :)'.
	"Create file or open it if it exists. createFile method has already all permissions set up for you so you wont have to worry with windows flags"
	fh := self createFile_path: uPath.
	"get the last error, this error can be from any other method too. To check is the method fails we could check whether the returned void pointer (HANDLE) is zero . "
	fhError := self getLastError.
	"this is where we create the shared memory and we connect it with the file we opened"
	fm := self
		createFileMapping_handle: fh
		access: self PAGE_READWRITE
		bufferSize: 1000
		name: szName.
	fmError := self getLastError.
	"Now we want to get the pointer to the first byte of the shared memory, we do this by mapping the memory to the view of the file"
	mmapPointer := self mapViewOfFile_handle: fm getHandle access: self FILE_MAP_ALL_ACCESS bufferSize: 1000.
	mmerror := self getLastError.
	"Special method that copies data byte by byte. Much simpler than it looks"
	self copyMemoryDestination: mmapPointer text: text size: text size + 1.


	"data is a convenience array to display the
results of all our function calls "
	data := {fh.
	fhError.
	fm.
	fmError.
	mmapPointer.
	mmerror.
	szName.
	text}.
	data inspect.
	"we unmap the shared memory, free the file mapping, and close the file as a total clean up to keep things tidy and nice"
	self unmapViewOfFile_SharedMemory: mmapPointer.
	self closeHandle: fm.
	self closeHandle: fh.
	^ data