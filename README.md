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

### a note on keyboards
Both SVC and DSD scripts have two redundant pieces of code that help with keyboard selection. **Either one or the other should be active, while the other one should be commented out.**

The first one looks like this, and is for manual keyboard selection. If this is activated, then with each run of the script the user will manually select the internal keyboard and response keyboard. 

```matlab
[internalKeyboardDevice, inputDevice] = getKeyboards;
drs.keys = initKeysFromId(inputDevice);
```

The second one looks like this, and relies on harcoded specifications about the devices in order to identify keyboards. 

```matlab
 drs.keys = initKeys;
 inputDevice = drs.keys.deviceNum;
 
 devices=PsychHID('Devices');
 for deviceCount=1:length(devices),
   % Just get the local keyboard
   if ((strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Mitsumi Electric')) ...
           || (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).product,'Apple Internal Keyboard / Trackpad'))),
     keys.bbox = deviceCount;
     keys.trigger = KbName('t'); % use 't' as KbTrigger
     internalKeyboardDevice=deviceCount;
   end
 end

```

===
DRS-TAG  
author: wem3, jflournoy  
edited: 16-01-07  
