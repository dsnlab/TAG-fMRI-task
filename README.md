# Transitions in Adolescent Girls (TAG) tasks

This repository includes the code for two tasks used in the TAG study:

* Self versus Change (SVC)
* Differential Self Disclosure (DSD)

SVC is a self-evaluation task based on prior work in our lab (Jankowski et al., 2014; Pfeifer et al., 2013; Pfeifer, Lieberman, & Dapretto, 2007). A generalized version of this task that is modifiable can be found here: https://gitlab.com/dsnlab/svc.

DSD is a self-disclosure task based on Tamir & Mitchell, 2012.

## setup
To run this task, proceed with the following steps:

1. Add the `task` and `UniversalHardware` folders to your matlab path (or the entire study folder)
2. You do NOT need to be in a specific directory to continue.
3. Run `getSubInfo()` on the matlab command line. It will automatically locate the study folder.
4. Run `runSVC()` or `runDSD()` on the matlab command line
 

All code is in [Psychtoolbox-3](http://psychtoolbox.org/), and should run on OSX, linux, or Windows. Matlab version 2017b or higher is required.

Keyboard information is stored in a .mat file and loaded by ButtonLoad.m in the UniversalHardware submodule. Calling ButtonLoad with no arguments will initiate a dialog to choose the appropriate file (hit cancel to create a new file). If the loaded information does not match the current hardware, ButtonLoad will ask you if you'd like to create a new file. Just follow the screen prompts. Always review the results after creating a new file.


### Differences between uh_dev and universal_hardware branches
* You do NOT need to be in a specific directory to run the experiment.
* You do not need to select the study directory, the script can find it.
* Better error handling for more graceful failures.
* Windows & linux support.
