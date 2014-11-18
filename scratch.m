%% DSD experiment'
cac

cd ~/Desktop/DRS
addpath '/Users/wem3/Desktop/DRS/code'
addpath '/Users/wem3/Desktop/DRS/design'
addpath '/Users/wem3/Desktop/DRS/task/input'
addpath '/Users/wem3/Desktop/DRS/task/materials'
addpath '/Users/wem3/Desktop/DRS/task/output'
subNum=1;
runNum=0;
%runDSD
%%
drs.keys = initKeys;
inputDevice = drs.keys.deviceNum;
