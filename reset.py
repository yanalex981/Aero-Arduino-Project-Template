import serial

s = serial.Serial('/dev/ttyACM0', 1200)

if s.isOpen():
	s.close()

s.open()
s.setRTS(True)
s.setDTR(False)
s.close()
