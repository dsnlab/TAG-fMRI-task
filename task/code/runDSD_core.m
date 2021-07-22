function [task] = runDSD_core(subject, keys, win)
% % runDSD_core.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runDSD_core(subject, keys, win)
%
%   Called by runDSD and introTAG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%    (subID)_dsd_(runNum).txt = comma delimited text with per trial input
%    input text columns (%u,%u,%u,%u,%u,%f%f) 
%       1. trialNum
%       2. condition
%           [1-3] = Neutral; [4-6] = Affective;
%           [1,4] = loss to share; [2, 5] = loss to private; [3,6] equal
%       3. leftTarget (self == 1, friend == 2) 
%       4. rightTarget
%       5. leftCoin
%       6. rightCoin
%       7. choiceJitter (%f, amount of time to vary gap b/w choice & disclosure)
%       8. discoJitter (%f, amount of time to vary ITI)
%       9. statement (string w/ self-disclosure statement)
%
%     DRSstim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%     (subID)_info.mat = structure w/ subject specific info
% Output:
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
%       13. payout amount according to choice
%   task.input.statement
%   task.payout
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get directories
thisfile = mfilename('fullpath'); % studyDir/task/code/thisfile.m
taskDir = fileparts(fileparts(thisfile));
inputDir = fullfile(taskDir, 'input');
outputDir = fullfile(taskDir, 'output');
if not(isfolder(outputDir))
    mkdir(outputDir)
end    

% get subID from subNum
subID = sprintf('tag%03d', subject.number);
prefix = [subID,'_wave_',num2str(subject.wave)];

% load subject's drs structure
subInfoFile = fullfile(inputDir, [prefix,'_info.mat']);
load(subInfoFile, 'drs');

%%
thisRun = ['run',num2str(subject.run)];
if strcmp(thisRun,'run0')
  inputTextFile = fullfile(inputDir,'dsd_practice_input.txt');
  subOutputMat = fullfile(outputDir, [prefix,'_rpe_',thisRun,'.mat']);
else
  subOutputMat = fullfile(outputDir, [prefix,'_dsd_',thisRun,'.mat']);
  inputTextFile = fullfile(inputDir, [prefix,'_dsd_',thisRun,'_input.txt']);
  outputTextFile = fullfile(outputDir, [prefix,'_dsd_',thisRun,'_output.txt']);
end

if not(isfile(inputTextFile))
    fprintf('Warning: file not found %s.', inputTextFile);
end

%%The first approximately half of all participants in wave 1 saw the
%%disclosure choice on the right hand side. We want to balance the side
%%that this choice is displayed on for the second half of the participants.
%%For future waves choiceAdvice should be updated to tell people to check
%%the run sheet for which side the disclosure choice should appear.

% old way, harder to read
%dsd_discoside.csv info:
% col1: Tag ID; col2: side (1 = Right, 2 = Left)
% dummy id 999 uses Right, 998 uses Left
% discoSideFN=fullfile(inputDir, 'dsd_discoside.csv');
% sides={'Right','Left'};
% discoSideMat=csvread(discoSideFN); 
% discoSideNum=discoSideMat(discoSideMat(:,1) == subject.number,2);
% discoSide=sides(discoSideNum);
% 
% if isempty(discoSide) || (~strcmp(discoSide, 'Right') && ~strcmp(discoSide, 'Left'))
%     discoSideNumRand=randi([1 2]);
%     discoSide=sides(discoSideNumRand);
%     newDiscoSideMat = [discoSideMat; subject.number,discoSideNumRand];
%     csvwrite(discoSideFN,newDiscoSideMat);
% end

% new way
discoSideFN = fullfile(inputDir, 'dsd_discoside.txt');
T = readtable(discoSideFN);
if not (ismember(subID, T.Properties.RowNames))
    sides=["Right", "Left"]; % now using strings
    randomSide=sides(randi(length(sides)));
    T{subID, 'discoSide'} = {randomSide};
    writetable(T, discoSideFN);
end
discoSide = T.discoSide{subID};

% load trialMatrix
fid=fopen(inputTextFile);
trialMatrix=textscan(fid,'%f%f%f%f%f%f%f%f%s\n','delimiter',',');
fclose(fid);

[trialMatRows, ~] = size(trialMatrix{3});
self_vec = ones(trialMatRows, 1);
friend_vec = ones(trialMatRows, 1)+1;

if discoSide == "Right"
    leftTarget_vec = self_vec;
    rightTarget_vec = friend_vec;
    sideInstructions = '\n\nstatement: left for ''yes'', right for ''no'' \n\ndecision: left to keep private, right to share ';
else
    leftTarget_vec = friend_vec;
    rightTarget_vec = self_vec;
    sideInstructions = '\n\nstatement: left for ''yes'', right for ''no'' \n\ndecision: left to share, right to keep it private ';
end

%% store info from trialMatrix in drs structure
task.input.raw = [trialMatrix{1} trialMatrix{2} trialMatrix{3} trialMatrix{4} trialMatrix{5} trialMatrix{6} trialMatrix{7} trialMatrix{8}];
task.input.condition = trialMatrix{2};
task.input.leftTarget = leftTarget_vec;
trialMatrix{3} = leftTarget_vec;
task.input.rightTarget = rightTarget_vec;
trialMatrix{4} = rightTarget_vec;
task.input.leftCoin = trialMatrix{5};
task.input.rightCoin = trialMatrix{6};
task.input.choiceJitter = trialMatrix{7};
task.input.discoJitter = trialMatrix{8};
task.input.statement = trialMatrix{9};
numTrials = length(trialMatrix{1});
task.output.raw = NaN(numTrials,13);
task.input.discoSide = char(discoSide); % backwards compatibility



%% 
screenNumber = max(Screen('Screens'));

% flip to get ifi

HideCursor();

drs.stim.box = ConvertStim(drs.stim.box, screenNumber); %jcs

Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);

Screen('TextSize', win, floor(50 * drs.stim.box.yratio)); %jcs
Screen('TextFont', win, 'Arial');

% to inform subject about upcoming task
prefaceText = ['Coming up... ','Sharing Task: ',thisRun, sideInstructions];
DrawFormattedText(win, prefaceText, 'center', 'center', drs.stim.sky);
[~,programOnset] = Screen('Flip',win);

try
    disp("waiting for input from " + keys.keyboard_name);
    KbStrokeWait(keys.keyboard_index);
catch
    error("Problem waiting for internal keyboard, try running ButtonSetup")
end


%% 
% remind em' not to squirm!
DrawFormattedText(win, 'Getting scan ready...\n\n hold really still!',...
  'center', 'center', drs.stim.white);
[~,calibrationOnset] = Screen('Flip', win);

% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList(keys.kill)=1; % unused? Should be use in internal keyboard queue
leftKeys = ([keys.b0 keys.b1 keys.b2 keys.b3 keys.b4]);
rightKeys = ([keys.b5 keys.b6 keys.b7 keys.b8 keys.b9]);
keyList(leftKeys) = 1;
keyList(rightKeys) = 1;

choiceSkips = [];
discoSkips = [];

% trigger pulse code 
disp(keys.trigger);

% Possibly a Psychtoolbox bug:
% we need to create and release the trigger queue
% when we've already used KbStrokeWait with the same device id
KbQueueCreate(keys.trigger_index);
KbQueueRelease(keys.trigger_index);

if subject.run == 0 
    disp("waiting for input from " + keys.keyboard_name);
    KbStrokeWait(keys.keyboard_index);
else
    disp("waiting for trigger from " + keys.trigger_name);
    KbTriggerWait(keys.trigger,keys.trigger_index); 
    disabledTrigger = DisableKeysForKbCheck(keys.trigger);
    triggerPulseTime = GetSecs;
    disp('trigger pulse received, starting experiment');
end
Screen('Flip', win);

for kn = 1:length(keys.response_indices)
    KbQueueCreate(keys.response_indices(kn), keyList);
end

loopStartTime = GetSecs;
%% trial loop
for tCount = 1:numTrials
  %% set variables for this trial
  targets = [trialMatrix{3}(tCount),trialMatrix{4}(tCount),trialMatrix{5}(tCount),trialMatrix{6}(tCount)];
  choiceJitter = trialMatrix{7}(tCount);
  discoJitter = trialMatrix{8}(tCount);
  statement = trialMatrix{9}{tCount};
  choiceResponse = 0;
  choiceRT = NaN;
  discoRT = NaN;
  payout = NaN;
  chose = 0;
  disclosed = 0;
  multiChoiceResponse = [];
  multiChoiceRT =[];
  multiDiscoResponse = [];
  multiDiscoRT =[];
  %% call draw function
  discoResponse = 0;
  drawYesNo(win,drs.stim,[0.5 0.5]);
  drawDisco(win,drs.stim,statement);
  
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.1], [drs.stim.box.choice{1}(1) drs.stim.box.choice{1}(2) drs.stim.box.choice{2}(3) drs.stim.box.choice{2}(4)]);
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.5], [drs.stim.box.coin{1}(1) drs.stim.box.coin{1}(2) drs.stim.box.coin{2}(3) drs.stim.box.coin{2}(4)]);
  
  for kn = 1:length(keys.response_indices)
    KbQueueStart(keys.response_indices(kn));
  end

  [~,discoOnset] = Screen('Flip',win);
  while (GetSecs - discoOnset) < 4.5
 %   [ pressed, firstPress]=KbQueueCheck(inputDevice);
    [ pressed, firstPress]=ResponseCheck(keys.response_indices);
    if pressed
      if disclosed == 0;
        discoRT = firstPress(find(firstPress)) - discoOnset;
      elseif disclosed == 1 ;
        multiDiscoResponse = [multiDiscoResponse discoResponse];
        multiDiscoRT =[multiDiscoRT discoRT];
        discoRT = firstPress(find(firstPress)) - discoOnset;
      end
      if find(firstPress(leftKeys))
        discoResponse = 1;
      elseif find(firstPress(rightKeys))
        discoResponse = 2;
      end
      disclosed = 1;
      drawDiscoFeedback(win,drs.stim,targets,statement,discoResponse);
    end
  end
  for kn = 1:length(keys.response_indices)
    KbQueueStop(keys.response_indices(kn));
  end
  WaitSecs('UntilTime',(discoOnset + 4.5 + discoJitter));
  %
  choiceResponse = 0;
  %drawHands(win,drs.stim,targets,[0.5 0.5]);
  drawChoice(win,drs.stim,targets,statement,discoResponse);
  for kn = 1:length(keys.response_indices)
    KbQueueStart(keys.response_indices(kn));
  end
  % flip the screen to show choice
  [~,choiceOnset] = Screen('Flip',win);
  %loop for response
  while (GetSecs - choiceOnset) < 3
    [ pressed, firstPress]=ResponseCheck(keys.response_indices);  
 %   [ pressed, firstPress]=KbQueueCheck(inputDevice);
      if pressed
        if chose == 0
          choiceRT = firstPress(find(firstPress)) - choiceOnset;
        elseif chose == 1
          multiChoiceResponse = [multiChoiceResponse choiceResponse];
          multiChoiceRT =[multiChoiceRT choiceRT];
          choiceRT = firstPress(find(firstPress)) - choiceOnset;
        end

        if find(firstPress(leftKeys))
            choiceResponse = 1;
            payout = targets(3);
        elseif find(firstPress(rightKeys))
            choiceResponse = 2;
            payout = targets(4);
        end
        chose=1;
        drawChoiceFeedback(win,drs.stim,targets,statement,discoResponse,choiceResponse);
      end   
  end
  for kn = 1:length(keys.response_indices)
    KbQueueStop(keys.response_indices(kn));
  end
  Screen('FillRect',win, drs.stim.bg);
  [~,choiceOffset] = Screen('Flip',win); % choiceOffset used to be discoOffset
  WaitSecs('UntilTime',(choiceOnset + 3 + choiceJitter + 1));
%%
  
  if choiceResponse == 0
    choiceSkips = [choiceSkips tCount];
  end
  if discoResponse == 0
    discoSkips = [discoSkips tCount];
  end
  % assign output for each trial to task.(thisRun).output.raw matrix
  
  task.output.raw(tCount,1) = tCount;
  task.output.raw(tCount,2) = trialMatrix{2}(tCount);
  task.output.raw(tCount,3) = trialMatrix{3}(tCount);
  task.output.raw(tCount,4) = trialMatrix{4}(tCount);
  task.output.raw(tCount,5) = trialMatrix{5}(tCount);
  task.output.raw(tCount,6) = trialMatrix{6}(tCount);
  task.output.raw(tCount,7) = (choiceOnset - loopStartTime);
  task.output.raw(tCount,8) = choiceResponse; 
  task.output.raw(tCount,9) = max(choiceRT); %This ensures we only record one RT. Errors can be caused by ultra-fast switching
  task.output.raw(tCount,10) = (discoOnset - loopStartTime);
  task.output.raw(tCount,11) = discoResponse;
  task.output.raw(tCount,12) = max(discoRT);
  if payout == 5
    payout = 0;
  end
  task.output.raw(tCount,13) = payout;
  % save task structure every trial (much faster than writing to text file)
  save(subOutputMat,'task');

end
% End of experiment screen. We clear the screen once they have made their
% response
payout = nansum(task.output.raw(:,13));
task.payout = payout;
endText = ['Sharing task ',thisRun,' complete! \n\nYou earned ',num2str(payout), ' pennies.'];
DrawFormattedText(win, endText,...
    'center', 'center', drs.stim.white);
Screen('Flip', win);
  
for kn = 1:length(keys.response_indices)
    KbQueueRelease(keys.response_indices(kn));
end

% write output text file for redundancy
if subject.run ~= 0
  fid=fopen(outputTextFile,'a');
  fprintf(fid,'trial_number,condition,left_target,right_target,left_coin,right_coin,trigger_to_share,share_choice,share_rt,trigger_to_statement,statement_choice,statement_rt,coins_earned,statement_text\n');
  for tCount = 1:numTrials
    fprintf(fid,'%u,%u,%u,%u,%u,%u,%4.3f,%u,%4.3f,%4.3f,%u,%4.3f,%u,%s\n',...
    task.output.raw(tCount,1:13), task.input.statement{tCount});
  end
  fclose(fid);
  task.calibration = calibrationOnset;
  task.triggerPulse = triggerPulseTime;
  task.loopStart = loopStartTime;
  task.output.choice.skips = choiceSkips;
  task.output.choice.multi = multiChoiceResponse;
  task.output.choice.multiRT = multiChoiceRT;
  task.output.disco.skips = discoSkips;
  task.output.disco.multi = multiDiscoResponse;
  task.output.disco.multiRT = multiDiscoRT;
  save(subOutputMat,'task');
end

disp('Waiting for key');
KbStrokeWait(keys.keyboard_index);

KbQueueRelease(keys.keyboard_index);
KbQueueRelease(keys.trigger_index);

end
