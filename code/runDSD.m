function [ task ] = runDSD( drs )
% % RUNDSD.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   usage: don't call this directly, it's called by selectTask 
%
%   input: drs = subject info structure created by getSubInfo.m
%          stim = stimulus structure created by makeDSDStimulus.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: wem3
%   written: 1411155
%   modified: 
%
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

% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));
% open a window, set more params
%[win,winBox] = PsychImaging('OpenWindow',screenNumber,bg,[0 0 1920/2 1080/2],[],'kPsychGUIWindow');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,stim.bg);
% flip to get ifi
Screen('Flip', win);
pos.ifi = Screen('GetFlipInterval', win);
% Screen('TextSize', win, 60);
Screen('TextSize', win, 70);
Screen('TextFont', win, 'Arial');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

keys = initKeys;
runNum = str2num(inputFile(end-4));
task.name = inputFile(end-7:end-4);

% load trialMatrix
fid=fopen(inputFile);
trialMatrix=textscan(fid,'%u%u%u%u%u%u%f%f%s\n','delimiter',',');
task.numTrials = length(trialMatrix{1});

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
KbTriggerWait(keys.trigger);
disabledTrigger = DisableKeysForKbCheck(keys.trigger);
triggerPulseTime = GetSecs;
disp('trigger pulse received, starting experiment');
Screen('Flip', win);

%% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList([dis.keys.buttons dis.keys.kill])=1;
leftKeys = ([dis.keys.b0 dis.keys.b1 dis.keys.b2 dis.keys.b3 dis.keys.b4 dis.keys.left]);
rightKeys = ([dis.keys.b5 dis.keys.b6 dis.keys.b7 dis.keys.b8 dis.keys.b9 dis.keys.right]);
KbQueueCreate(inputDevice, keyList);

% shut off input to command window
% ListenChar(2);

%% trial loop
for tCount = 1:task.numTrials
  targets = [trialMatrix{3}(tCount),trialMatrix{4}(tCount),trialMatrix{5}(tCount),trialMatrix{6}(tCount)];
  choiceJitter = trialMatrix{7};
  discoJitter = trialMatrix{8};
  %% try with KbPressWait...
  drawChoice(win,drs,targets,2);
  [~, choiceOnset] = Screen('Flip',win);
  % collect responses
  stopChoiceTime = GetSecs+3;
  [choiceSecs, choicePress] = KbPressWait(inputDevice,stopChoiceTime);
  if find(choicePress)
      choiceKey = find(choicePress);
      choiceRT = choiceSecs - choiceOnset;
  else
      choiceKey = 0;
  end

  % this looks clunky, but it's more consistent and faster than any other
  % way I could figure out to correctly check the choiceKey against a
  % vector. Order is based on likelihood of having selected that key,
  % based on which finger is assigned on the button box (less relevant
  % for keyboard)

  switch choiceKey
      case 0
          DrawFormattedText(win, 'too slow!', 'center', dis.pos.yStatement, dis.shades.white);
          choiceResponse = NaN;
          choiceRT = NaN;
      case dis.keys.b3
          choiceResponse = 0;
      case dis.keys.b6
          choiceResponse = 1;
      case dis.keys.b2
          choiceResponse = 0;
      case dis.keys.b7
          choiceResponse = 1;
      case dis.keys.b4
          choiceResponse = 0;
      case dis.keys.b5
          choiceResponse = 1;
      case dis.keys.b1
          choiceResponse = 0;
      case dis.keys.b8
          choiceResponse = 1;
      case dis.keys.b0
          choiceResponse = 0;
      case dis.keys.b9
          choiceResponse = 1;
  end

  % blink a box around the chosen answer
  drawChoiceFeedback(2,win,tCount,stim,pos,choiceResponse);
  % Screen('Flip',win);

  % draw the option they chose
  drawChoice(win,tCount,stim,pos,choiceResponse);
  % draw the statement
  DrawFormattedText(win, (stim.statement{tCount}), 'center',dis.pos.yStatement, dis.shades.white);
  waitTime = (stopChoiceTime - GetSecs  + stim.choiceJitter{tCount});
  WaitSecs(waitTime);
  %% aaaaaand, go!
  KbQueueFlush(inputDevice);
  %% try with KbPressWait...
  drawChoice(win,tCount,stim,pos,choiceResponse);
  [~, discoOnset] = Screen('Flip',win);
  % collect responses
  stopDiscoTime = GetSecs+3;
  [discoSecs, discoPress] = KbPressWait(inputDevice,stopDiscoTime);
  if find(discoPress)
      discoKey = find(discoPress);
      discoRT = discoSecs - discoOnset;
  else
      discoKey = NaN;
      discoRT = NaN;
  end
  switch discoKey
      case 0
          DrawFormattedText(win, 'too slow!', 'center', dis.pos.yStatement, dis.shades.white);
          discoResponse = NaN;
          discoRT = NaN;
      case dis.keys.b3
          discoResponse = 0;
      case dis.keys.b6
          discoResponse = 1;
      case dis.keys.b2
          discoResponse = 0;
      case dis.keys.b7
          discoResponse = 1;
      case dis.keys.b4
          discoResponse = 0;
      case dis.keys.b5
          discoResponse = 1;
      case dis.keys.b1
          discoResponse = 0;
      case dis.keys.b8
          discoResponse = 1;
      case dis.keys.b0
          discoResponse = 0;
      case dis.keys.b9
          discoResponse = 1;
  end


  KbQueueFlush(inputDevice);
  Screen('Flip',win);
  waitTime = (stopDiscoTime - GetSecs + stim.discoJitter{tCount});
  WaitSecs(waitTime);

  % assign output for each trial to rawOutput matrix
  rawOutput(tCount,1) = tCount;
  rawOutput(tCount,2) = choiceOnset;
  rawOutput(tCount,3) = choiceResponse;
  rawOutput(tCount,4) = choiceRT;
  rawOutput(tCount,5) = discoOnset;
  rawOutput(tCount,6) = discoResponse;
  rawOutput(tCount,7) = discoRT;

  % write output every trial
  outputFile = fullfile(dis.paths.output, [dis.info.subID,'_',task.name,'_',task.run,'.txt']);
  dlmwrite(outputFile,rawOutput(tCount,:),'-append');

  % save it to the structure as well
  dis.(task.name).(task.run).choiceOnset(tCount) = choiceOnset;
  dis.(task.name).(task.run).choiceResponse(tCount) = choiceResponse;
  dis.(task.name).(task.run).choiceRT(tCount) = choiceRT;
  dis.(task.name).(task.run).discoOnset(tCount) = discoOnset;
  dis.(task.name).(task.run).discoResponse(tCount) = discoResponse;
  dis.(task.name).(task.run).discoRT(tCount) = discoRT;
end
dis.(task.name).(task.run).onset.calibration = calibrationOnset;
dis.(task.name).(task.run).onset.triggerPulse = triggerPulseTime;
% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(win, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', dis.shades.white);
Screen('Flip', win);
ListenChar(0)
KbStrokeWait;
Screen('Close',win)

% save augmented drsInfoMat
save((drs.paths.OUTfo),'drs')

return