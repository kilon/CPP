# CPP


https://youtu.be/pI4PR3XaX6Q

------
# What is it ?

CPP is a library that allows Pharo to share memory with any C/C++ application or just between pharo images. Opening the door not
only to IPC and data sharing but also even complete control of C++ code from Pharo and vice versa and also the ability to work share very big data between pharo images fast and efficiently.

------
# Documentation

CPPBridge (MacOS /Linux) and CPPBridgeWin classes have a comments with all the details, each method at class side is commented , there are also 
an example methods you can identify with a green triangle . C++ files required for the example files are included with the repo, you have just to 
compile them and execute the file that are compatible with your OS. Use of C++ is completely optional if you prefer sharing memory only between pharo images executing at the same time you can ignore all the C++ code included.

------
## How to install ?

In a few hours it should be available from Package Browser, if you like to install it manually then open a 
Playground inside Pharo and do the following command

```Smalltalk
Metacello new baseline:
'CPP' ; repository: 'github://kilon/CPP:master';load.
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

* C++/C . If you think you can avoid learning C/C++ and that this is a magic solution , think again. The C/C++ application must be modified to include shared memory mapping for CPPBridge to work . However if you plan to use it only with pharo images you do not need learning C++ or the technical details of shared memory, just follow the example methods. 

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
