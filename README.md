#DRS  

This is the version to be used in TAG

##`{ Disclosure, Self }`

code for DRS suite of experiments  

###~/task
contains code && input text to run experiments, design info/materials, task output  

All code is in PTB-3, optimized for MATLAB_R2014b on Apple's OS X (10.9.2)  

Make sure to add the folders in `~/task` to the MATLAB search path. To wit, you can do:  

```matlab
addpath(genpath('~/task'));
```

### a frighteningly long note on keyboards: a word from Jolinda 

#### how to use new button setup scripts

Make sure ButtonLoad.m, ButtonSetup.m, and ResponseCheck.m are in a folder in your path. The files GetKeyboards.m, InitKeys.m, and InitKeysFromId.m are no longer needed and can be removed.

Run ButtonSetup on the computer you will use, hooked up to the equipment you will use, in order to create a key definition .mat file. I do not know if you can just copy this file from one laptop to another similar laptop. The script will ask you to press the response buttons: pressing the buttons in the control room rather than the actual buttons in the MRI bay is fine. Press any one of those buttons to define the trigger device. The default trigger should be correct for the skyra/prisma, but you can also send an actual trigger pulse to capture the correct trigger key code.

In your stimulus script, run ButtonLoad(keyfilename) to load the key structure and find the keyboard indices.

#### MORE DETAILED INFO AND HISTORY

##### In the beginning, there was initKeys.m

One way of handling button responses, triggers, etc in PsychToolbox is through using keyboard queues. These queues refer to each device by a device index. Problem number one: this index changes, even between sequential runs of the same script without rebooting matlab and without changing any hardware! So any script that uses keyboard queues must first attempt to determine what the device index is for each piece of hardware. This was originally done in the script initKeys by searching the product name in the 'devices' structure for 'Xkeys', 'Mitsumi Electric', 'Apple', etc. Obviously this is a big problem -- not only would if fail if we bought new button boxes, but it failed when we replaced the switch, and would even fail if we swapped out the keyboard. 

##### getKeyboards

This was my first attempt at something that could withstand hardware changes: it would use the PsychToolbox function "GetKeyboardIndices" to make a list of keyboards, and ask the user to select the correct "internal keyboard" and "response device". This failed when we bought the new button boxes for the simulator (now there are TWO identical response devices), and for the switch in the prisma control room (which shows up as two identical keyboards). What's more, the values of the buttons in the simulator (a9876 12345) are different from those in the scanner (01234 56789).

##### The solution

I wrote a script (ButtonSetup.m) that asks the user to hit keys on the keyboard, the trigger source, and each button box, and saves the information in a .mat file. Another script (ButtonLoad.m) loads the .mat file and finds the current device index for each 'keyboard'. This can be used in KbQueueCreate, KbResponseCheck, etc. Finally I wrote a helper function (ResponseCheck.m) that calls KbResponseCheck for multiple queues and returns all keys pressed since the last call to it (needed in the mock, where we have to check responses from two different keyboards).

The TAG scripts
I fixed runDSD and runSVC. I didn't touch runRPE yet but I can. Beyond the changes outlined above, I did a few other things:

1. The original scripts defined a list of right/left keys using the "key.bx" values, but the list of keys to listen for came from "keys.buttons". If you are lucky, this is merely redundant; if you are unlucky, someone changes one variable but not the other and you have big problems. So I eliminated the "keys.button" variable.

2. I added a check for the input/output folders and a dialog to select them if they weren't found; this made it much easier for me to test things.

3. The stimuli were written for a specific screen resolution, so I added setting/resetting the screen resolution to the scripts. If you've tried that before and it caused problems please change it back!

The scripts seem to work fine on the Prisma setup and in the mock (I haven't tried them at the Skyra yet but they should be fine), plus they run equally well under OSX or Windows (I haven't tried linux but they should work there too).
