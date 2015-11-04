% % DRSINTRO.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   drsIntro.m: a script what runs the introduction to DRS tasks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2222222232%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:6666663663330
%     getSubInfo.m (function to collect subject info)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open dialog to get some info from participant
Screen('Preference', 'SkipSyncTests', 1);
drs = getSubInfo();
% set subID & studyDir (cause I keep forgetting to drill into drs.subID/studyDir)
subID = drs.subID;
studyDir = drs.studyDir;

%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('default');
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));

% open a window, set more params
PsychImaging('PrepareConfiguration');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,drs.stim.bg);
% flip to get ifi
Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% query button box, set up keys
drs.keys = initKeys;
inputDevice = drs.keys.deviceNum;

%% preface
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, ['Hi, ',drs.demo.name,' !\n\n Welcome to the DRS study.\n\n (press any button to continue)'],...
  'center', 'center', drs.stim.white);
[~,instructionOnset] = Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do\n\n three different tasks \n\n (press any button to continue)',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'We''ll do two ''runs'' of each task\n\n and each ''run'' takes ~5-7 minutes \n\n (press any button to continue)',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
DrawFormattedText(win, 'The tasks are: ','center', (drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.white);
DrawFormattedText(win, '1. Sharing Task ',(drs.stim.box.xCenter - 3*drs.stim.box.unit), (drs.stim.box.yCenter - drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, '2. Alien Identification ',(drs.stim.box.xCenter - 3*drs.stim.box.unit), drs.stim.box.yCenter, drs.stim.purple);
DrawFormattedText(win, '3. Change Task ',(drs.stim.box.xCenter - 3*drs.stim.box.unit),(drs.stim.box.yCenter + drs.stim.box.unit), drs.stim.orange);
DrawFormattedText(win, '(press any button to continue) ','center',(drs.stim.box.yCenter + 2*drs.stim.box.unit), drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
%% Explain DSD
targets = [1 2 2 4];
statement = 'I think robots are awesome';
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: on each trial, you''ll see two of these three:, \n\n(with 0-4 gold coins presented beneath the text)... ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, [drs.stim.targetText{1},' : answer yes/no question privately'],'center',(drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.targetColors{1});
DrawFormattedText(win, [drs.stim.targetText{2},' : share answer via email '],'center',(drs.stim.box.yCenter - drs.stim.box.unit), drs.stim.targetColors{2});
DrawFormattedText(win, [drs.stim.targetText{3},' : share answer via email '],'center', drs.stim.box.yCenter,drs.stim.targetColors{3});
DrawFormattedText(win, 'At the end of the experiment, you''ll be paid \n\nbased on the number of gold coins you earn','center',(drs.stim.box.yCenter + 2*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, '(press any button to continue)','center',(drs.stim.box.yCenter + 4*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);

%%
DrawFormattedText(win, 'Sharing Task: example ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press any button to continue)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: on each trial... ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, 'to choose the left option, \n\n press the left index finger button ','center','center', drs.stim.white,[],[],[],[],[],drs.stim.box.statement);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left index finger button)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawChoiceFeedback(win,drs.stim,targets,1);
WaitSecs(1);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: on each trial... ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, 'to choose the right option, \n\n press the right index finger button ','center','center', drs.stim.white,[],[],[],[],[],drs.stim.box.statement);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press right index finger button)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawChoiceFeedback(win,drs.stim,targets,2);
WaitSecs(1);

%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: on each trial... ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, 'don''t rush, but choose quickly \n\nbecause you only have about 3 seconds','center','center', drs.stim.white,[],[],[],[],[],drs.stim.box.statement);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press any button)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawChoiceFeedback(win,drs.stim,targets,2);
WaitSecs(1);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: next, you''ll see a brief statement','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
choiceResponse=1;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,targets,statement,choiceResponse);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left for yes)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawDiscoFeedback(win,drs.stim,targets,statement,1,1);
WaitSecs(1);

%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: you have about 4 seconds to decide','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
choiceResponse=1;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,targets,statement,choiceResponse);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left for yes)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawDiscoFeedback(win,drs.stim,targets,statement,1,1);
WaitSecs(1);
%%
statement = 'I hate the smell of paint';
targets = [2 3 3 2];
DrawFormattedText(win, 'Sharing Task: try it out! ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press any button to start the trial)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
%%
 choiceResponse = 0;
  drawHands(win,drs.stim,targets,[0.5 0.5]);
  drawChoice(win,drs.stim,targets);
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.1], [drs.stim.box.choice{1}(1) drs.stim.box.choice{1}(2) drs.stim.box.choice{2}(3) drs.stim.box.choice{2}(4)]);
  Screen('FillRect',win,[drs.stim.bg(1:3) 0.5], [drs.stim.box.coin{1}(1) drs.stim.box.coin{1}(2) drs.stim.box.coin{2}(3) drs.stim.box.coin{2}(4)]);
  KbQueueCreate(inputDevice);
  KbQueueStart(inputDevice);
  % flip the screen to show choice
  [~,choiceOnset] = Screen('Flip',win);
  %loop for response
  while (GetSecs - choiceOnset) < 3
    [ pressed, firstPress]=KbQueueCheck(inputDevice);
    display(pressed);
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
        elseif find(firstPress(rightKeys))
            choiceResponse = 2;
        end
         chose=1;
        drawChoiceFeedback(win,drs.stim,targets,choiceResponse);
      end   
  end
%   KbQueueStop(inputDevice);


