# CPPBridge


https://youtu.be/pI4PR3XaX6Q

------
# What is it ?

CPPBridge is a library that allows Pharo to share memory with any C/C++ application. Opening the door not
only to IPC and data sharing but also even complete control of C++ code from Pharo and vice versa.

------
# Documentation

CPPBridge class has a comment with all the details, each method at class side is commented , there is also 
an example method . C++ files required for the example files are included with the repo, you have just to 
compile them and execute Atlas-server.

------
## How to install ?

In a few hours it should be available from Package Browser, if you like to install it manually then open a 
Playground inside Pharo and do the following command

```Smalltalk
Metacello new baseline:
'CPPBridge' ; repository: 'github://kilon/CPPBridger:master';load.
```
---------
## How to use it ?
You need to first build atlas-server.cpp which you can do with
```
g++ atlas-server.cpp -o atlas-server
```
then execute it
```
./atlas-server
```
it will ask you to type a string, type whatever you like and press enter. Will provide information about the C
struct which is used to store data into the shared memory. Basically this application is opening / creating a 
file called "mmaped.bin" which  is just a simple binary file and maps it to the memory. That means that whatever
is in the file is loaded to the memory. 

Then shares the memory with any other process who will memory map the same file. 

Then we start Pharo , install CPPBridge to it and go to CPPBridge class >> retrieveSharedValueStep1 , read 
the comment and click the green triangle to execute so that you receive the C string you typed from Pharo 
and then execute retrieveSharedValueStep2 to unmap and close the file

Bellow is the source of both methods together with their comments.
````Smalltalk
retrieveSharedValueStep1
<example>
"
This method is an example that retrieves a struct from a shared memory
section, in order for this example to work you need you first copy
paste the contents of the Example Souce Code of the C++ file in the
comment section (you can also find the cpp file in the same directory
where the git repo has been downloaded) of this class to a C++ source
code file and compile it a run then replace the path of in this code
of CPPBridge openFile: with the correct path of the bin that the C++
files has created , in order for this to work also you need to execute
the C++ example first so it creates and file and share the memory.

After executing this method you can execute retrieveSharedValueStep2
to unmap and close the memory mapped file (keeps sharing the memory it
just does not store it to the file)"

|instance fdNumber lseek mmapPointer data struct|

"Let's create an instance just an an example but we wont use it
because we can use either class method or intance methods. You would
want to use instance method if you want to open multiple memory mapped
files meaning multiple areas of shared memory. Class methods for using
just one"

instance := CPPBridge new.

"Warning !!! You must change the path to the file that is located in
your hard drive.  The file should be at the same location you built
atlas-server.cpp which is responsible for creating the file. The
number returned is a number that OS uses to identify the image , flag
O_RDWR is just a number that states that we want to write and read the
file"

fdNumber := CPPBridge openFile:'/Users/kilon/git/Pharo/Atlas/mmapped.bin' 
                     flags: (O_RDWR) .

"lseek is used to stretch the file to a new size" 

lseek := CPPBridge
lSeek_fd: fdNumber range:3999 value:0.

"this is the most importan method, this method maps the file to
memmory , which means it loads its contents into memory and associates
the memory with the file. PROT_READ means we want to write the memory
, PROT_WRITE to write the memory and MAP_SHARED is the most importan
because it defines the memory area as shared so we can access it from
other application"

mmapPointer := CPPBridge mmap_adress: 0 fileSize:4000
                          flag1: (PROT_READ | PROT_WRITE )flag2:
                          MAP_SHARED fd: fdNumber offset: 0 .

"This assigns the pointer to our Pharo structure so we can use it to
get the contents of the C structure located in the shared memory"

struct := CPPStruct pointTo: (mmapPointer getHandle ).

"data here serves as a convenience array its not necessary we use it
just to collect information about the instance, the fd number of the
file, the streched size of the file, the adress (point) where the file
is mapped to in memory and structthat contains the values of the C
struct that we received" 

data :={ instance.  fdNumber. lseek. mmapPointer .  struct}.  
data inspect.

"Store data to the class so we can use it in the second method"

ExampleDATA := data.  

^data

" Its also possible to write to the shared memory , in this case we
use once again the C struct which has the following members
(variables) :

1) data = char[3000] this is where we store the string 
2) count = int this is where we store the size of the string

struct := {(mmapPointer getHandle copyFrom: 1 to:3000 )asString .
            (mmapPointer getHandle integerAt: 3001 size:4 signed:
            false)}.

mmapPointer is the pointer that points to the first byte of the shared
memory.

getHandle gives us the memory address that the pointer points to

copyFrom:1 to:3000 copies byte from byte 0 (remember C counts from 0 ,
Pharo counts from 1) to byte 3000 because the string we store is
stored as a char array of 3000 elements, each element is a char, each
char is 1 byte in legth and represents a single character of the
string. This gets the value of the first struct member.

on the other hand integerAt: 3001 size: 4 signed: false returns us the
value count member of the C struct . its an integer in position 3001
because our string is a char[3000] and the size is 4 bytes because its
an C int, signed false because we use no negative values because it
does not make sense for a string to have negative length. This gets
the value of the second struct member" 


retrieveSharedValueStep2 
<example> 

"
this one is to be triggered after retrieveSharedValueStep1 when we are
finished with the shared memory and we want to erase it and close the 
memory mapped file

ExampleDATA here severs as convenience array for storing the return
values from the call to C function.

fd -> a number with which the OS identifies the memory mapped file

lseek -> a number that returns the size of the file after we stretched
it to its finaly size

mmap -> this is the juice, the pointer that points to the first byte
of the shared memory. The final byte is of the shared memory defined
by the size of the file.

struct -> here we put the values we retrieved from the C struct which
was the goal of the previous method

ExampleDATA = { CPPBridgeinstance . fd . lseek . mmap . struct}"

"first lets unmap the file, basically this will disassociate the file
with the memory area that is assigned to ,meaning the OS will no longer
store in that file automatically what we change in shared memory"

CPPBridge munmap_data: (ExampleDATA at: 4) filesize: 4000.

"And because we wont be using the file anymore lets close. Remember
you still have access to the shared memmory. "

CPPBridge closeFile: (ExampleDATA at: 2).  

```

-----
# Why bother making such a library ? 

In my saga to find a way to use Pharo as a scripting language for Unreal Game Engine, I had two options

1. Build Unreal as a Library and use Pharo UFFI to launch and control it
1. Embed Pharo inside the Unreal Executable (this is what every other scripting language uses for controlling Unreal) 

Option a was a no go, because Unreal is huge , complex and uses its own custom made build tools, making a DLL for Pharo or an army of DLLs  out of the question

Option b Embeding Pharo inside an executable is impossible and implementing it also insanely complex.Naturally my mind went first into sockets which is what I use to make Pharo able to use Python libraries. However sockets have proven too slow for the insanely fast loops of Unreal. 

-----
# What are the advantages ?

* No need to move data around. Sharing memory means you don't have to move data around, you can use directly the shared memory

* Extend the Pharo image beyond Pharo. Shared memory is mapped into a file means that you can do with C++ what you can do with Pharo image, save the live state directly to a binary file. That means we no longer need to worry about sessions and reinitializing C/C++ data since memory mapped file acts as an extension of the Pharo image. 

* Blazing fast. Memory mapping is a function that comes directly from the OS kernel and as such it has to be extremely fast. Memory mapping is also what is used for dynamically linked shared libraries an extremely important feature for any application including Pharo that heavily depends on (see Cairo for Athens). So its a very mature , well tested method. 

* No extra libraries needed to be installed, CPPBridge uses OS libraries to work out of the box

* Low level handling of memory. Direct access to memory you can even manipulate the memory byte by byte

* Memory efficient. Memory mapping excels at large data, the bigger the better. Can take full advantage of your entire free memory and not waste a byte.  That means also that can be used to optimise Pharo memory, since you could compress your Pharo objects to bytes and mapped file will store the live state.

* Tons of Languages. Because memory mapping is a core functionality for every OS out there, pretty much every programming language supports it. CPPBridge currently supports only C/C++ but all languages can be supported giving access to Pharo to any library for any programming language. Sky is the limit

* Self Documented. CPPBridge is small, simple and with large class comment and comments for every method. YouTube video tutorial also available and linked on top. 

* Works both ways, C/C++ and Pharo can access and modify the shared memory. Making it possible for C/C++ to use Pharo libraries and Pharo to use C/C++ libraries.

* Experiments have proven that it improves sex life...  if it does not please file a bug report ;)

-----
# What are the disadvantages ?

* Candy Crash Saga. Dare do something incorrectly and Pharo will crash. CPPBridge can easily point to wrong address if you are not aware of what you doing. 

* C++/C . If you think you can avoid learning C/C++ and that this is a magic solution , think again. The C/C++ application must be modified to include shared memory mapping for CPPBridge to work .

* Local only. Unlike sockets, Shared Memory works only on the same machine so no remote execution and manipulation of code like in my socket bridge to Python

* UFFI still No1 option. No replacement for UFFI it actually depends on it to work , so if you can turn your C/C++ code into a DLL that should be your first option.

-----
# Roadmap 

Currently CPPBridge works only on MacOS , most likely on Linux too (because it uses the Unix architecture) but I will have to test it.

Windows is coming next ASAP, since its my No1 platform for creating commercial games.

Maybe establish a small protocol of communication via the Shared Memory , JSON looks like a good universal format 

-----
# Thanks

Big thanks to Eliot for inspiring me and Esteban for helping me figure out things.
