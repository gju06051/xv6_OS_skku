#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char **argv)
{
	int in, out;
	int *a, *b;

	printf(1, "\n===============swap test start===============\n");

	// make some swappable page
	// allocuvm(growproc & write some data in vaddr)

	// consume physical memory for occur swap out
	printf(1, "\n=====================================mallocation_A=====================================\n");
	a = (int *)malloc(sizeof(int) * 1024 * 700);
	printf(1, "\n=================================mallocation_A_Finished=====================================\n");

	printf(1, "\n======================================Page Write A=====================================\n");
	for (int i = 0; i < 600; i++)
	{
		a[i * 1024] = i * 1024;
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	printf(1, "\n=====================================mallocation_B=====================================\n");
	b = (int *)malloc(sizeof(int) * 1024 * 700);
	printf(1, "\n=================================mallocation_B_Finished=====================================\n");

	printf(1, "\n======================================Page Write B=====================================\n");
	for (int i = 0; i < 600; i++)
	{
		b[i * 1024] = -i * 1024;
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	printf(1, "\n======================================Page Read A=====================================\n");
	for (int i = 0; i < 600; i++)
	{
		printf(1, "Read Array A call : %d\n", i);
		printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	printf(1, "\n======================================Page Read B=====================================\n");
	for (int i = 0; i < 600; i++)
	{
		printf(1, "Read Array B call : %d\n", i);
		printf(1, "number of b[%d] is %d\n", i * 1024, b[i * 1024]);
	}

	printf(1, "===========free a for checking swap in===========\n");
	free(a);
	free(b);

	// check swap state
	swapstat(&in, &out);
	printf(1, "\n1)swapin : %d\n2)swapout: %d\n", in, out);
	printf(1, "\n===============swap test end=============== \n");
	exit();
	return 0;
}
