function [task] = runSVC_core(subject, keys, win)
% % runSVC_core.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runSVC_core(subject, keys, win )
%
%   Called by runSVC and introTAG
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

    % get directories
    thisfile = mfilename('fullpath'); % studyDir/task/code/thisfile.m
    taskDir = fileparts(fileparts(thisfile));
    inputDir = fullfile(taskDir, 'input');
    outputDir = fullfile(taskDir, 'output');
    if not(isfolder(outputDir))
        mkdir(outputDir)
    end
    

    % get subID from subNum
    subID = ['tag',num2str(subject.number, '%03d')];
    % prefix for files
    prefix = [subID,'_wave_',num2str(subject.wave)];

    % load subject's drs structure
    subInfoFile = fullfile(inputDir, [prefix,'_info.mat']);
    load(subInfoFile, 'drs');
    thisRun = ['run',num2str(subject.run)];

    %%
    if strcmp(thisRun,'run0')
      inputTextFile = fullfile(inputDir,'svc_practice_input.txt');
      subOutputMat = fullfile(outputDir, [prefix,'_rpe_',thisRun,'.mat']);
    else
      subOutputMat = fullfile(outputDir, [prefix,'_svc_',thisRun,'.mat']);
      inputTextFile = fullfile(inputDir, [prefix,'_svc_',thisRun,'_input.txt']);
      outputTextFile = fullfile(outputDir, [prefix,'_svc_',thisRun,'_output.txt']);
    end
    
    if not(isfile(inputTextFile))
        fprintf('Warning: file not found %s.', inputTextFile);
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

    %%
    screenNumber = max(Screen('Screens'));

    % flip to get ifi

    HideCursor();
    drs.stim.box = ConvertStim(drs.stim.box, screenNumber); %jcs

    Screen('Flip', win);
    drs.stim.ifi = Screen('GetFlipInterval', win);

    Screen('TextSize', win, floor(50 * drs.stim.box.yratio)); %jcs
    %Screen('TextSize', win, 50);
    Screen('TextFont', win, 'Arial');

    % to inform subject about upcoming task
    prefaceText = ['Coming up... ','Change Task: ',thisRun, '\n\n(left for ''yes'', right for ''no'') '];
    DrawFormattedText(win, prefaceText, 'center', 'center', drs.stim.orange);
    [~,programOnset] = Screen('Flip',win);
    disp("waiting for input from " + keys.keyboard_name);
    KbStrokeWait(keys.keyboard_index);

    %% remind em' not to squirm!

    DrawFormattedText(win, 'Getting scan ready...\n\n hold really still!',...
      'center', 'center', drs.stim.white);
    [~,calibrationOnset] = Screen('Flip', win);

    % we need to create and release the trigger queue
    % when we've already used KbStrokeWait with the same device id
    KbQueueCreate(keys.trigger_index);
    KbQueueRelease(keys.trigger_index);

    % trigger pulse code (disabled for debug)
    disp(keys.trigger);
    if subject.run == 0
        disp("waiting for input from " + keys.keyboard_name);
        KbStrokeWait(keys.keyboard_index);

    else
        disp("waiting for trigger from " + keys.trigger_name);
        KbTriggerWait(keys.trigger, keys.trigger_index); 

        disabledTrigger = DisableKeysForKbCheck(keys.trigger);
        triggerPulseTime = GetSecs;
        disp('trigger pulse received, starting experiment');
    end
    Screen('Flip', win);

    %% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
    keyList = zeros(1,256);
    keyList(keys.kill)=1; % unused? Should be in internal keyboard queue
    leftKeys = ([keys.b0 keys.b1 keys.b2 keys.b3 keys.b4]);
    rightKeys = ([keys.b5 keys.b6 keys.b7 keys.b8 keys.b9]);
    keyList(leftKeys) = 1;
    keyList(rightKeys) = 1;

    for kn = 1:length(keys.response_indices)
        KbQueueCreate(keys.response_indices(kn), keyList);
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
        %Screen('TextSize', win, 80);
        Screen('TextSize', win, floor(80 * drs.stim.box.yratio));
        Screen('TextFont', win, 'Arial');
        DrawFormattedText( win, promptText, 'center', 'center', promptColor );
        Screen('Flip',win);
        WaitSecs(4.7);
      end
      %% call draw function
      drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);

      for kn = 1:length(keys.response_indices)
        KbQueueStart(keys.response_indices(kn));
      end
      % flip the screen to show trait
      [~,traitOnset] = Screen('Flip',win);
      %loop for response
      while (GetSecs - traitOnset) < 4.7
        [ pressed, firstPress]=ResponseCheck(keys.response_indices);
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
      for kn = 1:length(keys.response_indices)
        KbQueueStop(keys.response_indices(kn));
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

    for kn = 1:length(keys.response_indices)
      KbQueueRelease(keys.response_indices(kn));
    end

    % End of experiment screen. We clear the screen once they have made their
    % response
    DrawFormattedText(win, 'Scan Complete! \n\nWe will check in momentarily...',...
        'center', 'center', drs.stim.white);
    Screen('Flip', win);

    if subject.run ~= 0
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

    disp('Waiting for key');
    KbStrokeWait(keys.keyboard_index);


end
