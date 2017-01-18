function [ dsdFeedback ] = discloseDSD(subNumArg, waveNumArg, dirArg)
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
        useOtherDir = false;
    case 1
        error('Must specify 0 or 2 arguments');
    case 2
        subNum = subNumArg;
        waveNum = waveNumArg;
        useOtherDir = false;
    case 3
        subNum = subNumArg;
        waveNum = waveNumArg;
        useOtherDir = true;
        otherDir = dirArg;
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

if(useOtherDir)
    drs.output.path = otherDir;
end

finalDiscoOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_finalOut.mat'];
finalDiscoOutputTxt = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_finalOut.txt'];

subOutputMat1 = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_run1.mat'];
subOutputMat2 = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_dsd_run2.mat'];

if exist(subOutputMat1, 'file')
    task1_exists=true;
    task1=load(subOutputMat1);
    %       3. leftTarget (self == 1, friend == 2) 
    %       4. rightTarget
    [~,task1_sharekey] = ismember(2, [unique(task1.task.output.raw(:,3)) unique(task1.task.output.raw(:,4))]);
else
    display('WARNING: Run 1 output file does not exist.');
    task1_exists=false;
    task1_sharekey = [];
end
if exist(subOutputMat2, 'file')
    task2_exists=true;
    task2=load(subOutputMat2);
    %       3. leftTarget (self == 1, friend == 2) 
    %       4. rightTarget
    [~,task2_sharekey] = ismember(2, [unique(task2.task.output.raw(:,3)) unique(task2.task.output.raw(:,4))]);
else
    display('WARNING: Run 2 output file does not exist.');
    task2_exists=false;
    task2_sharekey = [];
end

% if shareResp is 2, right is disclose. 1 means left is disclose
shareResp = unique([task1_sharekey task2_sharekey]);
if shareResp == 2
    display('Option for disclosing appeard on the right: this is how the task was coded for the first block of participants.');
elseif shareResp == 1
    display('Option for disclosing appeard on the left: please be sure this switch was intended.');
else
    display('Disclosure response choice variabel makes no sense. Please report!');
end

if length(shareResp) > 1
    error('Target position is not consistent across runs. Something is not right.');
end

%%
% Set up discos we are allowed to share
%
% Updated from IRB doc as of 1/7/2016
%%%%%%%

% Maximum number of choices for each affective and neutral statements.
maxChoicesPer = 2;

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

%concatenate all decisions to disclose or not, all yes/no responses to
%statements, and all statements.

if task1_exists
    task1_choices=task1.task.output.raw(:,8);
    task1_endochoices=task1.task.output.raw(:,11);
    task1_statements=task1.task.input.statement;
else
    task1_choices=[];
    task1_endochoices=[];
    task1_statements=cell(0);
end
if task2_exists
    task2_choices=task2.task.output.raw(:,8);
    task2_endochoices=task2.task.output.raw(:,11);
    task2_statements=task2.task.input.statement;
else
    task2_choices=[];
    task2_endochoices=[];
    task2_statements=cell(0);
end

allDiscoChoices = [task1_choices; task2_choices];
allEndorseChoices = [task1_endochoices; task2_endochoices];
allStatements = {task1_statements{:}, task2_statements{:}};

%Get a vector of logical values as to whether the person disclosed to their
%friend or not.
allRowsDisclosed = allDiscoChoices == shareResp;

%If not any of the items were disclosed, warn the user and set the
%statements
endorseString = {'Yes', 'No'}; %Yes on left, No on right.

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
        %Gets a max of 2 indexes from a randomly shuffled index of all 
        % possible statments
        randAffItemIndex = Shuffle(1:nPossAff);
        chosenAffItemNumbers = randAffItemIndex(1:min(maxChoicesPer,nPossAff));
        chosenAffStatements = possibleAffStatements(chosenAffItemNumbers);
        randAffEndorseChoice = possibleAffEndorseChoices(chosenAffItemNumbers); % must be 1 or 2
        for(aff_i=1:length(chosenAffStatements))
            randAffItem{aff_i} = [possibleAffStatements{chosenAffItemNumbers(aff_i)} ': ' endorseString{randAffEndorseChoice(aff_i)}];
        end
        %We'll save discoInfo later
        discoInfo.aff.statements = randAffItem;
        discoInfo.aff.endorseButton = randAffEndorseChoice;
    else
        display('WARNING: No appropriate A statement');
        discoInfo.aff.statements{1} = 'NO STATEMENT';
        discoInfo.aff.endorseButton{1} = null(1);
    end
    if any(neutStatementRows)
         %pare down the list of statements and corresponding choices so
        %we're left with just the options we are allowed to disclose.
        possibleNeutStatements = {allDisclosedStatements{neutStatementRows}};
        possibleNeutEndorseChoices = allDisclosedEndorseChoices(neutStatementRows);
        
        %get the number of statements, and then select one at random.
        [~, nPossNeut] = size(possibleNeutStatements);
        %Gets a max of 2 indexes from a randomly shuffled index of all 
        % possible statments
        randNeutItemIndex = Shuffle(1:nPossNeut);
        chosenNuetItemNumbers = randNeutItemIndex(1:min(maxChoicesPer,nPossNeut));
        chosenNeutStatements = possibleNeutStatements(chosenNuetItemNumbers);
        randNeutEndorseChoice = possibleNeutEndorseChoices(chosenNuetItemNumbers); % must be 1 or 2
        for(neut_i=1:length(chosenNeutStatements))
            randNeutItem{neut_i} = [possibleNeutStatements{chosenNuetItemNumbers(neut_i)} ': ' endorseString{randNeutEndorseChoice(neut_i)}];
        end
        discoInfo.neut.statements = randNeutItem;
        discoInfo.neut.endorseButton = randNeutEndorseChoice;
    else
        display('WARNING: No appropriate N statement');
        discoInfo.neut.statements{1} = 'NO STATEMENT';
        discoInfo.neut.endorseButton{1} = null(1);
    end
end

if task1_exists 
    task1_coins = task1.task.output.raw(:,5:6);
    task1_sum_lcoins = task1.task.output.raw(:,8) == 1;
    task1_sum_rcoins = task1.task.output.raw(:,8) == 2;
    task1_payout = sum(task1_coins(task1_sum_lcoins,1)) + sum(task1_coins(task1_sum_rcoins,2));
else
    task1_payout = 0;
end
if task2_exists 
    task2_coins = task2.task.output.raw(:,5:6);
    task2_sum_lcoins = task2.task.output.raw(:,8) == 1;
    task2_sum_rcoins = task2.task.output.raw(:,8) == 2;
    task2_payout = sum(task2_coins(task2_sum_lcoins,1)) + sum(task2_coins(task2_sum_rcoins,2));
else
    task2_payout = 0;
end


%put payouts and friend name into final output structure.
discoInfo.payouts = {task1_payout, task2_payout};
discoInfo.friend = drs.friend;

%save final output.
stringSpec = 'Friend: %s\nPayout Run1: %u\nPayout Run2: %u\nStatements:\n';
statementStringSpec = '\t- Sometimes I %s\n';

displayString=[sprintf(stringSpec,...
    discoInfo.friend, discoInfo.payouts{1}, discoInfo.payouts{2})...
    sprintf(statementStringSpec, discoInfo.aff.statements{:})...
    sprintf(statementStringSpec, discoInfo.neut.statements{:})];

fid=fopen(finalDiscoOutputTxt,'a');
fprintf(fid,displayString);
fclose(fid);

display(displayString);

save(finalDiscoOutputMat,'discoInfo');

%% End Function
end

