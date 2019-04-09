# Transitions in Adolescent Girls (TAG) tasks

This repository includes the code for two tasks used in the TAG study:

* Self versus Change (SVC)
* Differential Self Disclosure (DSD)

SVC is a self-evaluation task based on prior work in our lab (Jankowski et al., 2014; Pfeifer et al., 2013; Pfeifer, Lieberman, & Dapretto, 2007). A generalized version of this task that is modifiable can be found here: https://gitlab.com/dsnlab/svc.

DSD is a self-disclosure task based on Tamir & Mitchell, 2012.

## setup
To run this task, proceed with the following steps:

1. Add `task/code` to your matlab path
2. You **must** run the following from `svc/task`
3. Run `getSubInfo()` on the matlab command line
	- it will ask you to select the study folder -- this will be the `svc/` folder in which you find `task/` and this file, `README.md`. 
4. Run `runSVC()` or `runDSD()` on the matlab command line

## `~/task`

Contains code and input text to run experiments, design info/materials, task output  

All code is in [Psychtoolbox-3](http://psychtoolbox.org/), often run on OS X using MATLAB_R2014b

Make sure to add the folders in `~/task` to the MATLAB search path. To do so, type:  

```matlab
addpath(genpath('~/task'));
```

## a note on keyboards
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