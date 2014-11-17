% % RUNDSD.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is a script, not a function, by design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%    (subID)_dsd_(runNum).txt = comma delimited text with per trial input
%    input text columns (%u,%u,%u,%u,%u,%f%f) 
%       1. trialNum
%       2. condition (self vs. friend == 1, self vs. parent == 2, friend vs. parent == 3)
%       3. leftTarget (self == 1, friend == 2, parent == 3)
%       4. rightTarget
%       5. leftCoin (1:4 == 1:4 coins, 5 == 0 coins, for indexing convenience)
%       6. rightCoin
%       7. choiceJitter (%f, amount of time to vary gap b/w choice & disclosure)
%       8. discoJitter (%f, amount of time to vary ITI)
%       9. statement (string w/ self-disclosure statement)
%
%     DRSstim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%     (subID)_info.mat = structure w/ subject specific info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get subID from subNum
if subNum < 10
  subID = ['drs00',num2str(subNum)];
elseif subNum >= 10
  subID = ['drs0',num2str(subNum)];
end
% get thisRun from runNum
thisRun = ['run',num2str(runNum)];
% load subject's drs structure
subFile = [subID,'_info.mat'];
load(subFile);
inputTextFile = [drs.input.path,filesep,subID,'_dsd_',thisRun,'_input.txt'];
outputTextFile = [drs.output.path,filesep,subID,'_dsd_',thisRun,'_output.txt'];
% load trialMatrix
fid=fopen(inputTextFile);
trialMatrix=textscan(fid,'%u%u%u%u%u%u%f%f%s\n','delimiter',',');
fclose(fid);
%% store info from trialMatrix in drs structure
task.input.raw = [trialMatrix{1} trialMatrix{2} trialMatrix{3} trialMatrix{4} trialMatrix{5} trialMatrix{6} trialMatrix{7} trialMatrix{8}];
task.input.condition = trialMatrix{2};
task.input.leftTarget = trialMatrix{3};
task.input.rightTarget = trialMatrix{4};
task.input.leftCoin = trialMatrix{5};
task.input.rightCoin = trialMatrix{6};
task.input.choiceJitter = trialMatrix{7};
task.input.discoJitter = trialMatrix{8};
task.input.statement = trialMatrix{9};
numTrials = length(trialMatrix{1});
task.output.raw = NaN(numTrials,13);
%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));
% open a window, set more params
%[win,winBox] = PsychImaging('OpenWindow',screenNumber,bg,[0 0 1920/2 1080/2],[],'kPsychGUIWindow');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,drs.stim.bg);
% flip to get ifi
Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

drs.keys = initKeys;



%% present during multiband calibration (time shortened for debug)
% remind em' not to squirm!
DrawFormattedText(win, 'Calibrating scanner\n\n Please hold VERY still',...
  'center', 'center', drs.stim.white);
[~,calibrationOnset] = Screen('Flip', win);
WaitSecs(1);
DrawFormattedText(win, 'Sharing Experiment:\n\n Starting in... 3',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
WaitSecs(1);
DrawFormattedText(win, 'Sharing Experiment:\n\n Starting in... 2',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
DrawFormattedText(win, 'Sharing Experiment:\n\n Starting in... 1',...
  'center', 'center', drs.stim.white);
WaitSecs(1);
Screen('Flip', win);
DrawFormattedText(win, 'Sharing Experiment:\n\n Get Ready!',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);

%% trigger pulse code (disabled for debug)
%KbTriggerWait(drs.keys.trigger);
%disabledTrigger = DisableKeysForKbCheck(drs.keys.trigger);
triggerPulseTime = GetSecs;
disp('trigger pulse received, starting experiment');
Screen('Flip', win);

%% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList([drs.keys.buttons drs.keys.kill])=1;
leftKeys = ([drs.keys.b0 drs.keys.b1 drs.keys.b2 drs.keys.b3 drs.keys.b4 drs.keys.left]);
rightKeys = ([drs.keys.b5 drs.keys.b6 drs.keys.b7 drs.keys.b8 drs.keys.b9 drs.keys.right]);
KbQueueCreate(drs.keys.deviceNum, keyList);

% shut off input to command window
% ListenChar(2);
choiceSkips = [];
discoSkips = [];
loopStartTime = GetSecs;
%% trial loop
for tCount = 1:numTrials
  %% set variables for this trial
  targets = [trialMatrix{3}(tCount),trialMatrix{4}(tCount),trialMatrix{5}(tCount),trialMatrix{6}(tCount)];
  choiceJitter = trialMatrix{7};
  discoJitter = trialMatrix{8};
  statement = trialMatrix{9}{tCount};
  choiceResponse = 0;
  choiceRT = NaN;
  discoRT = NaN;
  chose = 0;
  disclosed = 0;
  multiChoiceResponse = [];
  multiChoiceRT =[];
  multiDiscoResponse = [];
  multiDiscoRT =[];
  %% call draw function
  choiceResponse = 0;
  drawHands(win,drs.stim,targets,[0.5 0.5]);
  drawChoice(win,drs.stim,targets);
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.1], [drs.stim.box.choice{1}(1) drs.stim.box.choice{1}(2) drs.stim.box.choice{2}(3) drs.stim.box.choice{2}(4)]);
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.5], [drs.stim.box.coin{1}(1) drs.stim.box.coin{1}(2) drs.stim.box.coin{2}(3) drs.stim.box.coin{2}(4)]);
  KbQueueStart(drs.keys.deviceNum);
  % flip the screen to show choice
  [~,choiceOnset] = Screen('Flip',win);
  % loop for response
  while (GetSecs - choiceOnset) < 3
    [ pressed, firstPress]=KbQueueCheck(drs.keys.deviceNum);
      if pressed
        if chose == 0
          choiceRT = firstPress(find(firstPress)) - choiceOnset;
          chose == 1;
        elseif chose == 1
          multiChoiceResponse = [multiChoiceResponse choiceResponse];
          multiChoiceRT =[multiChoiceRT choiceRT];
          choiceRT = firstPress(find(firstPress)) - choiceOnset;
        end
        if find(firstPress(leftKeys))
            choiceResponse = 1;
        elseif find(firstPress(rightKeys))
            choiceResponse = 2;
        end
        drawChoiceFeedback(win,drs.stim,targets,choiceResponse);
      end   
  end
  
  KbQueueStop(drs.keys.deviceNum)
  %% call draw function
  discoResponse = 0;
  drawYesNo(win,drs.stim,[0.5 0.5]);
  drawDisco(win,drs.stim,targets,statement,choiceResponse);
  KbQueueStart(drs.keys.deviceNum);
  [~,discoOnset] = Screen('Flip',win);
  while (GetSecs - discoOnset) < 3
    [ pressed, firstPress]=KbQueueCheck(drs.keys.deviceNum);
    if pressed
      if disclosed == 0;
        discoRT = firstPress(find(firstPress)) - discoOnset;
        disclosed == 1;
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
      drawDiscoFeedback(win,drs.stim,targets,statement,choiceResponse,discoResponse);
    end
  end
  KbQueueStop(drs.keys.deviceNum)

%%
  KbQueueFlush(drs.keys.deviceNum);
  Screen('Flip',win);
  if choiceResponse == 0
    choiceSkips = [choiceSkips choiceSkips(tCount)];
  end
  if discoResponse == 0
    discoSkips = [discoSkips(tCount) discpSkips(tCount)];
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
  task.output.raw(tCount,9) = choiceRT;
  task.output.raw(tCount,10) = (discoOnset - loopStartTime);
  task.output.raw(tCount,12) = discoResponse;
  task.output.raw(tCount,13) = discoRT;

end
% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(win, 'Scan Complete! \n\nWe will check in momentarily...',...
    'center', 'center', drs.stim.white);
Screen('Flip', win);

fid=fopen(outputTextFile,'a');
for tCount = 1:numTrials
  fprintf(fid,'%u,%u,%u,%u,%u,%u,%4.3f,%u,%4.3f,%4.3f,%u,%4.3f,%s\n',...
  task.output.raw(tCount,1),...
  task.output.raw(tCount,2),...
  task.output.raw(tCount,3),...
  task.output.raw(tCount,4),...
  task.output.raw(tCount,5),...
  task.output.raw(tCount,6),...
  task.output.raw(tCount,7),...
  task.output.raw(tCount,8),...
  task.output.raw(tCount,9),...
  task.output.raw(tCount,10),...
  task.output.raw(tCount,12),...
  task.output.raw(tCount,13),...
  task.input.statement{tCount});
end
fclose(fid);
% task.onsets.calibration = calibrationOnset;
% task.onsets.triggerPulse = triggerPulseTime;
% task.output.choice.skips = choiceSkips;
% task.output.choice.multi = multiChoiceResponse;
% task.output.choice.multiRT = multiChoiceRT;
% task.output.disco.skips = discoSkips;
% task.output.disco.multi = multiDiscoResponse;
% task.output.disco.multiRT = multiDiscoRT;
KbStrokeWait(drs.keys.deviceNum);

Screen('CloseAll')