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

leftKeys = ([drs.keys.b0 drs.keys.b1 drs.keys.b2 drs.keys.b3 drs.keys.b4 drs.keys.left]);
rightKeys = ([drs.keys.b5 drs.keys.b6 drs.keys.b7 drs.keys.b8 drs.keys.b9 drs.keys.right]);

%% preface
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, ['Welcome to the TAG study!\n\n (press any button to continue)'],...
  'center', 'center', drs.stim.white);
[~,instructionOnset] = Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do\n\n two different tasks \n\n (press any button to continue)',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'We''ll do two ''runs'' of each task\n\n and each ''run'' takes ~5-7 minutes \n\n (press any button to continue)',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
DrawFormattedText(win, 'The tasks are: ','center', (drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.white);
DrawFormattedText(win, '1. Sharing Task ','center', (drs.stim.box.yCenter - drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, '2. Change Task ','center', drs.stim.box.yCenter, drs.stim.purple);
DrawFormattedText(win, '(press any button to continue) ','center',(drs.stim.box.yCenter + drs.stim.box.unit), drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
%% Explain DSD
targets = [1 2 2 4];
statement = 'like robots';
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Sharing Task: First, you''ll see a brief statement.','center', (drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.white);
DrawFormattedText(win, 'Decide if this statement describes you.','center', (drs.stim.box.yCenter - drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, 'You''ll have about 4 seconds to decide.','center', drs.stim.box.yCenter, drs.stim.yellow);
DrawFormattedText(win, '(press any button to continue) ','center',(drs.stim.box.yCenter + drs.stim.box.unit), drs.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
WaitSecs(1);

%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
choiceResponse=1;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,statement);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left for yes)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawDiscoFeedback(win,drs.stim,targets,statement,1);
WaitSecs(1);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
choiceResponse=2;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,statement);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press right for no)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawDiscoFeedback(win,drs.stim,targets,statement,2);
WaitSecs(1);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Next, decide whether to share this statement\nwith your friend or keep it private, \n\n(with 2-4 pennies presented beneath the text)... ','center',(drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.white);
DrawFormattedText(win, 'At the end of the task, you''ll be paid \n\nthe number of pennies you earn','center',(drs.stim.box.yCenter), drs.stim.yellow);
DrawFormattedText(win, '(press any button to continue)','center',(drs.stim.box.yCenter + 2*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets,statement,2);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left to keep it private)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawChoiceFeedback(win,drs.stim,targets,statement,2,1);
WaitSecs(1);
%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets,statement,2);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press right to share with your friend)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
drawChoiceFeedback(win,drs.stim,targets,statement,2,2);
WaitSecs(1);

%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Don''t rush, but choose quickly \n\nbecause you only have about 3 seconds ','center',(drs.stim.box.yCenter - 2*drs.stim.box.unit), drs.stim.yellow);
DrawFormattedText(win, '(press any button)','center',(drs.stim.box.yCenter + 2*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);
WaitSecs(1);

%%
statement = 'I hate the smell of paint';
targets = [1 2 3 2];
DrawFormattedText(win, 'Sharing Task: try it out! ','center',(drs.stim.box.yCenter - 4*drs.stim.box.unit), drs.stim.yellow);
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets,statement,2);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press any button to start the trial)','center',(drs.stim.box.yCenter + 3*drs.stim.box.unit), drs.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);

runDSD(drs.subNum,0);


