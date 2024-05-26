#include "id1000500c.h"
#include "caip.h"
#include <stdio.h>
#include <stdbool.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif // _WIN32

//Defines
#define INT_DONE    0
#define ONE_FLIT    1
#define ZERO_OFFSET 0
#define STATUS_BITS 8
#define INT_DONE_BIT    0x00000001


/** Global variables declaration (private) */
caip_t      *id1000500c_aip;
uint32_t    id1000500c_id = 0;
/*********************************************************************/

/** Private functions declaration */
static uint32_t id1000500c_getID(uint32_t* id);
static uint32_t id1000500c_clearStatus(void);
/*********************************************************************/

/** Global variables declaration (public)*/

/*********************************************************************/

/**Functions*/

/* Driver initialization*/
int32_t id1000500c_init(const char *connector, uint8_t nic_addr, uint8_t port, const char *csv_file)
{
    id1000500c_aip = caip_init(connector, nic_addr, port, csv_file);

    if(id1000500c_aip == NULL){
        printf("CAIP Object not created");
        return -1;
    }
    id1000500c_aip->reset();

    id1000500c_getID(&id1000500c_id);
    id1000500c_clearStatus();

    printf("\nIP Convolver controller created with IP ID: %08X\n\n", id1000500c_id);
    return 0;
}

int32_t id1000500c_Convolver(uint32_t S_X[],uint8_t size_x, uint32_t S_Y[],uint8_t size_y, uint8_t Shape, uint32_t S_Z[])
{
    uint32_t* id;
    uint32_t status;
    uint32_t conf_register;
    uint32_t size_z;
    uint8_t data;
    
    //Get ID
    //id1000500c_aip->getID(id);

    //Get Status
    id1000500c_aip->getStatus(&status);
    printf("\nStatus: %08X",status);

    //Write input memories 
    id1000500c_aip->writeMem("MMEM_X", S_X, size_x, ZERO_OFFSET);
    printf("\nData captured in Mem Data In X:");
    id1000500c_aip->writeMem("MMEM_Y", S_Y, size_y, ZERO_OFFSET);
    printf("\nData captured in Mem Data In X:");

    //Conf_Reg Write
    conf_register = (size_x)|(size_y << size_x)|(Shape << size_y);
    printf("\nConf. Register: %08X",conf_register);
    uint32_t time_delay[] = {conf_register};
    id1000500c_aip->writeConfReg("CCONF_REG", time_delay, ONE_FLIT, ZERO_OFFSET);
    
    if(Shape == 1)
    {
        size_z = size_x + size_y -1;
    }
    else
    {
        size_z = size_x;
    }

    //Start()
    id1000500c_aip->start();

    //Wait for the completion of the process
    bool waiting = true;

    while(waiting)
    {
        id1000500c_aip->getStatus(&status);

        if((status & INT_DONE_BIT)>0)
            waiting = false;

        #ifdef _WIN32
        Sleep(500); // ms
        #else
        sleep(0.1); // segs
        #endif
    }

    //Get Status
    id1000500c_aip->getStatus(&status);
    printf("\nStatus: %08X",status);

    id1000500c_aip->clearINT(INT_DONE);
    printf("\nStatus: %08X",status);
    
    //Read Memory Z
    id1000500c_aip->readMem("MMEM_Z", S_Z, size_z, ZERO_OFFSET);
    printf("\nData obtained from Mem Data Out:\n");

    //Finish connection 
    id1000500c_aip->finish();

    return 0;

}


//PRIVATE FUNCTIONS
uint32_t id1000500c_getID(uint32_t* id)
{
    id1000500c_aip->getID(id);

    return 0;
}

uint32_t id1000500c_clearStatus(void)
{
    for(uint8_t i = 0; i < STATUS_BITS; i++)
        id1000500c_aip->clearINT(i);

    return 0;
}