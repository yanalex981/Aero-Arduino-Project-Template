## About

This project serves as a template for Arduino projects that cannot rely on a GUI environment (Arduino IDE) in order to compile.

The quickest way to access the Pi once it's installed inside the plane is with SSH through the radios. No GUIs are available, and existing solutions doesn't seem to work with Aero's Arduino projects.

Most of the programmers on the team is familiar with GNU Make, and so was chosen as the build tool.

Most of the build process was discovered via the Arduino IDE with sample projects. The reset process for Arduino Micros were discovered by online  documentation and forum posts.

## Usage

### Variables

`PORT`: serial port in which the target Arduino is connected to
`MAIN_SKETCH`: file name of the main source file
`EXTRA_OBJS`: extra project object dependencies
`ARD_BOARD`: target Arduino board type (standard, micro, etc)

Make sure `Arduino.h` is included at the top of the main source file.

`make` to builds the project, and `make upload` uploads the compiled project to the connected Arduino.
