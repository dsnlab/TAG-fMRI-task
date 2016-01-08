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
subInfoFile = ['input', filesep, subID,'_wave_',num2str(waveNum),'_info.mat'];
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
% Left: Yes, Private; Right: No, Share. This will change after some number
% of participants have been run, and this must change accordingly.
% endorseString is set to correspond to order on screen so we can reference
% easily using the codes for left choice and right, e.g., endorseString{1}
% gives us the response corresponding to the left side of the screen.
    endorseString = {'Yes', 'No'}; %Yes on left, No on right.
    shareResp = 2;
else
    display('Have you swapped choice positions yet?');
    endorseString = {'Yes', 'No'}; %Yes on left, No on right.
    shareResp = 2;
end

%concatenate all decisions to disclose or not, all yes/no responses to
%statements, and all statements.
allDiscoChoices = [task1.task.output.raw(:,8); task2.task.output.raw(:,8)];
allEndorseChoices = [task1.task.output.raw(:,11); task2.task.output.raw(:,11)];
allStatements = {task1.task.input.statement{:}, task2.task.input.statement{:}};

%Get a vector of logical values as to whether the person disclosed to their
%friend or not.
allRowsDisclosed = allDiscoChoices == shareResp;

%If not any of the items were disclosed, warn the user and set the
%statements
if ~any(allRowsDisclosed)
    display('WARNING: All statements kept private');
    discoInfo.chosenStatements = {'NO STATEMENT', 'NO STATEMENT'};
else
    %get every statement that they chose to share with a friend, and the
    %corresponding endorsement choices for those statements.
    allDisclosedStatements = {allStatements{allRowsDisclosed}};
    allDisclosedEndorseChoices = allEndorseChoices(allRowsDisclosed);
    
    %get a vector of all disclosed statements that is true if it is in our
    %IRB approved list of disclosable statements and if there is an
    %endoresement choice for the statement (one for both aff and neut
    %items.
    affStatementRows = ismember(allDisclosedStatements,affDisco)' & allDisclosedEndorseChoices;
    neutStatementRows = ismember(allDisclosedStatements,neutDisco)' & allDisclosedEndorseChoices;
    
    %check if any statements are shareable and have endorsement choices
    %or else warn and set the statement to 'NO STATEMENT'.
    if any(affStatementRows)
        %pare down the list of statements and corresponding choices so
        %we're left with just the options we are allowed to disclose.
        possibleAffStatements = {allDisclosedStatements{affStatementRows}};
        possibleAffEndorseChoices = allDisclosedEndorseChoices(affStatementRows);
        
        %get the number of statements, and then select one at random.
        [~, nPossAff] = size(possibleAffStatements);
        % you can easily check that the below does what we want if you run:
        % histogram(floor(5*rand(1,10000)+1))
        randAffItemNum = floor(nPossAff*rand(1)+1); 
        randAffEndorseChoice = possibleAffEndorseChoices(randAffItemNum); % must be 1 or 2
        randAffItem = [possibleAffStatements{randAffItemNum} ': ' endorseString{randAffEndorseChoice}];
    else
        display('WARNING: No appropriate A statement');
        randAffItem = 'NO STATEMENT';
    end
    if any(neutStatementRows)
         %pare down the list of statements and corresponding choices so
        %we're left with just the options we are allowed to disclose.
        possibleNeutStatements = {allDisclosedStatements{neutStatementRows}};
        possibleNeutEndorseChoices = allDisclosedEndorseChoices(neutStatementRows);
        
        %get the number of statements, and then select one at random.
        [~, nPossNeut] = size(possibleNeutStatements);
        randNeutItemNum = floor(nPossNeut*rand(1)+1);
        randNeutEndorseChoice = possibleNeutEndorseChoices(randNeutItemNum); % must be 1 or 2
        randNeutItem = [possibleNeutStatements{randNeutItemNum} ': ' endorseString{randNeutEndorseChoice}];
    else
        display('WARNING: No appropriate N statement');
        randNeutItem = 'NO STATEMENT';
    end
    %start building discoInfo to save to a mat with strings we want to output
    discoInfo.chosenStatements = {['Sometimes I ' randAffItem],...
        ['Sometimes I ' randNeutItem]};
end

%put payouts and friend name into final output structure.
discoInfo.payouts = {task1.task.payout, task2.task.payout};
discoInfo.friend = drs.friend;

%save final output.
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

