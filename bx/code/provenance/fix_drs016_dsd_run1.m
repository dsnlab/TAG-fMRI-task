% fix_drs016_dsd_run1.m
%
% participant squeezed emergency ball because her earbud fell out
%
% scan halted - proceeded w/ dsd_run2, hacked dsd_run1_input.txt
% to recapture last 20 trials or so (two trials repeated)
%
% fortunately, a long null event preceeds the next meaningful trial
% load first part of dsd_run1 output
load('/Users/wem3/Desktop/DRS/task/hold/drs016_dsd_run1a.mat');
A = task;
clear task;
% load second part of dsd_run1 output
load('/Users/wem3/Desktop/DRS/task/hold/drs016_dsd_run1b.mat');
B = task;
clear task;
rawCombo = A.output.raw;
rawCombo([26:end],:) = B.output.raw(:,:);
% correct timing (this is a patch to facilitate batching)
rawCombo([26:end],7) = (rawCombo([26:end],7) + 250);
rawCombo([26:end],10) = (rawCombo([26:end],10) + 250);
B.output.raw = rawCombo;
B.payout = nansum(B.output.raw(:,13))
task = B;
saveName = '/Users/wem3/Desktop/DRS/task/output/drs016_dsd_run1.mat';
save(saveName,'task');

