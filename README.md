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

All code is in [Psychtoolbox-3](http://psychtoolbox.org/), and should run on OSX, linux, or Windows. Matlab version 2017b or higher is required.

Make sure to add the folders in `~/task` to the MATLAB search path. To do so, type:  

```matlab
addpath(genpath('~/task'));
```

## a note on keyboards
Keyboard information is stored in a .mat file and loaded by ButtonLoad.m in the UniversalHardware submodule. Calling ButtonLoad with no arguments will initiate a dialog to choose the appropriate file. If the loaded information does not match the current hardware, ButtonLoad will ask you to create a new file. Just follow the screen prompts.
