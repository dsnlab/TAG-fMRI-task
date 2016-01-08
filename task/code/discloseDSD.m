function [ dsdFeedback ] = discloseDSD(subNumArg, waveNumArg, runNumArg)
% % discloseDSD.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ dsdFeedback ] = discloseDSD(subNumArg, waveNumArg, runNumArg)
%
%   All args are scalar
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   A stucture named 'task' within which these may be of interest
%
%   task.output.raw:
%       1. Trial Number
%       2. condition
%           [1-3] = Neutral; [4-6] = Affective;
%           [1,4] = loss to share; [2, 5] = loss to private; [3,6] equal
%       3. leftTarget (self == 1, friend == 2) 
%       4. rightTarget
%       5. leftCoin
%       6. rightCoin
%       7. Time since trigger for disclosure (choiceOnset - loopStartTime);
%       8. choiceResponse - Share or not? (leftkeys = 1, rightkeys = 2)
%       9. choiceRT - reaction time
%       10. Time since trigger for statement decisions (discoOnset - loopStartTime);
%       11. discoResponse - endorse or not?  (leftkeys = 1, rightkeys = 2)
%       12. discoRT - reaction time
%   task.input.statement
%   task.payout
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subNumArg = '000';
waveNumArg = 1;
runNumArg = ;

switch nargin
    case 0
        clear all;
        prompt = {...
        'sub num: ',...
        'wave num: ',...
        'run num: '};
        dTitle = 'Input Subject, Wave, and Run Number';
        nLines = 1;
        % defaults
        def = {'', '', ''};
        manualInput = inputdlg(prompt,dTitle,nLines,def);
        subNum = str2double(manualInput{1});
        waveNum = str2double(manualInput{2});
        runNum = str2double(manualInput{3});
    case 1
        error('Must specify 0 or 3 arguments');
    case 2
        error('Must specify 0 or 3 arguments');
    case 3
        subNum = subNumArg;
        waveNum = waveNumArg;
        runNum = runNumArg;
end

%% get subID from subNum
if subNum < 10
  subID = ['tag00',num2str(subNum)];
elseif subNum < 100
  subID = ['tag0',num2str(subNum)];
else
  subID = ['tag',num2str(subNum)];
end

% load subject's drs structure
subInfoFile = [subID,'_wave_',num2str(waveNum),'_info.mat'];
load(subInfoFile);
thisRun = ['run',num2str(runNum)];
if strcmp(thisRun,'run0')
  inputTextFile = [drs.input.path,filesep,'dsd_practice_input.txt'];
  subOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_rpe_',thisRun,'.mat'];
else
  subOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_',thisRun,'.mat'];
  inputTextFile = [drs.input.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_',thisRun,'_input.txt'];
  outputTextFile = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_',thisRun,'_output.txt'];
end

load(subOutputMat);

%%
% Set up discos we are allowed to share
%
% Updated from IRB doc as of 1/7/2016
%%%%%%%

affDisco = {'can get moody', ...
'find homework hard', ...
'can?t keep secrets', ...
'count calories', ...
'wish I was in love', ...
'hide my feelings', ...
'can?t wait to be older ', ...
'dislike my body', ...
'act without thinking', ...
'worry about kissing', ...
'think smoking is gross', ...
'can?t ignore gossip ', ...
'worry about grades', ...
'ignore my parents', ...
'feel shy in groups', ...
'want to be popular', ...
'dream about my wedding ', ...
'worry about high school', ...
'feel lonely', ...
'get mad at friends'}

neutDisco = {'like wearing makeup', ...
'wear leggings?', ...
'like to doodle', ...
'carry chapstick?', ...
'like sleepovers', ...
'sing in the shower', ...
'can be creative', ...
'like to wear hats', ...
'drink milk', ...
'like reality TV shows', ...
'read magazines?', ...
'can be messy', ...
'wear sunglasses', ...
'like eating out', ...
'don?t brush my teeth', ...
'go barefoot', ...
'take bubble baths', ...
'listen to music', ...
'try new foods', ...
'braid my hair'}

%%
% Get the output we want
%       8. choiceResponse - Share or not? (leftkeys = 1, rightkeys = 2)
%       11. discoResponse - endorse or not?  (leftkeys = 1, rightkeys = 2)
%
% Wether correspondence between keys and yes/no response may change by
% participant number
%

if subNum < 40
% Left: Yes, Private; Right: No, Share.
    yesResp = 1;
    shareResp = 2;
else
    warning("Have you swapped choice positions yet?")
    yesResp = 1;
    shareResp = 2;
end
    
allRowsDisclosed = task.output.raw(8,:) == shareResp;
task.input.statement
task.payout





