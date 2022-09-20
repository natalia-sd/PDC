#include <stdlib.h>
#include <stdio.h>
#include <windows.h>

//20.	Задать 1024 числа и выдать чётное/ нечётное
void oddeven_sep(int n, int* array_odd, int* array_even)
{
    int c_even = 0;
    int c_odd = 0;
    for (int i = 0; i < n; i++)
    {
        if (i % 2 == 0)
        {
            array_even[c_even] = i;
            c_even++;
        }
        else
        {
            array_odd[c_odd] = i;
            c_odd++;
        }
    }
}


int main() {
    //timer
    LARGE_INTEGER frequency;        // ticks per second
    LARGE_INTEGER t1, t2;           // ticks
    double elapsedTime;

    int n;      // input n, int n = 1024;
    scanf("%d", &n);
    int* c_array_odd = (int*)malloc(n/2 * sizeof(int));
    int* c_array_even = (int*)malloc(n/2 * sizeof(int));

    // get ticks per second
    QueryPerformanceFrequency(&frequency);

    QueryPerformanceCounter(&t1);       //start
    oddeven_sep(n, c_array_odd, c_array_even);
    QueryPerformanceCounter(&t2);       //stop

    elapsedTime = (t2.QuadPart - t1.QuadPart) * 1000.0 / frequency.QuadPart;
    printf("CPU Time: %f ms.\n", elapsedTime);


    printf("Odd numbers:\n");
    for (int i = 0; i < n/2; i++) {
		printf("%d ", c_array_odd[i]);
	}

    printf("\n Even numbers:\n");
    for (int i = 0; i < n/2; i++) {
		printf("%d ", c_array_even[i]);
	}
    printf("\n");


    free(c_array_odd);
    free(c_array_even);

    system ( "PAUSE" );
    return 0;
}