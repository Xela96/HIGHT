#include "xparameters.h"
#include "xil_io.h"
#include "xbasic_types.h"

int main(){

	xil_printf("Start of IP HIGHT test \n\n\r");
	// Encrypt 64 bit plaintext

	u32 text_out_lower;
	u32 text_out_upper;
	u64 hightout;

	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR, 0x00000000); //set lower half of plaintext
	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR+4, 0x00000000); //set upper half of plaintext

	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR+8, 0xccddeeff); //set 1st quarter of master key
	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR+12, 0x8899aabb); //set 2nd quarter of master key
	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR+16, 0x44556677); //set 3rd quarter of master key
	Xil_Out32(XPAR_MYIP_0_S00_AXI_BASEADDR+20, 0x00112233); //set 4th quarter of master key

	text_out_lower = Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+24);
	text_out_upper = Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+28);

	//hightout = ((uint64_t)text_out_upper << 32) | text_out_lower;

	//xil_printf("Plaintext = 0000000000000000; Masterkey = 00112233445566778899aabbccddeeff; Ciphertext = %08x \n\r",text_out_lower);
	xil_printf("Upper = %x \n\r",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+24));
	xil_printf("Lower = %x \n\r",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+28));

	/*xil_printf("base %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR));
	xil_printf("1 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+4));
	xil_printf("2 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+8));
	xil_printf("3 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+12));
	xil_printf("4 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+16));
	xil_printf("5 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+20));
	xil_printf("6 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+24));
	xil_printf("7 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+28));
	xil_printf("8 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+32));
	xil_printf("9 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+36));
	xil_printf("10 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+40));
	xil_printf("11 %x \n",Xil_In32(XPAR_MYIP_0_S00_AXI_BASEADDR+44));
	xil_printf("12 %x \n",text_out_lower);
	xil_printf("13",text_out_lower);*/



	return 0;
}
