# AVR Make: Build and Flash for AVR on Arduino Nano

This repository provides a `Makefile` to assemble, link, and flash AVR assembly files (specifically for `atmega328p` on the Arduino Nano) using tools such as `avr-as`, `avr-ld`, `avr-objcopy`, and `avrdude`. This `Makefile` simplifies the compilation and flashing process for AVR assembly projects.


## Using the Bash Script

If you prefer to use `bash` for building and flashing AVR assembly files, I've provided a bash script that automates the process. It supports compiling `.s` files, generating `.hex` files, and flashing them to the Arduino Nano.

To learn how to use the `bash`, check out the [detailed guide](./README.md).

## Prerequisites

Before using the `Makefile`, ensure you have the following tools installed and configured on your system:

1. **AVR-GCC tools**: Includes `avr-as`, `avr-ld`, `avr-objcopy` for assembling and linking your code.
2. **AVRDUDE**: A utility for flashing microcontroller chips via a programmer.

To install these tools on Debian-based distributions, you can run:
```bash
sudo apt-get install gcc build-essential
sudo apt-get install gcc-avr avr-libc
sudo apt-get install avrdude
```

This will also install `gcc` and other essential build tools on your system.

## Makefile Overview

The `Makefile` automates the following tasks:
- Compiling `.s` (assembly) files to AVR object files using `avr-as`.
- Linking object files into ELF format using `avr-ld`.
- Converting ELF to Intel HEX format using `avr-objcopy`.
- Flashing the generated HEX file to an AVR microcontroller (e.g., Arduino Nano).
- Cleaning the build directory to remove intermediate and compiled files.

### Makefile Variables

- **BUILD_DIR**: The directory where build artifacts (object files, ELF files, HEX files) will be stored (default: `build`).
- **MCU**: The target microcontroller (default: `atmega328p`).
- **DEVICE_PORT**: The serial port where the Arduino is connected (default: `/dev/ttyUSB0`).
- **FILENAME**: The assembly file to compile and flash.

### Targets
- **compile**: Assembles, links, and converts the assembly source file (`.s`) into a `.hex` file for flashing.
- **flash**: Compiles the project and flashes the resulting `.hex` file to the AVR microcontroller.
- **clean**: Removes all build artifacts from the `build/` directory.

## How to Use

### 1. **Compile Only**

To compile an AVR assembly file into a `.hex` file, run:

```bash
make FILENAME=<filename.s> compile
```

- Replace `<filename.s>` with the AVR assembly file you wish to compile. Ensure that the file is located in the same directory as the `Makefile` or provide the relative path.

Example:
```bash
make FILENAME=blink.s compile
```

This will generate the following files in the `build/` directory:
- Object file: `build/blink.o`
- ELF file: `build/blink.elf`
- HEX file: `build/blink.hex`

### 2. **Compile and Flash to Microcontroller**

To compile and flash the generated `.hex` file to an Arduino Nano (or other AVR microcontroller), run:

```bash
make FILENAME=<filename.s> flash
```

Example:
```bash
make FILENAME=blink.s flash
```

This command will:
- Compile the assembly file as explained above.
- Flash the resulting `.hex` file to the microcontroller using `avrdude`.

> **Note**: The `Makefile` assumes your Arduino is connected to `/dev/ttyUSB0`. If your Arduino is connected to a different port, update the `DEVICE_PORT` variable in the `Makefile` or override it when running the command:
```bash
make FILENAME=blink.s DEVICE_PORT=/dev/ttyUSB1 flash
```

### 3. **Clean Build Directory**

To remove all build artifacts generated during the compilation process, run:

```bash
make clean
```

This will delete the `build/` directory and all the files within it.

### Example Workflow

1. **Compile the assembly file**:
    ```bash
    make FILENAME=blink.s compile
    ```
2. **Flash the compiled file to the microcontroller**:
    ```bash
    make FILENAME=blink.s flash
    ```
3. **Clean the build directory**:
    ```bash
    make clean
    ```

## Customization

### 1. **Change the Target Microcontroller**

By default, the `Makefile` is set up for the `atmega328p` microcontroller (used in Arduino Nano). If you're using a different AVR chip, update the `MCU` variable in the `Makefile`:
```make
MCU = atmega2560
```

### 2. **Change the Serial Port for Flashing**

If your Arduino or AVR device is connected to a different serial port (e.g., `/dev/ttyUSB1`), update the `DEVICE_PORT` variable:
```make
DEVICE_PORT = /dev/ttyUSB1
```

Alternatively, you can override the port when invoking `make`:
```bash
make FILENAME=blink.s DEVICE_PORT=/dev/ttyUSB1 flash
```

## Troubleshooting

### 1. **Device Not Found**

If `avrdude` cannot find your device, ensure the correct serial port is specified in the `DEVICE_PORT` variable. You can check the available serial devices with:
```bash
ls /dev/ttyUSB*
```

### 2. **Permission Denied on Serial Port**

If you encounter permission issues when accessing `/dev/ttyUSB0`, you may need to add your user to the `dialout` group:
```bash
sudo usermod -a -G dialout $USER
```
Log out and log back in for the changes to take effect.

### 3. **Error Handling**

The `Makefile` checks for errors during each stage (assembly, linking, HEX conversion, and flashing). If an error occurs, the build will stop, and you can inspect the terminal output for details about what went wrong.

## License

This `Makefile` is open for modification and distribution under the MIT License. Feel free to customize it to suit your project needs.

---

Let me know if you need further assistance!
