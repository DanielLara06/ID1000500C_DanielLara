from ipdi.ip.pyaip import pyaip, pyaip_init

import sys

try:
    connector = '/dev/ttyACM0'
    nic_addr = 1
    port = 0
    csv_file = '/home/dani/Desktop/AIP_Generated/ID1000500C_config.csv'

    aip = pyaip_init(connector, nic_addr, port, csv_file)

    aip.reset()

    #==========================================
    # Code generated with IPAccelerator 

    ID = aip.getID()
    print(f'Read ID: {ID:08X}\n')

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    CONF_REG = [0x00000545]

    print('Write configuration register: CCONF_REG')
    aip.writeConfReg('CCONF_REG', CONF_REG, 1, 0)
    print(f'CONF_REG Data: {[f"{x:08X}" for x in CONF_REG]}\n')

    MEM_X = [0x00000009, 0x00000002, 0x00000004, 0x00000001, 0x0000000A]

    print('Write memory: MMEM_X')
    aip.writeMem('MMEM_X', MEM_X, 5, 0)
    print(f'MEM_X Data: {[f"{x:08X}" for x in MEM_X]}\n')

    MEM_Y = [0x00000008, 0x00000008, 0x00000002, 0x00000004, 0x00000002, 0x00000005, 0x00000009, 0x00000007, 0x00000007, 0x00000007]

    print('Write memory: MMEM_Y')
    aip.writeMem('MMEM_Y', MEM_Y, 10, 0)
    print(f'MEM_Y Data: {[f"{x:08X}" for x in MEM_Y]}\n')

    print('Start IP\n')
    aip.start()

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    print('Read memory: MMEM_Z')
    MEM_Z = aip.readMem('MMEM_Z', 14, 0)
    print(f'MEM_Z Data: {[f"{x:08X}" for x in MEM_Z]}\n')

    print('Clear INT: 0')
    aip.clearINT(0)

    #==========================================

    aip.finish()

except:
    e = sys.exc_info()
    print('ERROR: ', e)

    aip.finish()
    raise
