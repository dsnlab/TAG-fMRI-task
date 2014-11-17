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
inputFile = [subID,'_dsd_',thisRun,'.txt'];
% load trialMatrix
fid=fopen(inputFile);
trialMatrix=textscan(fid,'%u%u%u%u%u%u%f%f%s\n','delimiter',',');
numTrials = length(trialMatrix{1});

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
WaitSecs(3);
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

%% trigger pulse code
KbTriggerWait(drs.keys.trigger);
disabledTrigger = DisableKeysForKbCheck(drs.keys.trigger);
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
  [~,choiceOnset] = Screen('Flip',win);
  while (GetSecs - choiceOnset) < 3
    [ pressed, firstPress]=KbQueueCheck(drs.keys.deviceNum);
    if chose == 0;
      if pressed
        choiceRT = firstPress(find(firstPress)) - choiceOnset;
        if find(firstPress(leftKeys))
            choiceResponse = 1;
        elseif find(firstPress(rightKeys))
            choiceResponse = 2;
        end
        drawChoiceFeedback(win,drs.stim,targets,choiceResponse);
      end
      chose = 1;
    else
      if pressed
        multiChoiceResponse = [multiChoiceResponse choiceResponse];
        multiChoiceRT =[multiChoiceRT choiceRT];
        choiceRT = firstPress(find(firstPress)) - choiceOnset;
        if find(firstPress(leftKeys))
            choiceResponse = 1;
        elseif find(firstPress(rightKeys))
            choiceResponse = 2;
        end
        drawChoiceFeedback(win,drs.stim,targets,choiceResponse);
      end
      
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
    if disclosed == 0;
      if pressed
        discoRT = firstPress(find(firstPress)) - discoOnset;
        if find(firstPress(leftKeys))
            discoResponse = 1;
        elseif find(firstPress(rightKeys))
            discoResponse = 2;
        end
        drawDiscoFeedback(win,drs.stim,targets,choiceResponse,discoResponse);
      end
      disclosed = 1;
    else
      if pressed
        multiDiscoResponse = [multiDiscoResponse discoResponse];
        multiDiscoRT =[multiDiscoRT discoRT];
        discoRT = firstPress(find(firstPress)) - discoOnset;
        if find(firstPress(leftKeys))
            discoResponse = 1;
        elseif find(firstPress(rightKeys))
            discoResponse = 2;
        end
        drawDiscoFeedback(win,drs.stim,targets,statement,choiceResponse,discoResponse);
      end
      
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
  % assign output for each trial to dsd.(thisRun).output.raw matrix
  dsd.output.raw(tCount,1) = tCount;
  dsd.output.raw(tCount,2) = trialMatrix{2}(tCount);
  dsd.output.raw(tCount,3) = trialMatrix{3}(tCount);
  dsd.output.raw(tCount,4) = trialMatrix{4}(tCount);
  dsd.output.raw(tCount,5) = trialMatrix{5}(tCount);
  dsd.output.raw(tCount,6) = trialMatrix{6}(tCount);
  dsd.output.raw(tCount,7) = choiceOnset;
  dsd.output.raw(tCount,8) = choiceResponse;
  dsd.output.raw(tCount,9) = choiceRT;
  dsd.output.raw(tCount,10) = discoOnset;
  dsd.output.raw(tCount,11) = discoResponse;
  dsd.output.raw(tCount,16) = discoRT;
  dsd.statement{tCount} = statement;

end
dsd.onset.calibration = calibrationOnset;
dsd.onset.triggerPulse = triggerPulseTime;

% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(win, 'Scan Complete! \n\n We"ll check in momentarily',...
    'center', 'center', drs.stim.white);
Screen('Flip', win);
KbStrokeWait;
Screen('Close',win)