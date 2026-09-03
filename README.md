# RC2014_PCBs
I started with a simple RC2014 Classic II and then built a Zeta2. However; the Zeta2 didn't allow for expansion so I returned to the RC2014 and was confronted with its low cost simplicity. The Classic II is optimized for cost not unfettered expansion. Instead I've redone all the PCBs for the RC2014 with operational independence in mind. No more one clock per system to drive CPU and UART. What I've arrived at is something close to a Zeta2 in RC2014 form factor.

I've used SMT on pretty much all the boards. In my professional life I've done a lot of work with SMT and don't find it that difficult. I'd recommend some solder paste and a hot air setup along with a good soldering iron, a flux pen and various sizes of solder wick.

# 64K RAM/ROM Battery Backed Memory Board
One of the last boards is a 64k ROM/RAM board without banking. Not efficient with memory usage but flexible in being able to make many different memory maps. The ROM can be manually bank selected and will accept any of the SST39SF0x0 flash ICs. The jumpers allow RAM or ROM to traded in 4K block across the memory map. The RAM is battery backed.
<img width="1291" height="876" alt="ROM-RAM-RC2014-V1" src="https://github.com/user-attachments/assets/75d2a686-3334-484b-a062-78efc3c0cf91" />


