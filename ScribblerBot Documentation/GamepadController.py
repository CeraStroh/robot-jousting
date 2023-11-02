from Myro import *

def battleCry(robot):
    robot.beep(0.5, 1000)
    robot.beep(0.5, 900)
    robot.beep(0.5, 800)
    robot.beep(0.6, 1000)
    robot.beep(1, 500)
    
def warningStance(robot):
    for seconds in timer(5):
        robot.turnLeft(1, .5)
        robot.turnRight(1, .5)
        
def handleButton(robot, buttonState):
    if buttonState[0]:
        battleCry(robot)
    if buttonState[1]:
        warningStance(robot)

def handleAxis(robot, robotState):
    robot.move(*robotState)

def game(controller, com):
    r1 = makeRobot("Scribbler", com)
    #r2 = makeRobot("Scribbler", "COM7")
    
    while True:
        handleButton(r1, getGamepadNow(controller, "button"))
        handleAxis(r1, getGamepadNow(controller, "robot"))
        #handleButton(r2, getGamepadNow(1, "button"))
        #handleAxis(r2, getGamepadNow(1, "robot"))