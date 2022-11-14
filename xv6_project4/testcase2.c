#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char **argv)
{
    int child;
    int in, out;
    int *a, *b;
    printf(1, "\n===============swap test start===============\n");

    // make some swappable page
    // allocuvm(growproc & write some data in vaddr)

    // consume physical memory for occur swap out
    printf(1, "\n=====================================mallocation_A=====================================\n");
    if ((child = fork()) == 0)
    {
        a = (int *)malloc(sizeof(int) * 1024 * 700);
        // first write
        for (int i = 0; i < 400; i++)
        {
            a[i * 1024] = i * 1024;
        }
        for (int i = 0; i < 700; i++)
        {
            printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
        }
        swapstat(&in, &out);
        printf(1, "\n1)swapin : %d\n2)swapout: %d\n", in, out);
        printf(1, "\n===============swap test end=============== \n");
        exit();
    }
    else
    {
        b = (int *)malloc(sizeof(int) * 1024 * 400);
        for (int i = 0; i < 400; i++)
        {
            b[i * 1024] = -i * 1024;
        }
        for (int i = 0; i < 400; i++)
        {
            printf(1, "number of b[%d] is %d\n", i * 1024, b[i * 1024]);
        }
        wait();
    }
    return 0;
}
