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
	printf(1, "\n===============mallocation===============\n");
	a = (int *)malloc(sizeof(int) * 1024 * 700);
	// first write
	for (int i = 0; i < 600; i++)
	{
		a[i * 1024] = i;
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	b = (int *)malloc(sizeof(int) * 1024 * 700);
	for (int i = 0; i < 600; i++)
	{
		b[i * 1024] = -i;
		// printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	for (int i = 0; i < 600; i++)
	{
		printf(1, "number of a[%d] is %d\n", i * 1024, a[i * 1024]);
	}
	for (int i = 0; i < 600; i++)
	{
		printf(1, "number of b[%d] is %d\n", i * 1024, b[i * 1024]);
	}

	printf(1, "===========free a for checking swap in===========\n");
	free(a);

	printf(1, "\n===============swap in test start===============\n");
	// access to vaddr that swapped out page
	// check swap state
	swapstat(&in, &out);
	printf(1, "\n1)swapin : %d\n2)swapout: %d\n", in, out);
	printf(1, "\n===============swap test end=============== \n");
	exit();
	return 0;
}

// void testcfs()
// {
// 	int child;
// 	// int parent = getpid();
// 	// int* in,*out;
// 	// int i;
// 	// volatile double x = 0, z;
// 	int *a;
// 	int *b;
// 	// int ret;
// 	if ((child = fork()) == 0)
// 	{ // child
// 		// setnice(parent, 5);
// 		// if you set parent's priority lower than child,
// 		// 2nd ps will only printout parent process,
// 		// since child finished its job earlier & exit
// 		/*
// 		for(i = 0; i < 3000; i++){
// 			for ( z = 0; z < 30000.0; z += 0.1 )
// 				x =  x + 3.14 * 89.64;
// 		}
// 		ps();
// 		*/
// 		a = (int *)malloc(sizeof(int) * 1024 * 2700);
// 		for (int i = 0; i < 2500; i++)
// 		{
// 			a[i] = 3;
// 		}
// 		exit();
// 	}
// 	else
// 	{
// 		int in, out;
// 		// setnice(child, 0);
// 		// parent
// 		/*
// 		for(i = 0; i < 3000; i++){
// 			for ( z = 0; z < 30000.0; z += 0.1 )
// 				x =  x + 3.14 * 89.64;
// 		}
// 		ps();
// 		*/
// 		b = (int *)malloc(sizeof(int) * 1024 * 1000);
// 		for (int i = 0; i < 2500; i++)
// 		{
// 			b[i] = 2;
// 		}
// 		wait();
// 		/*
// 		for(int i = 0; i < 2500; i++){
// 			ret = a[i];
// 			if(i%1000 == 0)
// 				printf(1,"%d\n",ret);
// 		}
// 		*/
// 		swapstat(&in, &out);
// 		printf(1, "swap out : %d\n", out);
// 		printf(1, "swap in : %d\n", in);
// 	}
// }

/*
int main(int argc, char **argv)
{
	printf(1, "=== TEST START ===\n");
	testcfs();
	printf(1, "=== TEST   END ===\n");
	exit();
}
*/