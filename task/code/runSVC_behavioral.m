function [task] = runSVC(subNumArg, waveNumArg, runNumArg)
% % RUNSVC.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runSVC( subNumArg, waveNumArg, runNumArg )
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
%       2. condition (1-6)
%       3. jitter
%       4. reverse coded (0 == normal, 1 == reverse coded) !!See word-list in design/materials/
%       5. syllables
%       6. trait (string w/ trait adjective)
%
%-->  DRSstim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%--> (subID)_info.mat = structure w/ subject specific info
%
% Conditions are:
%   1. Self good
%   2. Self withdrawn
%   3. Self aggressive
%   4. Change good
%   5. Change withdrawn
%   6. Change aggressive
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
rng('default');
Screen('Preference', 'SkipSyncTests', 1);

%% get subID from subNum
if subNum < 10
  subID = ['tag00',num2str(subNum)];
elseif subNum < 100
  subID = ['tag0',num2str(subNum)];
else
  subID = ['tag',num2str(subNum)];
end
% get thisRun from runNum
thisRun = ['run',num2str(runNum)];
% load subject's drs structure
subInfoFile = ['input', filesep, subID,'_wave_',num2str(waveNum),'_info.mat'];
load(subInfoFile);
thisRun = ['run',num2str(runNum)];

%% added jcs
if ~isfolder(drs.input.path)
    disp("Select input folder");
    drs.input.path = uigetdir(pwd, 'Select input folder');
end

if ~isfolder(drs.output.path)
    disp("Select output folder");
    drs.output.path = uigetdir(pwd, 'Select output folder');
end

%%
if strcmp(thisRun,'run0')
  inputTextFile = [drs.input.path,filesep,'svc_practice_input.txt'];
  subOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_rpe_',thisRun,'.mat'];
else
  subOutputMat = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'.mat'];
  inputTextFile = [drs.input.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'_input.txt'];
  outputTextFile = [drs.output.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'_output.txt'];
end

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

%% load key definitions file 
% Run ButtonSetup.m first to verify assignments
disp("Open key file");
keyfile = uigetfile('*.mat', 'Open key file');
if keyfile
    drs.keys = ButtonLoad(keyfile);
else
    return;
end

%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));

% added jcs
% oldres = SetResolution(screenNumber, %1440, 900); %1920, 1080); %

% open a window, set more params
%[win,winBox] = PsychImaging('OpenWindow',screenNumber,bg,[0 0 1920/2 1080/2],[],'kPsychGUIWindow');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,drs.stim.bg);
% flip to get ifi

%drs.stim.box = ConvertStim(drs.stim.box, screenNumber);

HideCursor();

Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% to inform subject about upcoming task
prefaceText = ['Coming up... ','Change Task: ',thisRun, '\n\n(left for ''yes'', right for ''no'') '];
DrawFormattedText(win, prefaceText, 'center', 'center', drs.stim.orange);
[~,programOnset] = Screen('Flip',win);
KbStrokeWait(drs.keys.keyboard_index);

%% present during multiband calibration (time shortened for debug)
% skip the long wait for training session
if runNum == 0
    calibrationTime = 1;
else
    calibrationTime = 17;
end
% remind em' not to squirm!
DrawFormattedText(win, 'Getting scan ready...\n\n hold really still!',...
  'center', 'center', drs.stim.white);
[~,calibrationOnset] = Screen('Flip', win);

%WaitSecs(calibrationTime);
%DrawFormattedText(win, 'Self or Change Task\n\n Starting in... 5',...
%  'center', 'center', drs.stim.white);
%Screen('Flip', win);
%WaitSecs(1);
%DrawFormattedText(win, 'Self or Change Task\n\n Starting in... 4',...
%  'center', 'center', drs.stim.white);
%Screen('Flip', win);
%DrawFormattedText(win, 'Self or Change Task\n\n Starting in... 3',...
%  'center', 'center', drs.stim.white);
%WaitSecs(1);
%Screen('Flip', win);
%DrawFormattedText(win, 'Self or Change Task\n\n Get Ready!',...
%  'center', 'center', drs.stim.white);
%WaitSecs(1);
%Screen('Flip', win);

% Possibly a Psychtoolbox bug:
% we need to create and release the trigger queue
% when we've already used KbStrokeWait with the same device id
KbQueueCreate(drs.keys.trigger_index);
KbQueueRelease(drs.keys.trigger_index);

% trigger pulse code (disabled for debug)
disp(drs.keys.trigger);
if runNum == 0
    KbStrokeWait(drs.keys.keyboard_index);
else
    KbTriggerWait(drs.keys.trigger, drs.keys.trigger_index); 
    % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
    disabledTrigger = DisableKeysForKbCheck(drs.keys.trigger);
    triggerPulseTime = GetSecs;
    disp('trigger pulse received, starting experiment');
end
Screen('Flip', win);

%% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList(drs.keys.kill)=1; % unused? Should be in internal keyboard queue
leftKeys = ([drs.keys.b0 drs.keys.b1 drs.keys.b2 drs.keys.b3 drs.keys.b4]);
rightKeys = ([drs.keys.b5 drs.keys.b6 drs.keys.b7 drs.keys.b8 drs.keys.b9]);
keyList(leftKeys) = 1;
keyList(rightKeys) = 1;

for kn = 1:length(drs.keys.response_indices)
    KbQueueCreate(drs.keys.response_indices(kn), keyList);
end

traitSkips = [];
blockStartTrials = 1:5:50;
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
      iconMatrix = drs.stim.promptMatrix{1};
      promptText = 'true about me?';
      promptColor = drs.stim.promptColors{1};
    case 4
      iconMatrix = drs.stim.promptMatrix{2};
      promptText = 'can it change?';
      promptColor = drs.stim.promptColors{2};
    case 5
      iconMatrix = drs.stim.promptMatrix{2};
      promptText = 'can it change?';
      promptColor = drs.stim.promptColors{2};
    case 6
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
    WaitSecs(4.7);
  end
  %% call draw function
  drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);
  
  for kn = 1:length(drs.keys.response_indices)
    KbQueueStart(drs.keys.response_indices(kn));
  end
  % flip the screen to show trait
  [~,traitOnset] = Screen('Flip',win);
  %loop for response
  while (GetSecs - traitOnset) < 4.7
    [ pressed, firstPress]=ResponseCheck(drs.keys.response_indices);
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
  for kn = 1:length(drs.keys.response_indices)
    KbQueueStop(drs.keys.response_indices(kn));
  end
  drawTrait(win,drs.stim,' ',condition,[0.5 0.5]);
  Screen('Flip',win);
  if traitJitter > 4.7
    [~,traitOffset] = Screen('Flip',win);
  else
    traitOffset = GetSecs;
  end
  WaitSecs('UntilTime',(traitOnset + 4.7 + traitJitter));
  %%
  if traitResponse == 0
    traitSkips = [traitSkips tCount];
  end
  % assign output for each trial to task.(thisRun).output.raw matrix
  task.output.raw(tCount,1) = tCount;
  task.output.raw(tCount,2) = trialMatrix{2}(tCount);
  task.output.raw(tCount,3) = (traitOnset - loopStartTime);
  task.output.raw(tCount,4) = max(traitRT); %This ensures we only record one RT. Errors can be caused by ultra-fast switching
  task.output.raw(tCount,5) = traitResponse;
  task.output.raw(tCount,6) = trialMatrix{4}(tCount);
  task.output.raw(tCount,7) = trialMatrix{5}(tCount);
  save(subOutputMat,'task');

end

for kn = 1:length(drs.keys.response_indices)
  KbQueueRelease(drs.keys.response_indices(kn));
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
  task.calibration = calibrationOnset;
  task.triggerPulse = triggerPulseTime;
  task.output.skips = traitSkips;
  task.output.multi.response = multiTraitResponse;
  task.output.multi.RT = multiTraitRT;
  save(subOutputMat,'task');
end

KbStrokeWait(drs.keys.keyboard_index);
Screen('Close', win);
SetResolution(screenNumber, oldres);
return
