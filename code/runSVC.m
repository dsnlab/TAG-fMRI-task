function [task] = runSVC(subNum,runNum)
% % RUNSVC.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runSVC( subNum, runNum )
%
%   subNum && runNum are scalar
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%--> (subID)_svc_(runNum).txt = comma delimited text with per trial input
%
%    input text columns (%u,%u,%u,%u,%u,%f%f) 
%       1. trialNum
%       2. condition (1/2 == self (good/cool), 3/4 == change (good/cool) )
%       3. jitter
%       4. reverse coded (0 == normal, 1 == reverse coded)
%       5. syllables
%       6. trait (string w/ trait adjective)
%
%-->  DRSstim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%--> (subID)_info.mat = structure w/ subject specific info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% get subID from subNum
if subNum < 10
  subID = ['drs00',num2str(subNum)];
elseif subNum < 100
  subID = ['drs0',num2str(subNum)];
else
  subID = ['drs',num2str(subNum)];
end
% get thisRun from runNum
thisRun = ['run',num2str(runNum)];
% load subject's drs structure
subFile = [subID,'_info.mat'];
load(subFile);
inputTextFile = [drs.input.path,filesep,subID,'_svc_',thisRun,'_input.txt'];
outputTextFile = [drs.output.path,filesep,subID,'_svc_',thisRun,'_output.txt'];
% load trialMatrix
fid=fopen(inputTextFile);
trialMatrix=textscan(fid,'%u%u%f%u%u%s\n','delimiter',',');
fclose(fid);
%% store info from trialMatrix in drs structure
task.input.raw = [trialMatrix{1} trialMatrix{2} trialMatrix{3} trialMatrix{4} trialMatrix{5}];
task.input.condition = trialMatrix{2};
task.input.jitter = trialMatrix{3};
task.input.reverse = trialMatrix{4};
task.input.syllables = trialMatrix{5};
task.input.trait = trialMatrix{6};
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
inputDevice = drs.keys.deviceNum;

%% present during multiband calibration (time shortened for debug)
% remind em' not to squirm!
DrawFormattedText(win, 'Calibrating scanner\n\n Please hold VERY still',...
  'center', 'center', drs.stim.white);
[~,calibrationOnset] = Screen('Flip', win);
WaitSecs(.1);
DrawFormattedText(win, 'Self or Change? Experiment:\n\n Starting in... 3',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
WaitSecs(.1);
DrawFormattedText(win, 'Self or Change? Experiment:\n\n Starting in... 2',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
DrawFormattedText(win, 'Self or Change? Experiment:\n\n Starting in... 1',...
  'center', 'center', drs.stim.white);
WaitSecs(.1);
Screen('Flip', win);
DrawFormattedText(win, 'Self or Change? Experiment:\n\n Get Ready!',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);

% trigger pulse code (disabled for debug)
%KbTriggerWait(drs.keys.trigger,inputDevice); % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
%disabledTrigger = DisableKeysForKbCheck(drs.keys.trigger);
triggerPulseTime = GetSecs;
disp('trigger pulse received, starting experiment');
Screen('Flip', win);

%% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList(drs.keys.buttons)=1;
keyList(drs.keys.kill)=1;
leftKeys = ([drs.keys.b0 drs.keys.b1 drs.keys.b2 drs.keys.b3 drs.keys.b4 drs.keys.left]);
rightKeys = ([drs.keys.b5 drs.keys.b6 drs.keys.b7 drs.keys.b8 drs.keys.b9 drs.keys.right]);
KbQueueCreate(inputDevice, keyList);
traitSkips = [];
blockStartTrials = 1:4:48;
loopStartTime = GetSecs;
%% trial loop
for tCount = 1:numTrials
  %% set variables for this trial
  condition = trialMatrix{2}(tCount);
  traitJitter = trialMatrix{3}(tCount);
  trait = trialMatrix{6}{tCount};
  traitResponse = 0;
  traitRT = NaN;
  chose = 0;
  multiTraitResponse = [];
  multiTraitRT =[];
  if find(blockStartTrials==tCount)
    switch condition
    case 1 
      iconMatrix = drs.stim.promptMatrix{1};
      promptText = 'true about me?';
      promptColor = drs.stim.promptColors{1};
    case 2 
      iconMatrix = drs.stim.promptMatrix{1};
      promptText = 'true about me?';
      promptColor = drs.stim.promptColors{1};
    case 3
      iconMatrix = drs.stim.promptMatrix{2};
      promptText = 'can it change?';
      promptColor = drs.stim.promptColors{2};
    case 4
      iconMatrix = drs.stim.promptMatrix{2};
      promptText = 'can it change?';
      promptColor = drs.stim.promptColors{2};
    end
    % draw prompt with instructions
    iconTex = Screen('MakeTexture',win,iconMatrix);
    Screen('DrawTexture',win,iconTex,[],drs.stim.box.prompt);
    Screen('TextSize', win, 80);
    Screen('TextFont', win, 'Arial');
    DrawFormattedText( win, promptText, 'center', 'center', promptColor );
    Screen('Flip',win);
    WaitSecs(3.6);
  end
  %% call draw function
  drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);
  KbQueueStart(inputDevice);
  % flip the screen to show trait
  [~,traitOnset] = Screen('Flip',win);
  %loop for response
  while (GetSecs - traitOnset) < 3.6
    [ pressed, firstPress]=KbQueueCheck(inputDevice);
      if pressed
        if chose == 0
          traitRT = firstPress(find(firstPress)) - traitOnset;
        elseif chose == 1
          multiTraitResponse = [multiTraitResponse traitResponse];
          multiTraitRT =[multiTraitRT traitRT];
          traitRT = firstPress(find(firstPress)) - traitOnset;
        end

        if find(firstPress(leftKeys))
            traitResponse = 1;
        elseif find(firstPress(rightKeys))
            traitResponse = 2;
        end
         chose=1;
        drawTraitFeedback(win,drs.stim,trait,condition,traitResponse);
      end   
  end
  KbQueueStop(inputDevice);
  drawTrait(win,drs.stim,' ',condition,[0.5 0.5]);
  Screen('Flip',win);
  if traitJitter > 5
    [~,traitOffset] = Screen('Flip',win);
  else
    traitOffset = GetSecs;
  end
  WaitSecs('UntilTime',(traitOnset + 3.6 + traitJitter));
  %%
  if traitResponse == 0
    traitSkips = [traitSkips tCount];
  end
  % assign output for each trial to task.(thisRun).output.raw matrix
  task.output.raw(tCount,1) = tCount;
  task.output.raw(tCount,2) = trialMatrix{2}(tCount);
  task.output.raw(tCount,3) = (traitOnset - loopStartTime);
  task.output.raw(tCount,4) = traitRT;
  task.output.raw(tCount,5) = traitResponse;
  task.output.raw(tCount,6) = trialMatrix{4}(tCount);
  task.output.raw(tCount,7) = trialMatrix{5}(tCount);

end
% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(win, 'Scan Complete! \n\nWe will check in momentarily...',...
    'center', 'center', drs.stim.white);
Screen('Flip', win);

if runNum ~= 0
  fid=fopen(outputTextFile,'a');
  for tCount = 1:numTrials
    fprintf(fid,'%u,%u,%4.3f,%4.3f,%u,%u,%u,%s\n',...
    task.output.raw(tCount,1:7), task.input.trait{tCount});
  end
  fclose(fid);
end

task.calibration = calibrationOnset;
task.triggerPulse = triggerPulseTime;
task.output.skips = traitSkips;
task.output.multi.response = multiTraitResponse;
task.output.multi.RT = multiTraitRT;

KbQueueRelease;
KbStrokeWait(inputDevice);
Screen('CloseAll');

return