This class wraps several functions that are needed for the operation of the Shared Memory Mapped File

The purpose is to allow Pharo to write and read from an area of memory that it can share with a running C++ application. This way we can communicate with C++ applications and even execute their functions without having to compile a shared library.  Obvoiously using a shared library via the UFFI is the preffered optionsthis option is offered in case the ideal option is not available or hard to accomplish. 

see each function comment  at the class side for details.

Example Source Code for the C++ file  provided bellow . For you convenience the source file is provided with this repo in file Atlas-server.cpp

atlas-client.cpp is just a C++ version of class side retrieveSharedValue for testing purposes

printflags.cpp as you may imagine is the source for an application that print flags that are usd by this library and also works similar as atlas-client.cpp

----------------------------------------------

```C++

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string>
#include <iostream>

#define FILEPATH "./mmapped.bin"
#define NUMINTS  (1000)
#define FILESIZE (NUMINTS * sizeof(int))


typedef struct {
  char data[3000];
  int count;
} state_data;

int main(int argc, char *argv[])
{
    int i;
    int fd;
    int result;
    char map[100];
    char* map_address; /* mmapped array of int's */
    std::string reply;

    /* Open a file for writing.
     *  - Creating the file if it doesn't exist.
     *  - Truncating it to 0 size if it already exists. (not really needed)
     *
     * Note: "O_WRONLY" mode is not sufficient when mmaping.
     */
    fd = open(FILEPATH, O_RDWR | O_CREAT | O_TRUNC, (mode_t)0600);
    if (fd == -1) {
	perror("Error opening file for writing");
	exit(EXIT_FAILURE);
    }

    /* Stretch the file size to the size of the (mmapped) array of ints
     */
    result = lseek(fd, FILESIZE-1, SEEK_SET);
    if (result == -1)
      {
      close(fd);
      perror("Error calling lseek() to 'stretch' the file");
      exit(EXIT_FAILURE);
    }

    /* Something needs to be written at the end of the file to
     * have the file actually have the new size.
     * Just writing an empty string at the current file position will do.
     *
     * Note:
     *  - The current position in the file is at the end of the stretched
     *    file due to the call to lseek().
     *  - An empty string is actually a single '\0' character, so a zero-byte
     *    will be written at the last byte of the file.
     */
    result = write(fd, "", 1);
    if (result != 1) {
	close(fd);
	perror("Error writing last byte of the file");
	exit(EXIT_FAILURE);
    }

    /* Now the file is ready to be mmapped.
     */
    std::cout<<"call mmap\n";
    state_data* data =(state_data*) mmap(0, FILESIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (map == MAP_FAILED) {
	close(fd);
	perror("Error mmapping the file");
	exit(EXIT_FAILURE);
    }

    /* Now write int's to the file as if it were memory (an array of ints).
     */
    while(reply !="n")
    {

      std::cout<<"*************************\n";
      printf("Map pointer points to adress : %d \n",data);
      std::cout<<"type the value you want to share : \n";
      std::getline(std::cin,reply);
      memset(data,0,sizeof(state_data));
      //data->data = reply
      std::cout<<"Looping assignment\n";
      for( data->count = 0 ; data->count < reply.length() ; ++data->count )
        {
          data->data[data->count] = reply[data->count];

        }

      //*map[100] = reply.c_str();
      //msync(map,FILESIZE,MS_SYNC | MS_INVALIDATE);
      std::cout<<"Struct data : "<<data->data<<"\n";
      std::cout<<"Struct count : "<<data->count<<"\n";
      std::cout<<"The size of the Struct is : "<<sizeof(data)<<" bytes\n";
      std::cout<<"if you want to exit type n\n";
      std::getline(std::cin,reply);
    }

    /* Don't forget to free the mmapped memory
     */
    if (munmap(data, FILESIZE) == -1) {
	perror("Error un-mmapping the file");
	/* Decide here whether to close(fd) and exit() or not. Depends... */
    }

    /* Un-mmaping doesn't close the file, so we still need to do that.
     */
    close(fd);
    return 0;
}

```