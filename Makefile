# Variables
BUILD_DIR = build
MCU = atmega328p

# Extract the filename without extension
BASENAME = $(basename $(FILENAME))

# Targets
all: flash

# Compile assembly to object file
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(BUILD_DIR)
	avr-as -g -mmcu=$(MCU) -o $@ $<

# Link object file to ELF
$(BUILD_DIR)/%.elf: $(BUILD_DIR)/%.o
	avr-ld -o $@ $<

# Convert ELF to HEX
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	avr-objcopy -O ihex -R .eeprom $< $@

# Compile only (assemble, link, and convert to hex)
compile: $(BUILD_DIR)/$(BASENAME).hex
	@echo "Compilation complete: $(BUILD_DIR)/$(BASENAME).hex"

# Flash the compiled hex file to the Arduino Nano
flash: compile
	avrdude -C /etc/avrdude.conf -p $(MCU) -c arduino -P /dev/ttyUSB0 -D -U flash:w:$(BUILD_DIR)/$(BASENAME).hex:i

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean flash compile
