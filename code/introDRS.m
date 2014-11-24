% % DRSINTRO.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   drsIntro.m: a script what runs the introduction to DRS tasks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%     getSubInfo.m (function to collect subject info)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open dialog to get some info from participant
drs = getSubInfo();
% set subID & studyDir (cause I keep forgetting to drill into drs.subID/studyDir)
subID = drs.subID;
studyDir = drs.studyDir;

%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));

% open a window, set more params
[win,winBox] = PsychImaging('OpenWindow',screenNumber,drs.stim.bg);
% flip to get ifi
Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% query button box, set up keys
drs.keys = initKeys;
inputDevice = drs.keys.deviceNum;

%% preface
DrawFormattedText(win, ['Hi, ',drs.demo.name,' !\n\n Welcome to the DRS study.\n\n (press any button to continue)'],...
  'center', 'center', drs.stim.white);
[~,instructionOnset] = Screen('Flip', win);
KbStrokeWait(inputDevice);
DrawFormattedText(win, 'Today, we''re going to do 3 experiments:\n\n    1.\n\n    2.\n\n    3.\n\n',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
WaitSecs(1);
DrawFormattedText(win, 'Today, we''re going to do 3 experiments:\n\n    1. Disclosing for Dollars\n\n    2.\n\n    3.\n\n',...
  'center', 'center', drs.stim.white);
WaitSecs(0.5);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do 3 experiments:\n\n    1. Disclosing for Dollars\n\n    2.Alien Identification\n\n    3.\n\n',...
  'center', 'center', drs.stim.white);
WaitSecs(0.5);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do 3 experiments:\n\n    1. Disclosing for Dollars\n\n    2.Alien Identification\n\n    3.Self or Change?\n\n',...
  'center', 'center', drs.stim.white);
WaitSecs(0.5);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do 3 experiments:\n\n    1. Disclosing for Dollars\n\n    2.Alien Identification\n\n    3.Self or Change?\n\n (press any button to continue)',...
  'center', 'center', drs.stim.white);
WaitSecs(0.5);
Screen('Flip', win);
KbStrokeWait(inputDevice);

%% DSD explanation3
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

dsdImage2=dsdImage2((151:930),(301:1620),:);
imwrite(dsdImage2,'dsdImage2.png')
dsdImage3=dsdImage3((151:930),(301:1620),:);
imwrite(dsdImage3,'dsdImage3.png')
dsdImage4=dsdImage4((151:930),(301:1620),:);
imwrite(dsdImage4,'dsdImage4.png')