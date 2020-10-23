#HIGHT
Final Year Project (Bachelors)

##Project Overview
This project addresses the implementation of the lightweight hardware block cipher called HIGHT (HIGH security and lightweighT). This was designed using the hardware description language VHDL. Two main designs were made for the cipher core. The first is a round-based design closely following the algorithm specification and the second is a parallel architecture. The cipher was then implemented using a Zybo FPGA board. The encryption cipher was evaluated in terms of performance and resource usage, as well as power and energy consumption.

##Simulating These Designs
To simulate the VHDL implementations of these designs, an IDE such as Vivado is required. The round-based and parallel core can both be simulated separately. The files in the sim and sources folders are required to simulate the design. Once these files have been added to the project, the core testbench file should be set as the top file. The simulation can now be run for the design.