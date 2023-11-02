# robot-jousting
The necessary software to connect to ScribblerBots and "joust" them (one of Computer Science Club's funnest activities)

## Steps:
1. Download the Calico software in this folder, then unzip the thing
    - **WARNING**: This software only works on Windows machines! Not Macs!
    - **WARNING 2**: This folder is rather large, so this process may take a bit
2. Turn on the robot via the small black switch on top, and make sure you have the external circuit board plugged into the bot, otherwise this won’t work.
3. Turn on your computer’s bluetooth. Go to your bluetooth settings and click “Add a device.” 
    - These bots can be a little finiky to connect to, so give it a second to pop up. If nothing pops up, try closing the current settings window that is trying to find bluetooth devices, then reopen it.
4. Hopefully, something pops up with a name similar to “Fluke2-XXXX.” Connect to the bot
    - The XXXX represents the number on the sticker on the outward-facing side of the circuit board. Make sure you connect to the correct bot. (Hopefully the bot beeps, but I can’t actually remember if it does or not).
5. Check to see what port the robot is connected to by clicking on “More bluetooth options,” then clicking on the “COM Ports” tab. We want the COM port number, like “COM4”
    - We are looking for the outgoing port
6. Now, open the Calico program. It will be the “calico.bat” file. 
    - There are two folders called “calico,” so it will be the one that doesn’t have a blank piece of paper as its icon (or, you could just make file extensions visible you nimwit).
    - It will take a second to load the program (Don’t worry, you don’t need to type anything into the terminal window that pops up, _but you do need to keep it open_)
7. **If you just want to use the shell (what we normally do):**
    - Click the shell tab.
    - Type: “from Myro import *” (without quotes).
      - Make sure Myro is capitalized!
    - Type: “initialize(<port name>)” where <port name> is the COM port we found earlier. <port name> should be a string!
      - UPDATE: “initialize” is correct, as in “initialize("COM3")”
    - At this point, the bot should beep, indicating you have successfully connected. Now, you can type commands into the shell. Commands are found in the ScribblerBotCommands file in this folder. Some notable ones:
      - forward(<speed>, <time>)
        - Speed - value from -1 to 1
        - Time - commands executes for this number of seconds
      - forward(<speed>)
        - Goes until another command is given
      - stop()
      - turnRight(<speed>, <time>)
      - turnRight(<speed>)
      - turnLeft(<speed>, <time>)
      - turnLeft(<speed>)
      - backward(<speed>, <time>)
      - backward(<speed>)
      - rotate(<speed>)Many other commands exist: look at the other document!
  - **If you want to code in the text editor to the right:**
    - In the editor, type the following:
```
from Myro import *
initialize(“<port name>”) 
```
  - Hopefully this works. You can then type what actions you want the bot to do.
  - Note: the bot will have to reinitialize every time you run the code, which makes it slightly delayed. 
