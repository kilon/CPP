#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <iostream>
#include <string>

#define FILEPATH "mmapped.bin"
#define NUMINTS  (1000)
#define FILESIZE (NUMINTS * sizeof(int))

int main(int argc, char *argv[])
{
    int i;
    int fd;
    std::string* map;
    std::string map_contents;

    fd = open(FILEPATH, O_RDONLY);
    if (fd == -1) {
	perror("Error opening file for reading");
	exit(EXIT_FAILURE);
    }
    map = (std::string*)mmap(0, FILESIZE, PROT_READ, MAP_SHARED, fd, 0);
    if (map == MAP_FAILED) {
	close(fd);
	perror("Error mmapping the file");
	exit(EXIT_FAILURE);
    }

    /* Read the file int-by-int from the mmap
     */
    map_contents = std::string(*map);
    std::cout<<"type of map is : "<< typeid(map).name()<<"\n";
    std::cout<<"I am reading from mmap : "<< map_contents <<" \n";

    if (munmap(map, FILESIZE) == -1) {
	perror("Error un-mmapping the file");
    }
    close(fd);
    return 0;
}
