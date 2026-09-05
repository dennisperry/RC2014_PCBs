# PCBs for RC2014
I started with a simple RC2014 Classic II as something interesting to try a new logic analyze. Then built a Zeta2 to get more capability; CP/M etal using ROMWBW. However; the Zeta2 didn't allow for much hardware expansion so I returned to the RC2014 and was confronted with its low cost simplicity. The Classic II is optimized for cost not unfettered expansion. Instead I've redone all the PCBs for the RC2014 with operational independence in mind. No more one clock per system to drive CPU and UART. What I've arrived at is something close to a Zeta2 in RC2014 form factor.

I've used SMT on pretty much all the boards. In my professional life I've done a lot of work with SMT and don't find it that difficult. I'd recommend some solder paste and a hot air setup along with a good soldering iron, a flux pen and various sizes of solder wick. I've converted a toaster oven into a reflow oven for when I'm doing more that one unit builds. This route requires you purchase a solder paste stencil with your PCBs.

No attempt is made to make the boards the same size or particularly pretty, these boards were started with the tariffs at their peak and every sq inch was expensive. The routing is from the FreeRouting plug-in to KiCad. Some of the rough edges are fixed but I didn't want to make them a lifetime project.

If you are a small club or other organization you could get the boards built by someone like JLCPCB or the likes and not have to deal with the SMT issue.

What's missing; generally there is no complete BOM. A BOM can be generated from the KiCad schematic along with looking at the package type. My general practice was to build up a list on Digikey or Mouser as I designed the board. Also combined with what stock I have on hand along with contributions from ebay and JameCo.

# 64K RAM/ROM Battery Backed Memory Board for RC2014
One of the last boards I built is a 64k ROM/RAM board without banking. I needed something simpler for a project than the Zeta2 banking system. It is not efficient with memory usage but flexible in being able to make many different memory maps. The ROM can be manually bank selected and will accept any of the SST39SF0x0 flash ICs. The jumpers allow RAM or ROM to traded in 4K block across the memory map. The RAM is battery backed. I use a non-banked version of SCM on this board. If you change your ROM frequently experimenting you will appreciate the 32 pin ZIF socket.
<img width="1291" height="876" alt="ROM-RAM-RC2014-V1" src="https://github.com/user-attachments/assets/75d2a686-3334-484b-a062-78efc3c0cf91" />

# Backplane with UART for RC2014

This backplane is built a 16550 UART which will save 1 slot and pretty much every system will need a basic serial port. The UART is supplied with its own oscillator to make it independent of the other parts of the system.
<img width="857" height="1014" alt="BackPlane-WUART_for_RC2014" src="https://github.com/user-attachments/assets/33015d23-e15b-46ce-addb-7d47fe5048eb" />

# Z80 CPU for RC2014
A simple card with its own oscillator which can be either the 8 or 14 pin sizes. Clock can be put on the bus or not by jumper.
<img width="2071" height="554" alt="Z80_CPU_for_RC2014_v21" src="https://github.com/user-attachments/assets/9afb27e2-b296-40d8-885c-f3e02628f19c" />

# 512K RAM/ROM MEMORY for RC2014
This is a Zeta2 compatible bank select memory board. Allows full ROMWBW CP/M system with ROM and RAM disks. Again experimenters will appreciate the 32 pin ZIF socket. It does lack the battery backup of the Zeta2.
<img width="1447" height="638" alt="512K_RAM-ROM-RC2014_V2" src="https://github.com/user-attachments/assets/cea71e1e-2a4a-45a7-96d1-5c0ec98a089f" />

# 16550 UART for RC2014
Done before the backplane with UART, is Zeta2 compatible using ROMWBW. Has its own clock, and has pinout for a standard FTDI TTL to USB UART adapter.
<img width="2090" height="557" alt="16550UART_RC2014_V21" src="https://github.com/user-attachments/assets/07df3dfc-3fa3-4a40-a05c-296a21805f2b" />

# Z80 CTC DS1302 RTC for RC2014
This board is Zeta2 compatible with ROMWBW. The RTC is battery backed. Generates periodic interrupts using tpye 2 interrupts.
<img width="1735" height="801" alt="Z80-CTC-DS1302-RTC_RC2014_V2" src="https://github.com/user-attachments/assets/6e42ad85-327f-42dd-8d65-5a4c88f21f55" />

# PPIDE for RC2014
Again Zeta2 compatible with ROMWBW. Supports power for a CF Card adapter. I use this with a CF card adapter combined with a CF to SD card adapter. You can load all the ROMWBW disk images on a reasonable SD card.
<img width="2074" height="772" alt="PPIDE_RC2014_V22" src="https://github.com/user-attachments/assets/e8febc75-5c63-4277-abde-872701445166" />

# FDC for RC2014
Zeta2 compatible with ROMWBW. I found that once I had the PPIDE board in my system I really had no need for the FDC but it works fine.
<img width="2082" height="736" alt="FDC_RC2014_V22" src="https://github.com/user-attachments/assets/c29d8abd-9f7f-44f7-be34-4a53e069522d" />



