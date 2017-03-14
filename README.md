## About

This project serves as a template for Arduino projects that cannot rely on a GUI environment (Arduino IDE) in order to compile.

The quickest way to access the Pi once it's installed inside the plane is with SSH through the radios. No GUIs are available, and existing solutions doesn't seem to work with Aero's Arduino projects.

Most of the programmers on the team is familiar with GNU Make, and so was chosen as the build tool.

Most of the build process was discovered via the Arduino IDE with sample projects. The reset process for Arduino Micros were discovered by online  documentation and forum posts.

## Usage

1. Create .cpp/.c files as expected of C/C++ projects
2. Include `Arduino.h` at the top of the main source file
3. Point `PORT` to the serial port in which the Arduino is connected to
4. Point the `MAIN_SKETCH` variable to the main source file
5. Add any object dependencies to `EXTRA_OBJS`

If needed, change `ARD_BOARD` to match the target Arduino board. `make` to builds the project, and `make upload` uploads the compiled binary to the connected Arduino
