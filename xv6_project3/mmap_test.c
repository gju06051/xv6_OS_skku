/*
#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char **argv)
{

    printf(1, "mmap test \n");
    int i;
    int size = 4096;
    int fd = open("README", O_RDWR);
    char *text = mmap(fd, 2048, size, MAP_PROT_READ);                               // File example
    char *text2 = mmap(-1, 0, size, MAP_PROT_WRITE | MAP_PROT_READ | MAP_POPULATE); // ANONYMOUS example
    for (i = 0; i < size; i++)
    {
        printf(1, "%c", text[i]);
    }
    printf(1, "\n============file mmap end===========\n\n\n\n");

    text2[0] = 's';
    text2[4095] = 'Y';
    for (i = 0; i < size; i++)
        printf(1, "%c", text2[i]);
    printf(1, "\n============anonymous mmap end============\n");

    munmap(text, size);
    munmap(text2, size);
    printf(1, "=============Unmap_test=====================\n");
    for (i = 0; i < size; i++)
    {
        printf(1, "%c", text[i]);
    }
    printf(1, "=============Unmap_test_error===============\n");
    exit();
}
*/

#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char **argv)
{

    printf(1, "mmap test \n");
    // int fd = open("README", O_RDWR);

    char *addr_1 = mmap(-1, 0, 8192, MAP_PROT_WRITE | MAP_PROT_READ);
    addr_1[0] = 'c';
    addr_1[1] = 's';

    char a = addr_1[0];
    char b = addr_1[1];

    printf(1, "%c", a);
    printf(1, "%c", b);

    munmap(addr_1, 8192);
    char b_1 = addr_1[1];
    printf(1, "%c", b_1);
    exit();
}