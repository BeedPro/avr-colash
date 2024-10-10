# AVR-colash: Build and Flash Script for AVR on Arduino Nano

This repository provides a simple Bash script to assemble, and flash AVR assembly files (specifically for `atmega328p` on the Arduino Nano) using tools such as `avr-as`, `avr-ld`, `avr-objcopy`, and `avrdude`. This repository also provides a if you wish to use `make` instead.

## Using the Makefile

If you prefer to use `make` for building and flashing AVR assembly files, I've provided a `Makefile` that automates the process. It supports compiling `.s` files, generating `.hex` files, and flashing them to the Arduino Nano.

To learn how to use the `Makefile`, check out the [detailed guide](./README_Makefile.md).

## Prerequisites

Before using this script, ensure you have the following installed and configured on your system:

1. **AVR-GCC tools**: Includes `avr-as`, `avr-ld`, `avr-objcopy` for assembling and linking your code.
2. **AVRDUDE**: A utility for flashing microcontroller chips via a programmer.

To install these tools on Debian-based distributions, you can run:
```bash
sudo apt-get install gcc build-essential
sudo apt-get install gcc-avr avr-libc
sudo apt-get install avrdude
```
This will also install `gcc` on your system.


## Installation
To install this script you must first clone this repository. To do this run:
```bash
git clone git@github.com:BeedPro/avr-colash.git
```
You can now just copy the script or/and Makefile to your project directories. Note that if you do copy it instead of installing this script locally, then you must do `./avr-colash` to run the script.

To install it locally:
```bash
cd avr-colash
./install.sh
```
### Removing the script locally
If you wish to remove the script then remove `avr-colash` in `~/.local/bin` or run:
```
./uninstall.sh
```
which is found in this repository.


## Script Overview

This script automates the following tasks:
- Compiling `.s` (assembly) files to AVR object files using `avr-as`.
- Linking object files into ELF format using `avr-ld`.
- Converting ELF to Intel HEX format using `avr-objcopy`.
- Optionally flashing the generated HEX file to an AVR microcontroller (e.g., Arduino Nano).
- Cleaning the build directory to remove intermediate and compiled files.

### Script Logic

The script has three main actions:
1. `compile`: Assemble the `.s` file into an object file, link it into an ELF file, convert to HEX, and clean up intermediate files.
2. `flash`: Compile as above and flash the resulting HEX file to the microcontroller.
3. `clean`: Remove all build artifacts.

## How to Use

### 1. **Compile Only**

To compile an AVR assembly file into a `.hex` file:

```bash
avr-colash compile <filename.s>
```

- `<filename.s>`: The AVR assembly file you want to compile. Make sure the file is in the same directory as the script or provide a relative path.

Example:

```bash
avr-colash compile blink.s
```

This will create the following files in the `build/` directory:
- Object file: `build/blink.o`
- ELF file: `build/blink.elf`
- HEX file: `build/blink.hex`

### 2. **Compile and Flash to Microcontroller**

To compile and flash the generated `.hex` file to an Arduino Nano (or another AVR microcontroller):

```bash
avr-colash flash <filename.s>
```

Example:

```bash
avr-colash flash blink.s
```

This will:
- Compile the assembly file as explained above.
- Flash the resulting `.hex` file to the AVR microcontroller using `avrdude`.

> **Note:** The script assumes your Arduino is connected to `/dev/ttyUSB0`. If you are using a different port, modify the `DEVICE_PORT` at the start of the script:
```bash
avrdude -C /etc/avrdude.conf -p $MCU -c arduino -P /dev/ttyUSB0 -D -U flash:w:"$BUILD_DIR/$BASENAME.hex":i
```
Replace `/dev/ttyUSB0` with the correct serial port. You can find this using `ls /dev/USB*`

### 3. **Clean Build Directory**

To remove all files generated during the compilation process:

```bash
avr-colash clean
```

This will delete the `build/` directory and all its contents.

## Customisation

### 1. **Change the Target Microcontroller**

By default, the script is set up for the `atmega328p` microcontroller (used in Arduino Nano). If you're working with a different microcontroller, update the `MCU` variable at the top of the script:
```bash
MCU="atmega328p"
```
Change `atmega328p` to your target MCU model.

### 2. **Change the Serial Port for Flashing**

If your Arduino or AVR device is connected to a different serial port (e.g., `/dev/ttyUSB1`), update the `DEVICE_PORT` variable at the top of the script.

### 3. **Error Handling**

The script checks for errors during each stage (assembly, linking, HEX conversion, and flashing) and exits if an error is detected. If you encounter specific errors, check the output of the corresponding command (e.g., `avr-as`, `avr-ld`, `avr-objcopy`, or `avrdude`) for more details.

## License

This script is open for modification and distribution under the MIT License. Feel free to customise it to suit your project needs.

## Troubleshooting

- **Device Not Found**: If `avrdude` cannot find your device, make sure the correct port is specified and the device is properly connected.

Let me know if you need further assistance!

(P.S you can create an issue and I will help you with your problem)
