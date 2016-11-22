examples
storeStringToSharedMemory
<example>
| c fdNumber lseek mmapPointer memset data stringReturn |

"Make sure you read first comment at retrieveSharedValueStep1
This is the reverse we write a string to the shared memory.
map the Class name to variable c for convenience"
c := CPPBridge .

"Open the file or create it, of course you need 
to change the path to wherever you want just
remember the path because you will need it 
when you want to share memory with another 
process"
fdNumber := c openFile: '/Users/kilon/git/Pharo/CPPBridge/mmapped.bin' 
					flags: (c O_RDWR | c O_CREAT | c O_TRUNC) 
					mode: (c FILEMODE). 

"Stretch the file to fit 4KB this the stadard size of a page of
memory of your OS. This way we waste no bytes"
lseek := c lSeek_fd: fdNumber range:3999  value:0.

"In order to apply the change in size we have to first
write to the file"
c write_fd:fdNumber value: '' size: 1.

"get the pointer to the start of the shared memory that 
will have access for reating and writting and mapped to
our opened file"
mmapPointer := c  mmap_adress: 0 
						fileSize:4000  
						flag1: (c PROT_READ | c PROT_WRITE )
						flag2: (c MAP_SHARED)  
						fd: fdNumber  
						offset: 0  .

"fill the memory with zeros in order to erase any 
previous value. We zero out only the 3004 bytes
but if we want we can zero the entire size 
which is 4000 bytes"
memset := c memset_startAddress: (mmapPointer  ) 
				value: 0  
				size: 3004.

"writeString is a convenience method for writting 
strings to memory. Of course we can write anything
to memory not just strings because in the end 
eveything is stored as bytes. Remember this is
a binary file not a text file"

stringReturn :=c writeString: 'Hello world from Pharo with love' toAdress: mmapPointer. 

"data is a convenience array to display the
results of all our function calls "
data :={  fdNumber . lseek. mmapPointer  .  stringReturn}.
data inspect.

^ data