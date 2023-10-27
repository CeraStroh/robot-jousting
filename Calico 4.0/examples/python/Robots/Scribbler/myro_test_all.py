import Myro
Myro.init()

pic = Myro.takePicture()
Myro.show(pic)

Myro.robot.backward(1, 1)
Myro.robot.forward(1, 1)
Myro.robot.beep(1, 440)
Myro.robot.beep(1, 440, 880)
Myro.robot.forward(.5, 2)
Myro.robot.backward(.5, 2)
print(Myro.robot.get("all"))
print(Myro.robot.getAll())
print(Myro.robot.getBattery())
print(Myro.robot.getBlob())
# print(Myro.robot.getBright())
print(Myro.robot.getConfig())
print(Myro.robot.getData())
print(Myro.robot.getIR())
print(Myro.robot.getIRMessage())
print(Myro.robot.getInfo())
print(Myro.robot.getLight())
print(Myro.robot.getLine())
print(Myro.robot.getName())
# print(Myro.robot.getObstacle())
print(Myro.robot.getPassword())
print(Myro.robot.getStall())
Myro.robot.motors(.5, .5)
Myro.robot.move(1, 1)
Myro.robot.move(-1, -1)
Myro.robot.reboot()
Myro.robot.rotate(.5, 1)
Myro.robot.rotate(-.5, 1)
#Myro.robot.sendIRMessage
#Myro.robot.setCommunicate
#Myro.robot.setData(0, 0)
print(Myro.robot.getData())
#Myro.robot.setData(0, 128)
#Myro.robot.setEchoMode
#Myro.robot.setForwardness
#Myro.robot.setIRPower
Myro.robot.setLED("front", 1)
Myro.robot.setLEDBack(1)
Myro.robot.setLEDBack(0)
Myro.robot.setLEDFront(1)
Myro.robot.setLEDFront(0)
Myro.robot.setName("Hello")
print(Myro.robot.getName())
Myro.robot.setName("Scribby")
print(Myro.robot.getName())
Myro.robot.setPassword("password")
#Myro.robot.setWhiteBalance
Myro.robot.setup()
Myro.robot.stop()
p = Myro.robot.takePicture()
Myro.robot.translate(.5, 1)
Myro.robot.translate(-.5, 1)
Myro.robot.turnLeft(1, .25)
Myro.robot.turnLeft(0.5, .25)
Myro.robot.turnRight(0.5, .25)
Myro.robot.turnRight(1, .25)

Myro.backward(1, 1)
Myro.forward(1, 1)
Myro.beep(1, 440)
Myro.beep(1, 440, 880)
Myro.forward(.5, 2)
Myro.backward(.5, 2)
print(Myro.get("all"))
print(Myro.getAll())
print(Myro.getBattery())
print(Myro.getBlob())
# print(Myro.getBright())
print(Myro.getConfig())
print(Myro.getData())
print(Myro.getIR())
print(Myro.getIRMessage())
print(Myro.getInfo())
print(Myro.getLight())
print(Myro.getLine())
print(Myro.getName())
# print(Myro.getObstacle()
print(Myro.getPassword())
print(Myro.getStall())
Myro.motors(.5, .5)
Myro.move(1, 1)
Myro.move(-1, -1)
Myro.reboot()
Myro.rotate(.5, 1)
Myro.rotate(-.5, 1)
#Myro.sendIRMessage
#Myro.setCommunicate
#Myro.setData(0, 0)
print(Myro.getData())
#Myro.setData(0, 128)
#Myro.setEchoMode
#Myro.setForwardness
#Myro.setIRPower
Myro.setLED("front", 1)
Myro.setLEDBack(1)
Myro.setLEDBack(0)
Myro.setLEDFront(1)
Myro.setLEDFront(0)
Myro.setName("Hello")
print(Myro.getName())
Myro.setName("Scribby")
print(Myro.getName())
Myro.setPassword("password")
#Myro.setWhiteBalance
Myro.setup()
Myro.stop()
p = Myro.takePicture()
Myro.translate(.5, 1)
Myro.translate(-.5, 1)
Myro.turnLeft(1, .25)
Myro.turnLeft(0.5, .25)
Myro.turnRight(0.5, .25)
Myro.turnRight(1, .25)

from Myro import *

backward(1, 1)
forward(1, 1)
beep(1, 440)
beep(1, 440, 880)
forward(.5, 2)
backward(.5, 2)
print(get("all"))
print(getAll())
print(getBattery())
print(getBlob())
# print(getBright())
print(getConfig())
print(getData())
print(getIR())
print(getIRMessage())
print(getInfo())
print(getLight())
print(getLine())
print(getName())
# print(getObstacle()
print(getPassword())
print(getStall())
motors(.5, .5)
move(1, 1)
move(-1, -1)
reboot()
rotate(.5, 1)
rotate(-.5, 1)
#sendIRMessage
#setCommunicate
#setData(0, 0)
print(getData())
#setData(0, 128)
#setEchoMode
#setForwardness
#setIRPower
setLED("front", 1)
setLEDBack(1)
setLEDBack(0)
setLEDFront(1)
setLEDFront(0)
setName("Hello")
print(getName())
setName("Scribby")
print(getName())
setPassword("password")
#setWhiteBalance
setup()
stop()
p = takePicture()
translate(.5, 1)
translate(-.5, 1)
turnLeft(1, .25)
turnLeft(0.5, .25)
turnRight(0.5, .25)
turnRight(1, .25)
