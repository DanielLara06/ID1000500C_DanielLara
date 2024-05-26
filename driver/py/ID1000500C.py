import logging, time
from ipdi.ip.pyaip import pyaip, pyaip_init

## IP Dummy driver class
class Convolver:
    ## Class constructor of IP Dummy driver
    #
    # @param self Object pointer
    # @param targetConn Middleware object
    # @param config Dictionary with IP Dummy configs
    # @param addrs Network address IP
    def __init__(self, connector, nic_addr, port, csv_file):
        ## Pyaip object
        self.__pyaip = pyaip_init(connector, nic_addr, port, csv_file)

        if self.__pyaip is None:
            logging.debug(error)

        ## Array of strings with information read
        self.dataRX = []

        ## IP Dummy IP-ID
        self.IPID = 0

        self.__getID()

        self.__clearStatus()

        logging.debug(f"IP Dummy controller created with IP ID {self.IPID:08x}")

    ## Write data in the IP Dummy input memory
    #
    # @param self Object pointer
    # @param data String array with the data to write

    def conv(self,S_X,S_Y,Shape):
        self.IPID = self.__pyaip.getID()

        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")

        ## Show IP Dummy status
        #
        # @param self Object pointer
        def status(self):
            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

        ## S_X Write Data
        self.__pyaip.writeMem('MMEM_X', S_X, len(S_X), 0)
        logging.debug("Data captured in Mem Data In X")

        ## S_Y Write Data
        self.__pyaip.writeMem('MMEM_Y', S_Y, len(S_Y), 0)
        logging.debug("Data captured in Mem Data In Y")

        ## ConF_Reg Write
        size_x = len(S_X)
        size_y = len(S_Y)
        shape_full_same = Shape
        # conf_register = 1349  # shape_full_same+size_y+size_x
        conf_register = (size_x)|(size_y << size_x)|(Shape << size_y)
        logging.info(conf_register)
        timeDelay = []

        timeDelay.append(conf_register)
        self.__pyaip.writeConfReg('CCONF_REG', timeDelay, 1, 0)
        logging.debug(f"Configuration Register setted up with {size_x},{size_y} and Shape = {shape_full_same}")

        if Shape == 1:
            s_z_size = len(S_X) + len(S_Y) - 1
        else:
            s_z_size = len(S_X)

        ## Start()
        self.__pyaip.start()
        logging.debug("Start sent")

        ## Wait for the completion of the process
        #
        # @param self Object pointer

        waiting = True
        while waiting:
            status = self.__pyaip.getStatus()
            logging.debug(f"status {status:08x}")

            if status & 0x1:
                waiting = False
            time.sleep(0.1)

        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")

        ## Show IP Dummy status
        #
        # @param self Object pointer
        def status(self):
            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

        ## Clear status register of IP Dummy
        #
        # @param self Object pointer
        for i in range(8):
            self.__pyaip.clearINT(i)

        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")

        ## Show IP Dummy status
        #
        # @param self Object pointer
        def status(self):
            status = self.__pyaip.getStatus()
            logging.info(f"{status:08x}")

        ## Read Memory S_Z
        data = self.__pyaip.readMem('MMEM_Z',s_z_size, 0)
        logging.debug("Data obtained from Mem Data Out")



        ## Finish connection
        #
        # @param self Object pointer
        self.__pyaip.finish()

        return data
        ## Get IP ID
        #
        # @param self Object pointer

    def __getID(self):
        self.IPID = self.__pyaip.getID()

        ## Clear status register of IP Dummy
        #
        # @param self Object pointer

    def __clearStatus(self):
        for i in range(8):
            self.__pyaip.clearINT(i)

    ## Disable IP Dummy interruptions
    #
    # @param self Object pointer
    def disableINT(self):
        self.__pyaip.disableINT(0)

        logging.debug("Int disabled")

if __name__=="__main__":
    import numpy as np
    import sys
    import random
    import time, os

    logging.basicConfig(level=logging.INFO)
    connector = '/dev/ttyACM0'
    csv_file = '/home/dani/Desktop/AIP_Generated/ID1000500C_config.csv'
    addr = 1
    port = 0
    aip_mem_size_X = 5
    aip_mem_size_Y = 10

    try:
        convol = Convolver(connector, addr, port, csv_file)
        logging.info("Test Convolver: Driver created")
    except:
        logging.error("Test Convolver: Driver not created")
        sys.exit()

    random.seed(1)

    L = []
    L3 = []
    L5 = []

    ## Show IP Dummy status
    #
    # @param self Object pointer
    def status(self):
        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")

    convol.disableINT()

    S_X = [random.randrange(10) for i in range(0, aip_mem_size_X)]
    S_Y = [random.randrange(10) for i in range(0, aip_mem_size_Y)]
    Shape = 1  # Full Convolution
    logging.info(f"Data generated with {len(S_X):d}")
    logging.info(f'TX Data {[f"{x:08X}" for x in S_X]}')

    logging.info(f"Data generated with {len(S_Y):d}")
    logging.info(f'TX Data {[f"{x:08X}" for x in S_Y]}')
    logging.info(f"Full Convolution mode")

    S_Z = convol.conv(S_X,S_Y,Shape)
    logging.info(f'RX Data {[f"{x:0d}" for x in S_Z]}')

    GM = (np.convolve(S_X,S_Y))

    for i in range(len(GM)):
        str(L.append(GM[i]))

    print(S_Z)
    print(L)


    for x, y in zip(S_Z, L):
        logging.info(f"TX: {x:0d} | RX: {y:0d} | {'TRUE' if x == y else 'FALSE'}")


    logging.info("The End")
