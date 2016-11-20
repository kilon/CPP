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
#define NUMINTS (1000)
#define FILESIZE (NUMINTS * sizeof(int))


typedef struct
{
  char data[3000]; // no need to take the entire space of the shared memory
  int count;
} state_data;

int main(int argc, char *argv[])
  {

    int fd;
    int result;

    std::string reply ="";

    /* Open a file for writing.  * - Creating the file if it doesn't exist.  * -
    Truncating it to 0 size if it already exists. (not really needed)

    Note: "O_WRONLY" mode is not sufficient when mmaping.  */

    fd = open(FILEPATH, O_RDWR | O_CREAT | O_TRUNC, (mode_t)0600);
    if (fd == -1)
      {
        perror("Error opening file for writing");
        exit(EXIT_FAILURE);
      }

    /* Stretch the file size to the size of the (mmapped) array of ints */

    result = lseek(fd, FILESIZE-1, SEEK_SET);
     if (result == -1)
      {
        close(fd);
        perror("Error calling lseek() to 'stretch' the file");
        exit(EXIT_FAILURE);
      }

    /* Something needs to be written at the end of the file to * have the file
    actually have the new size.  * Just writing an empty string at the current
    file position will do.
     *
     * Note: - The current position in the file is at the end of the stretched
     * file due to the call to lseek().  - An empty string is actually a single
     * '\0' character, so a zero-byte will be written at the last byte of the
     * file. */
     result = write(fd, "", 1);
     if (result != 1)
       {
         close(fd);
         perror("Error writing last byte of the file");
         exit(EXIT_FAILURE); }

     /*Now the file is ready to be mmapped.  */

     std::cout<<"call mmap\n";

    state_data* data =(state_data*) mmap(0, FILESIZE, PROT_READ | PROT_WRITE,
    MAP_SHARED, fd, 0);
    if (data == MAP_FAILED)
      {
        close(fd);
        perror("Error mmapping the file");
        exit(EXIT_FAILURE);
      }

    /* Now write write the string and the size of the string to the memory using
    the stuct. The file will be saved automatically by the OS.  */
    while(reply!="n")
      {

        std::cout<<"*************************\n";
        printf("Map pointer points to address : %d \n",data);
        std::cout<<"type the value you want to share : \n";

        std::getline(std::cin,reply);

        memset(data,0,sizeof(state_data)); // zero out the memory

        std::cout<<"Looping assignment\n";

        for( data->count = 0 ; data->count < reply.length() ; ++data->count )
          {
            data->data[data->count] = reply[data->count];

          }


        /* msync(map,FILESIZE,MS_SYNC | MS_INVALIDATE);
           you can use this if you want to save the file by yourself instead of
           expecting the OS to do it automatically. Makes sure that the shared
           data is always stored to the file. However this is option if storing
           the data to the file is not your prime concern. */

        std::cout<<"Struct data : "<<data->data<<"\n";
        std::cout<<"Struct count : "<<data->count<<"\n";
        std::cout<<"The size of the Struct is :"<<sizeof(state_data)<<" bytes\n";
        std::cout<<"File mode : "<<(mode_t)0600<<"\n";
        std::cout<<"if you want to exit type n\n";

        std::getline(std::cin,reply);
      }

    /* Don't forget to free the mmapped memory */
    if (munmap(data, FILESIZE) == -1)
      {
        perror("Error un-mmapping the file"); /* Decide here whether to
                                                 close(fd) and exit() or
                                                 not. Depends... */
      }

    /* Un-mmaping doesn't close the file, so we still need to do that.  */
    close(fd);
    return 0;
}
