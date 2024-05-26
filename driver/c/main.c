#include <stdio.h>
#include <stdlib.h>
//#include <conio.h> // getch
#include "id1000500c.h"


void convolution1(int32_t memoryX[], int32_t memoryY[], uint8_t sizeX, uint8_t sizeY, int32_t memoryZ[], uint8_t shape) {
    int f_index=0;
    int sizeZ = sizeX + sizeY - 1;     
    int k, i;
    int l_index;
    int u_index;
    int dato_temp;

    if(shape == 1){
        f_index = (sizeZ - sizeX +1)/2;
        sizeZ = sizeX;
        sizeX -= f_index;
        sizeY -= f_index;    
    }    
    for (k = 0 ; k < sizeZ; k++) {
        dato_temp = 0;
        l_index = (k < sizeY) ? 0 : k - sizeY +1;
        u_index = (k < sizeX) ? k + f_index : sizeX + f_index - 1;
        
        for (i = l_index; i <= u_index; i++) {
            dato_temp += memoryX[i] * memoryY[k + f_index - i];
        }
        memoryZ[k] = dato_temp;
    }

    //printf("\n--------------------------MEMORY Z--------------------------\n");   
    //printf("The output memory values are: ");
    //for (int i = 0; i < sizeZ; i++) {
     //   printf("%d,", memoryZ[i]);
    //}
}

int main() 
{
    uint8_t nic_addr  = 1;
    uint8_t port = 0;
    uint8_t aip_mem_size_X = 5; //Size of the input memory X
    uint8_t aip_mem_size_Y = 10; //Size of the input memory Y
    uint8_t S_Z_size; //Output Size
    uint8_t Shape = 1; 

    id1000500c_init("/dev/ttyACM0", nic_addr, port, "/home/dani/Desktop/AIP_Generated/ID1000500C_config.csv");

    srand(1);

    uint32_t S_X[aip_mem_size_X];
    printf("\nData generated with %i\n",aip_mem_size_X);
    printf("\nS_X Data\n");
    for(uint32_t i=0; i<aip_mem_size_X; i++){
        S_X[i] = (rand() % 10) + 1 %0XFFFFFFF;
        printf("%08X\n", S_X[i]);
    }

    uint32_t S_Y[aip_mem_size_Y];
    printf("\nData generated with %i\n",aip_mem_size_Y);
    printf("\nS_Y Data\n");
    for(uint32_t i=0; i<aip_mem_size_Y; i++){
        S_Y[i] = (rand() % 10) + 1 %0XFFFFFFF;
        printf("%08X\n", S_Y[i]);
    }

    if(Shape == 1)
    {
        S_Z_size = aip_mem_size_X + aip_mem_size_Y - 1;
    }
    else
    {
        S_Z_size = aip_mem_size_X;
    }
    
    uint32_t S_Z[S_Z_size];
    uint32_t S_Z2[S_Z_size];


    id1000500c_Convolver(S_X,aip_mem_size_X, S_Y,aip_mem_size_Y,Shape,S_Z);
    convolution1(S_X,S_Y,aip_mem_size_X,aip_mem_size_Y,S_Z2,0);

    for(uint32_t i=0; i<S_Z_size; i++){
        printf("%08X\n", S_Z[i]);
    }

    printf("Connvolucion GM:\n");

    for(uint32_t i=0; i<S_Z_size; i++){
        printf("%08X\n", S_Z2[i]);
    }
    

    for(uint32_t i=0; i<S_Z_size; i++){
        printf("TX: %08X \t | RX: %08X \t %s \n", S_Z[i], S_Z2[i], (S_Z[i]==S_Z2[i])?"YES":"NO" );
    }

    printf("\n\nPress key to close ... ");
   // getch();
    return 0;

}
