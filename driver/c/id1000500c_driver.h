#ifndef __ID1000500C_H__
#define __ID1000500C_H__

#include <stdint.h>

/** Global variables declaration (public) */
/* These variables must be declared "extern" to avoid repetitions. They are defined in the .c file*/
/******************************************/

/** Public functions declaration */

/* Driver initialization*/
int32_t id1000500c_init(const char *connector, uint8_t nic_addr, uint8_t port, const char *csv_file);

int32_t id1000500c_Convolver(uint32_t S_X[],uint8_t size_x, uint32_t S_Y[],uint8_t size_y, uint8_t Shape, uint32_t S_Z[]);


#endif // __ID00001001_H__

