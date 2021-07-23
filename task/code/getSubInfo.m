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
% get directory info
thisfile = mfilename('fullpath'); % studyDir/task/code/thisfile.m
taskDir = fileparts(fileparts(thisfile));
studyDir = fileparts(taskDir);
inputDir = fullfile(taskDir, 'input');

% interactive dialog to get demographic info
prompt = {...
'subID: ',...,
'friend: ',...
'experimentor: '...,
'wave: '};
dTitle = 'Define subject specific variables';
dims = [1 , 60];
% defaults
def = { '999' , 'Ally' , 'TAG', '1' };
manualInput = inputdlg(prompt,dTitle,dims,def);

if isempty(manualInput)
    drs = {};
    return
end

% the order is funky here because we want the structure output 
% to be readily readable in summary form (so this, err, isn't)
drs.subID = ['tag',manualInput{1}];
drs.studyDir = studyDir;
drs.subNum = str2num(manualInput{1});
drs.waveNum = str2num(manualInput{4});

% no longer necessary
%drs.input.path = fullfile(studyDir,'task', 'input');
%drs.output.path = fullfile(studyDir,'task','output');

% stimFile created by makeDRSstimulus.m
stimFile = fullfile(studyDir,'task','DRSstim.mat');
load(stimFile);

demo.name = '';
demo.friendEmail = '';
demo.parentEmail = '';
demo.exptID = manualInput{3};
demo.exptDate = datestr(now);
drs.friend = manualInput{2};
drs.parent = '';

% now that we know friend/parent names, we can finish the stimulus...
selfText = 'keep it private';
friendText = ['share with ', drs.friend];
parentText = ['share with ', drs.parent];
drs.demo = demo;
stim.targetText = {selfText, friendText, parentText};

% randomize colors, make boxen for dsd (so we can draw colored hands later)
stim.targetColors = Shuffle({stim.sky,stim.sky,stim.sky});
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
saveFile = fullfile(inputDir, [drs.subID,'_wave_',num2str(drs.waveNum),'_info.mat']);
save(saveFile,'drs');

return

