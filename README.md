## About

A Raspberry Pi is onboard the plane, reading from sensors, and relaying data back to the ground station.

The quickest way to access the Pi once it's installed inside the plane is with SSH through the radios. No GUIs are available, and existing solutions doesn't seem to work with our Arduino projects.

Most of the programmers on the team is familiar with GNU Make, and so was chosen as the project's build tool.

Most of the build process was discovered via the Arduino IDE with sample projects.

## Usage

1. Create .cpp/.c files as expected of C/C++ projects
2. Include `Arduino.h` at the top of the main source file
3. Point `PORT` to the serial port in which the Arduino is connected to
4. Point the `MAIN_SKETCH` variable to the main source file
5. Add any object dependencies to `EXTRA_OBJS`

`make` to build the project, and `make upload` to upload to the connected Arduino
