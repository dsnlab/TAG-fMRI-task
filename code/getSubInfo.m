function [ drs ] = getSubInfo()
% GETSUBINFO.M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   usage: demo = getSubInfo()
%   takes no input, saves harvested subject info dialog to drs structure
%
%   author: wem3
%   written: 141031
%   modified: 141104 ~wem3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prompt for study directory (highest level)
studyDir = uigetdir('top study directory');

% interactive dialog to get demographic info
prompt = {...
'subID: subID = ',...
'name: subName = ',...
'friend: friendName = ',...
'parent: parentName = ',...
'gender: subGender = ',...
'birthday: DOB = ',...
'handedness: hand = ',...
'experimentor: exptID = '};
dTitle = 'define subject specific variables';
nLines = 1;
% defaults
def = { '001' , 'Subastian' , 'Ricky' , 'Mom' , 'M' , '04-Jul-1994' , 'R' , 'wem3' };
manualInput = inputdlg(prompt,dTitle,nLines,def);
% the order is funky here because we want the structure output 
% to be readily readable in summary form (so this, err, isn't)
drs.subID = ['drs',manualInput{1}];
drs.subNum = str2num(manualInput{1});
drs.input = [studyDir,filesep,'task',filesep,'input'];
drs.output = [studyDir,filesep,'task',filesep,'output'];
% stimFile created by makeDRSstimulus.m
stimFile = [studyDir,filesep,materials,filesep,'DRSstim.mat'];
load(stimFile);
drs.stim = stim;
demo.name = manualInput{2};
demo.gender = manualInput{5};
demo.DOB = manualInput{6};
demo.hand = manualInput{7};
demo.exptID = manualInput{8};
demo.exptDate = datestr(now);
drs.friend = manualInput{3};
drs.parent = manualInput{4};

% now that we know friend/parent names, we can finish the stimulus...
selfText = 'keep it private';
friendText = ['share with ', drs.friend];
parentText = ['share with ', drs.parent];
drs.demo = demo;
drs.targetText = {selfText, friendText, parentText};

% randomize colors
drs.targetColors = Shuffle({stim.sky,stim.blue,stim.pink});

saveFile = [drs.output,filesep,[drs.subID,'_info.mat']];

save(saveFile,'drs');

return

