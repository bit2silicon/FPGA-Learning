/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
//
//#include <stdio.h>
//#include "platform.h"
//#include "xil_printf.h"
//
//
//int main()
//{
//    init_platform();
//
//    print("Hello World\n\r");
//    print("Successfully ran Hello World application");
//    cleanup_platform();
//    return 0;
//}




#include "xaxidma.h"
#include "xparameters.h"
#include "xdebug.h"
#include "xil_cache.h" // Required for cache operations
#include <sleep.h>

#if defined(XPAR_UARTNS550_0_BASEADDR)
#include "xuartns550_l.h"       /* to use uartns550 */
#endif

/******************** Constant Definitions **********************************/

/*
 * Device hardware build related constants.
 */
#ifndef XPAR_XAXIDMA_0_DEVICE_ID
#define XPAR_XAXIDMA_0_DEVICE_ID 0
#endif

#define DMA_DEV_ID          XPAR_XAXIDMA_0_DEVICE_ID

/*
 * Buffer and Transfer related constants
 */
#define MAX_PKT_LEN         40  /* 1KB buffer size */

/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/
int XAxiDma_SimplePollExample(u16 DeviceId);
static int CheckData(u32 *TxBufferPtr, u32 *RxBufferPtr, int Length) {
	for(int i = 0; i < Length; i ++) {
		if(RxBufferPtr[i] == TxBufferPtr[i]) {
			continue;
		} else {
			return XST_FAILURE;
		}
	}
	return XST_SUCCESS;
}

/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XAxiDma AxiDma;

/*
 * Buffers to hold data for sending and receiving. These are declared as global
 * to be placed in memory, not on the stack.
 */
u32 TxBuffer[MAX_PKT_LEN];
u32 RxBuffer[MAX_PKT_LEN];


/*****************************************************************************/
/**
*
* Main function
*
* This function is the main entry of the program. It calls the DMA test
* function and prints the result.
*
* @param	None
*
* @return
*		- XST_SUCCESS if tests pass
*		- XST_FAILURE if tests fail.
*
* @note		None.
*
******************************************************************************/
int main()
{
	int Status;

	xil_printf("\r\n--- Entering main() --- \r\n");

	/* Run the DMA Simple Poll example */
	Status = XAxiDma_SimplePollExample(XPAR_XAXIDMA_0_DEVICE_ID);

	if (Status != XST_SUCCESS) {
		xil_printf("DMA Loopback Test Failed\r\n");
		return XST_FAILURE;
	}
	else {
		xil_printf("DMA Loopback Test Successfully Passed\r\n");
	}

	xil_printf("Successfully ran DMA Loopback Test\r\n");
	xil_printf("--- Exiting main() --- \r\n");

	return XST_SUCCESS;

}

/*****************************************************************************/
/**
* This function does a test of the AXI DMA in simple polling mode.
*
* @param	DeviceId is the Device ID of the XAxiDma instance
*
* @return
*		- XST_SUCCESS if passed
*		- XST_FAILURE if failed.
*
* @note		None.
*
******************************************************************************/
int XAxiDma_SimplePollExample(u16 DeviceId)
{
	XAxiDma_Config *CfgPtr;
	int Status;
	int Tries = 10;
	int Index;
	u32 *TxBufferPtr = TxBuffer;
	u32 *RxBufferPtr = RxBuffer;

	/* Step 1: Initialize the AXI DMA device */
	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	/* Check if the DMA is in Scatter-Gather mode, which is not what we want for this simple test */
	if (XAxiDma_HasSg(&AxiDma)) {
		xil_printf("Device configured as SG mode.\r\n");
		return XST_FAILURE;
	}

	/* Disable interrupts, we use polling mode */
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

	/* Step 2: Prepare the data to be sent */
	// Fill the transmit buffer with a known pattern
	for(Index = 0; Index < MAX_PKT_LEN; Index ++) {
		TxBufferPtr[Index] = 2*Index;
	}
	// Initialize the receive buffer with zeros to ensure data is actually received
	for(Index = 0; Index < MAX_PKT_LEN; Index ++) {
		RxBufferPtr[Index] = 0;
	}

	/*
	 * Flush the buffers before the DMA transfer, in case the CPU has cached them.
	 * This is important for data consistency.
	 */
	Xil_DCacheFlushRange((UINTPTR)TxBuffer, MAX_PKT_LEN * sizeof(u32));
	Xil_DCacheFlushRange((UINTPTR)RxBuffer, MAX_PKT_LEN * sizeof(u32));


	/* Step 3: Start the DMA transfer */

	// *** CRITICAL STEP: Start the RECEIVER first ***
	// The Stream-to-Memory-Map (S2MM) channel must be ready to receive data
	// before the Memory-Map-to-Stream (MM2S) channel starts sending it.
	Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) RxBufferPtr,
				MAX_PKT_LEN * sizeof(u32), XAXIDMA_DEVICE_TO_DMA);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Now, start the TRANSMITTER
	Status = XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR) TxBufferPtr,
				MAX_PKT_LEN * sizeof(u32), XAXIDMA_DMA_TO_DEVICE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	/* Step 4: Wait for the transfer to complete */

	// Poll the S2MM (Receive) channel
	while (Tries && XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA)) {
		/* Wait */
        usleep(1000);
        Tries--;
	}
	if (!Tries) {
        xil_printf("Failed to receive data from PL\r\n");
        // You can add logic here to reset the DMA
    }


	// Poll the MM2S (Transmit) channel
    Tries = 10;
	while (Tries && XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE)) {
		/* Wait */
        usleep(1000);
        Tries--;
	}
    if (!Tries) {
        xil_printf("Failed to send data to PL\r\n");
        // You can add logic here to reset the DMA
    }


	/*
	 * Invalidate the receive buffer range in the cache to ensure we get the
	 * fresh data from memory.
	 */
	Xil_DCacheInvalidateRange((UINTPTR)RxBuffer, MAX_PKT_LEN * sizeof(u32));

	for(int i=0; i < MAX_PKT_LEN; i++) {
		xil_printf("Tx: %d -> Rx: %d\r\n",TxBuffer[i], RxBuffer[i]);
	}


	/* Step 5: Verify the received data */
	Status = CheckData(TxBufferPtr, RxBufferPtr, MAX_PKT_LEN);
	if (Status != XST_SUCCESS) {
		xil_printf("Data check failed\r\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
