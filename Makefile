# various programs
CC = "/usr/bin/avr-gcc"
CPP = "/usr/bin/avr-g++"
AR = "/usr/bin/avr-ar"
OBJ_COPY = "/usr/bin/avr-objcopy"

# compile flags for g++ and gcc
# board dependent
F_CPU := 16000000
# microcontroller model, uno is atmega328p, micro is atmega328p32u4
MCU := atmega32u4
# MCU := atmega328p
# used in one of the includes, standard is uno
# BOARD := standard
BOARD := micro

# change to program args
PORT=/dev/ttyACM0
# make sure to have an #include <Arduino.h> at the top
MAIN_SKETCH = relay.cpp

# useful dirs
EXTRAS := libs
ARD_DIR := /usr/share/arduino
ARD_CORE := $(ARD_DIR)/hardware/arduino/cores/arduino
AVR_LIBC := $(ARD_CORE)/avr-libc
ARD_BOARD := $(ARD_DIR)/hardware/arduino/variants/$(BOARD)
ARD_LIB := $(ARD_DIR)/libraries

# Arduino library
EEPROM := $(ARD_LIB)/EEPROM
Firmata := $(ARD_LIB)/Firmata
Robot_Control := $(ARD_LIB)/Robot_Control
Servo := $(ARD_LIB)/Servo
Stepper := $(ARD_LIB)/Stepper
Wire := $(ARD_LIB)/Wire
Esplora := $(ARD_LIB)/Esplora
GSM := $(ARD_LIB)/GSM
Robot_Motor := $(ARD_LIB)/Robot_Motor
SoftwareSerial := $(ARD_LIB)/SoftwareSerial
TFT := $(ARD_LIB)/TFT
Ethernet := $(ARD_LIB)/Ethernet
LiquidCrystal := $(ARD_LIB)/LiquidCrystal
SD := $(ARD_LIB)/SD
SPI := $(ARD_LIB)/SPI
WiFi := $(ARD_LIB)/WiFi

# dependencies
ADAFRUIT := $(EXTRAS)/Adafruit
QUADRINO := $(EXTRAS)/QuadrinoGPS

# compile flags, architecture of uctler, define cpu freq, no idea, define 2 arduino IDs, arduino version
# ARD_FLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -MMD -DUSB_VID=0x2341 -DUSB_PID=0x0037 -DARDUINO=105
ARD_FLAGS := -mmcu=$(MCU) -DF_CPU=$(F_CPU)L -MMD -DUSB_VID=0x2341 -DUSB_PID=0x0043 -DARDUINO=105
GEN_FLAGS := -c -g -Os -ffunction-sections -fdata-sections
CPP_FLAGS := $(ARD_FLAGS) $(GEN_FLAGS) -fno-exceptions -std=c++11
CC_FLAGS  := $(ARD_FLAGS) $(GEN_FLAGS)

# Any additional objs can be added here
ARD_CORE_CPP := CDC.cpp.o HardwareSerial.cpp.o HID.cpp.o IPAddress.cpp.o main.cpp.o new.cpp.o Print.cpp.o Stream.cpp.o Tone.cpp.o USBCore.cpp.o WMath.cpp.o WString.cpp.o
ARD_CORE_C := WInterrupts.c.o wiring.c.o wiring_pulse.c.o wiring_analog.c.o wiring_digital.c.o wiring_shift.c.o
EXTRA_OBJS := Adafruit_9DOF.cpp.o Adafruit_BMP085.cpp.o Adafruit_IMU.cpp.o Adafruit_LSM303_U.cpp.o Quadrino_GPS.cpp.o

# additional objs can be added like so:
#     EXTRA_OBJS += additional.cpp.o
# make sure to add a recipe declaration as well like:
#     additional.cpp.o: additional.cpp additional.h
# that's all

# location of include files
INC_FILES := $(addprefix -I,$(ARD_CORE) $(ARD_BOARD) $(ADAFRUIT) $(Wire))
INC_FILES += $(addprefix -I,$(addsuffix /utility,$(Ethernet) $(Robot_Control) $(SD) $(TFT) $(WiFi) $(Wire)))

##### begin DO NOT MODIFY UNLESS YOU KNOW WHAT THE FLAGS DO #####
firmware.hex: firmware.elf
	$(OBJ_COPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 firmware.elf firmware.eep
	$(OBJ_COPY) -O ihex -R .eeprom firmware.elf firmware.hex

firmware.elf: $(ARD_CORE_CPP) $(ARD_CORE_C) $(MAIN_SKETCH).o $(EXTRA_OBJS) Wire.cpp.o twi.c.o
	$(CC) -Os -Wl,--gc-sections -mmcu=$(MCU) -o firmware.elf $^ -lm
#####  end DO NOT MODIFY UNLESS YOU KNOW WHAT THE FLAGS DO  #####

upload:
	python reset.py
	sleep 0.5
	avrdude -patmega32u4 -Uflash:w:$(MAIN_SKETCH).hex:i -cavr109 -b57600 -D -P$(PORT) -C/etc/avrdude.conf -V

upload-uno:
	avrdude -patmega328p -Uflash:w:firmware.hex:i -carduino -b115200 -D -P$(PORT) -C/etc/avrdude.conf -V

# Arduino core C++
CDC.cpp.o: $(ARD_CORE)/CDC.cpp
HardwareSerial.cpp.o: $(ARD_CORE)/HardwareSerial.cpp
HID.cpp.o: $(ARD_CORE)/HID.cpp
IPAddress.cpp.o: $(ARD_CORE)/IPAddress.cpp
main.cpp.o: $(ARD_CORE)/main.cpp
new.cpp.o: $(ARD_CORE)/new.cpp
Print.cpp.o: $(ARD_CORE)/Print.cpp
Stream.cpp.o: $(ARD_CORE)/Stream.cpp
Tone.cpp.o: $(ARD_CORE)/Tone.cpp
USBCore.cpp.o: $(ARD_CORE)/USBCore.cpp
WMath.cpp.o: $(ARD_CORE)/WMath.cpp
WString.cpp.o: $(ARD_CORE)/WString.cpp

# Arduino core C
WInterrupts.c.o: $(ARD_CORE)/WInterrupts.c
wiring.c.o: $(ARD_CORE)/wiring.c
wiring_pulse.c.o: $(ARD_CORE)/wiring_pulse.c
wiring_analog.c.o: $(ARD_CORE)/wiring_analog.c
wiring_digital.c.o: $(ARD_CORE)/wiring_digital.c
wiring_shift.c.o: $(ARD_CORE)/wiring_shift.c

# extras
Adafruit_9DOF.cpp.o: $(EXTRAS)/Adafruit/Adafruit_9DOF.cpp
Adafruit_BMP085.cpp.o: $(ADAFRUIT)/Adafruit_BMP085.cpp
Adafruit_IMU.cpp.o: $(ADAFRUIT)/Adafruit_IMU.cpp
Adafruit_LSM303_U.cpp.o: $(ADAFRUIT)/Adafruit_LSM303_U.cpp
Quadrino_GPS.cpp.o: $(QUADRINO)/Quadrino_GPS.cpp

Wire.cpp.o: $(Wire)/Wire.cpp
twi.c.o: $(Wire)/utility/twi.c

$(MAIN_SKETCH).o: $(MAIN_SKETCH)

.phony: clean
clean:
	rm *.o *.d *.hex *.elf *.eep

%.c.o: $(Wire)/utility/%.c
	$(CC) $(CC_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: $(Wire)/%.cpp
	$(CPP) $(CPP_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: $(AVR_LIBC)/%.cpp
	$(CPP) $(CPP_FLAGS) $(INC_FILES) $^ -o $@

%.c.o: $(AVR_LIBC)/%.c
	$(CC) $(CC_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: $(ADAFRUIT)/%.cpp
	$(CPP) $(CPP_FLAGS) $(INC_FILES) $^ -o $@

%.c.o: $(ADAFRUIT)/%.c
	$(CC) $(CC_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: $(QUADRINO)/%.cpp
	$(CPP) $(CPP_FLAGS) $(INC_FILES) $^ -o $@

%.c.o: $(QUADRINO)/%.c
	$(CC) $(CC_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: $(ARD_CORE)/%.cpp
	$(CPP) $(CPP_FLAGS) $(INC_FILES) $^ -o $@

%.c.o: $(ARD_CORE)/%.c
	$(CC) $(CC_FLAGS) $(INC_FILES) $^ -o $@

%.cpp.o: %.cpp
	$(CPP) $(CPP_FLAGS) -Wall -Wextra $(INC_FILES) $^ -o $@

%.c.o: %.c
	$(CC) $(CC_FLAGS) -Wall -Wextra $(INC_FILES) $^ -o $@
