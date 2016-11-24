examples
retrieveSharedValueStep1
	"This method is an example that retrieves a struct from a shared memory section, in order for this example to work you need you first copy paste the contents of the Example Souce Code of the C++ file in the comment section  (you can also find the cpp file in the same directory where the git repo has been downloaded) of this class to a C++ source code file and compile it a run then replace the path of in this code of CPPBridge openFile: with the correct path of the bin that the C++ files has created , in order for this to work also you need to execute the C++ example first so it creates and file and share the memory.

After executing this method you can execute retrieveSharedValueStep2 to unmap and close the memory mapped file (keeps sharing the memory it just does not store it to the file)"

	<example>
	| instance fdNumber lseek mmapPointer data struct szName endReached charIndex |
	"Let's create an instance just an an example but we wont use it because we can use either class method or intance methods. You would want to use instance method if you want to open multiple memory mapped files meaning multiple areas of shared memory. Class methods for using just one"
	szName := CPPBridgeWin generateUnicodeFromString: 'MyFileMappingObject'.
	instance := CPPBridge new.


	"Warning !!! You must change the path to the file that is located in your hard drive. The file should be at the same location you built atlas-server.cpp which is responsible for creating the file. The number returned is a number that OS uses to identify the image , flag O_RDWR is just a number that states that we want to write and read the file"

	"fdNumber := CPPBridge openFile: '/Users/kilon/git/Pharo/CPPBridge/mmapped.bin' flags: (O_RDWR) "
	fdNumber := CPPBridgeWin openFileMapping_access: 983071 nameOfMemory: szName.


	"lseek is used to stretch the file to a new size"
	"lseek := CPPBridge lSeek_fd: fdNumber range:3999  value:0."

	"this is the most importan method, this method maps the file to memmory , which means it loads its contents into memory and associates the memory with the file. PROT_READ means we want to write the memory , PROT_WRITE to write the memory and MAP_SHARED is the most importan because it defines the memory area as shared so we can access it from other application"	"({109 . 0} asByteArray asString )"
	mmapPointer := CPPBridgeWin
		mapViewOfFile_handle: fdNumber
		access: 983071
		bufferSize: 256.

	"This assigns the pointer to our Pharo structure so we can use it to get the contents of the C structure located in the shared memory"
	"struct := CPPStruct pointTo: (mmapPointer getHandle )."
	struct := ''.
	endReached := false.
	charIndex := 1.
	[endReached ]whileFalse: [ (mmapPointer getHandle unsignedCharAt: charIndex) = Character null ifTrue: [ (mmapPointer getHandle unsignedCharAt: charIndex + 1) = Character null ifTrue: [endReached := true] ifFalse: [charIndex := charIndex +1]] ifFalse:[struct := struct, (mmapPointer getHandle unsignedCharAt: charIndex) asString. charIndex := charIndex + 1]].

	"data here serves as a convenience array its not necessary we use it just to collect information about the instance, the fd number of the file, the streched size of the file, the adress (point) where the file is mapped to in memory and struct that contains the values of the C struct that we received"
	data := {instance.
	fdNumber.
	lseek.
	mmapPointer.
	struct.
	szName}.
	data inspect.

	"Store data to the class so we can use it in the second method"
	ExampleDATA := data.
	^ data

	"
Its also possible to write to the shared memory , in this case we use once again the C struct which has the following members (variables) : 

1) data = char[3000]  this is where we store the string
2) count = int this is where we store the size of the string

struct := {(mmapPointer getHandle  copyFrom: 1 to:3000 )asString . (mmapPointer getHandle integerAt: 3001 size:4 signed: false)}.

mmapPointer is the pointer that points to the first byte of the shared memory.

getHandle gives us the memory adress that the pointer points to

copyFrom:1 to:3000 copies byte from byte 0 (remember C counts from 0 , Pharo counts from 1) to byte 3000 because the string we store is stored as a char array of 3000 elements, each element is a char, each char is 1 byte in leght and represents a single character of the string. This gets the value of the first struct member.

on the other hand integerAt: 3001 size: 4 signed: false returns us the value count memeber of the C struct . its an integer in position 3001 because our string is a char[3000] and the size is 4 bytes because its an C int, signed false because we use no negative values because it does not make sense for a string to have negative length. This gets the value of the second struct member"