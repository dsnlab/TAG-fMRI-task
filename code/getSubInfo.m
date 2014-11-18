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
studyDir = uigetdir('/Users/wem3/Desktop/DRS','Select study directory');

% interactive dialog to get demographic info
prompt = {...
'subID: ',...
'name: ',...
'friend: ',...
'friend email: ',...
'parent: ',...
'parent email: ',...
'gender: subGender = ',...
'birthday: DOB = ',...
'handedness: hand = ',...
'experimentor: exptID = '};
dTitle = 'define subject specific variables';
nLines = 1;
% defaults
def = { '999' , 'Subastian' , 'Ricky' , 'ricky@gmail.com', 'Mom' , 'mom@comcast.net', 'M' , '04-Jul-1994' , 'R' , 'wem3' };
manualInput = inputdlg(prompt,dTitle,nLines,def);
% the order is funky here because we want the structure output 
% to be readily readable in summary form (so this, err, isn't)
drs.subID = ['drs',manualInput{1}];
drs.subNum = str2num(manualInput{1});
drs.input.path = [studyDir,filesep,'task',filesep,'input'];
drs.output.path = [studyDir,filesep,'task',filesep,'output'];
% stimFile created by makeDRSstimulus.m
stimFile = [studyDir,filesep,'task',filesep,'materials',filesep,'DRSstim.mat'];
load(stimFile);

demo.name = manualInput{2};
demo.gender = manualInput{6};
demo.DOB = manualInput{8};
demo.hand = manualInput{9};
demo.friendEmail = manualInput{4};
demo.parentEmail = manualInput{6};
demo.exptID = manualInput{10};
demo.exptDate = datestr(now);
drs.friend = manualInput{3};
drs.parent = manualInput{5};

% now that we know friend/parent names, we can finish the stimulus...
selfText = 'keep it private';
friendText = ['share with ', drs.friend];
parentText = ['share with ', drs.parent];
drs.demo = demo;
stim.targetText = {selfText, friendText, parentText};

% randomize colors, make boxen for dsd (so we can draw colored hands later)
stim.targetColors = Shuffle({stim.sky,stim.pink,stim.blue});
for boxCount = 1:3
  for rgbCount = 1:3
    stim.targetBoxen{boxCount}(:,:,rgbCount) = ones(200,200).*stim.targetColors{boxCount}(rgbCount);
  end
end

% make icons for svc (there are only two, their colors don't change)
% but make boxen 3 & 4 out of convenience for condition code
stim.promptColors = Shuffle({stim.orange, stim.purple});
for rgbCount = 1:3
  stim.promptMatrix{1}(:,:,rgbCount) = ones(200,200) .* stim.promptColors{1}(rgbCount);
  stim.promptMatrix{2}(:,:,rgbCount) = ones(200,200) .* stim.promptColors{2}(rgbCount);
end
stim.promptMatrix{1}(:,:,4) = (stim.alpha.self) ./255;
stim.promptMatrix{2}(:,:,4) = (stim.alpha.delta) ./255;


% store stim in drs and save
drs.stim = stim;
saveFile = [drs.input.path,filesep,[drs.subID,'_info.mat']];
save(saveFile,'drs');

return

