function [ dsdFeedback ] = discloseDSD(subNumArg, waveNumArg)
% % discloseDSD.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ dsdFeedback ] = discloseDSD(subNumArg, waveNumArg)
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

switch nargin
    case 0
        clear all;
        prompt = {...
        'sub num: ',...
        'wave num: '};
        dTitle = 'Input Subject and Wave';
        nLines = 1;
        % defaults
        def = {'', ''};
        manualInput = inputdlg(prompt,dTitle,nLines,def);
        subNum = str2double(manualInput{1});
        waveNum = str2double(manualInput{2});
    case 1
        error('Must specify 0 or 2 arguments');
    case 2
        subNum = subNumArg;
        waveNum = waveNumArg;
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

finalDiscoOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_finalOut.mat'];
finalDiscoOutputTxt = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_finalOut.txt'];

subOutputMat1 = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_run1.mat'];
subOutputMat2 = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_run2.mat'];
task1=load(subOutputMat1);
task2=load(subOutputMat2);
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
'get mad at friends'};

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
'braid my hair'};

%% Get the output we want
% 
% task.output.raw:
%       8. choiceResponse - Share or not? (leftkeys = 1, rightkeys = 2)
%       11. discoResponse - endorse or not?  (leftkeys = 1, rightkeys = 2)
% task.input.stament
% task.payout
% drs.friend
%
% Whether correspondence between keys and yes/no response may change by
% participant number
%

if subNum < 40
% Left: Yes, Private; Right: No, Share.
    yesResp = 1;
    shareResp = 2;
else
    display('Have you swapped choice positions yet?')
    yesResp = 1;
    shareResp = 2;
end

allDiscoChoices = [task1.task.output.raw(:,8); task2.task.output.raw(:,8)];
% allDiscoChoices = floor(rand(82,1)+1.5);
% display('MUST DELETE LINE 143 BEFORE USING!!!');
allStatements = {task1.task.input.statement{:}, task2.task.input.statement{:}};
allRowsDisclosed = allDiscoChoices == shareResp;

if ~any(allRowsDisclosed)
    display('WARNING: All statements kept private');
    discoInfo.chosenStatements = {'NO STATEMENT', 'NO STATEMENT'};
else
    allDisclosedStatements = {allStatements{allRowsDisclosed}};
    affStatementRows = ismember(allDisclosedStatements,affDisco);
    neutStatementRows = ismember(allDisclosedStatements,neutDisco);
    possibleAffStatements = {allDisclosedStatements{affStatementRows}};
    possibleNeutStatements = {allDisclosedStatements{neutStatementRows}};
    [~, nPossAff] = size(possibleAffStatements);
    [~, nPossNeut] = size(possibleNeutStatements);
    randAffItemNum = floor(nPossAff*rand(1)+1);
    randNeutItemNum = floor(nPossNeut*rand(1)+1);
    randAffItem = possibleAffStatements{randAffItemNum};
    randNeutItem = possibleNeutStatements{randNeutItemNum};
    discoInfo.chosenStatements = {['Sometimes I ' randAffItem], ['Sometimes I ' randNeutItem]};
end

discoInfo.payouts = {task1.task.payout, task2.task.payout};
discoInfo.friend = drs.friend;

stringSpec = 'Friend: %s\nPayout Run1: %u\nPayout Run2: %u\nStatements:\n\t1. %s\n\t2. %s\n';

fid=fopen(finalDiscoOutputTxt,'a');
fprintf(fid,stringSpec,...
    discoInfo.friend, discoInfo.payouts{1}, discoInfo.payouts{2}, ...
    discoInfo.chosenStatements{1}, discoInfo.chosenStatements{2});
fclose(fid);

displayString=sprintf(stringSpec,...
    discoInfo.friend, discoInfo.payouts{1}, discoInfo.payouts{2}, ...
    discoInfo.chosenStatements{1}, discoInfo.chosenStatements{2});

display(displayString);

save(finalDiscoOutputMat,'discoInfo');

%% End Function
end

