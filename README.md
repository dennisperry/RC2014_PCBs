# RC2014_PCBs
I started with a simple RC2014 Classic II and then built a Zeta2 to get more capability. However; the Zeta2 didn't allow for much hardware expansion so I returned to the RC2014 and was confronted with its low cost simplicity. The Classic II is optimized for cost not unfettered expansion. Instead I've redone all the PCBs for the RC2014 with operational independence in mind. No more one clock per system to drive CPU and UART. What I've arrived at is something close to a Zeta2 in RC2014 form factor.

I've used SMT on pretty much all the boards. In my professional life I've done a lot of work with SMT and don't find it that difficult. I'd recommend some solder paste and a hot air setup along with a good soldering iron, a flux pen and various sizes of solder wick. I've converted a toaster oven into a reflow oven if I were doing more that one unit builds. This route requires you purchase a solder paste stencil with your PCBs.

If you are a small club or other organization you could get the boards built by someone like JLCPCB or the likes and not have to deal with the SMT issue.

# 64K RAM/ROM Battery Backed Memory Board for RC2014
One of the last boards is a 64k ROM/RAM board without banking. Not efficient with memory usage but flexible in being able to make many different memory maps. The ROM can be manually bank selected and will accept any of the SST39SF0x0 flash ICs. The jumpers allow RAM or ROM to traded in 4K block across the memory map. The RAM is battery backed. I use a non-banked version of SCM on this board.
<img width="1291" height="876" alt="ROM-RAM-RC2014-V1" src="https://github.com/user-attachments/assets/75d2a686-3334-484b-a062-78efc3c0cf91" />

#Backplane with UART for RC2014
This backplane is built a 16550 UART which will save 1 slot and pretty every system will need a basic serial port. The UART is supplied with its own oscillator to make it independent of the other parts of the system.
<img width="857" height="1014" alt="BackPlane-WUART_for_RC2014" src="https://github.com/user-attachments/assets/33015d23-e15b-46ce-addb-7d47fe5048eb" />



