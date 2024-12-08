# Custom emulated computer
A 16-bit computer architecture i made, emulated in opal.

NOTE: The project is not finished, there will probably be changes in the design and architecture in the future

to run, open or compile `Computer.opal` using the opal compiler, and pass it a file to run as a command line argument.

## Command line arguments
- `--clock`
	- Sets the clock pulse duration of the CPU. Default is 0.
	- **Usage**: --clock [duration]
- `--resolution`
	- Sets the computer screen resolution. Default is 256x256.
	- **Usage**: --resolution [width]x[height]
- `--scale`
	- Sets the computer screen window scale. Default is 1.
	- **Usage**: --scale [scale factor]
- `--hex-dump`
	- Shows an hex dump of the data that is written to RAM after compilation.
	- **Usage** --hex-dump
- `--time`
	- Shows the time elapsed since the computer started running when the computer stops.
	- **Usage** --time
- `--mixer-words`
	- Sets the amount of words dedicated to each [mixer code](https://github.com/amari-calipso/custom-emulated-computer#sound-code). Default is 1.
	- **Usage**: --mixer-words [word count]
# General specs
The computer, designed to have a 16 bits CPU, supports a maximum of 8 GB of RAM (around 4 billion addresses), split in 65536 memory banks, each having a maximum size of 128 KB (65536 addresses). By default, the computer uses 2 MB of RAM split in 16 memory banks. The GPU has a dedicated video memory, that can be of a maximum size of 12 GB (when assuming a 65536x65536 screen resolution). The video memory size depends on the resolution set by the user. By default, it can store 196 KB of data using a 256x256 resolution.

# Registers
The computer contains 5 general purpose registers (X, Y, Z, A, B), 2 of which (A and B) are directly connected to the ALU.
It also contains an alphanumeric display (often used as a data register, referred to as "D"), and a stack pointer (referred to as "S").

# Instructions

## NOP / No OPeration / 0x00
## LI* / Load Immediate * / 0x01 - 0x06 + 0x71
- Loads a register with a value. * indicates the register letter:
	- LIX - 0x01
	 - LIY - 0x02
	 - LIZ - 0x03
	 - LIA - 0x04
	 - LIB - 0x05
	 - LID - 0x06
	 - LIS - 0x71
- **Usage**: LI* [value]
## FL* / Fast Load * / 0x07 - 0x0c
- Loads a register with a value, directly taken from the low half of the instruction register. * indicates the register letter:
	- FLX - 0x07
	- FLY - 0x08
	- FLZ - 0x09
	- FLA - 0x0a
	- FLB - 0x0b
	- FLD - 0x0c
- **Usage**: FL* [value]
## LO* / LOad * / 0x0d - 0x12 + 0x70
- Loads a register with a value from the given memory address. * indicates the register letter:
	 - LOX - 0x0d
	 - LOY - 0x0e
	 - LOZ - 0x0f
	 - LOA - 0x10
	 - LOB - 0x11
	 - LOD - 0x12
	 - LOS - 0x70
- **Usage**: LO* [address]
## ST* / STore * / 0x13 - 0x18 + 0x72
- Stores the contents of a register in a given memory address. * indicates the register letter:
	 - STX - 0x13
	 - STY - 0x14
	 - STZ - 0x15
	 - STA - 0x16
	 - STB - 0x17
	 - STD - 0x18
	 - STS - 0x72
- **Usage**: ST* [address]
## ADD / ADD / 0x19
- Adds the contents of registers A and B and saves the result in X:
- **Usage**: ADD
## SUB / SUBtract / 0x1a
- Subtracts the contents of registers A and B and saves the result in X:
- **Usage**: SUB
## ADI / ADd Immediate / 0x1b
- Adds two values and saves the result in X:
- **Usage**: ADI [value1], [value2]
## SBI / SuBtract Immediate / 0x1c
- Subtracts two values and saves the result in X:
- **Usage**: SBI [value1], [value2]
## DPM / DisPlay Mode / 0x1d
- Sets the alphanumeric display mode. Available modes are:
	 - 0: unsigned int;
	 - 1: signed int;
	 - 2: char.
- **Usage**: DPM [mode]
## DPL / DisPLay / 0x1e
- Displays the contents of the alphanumeric display:
- **Usage**: DPL
## DLI / DispLay Immediate / 0x1f
- Displays a value on the alphanumeric display:
- **Usage**: DLI [value]
## FDL / Fast DispLay / 0x20
- Displays a value on the alphanumeric display, taken from the low half of the instruction register:
- **Usage**: FDL [value]
## JMP / JuMP / 0x21
- Jumps to a given memory address (NOTE: all jump instructions can't jump to different memory banks):
- **Usage**: JMP [address]
## JMI / JuMp Immediate / 0x22
- Jumps to a given memory address, taken from the low half of the instruction register:
- **Usage**: JMI [address]
## JC - JGT / Jump Carry - Jump Greater Than / 0x23
- Jumps to a given memory address if the carry flag is set:
- **Usage**: JC [address]
## JCI - JGI / Jump Carry Immediate - Jump Greater Immediate / 0x24
- Jumps to a given memory address, taken from the low half of the instruction register, if the carry flag is set:
- **Usage**: JCI [address]
## JZ - JEQ/ Jump Zero - Jump EQual / 0x25
- Jumps to a given memory address if the zero flag is set:
- **Usage**: JZ [address]
## JZI - JEI / Jump Zero Immediate - Jump Equal Immediate / 0x26
- Jumps to a given memory address, taken from the low half of the instruction register, if the zero flag is set:
- **Usage**: JZI [address]
## IN* / INcrement * / 0x27 - 0x2c + 0x73
- Increments the value stored in a register. * indicates the register letter:
	 - INX - 0x27
	 - INY - 0x28
	 - INZ - 0x29
	 - INA - 0x2a
	 - INB - 0x2b
	 - IND - 0x2c
	 - INS - 0x73
- **Usage**: IN*
## DC* / DeCrement * / 0x2c - 0x31 + 0x74
- Decrements the value stored in a register. * indicates the register letter:
	 - DCX - 0x2c
	 - DCY - 0x2d
	 - DCZ - 0x2e
	 - DCA - 0x2f
	 - DCB - 0x30
	 - DCD - 0x31
	 - DCS - 0x74
- **Usage**: DC*
## SL* / Shift Left * / 0x32 - 0x37
- Shifts left the value stored in a register a given amount of times. * indicates the register letter:
	 - SLX - 0x32
	 - SLY - 0x33
	 - SLZ - 0x34
	 - SLA - 0x35
	 - SLB - 0x36
	 - SLD - 0x37
- **Usage**: SL* [amount]
## SR* / Shift Right * / 0x38 - 0x3d
- Shifts right the value stored in a register a given amount of times. * indicates the register letter:
	 - SRX - 0x38
	 - SRY - 0x39
	 - SRZ - 0x3a
	 - SRA - 0x3b
	 - SRB - 0x3c
	 - SRD - 0x3d
- **Usage**: SR* [amount]
## RL* / Rotate Left * / 0x3e - 0x43
- Rotates left the value stored in a register a given amount of times. * indicates the register letter:
	 - RLX - 0x3e
	 - RLY - 0x3f
	 - RLZ - 0x40
	 - RLA - 0x41
	 - RLB - 0x42
	 - RLD - 0x43
- **Usage**: RL* [amount]
## RR* / Rotate Right * / 0x44 - 0x49
- Rotates right the value stored in a register a given amount of times. * indicates the register letter:
	 - RRX - 0x44
	 - RRY - 0x45
	 - RRZ - 0x46
	 - RRA - 0x47
	 - RRB - 0x48
	 - RRD - 0x49
- **Usage**: RR* [amount]
## M?* / Move from ? to * / 0x4a - 0x67
- Copies the contents of a register to another register. ? indicates the source and * indicates the destination:
	- MXY - 0x4a
	- MXZ - 0x4b
	- MXA - 0x4c
	- MXB - 0x4d
	- MXD - 0x4e
	- MYX - 0x4f
	- MYZ - 0x50
	- MYA - 0x51
	- MYB - 0x52
	- MYD - 0x53
	- MZX - 0x54
	- MZY - 0x55
	- MZA - 0x56
	- MZB - 0x57
	- MZD - 0x58
	- MAX - 0x59
	- MAY - 0x5a
	- MAZ - 0x5b
	- MAB - 0x5c
	- MAD - 0x5d
	- MBX - 0x5e
	- MBY - 0x5f
	- MBZ- 0x60
	- MBA - 0x61
	- MBD - 0x62
	- MDX - 0x63
	- MDY - 0x64
	- MDZ - 0x65
	- MDA - 0x66
	- MDB - 0x67
- **Usage**: M?*
## LA* / Load from Address * / 0x68 - 0x6d
- Loads a value from the address stored in given register, to the same register. * indicates the register letter:
	 - LAX - 0x68
	 - LAY - 0x69
	 - LAZ - 0x6a
	 - LAA - 0x6b
	 - LAB - 0x6c
	 - LAD - 0x6d
- **Usage**: LA*
## CMP / CoMPare / 0x6e
- Subtracts the contents of registers A and B without saving the result:
- **Usage**: CMP
## CPI / ComPare Immediate / 0x6f
- Subtracts two values without saving the result:
- **Usage**: CPI [value1], [value2]
## PS* / PuSh * / 0x75 - 0x7a
- Pushes the contents of a register into the stack. * indicates the register letter:
	 - PSX - 0x75
	 - PSY - 0x76
	 - PSZ - 0x77
	 - PSA - 0x78
	 - PSB - 0x79
	 - PSD - 0x7a
- **Usage**: PS*
## PP* / PoP to * / 0x7b - 0x80
- Pops an element from the stack and saves it in given register. * indicates the register letter:
	 - PPX - 0x7b
	 - PPY - 0x7c
	 - PPZ - 0x7d
	 - PPA - 0x7e
	 - PPB - 0x7f
	 - PPD - 0x80
- **Usage**: PP*
## JSR / Jump SubRoutine / 0x81
- Pushes the next address and the current general purpose registers' values to the stack and jumps to a given memory address:
- **Usage**: JSR [address]
## RTS / ReTurn Subroutine / 0x82
- Jumps to the last memory address saved into the stack and restores registers values from it:
- **Usage**: RTS
## NE* / NEgate * / 0x83 - 0x88
- Negates the value stored in a register. * indicates the register letter:
	 - NEX - 0x83
	 - NEY - 0x84
	 - NEZ - 0x85
	 - NEA - 0x86
	 - NEB - 0x87
	 - NED - 0x88
- **Usage**: NE*
## JOD / Jump ODd / 0x89
- Jumps to a given memory address if the odd flag is set:
- **Usage**: JOD [address]
## JDI / Jump oDd Immediate / 0x8a
- Jumps to a given memory address, taken from the low half of the instruction register, if the odd flag is set:
- **Usage**: JDI [address]
## INT / INTerrupt / 0x8b
- Generates an interrupt with a given value taken from the low half of the instruction register:
- **Usage**: INT [value]
## RTI / ReTurn Interrupt / 0x8c
- Returns from an interrupt call:
- **Usage**: RTI
## LG* / Load Gpu * / 0x8d - 0x8e
- Loads a GPU pointer register with a value from the given memory address. * indicates the register letter:
	 - LGX - 0x8d
	 - LGY - 0x8e
- **Usage**: LG* [address]
## FG* / Fast load Gpu * / 0x8f - 0x90
- Loads a GPU pointer register with a value. * indicates the register letter:
	 - FGX - 0x8f
	 - FGY - 0x90
- **Usage**: FG* [value]
## GPM / GPu Mode / 0x91
- Sets the GPU mode. Available modes are:
	- 0 - pixel mode:
		- Draws a pixel at the location pointed by the GPU pointers. Expects a [full color code](https://github.com/amari-calipso/custom-emulated-computer#full-color-code) as input.
	- 1 - text mode:
		- Draws a character at the location pointed by the GPU pointers. Expects a [background-foreground-character code](https://github.com/amari-calipso/custom-emulated-computer#text-color-code) as input.
	- 2 - rectangle mode:
		- Draws a rectangle at the location pointed by the GPU pointers. Expects a memory address that points to 3 words of data, respectively containing the rectangle width, height, and color (in [full color code](https://github.com/amari-calipso/custom-emulated-computer#full-color-code) format).
	- 3 - line mode:
		- Draws a line starting from the location pointed by the GPU pointers. Expects a memory address that points to 3 words of data, respectively containing the horizontal and vertical line destination coordinates, and a [full color code](https://github.com/amari-calipso/custom-emulated-computer#full-color-code).
	- 4 - black/white mode:
		- Draws 16 pixels according to the binary representation of the given value (1 is white, 0 is black)
- **Usage**: GPM [mode]
## FS* / Framebuffer Store * / 0x92 - 0x97
- Sends data to the GPU as explained in the GPM instruction section. The data is taken from any general purpose register. * indicates the register letter:
	 - FSX - 0x92
	 - FSY - 0x93
	 - FSZ - 0x94
	 - FSA - 0x95
	 - FSB - 0x96
	 - FSD - 0x97
- **Usage**: FS*
## GXX / Gpu X from X / 0x98
- Copies the contents of the X register to the X GPU pointer:
- **Usage**: GXX
## GYY / Gpu Y from Y / 0x99
- Copies the contents of the Y register to the Y GPU pointer:
- **Usage**: GYY
## IG* / Increment Gpu * / 0x9a - 0x9b
- Increments a GPU pointer register. * indicates the register letter:
	 - IGX - 0x9a
	 - IGY - 0x9b
- **Usage**: IG*
## DG* / Decrement Gpu * / 0x9c - 0x9d
- Decrements a GPU pointer register. * indicates the register letter:
	 - DGX - 0x9c
	 - DGY - 0x9d
- **Usage**: DG*
## A?* / at Address ? store * / 0x9e - 0xa7
- Stores the value of a register at an address contained in another register. ? indicates the register containing the address and * indicates the register to store:
	- AXY - 0x9e
	- AXZ - 0x9f
	- AXA - 0xa0
	- AXB - 0xa1
	- AXD - 0xa2
	- AYX - 0xa3
	- AYZ - 0xa4
	- AYA - 0xa5
	- AYB - 0xa6
	- AYD - 0xa7
- **Usage**: A?*
## SND / SouND / 0xa8
- Plays a sound. Expects a memory address pointing to a [sound code](https://github.com/amari-calipso/custom-emulated-computer#sound-code):
- **Usage**: SND [address]
## SN* / SouNd * / 0xa9 - 0xad
- Plays a sound. Expects a memory address pointing to a [sound code](https://github.com/amari-calipso/custom-emulated-computer#sound-code) stored in a general purpose register. * indicates the register letter:
	 - SNX - 0xa9
	 - SNY - 0xaa
	 - SNZ - 0xab
	 - SNA - 0xac
	 - SNB - 0xad
- **Usage**: SN*
## WT* / WaiT * / 0xae - 0xb2
- Waits a certain number of milliseconds stored in a general purpose register. * indicates the register letter:
	 - WTX - 0xae
	 - WTY - 0xaf
	 - WTZ - 0xb0
	 - WTA - 0xb1
	 - WTB - 0xb2
- **Usage**: WT*
- The CPU might also switch to a secondary process while [waiting](https://github.com/amari-calipso/custom-emulated-computer#compiler-instructions).
## FLS / Fast Load memory bank Selector / 0xb3
- Loads the memory bank selector register with a value taken from the low half of the instruction register:
- **Usage**: FLS [value]
## M*S / Move * to memory bank Selector / 0xb4 - 0xb8
- Copies the contents of a general purpose register into the memory bank selector. * indicates the register letter:
	 - MXS - 0xb4
	 - MYS - 0xb5
	 - MZS - 0xb6
	 - MAS - 0xb7
	 - MBS - 0xb8
- **Usage**: M*S
## GFXSTOP / Graphics STOP / 0xfd
- Stops the GPU from updating the screen every time it gets loaded:
- **Usage**: GFXSTOP
## GFXSTART / Graphics START / 0xfe
- Restores the normal updating behaviour of the GPU:
- **Usage**: GFXSTART
## HLT / HaLT / 0xff
- Stops the CPU and closes the emulator:
- **Usage**: HLT
# Compiler
## Expressions
- The compiler will accept as expressions:
	-	Integers (signed, unsigned, and in hex);
	-	Characters (indicated with apostrophes, example: 'a');
	-	Labels;
	-	Expressions that only require addition and subtraction between the items mentioned above.
- Expressions can be used with no instruction, and they will be stored in RAM at the address that line of code represents.
- If you leave a field that needs and expression as blank, it will be 0 by default.
## Labels
- Labels are used to identify memory addresses;
- They are created by placing a colon at the beginning of the line, then giving it a name (example: `:loop`);
- Label names can only contain letters and numbers.
## Comments
Code can be commented out using an hash at the beginning of a line.
## Compiler instructions
Some instructions are used to determine computer settings or special actions, and don't get written to RAM. They are easily recognizable because they all start with a dot. Compiler instructions, as opposed to assembly instructions, are case sensitive:
- `.addr`
	- Shifts the next code to start at the address specified.
	- **Usage**: .addr [address]
- `.fill`
	- Fills RAM with a certain number of empty words.
	- **Usage**: .fill [amount]
- `.stack`
	- Locates the stack in RAM and allocates it a certain number of empty words.
	- **Usage**: .stack [size]
- `.string`
	- Fills RAM with a string.
	- **Usage**: .string [string]
- `.interrupt`
	- Locates code assigned to an interrupt subroutine.
	- **Usage**: .interrupt [interrupt number]
- `.waiting`
	-  Locates a segment of code that is ran when the CPU is waiting.
	- This instruction will reserve 7 words of RAM to store a separate program counter for the waiting code section and register states (so that they can get restored when the CPU executes the waiting section again).
	- **Usage**: .waiting
- `.endwaiting`
	- Marks the last line of the waiting segment.
	- The CPU will stop calling the waiting section when waiting once this line has been reached. If you plan on making the waiting section loop, this statement should be omitted.
	- **Usage**: .endwaiting
# GPU
## Full color code
A full color code is a word composed like this:
```
[  modifier  ][   blue   ][   green   ][    red    ]
|-- 1 bit  --||- 5 bits -||- 5 bits  -||- 5 bits  -|
```
The modifier bit is used to switch palettes by offsetting the red, green, and blue values.
## Text color code
A text color code is a word composed like this:
```
[bg blue][bg green][ bg red ][ fg blue ][ fg green ][ fg red ][  char  ]
| 1 bit || 1 bit  || 1 bit  || 2 bits  ||  2 bits  || 2 bits || 7 bits |
```
NOTE:  The character set is not complete yet.
# Sound chip
## Sound code
A sound code is 2 to 4 words of data, composed like this:
```
[ amplitude ][ frequency ]
|- 3 bits  -||- 13 bits -|
[     1st mixer word     ]
|------- 16 bits --------|
[     2nd mixer word     ]
|------- 16 bits --------|
[   sound duration (ms)  ]
|------- 16 bits --------|
```
Mixer codes are used to create a custom waveform by combining multiple waveforms. When the amount of mixer codes is 0, the sound chip will use square waves for every sound. The first mixer code is composed like this:
```
Most significant bit
[    sawtooth width    ][  sawtooth amplitude   ]
|------- 4 bits -------||------- 4 bits --------|
[ square PWM sawtooth width ][ square amplitude ] Least significant bit
|--------- 4 bits ----------||----- 4 bits -----|
```
- The square amplitude controls the relative amplitude of the square wave;
- The square PWM sawtooth width controls the width of a sawtooth wave on which the square wave will be modulated (0 for no modulation);
- The sawtooth amplitude controls the relative amplitude of the sawtooth wave;
- The sawtooth width controls the "width of the rising ramp as a proportion of the total cycle" (https://docs.scipy.org/doc/scipy/reference/generated/scipy.signal.sawtooth.html) of the sawtooth wave.

The second mixer code is composed like this:

```
[ noise amplitude ][ square duty cycle ][ square amplitude ]
|----- 5 bits ----||------ 6 bits -----||----- 5 bits -----|
```
- The square amplitude controls the relative amplitude of a second square wave;
- The square duty cycle controls the duty cycle of the second square wave;
- The noise amplitude controls the relative amplitude of a white noise sample.
