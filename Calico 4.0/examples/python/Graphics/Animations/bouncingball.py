from Graphics import *
from Myro import pickOne, randomNumber, Random

Random.seed = 247534

win = Window("Bouncing Shapes", 300, 600)
win.mode = "physics"

p1 = Polygon((100, 100), (130, 100), (130, 150))
p1.fill=Color("gold")
p1.bounce = randomNumber() * .3
p1.draw(win)
p1.wrap = True

p2 = Polygon((100, 100), (130, 100), (130, 150))
p2.fill=Color("gold")
p2.bounce = randomNumber() * .3
p2.draw(win)
p2.wrap = True

j = p1.makeJointTo(p2, "df")
j.CollideConnected = True

for i in range(5):
    c = Rectangle((130 - i, 130 - i), (130 - i + 20, 130 - i + 20))
    c.fill = Color(pickOne(getColorNames()))
    c.bounce = .1
    c.draw(win)
    c.wrap = True

for i in range(5):
    c = Pie((130 - i, 150 - i), 10, 0, 360)
    c.fill = Color(pickOne(getColorNames()))
    c.draw(win)

ground = Rectangle((0, 580), (200, 610))
ground.bodyType = "static"
ground.color = Color("green")
ground.draw(win)

wall = Rectangle((0, 500), (10, 580))
wall.bodyType = "dynamic"
wall.draw(win)

wall2 = Rectangle((180, 500), (190, 580))
wall2.draw(win)

wall3 = Rectangle((0, 400), (10, 500))
wall3.draw(win)

def main():
    while win.isRealized():
        if getMouseState() == "down":
            x, y = getMouseNow()
            c = Oval((x, y), 10, 20)
            c.fill = Color("gray")
            c.draw(win)
            c.wrap = True
        win.step(.01)

# win.run() or
win.run(main)
