function introTAG()

% % DRSINTRO.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   drsIntro.m: a script what runs the introduction to DRS tasks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2222222232%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%     getSubInfo.m (function to collect subject info)
%     ButtonLoad.m (from UniversalHardware)
%     runDSD.m
%     runSVC.m
%     
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open dialog to get some info from participant
drs = getSubInfo();

% set subID 
subID = drs.subID;
%subNum = str2num(cell2mat(regexp(subID,'\d*','Match')));
subject.number = drs.subNum;
subject.wave = drs.waveNum;
subject.run = 0;

% get input directory
thisfile = mfilename('fullpath'); % studyDir/task/code/thisfile.m
taskDir = fileparts(fileparts(thisfile));
inputDir = fullfile(taskDir, 'input');


%dsd_discoside.csv info:
% col1: Tag ID; col2: side (1 = Right, 2 = Left)
% dummy id 999 uses Right, 998 uses Left
discoSideFN = fullfile(inputDir, 'dsd_discoside.csv');
sides={'Right','Left'};
discoSideMat=csvread(discoSideFN); 
discoSideNum=discoSideMat(discoSideMat(:,1) == subject.number,2);
discoSide=sides(discoSideNum);

if isempty(discoSide) || (~strcmp(discoSide, 'Right') && ~strcmp(discoSide, 'Left'))
    discoSideNumRand=randi([1 2]);
    discoSide=sides(discoSideNumRand);
    newDiscoSideMat = [discoSideMat; subject.number,discoSideNumRand];
    csvwrite(discoSideFN,newDiscoSideMat);
end

%% query button box, set up keys
% jcs
keys = ButtonLoad();

%% set up screen preferences, rng
win = initWindow();

screenNumber = max(Screen('Screens'));

%% adjust stim for retina problems & different projectors
drs.stim.box = ConvertStim(drs.stim.box, screenNumber); 
smalltext = floor(50 * drs.stim.box.yratio); 
largetext = floor(80 * drs.stim.box.yratio); 

% flip to get ifi
Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);

SetTextStyle(smalltext);

%% preface
FlushEvents('keyDown');
DrawText('Welcome to the TAG study!');
DrawContinue;

DrawText('Today, we''re going to do\n\n two different tasks');
DrawContinue;
DrawText('We''ll do two ''runs'' of each task\n\n and each ''run'' takes ~5-7 minutes');
DrawContinue;

DrawText('The tasks are: ', -2);
DrawText('1. Sharing Task ', -1, drs.stim.yellow);
DrawText('2. Change Task ', 0, drs.stim.purple);
DrawContinue;

%%
%%Practice SvC

DrawText('Change Task:', -2);
DrawText('Each time you see a word \nyou will have to decide if it describes you \nor if it''s something that can change.', ...
    -1, drs.stim.yellow);
DrawText('You''ll have about 4 seconds to decide.', 1);
DrawContinue;

WaitSecs(1);

%%
trait='funny';
condition=1;

iconMatrix = drs.stim.promptMatrix{1};
promptText = 'true about me?';
promptColor = drs.stim.promptColors{1};
iconTex = Screen('MakeTexture',win,iconMatrix);
Screen('DrawTexture',win,iconTex,[],drs.stim.box.prompt);

SetTextStyle(largetext);
DrawText(promptText, 0, promptColor);

SetTextStyle(smalltext);
DrawText('If you see this, you''ll need to decide \nif the next set of words describe you.', 1);
DrawContinue([], 3);

drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);
SetTextStyle(smalltext);
DrawContinue('(press left for yes or right for no)', 3);

% flip the screen to show trait

%%
trait='weird';
condition=4;

iconMatrix = drs.stim.promptMatrix{2};
promptText = 'can it change?';
promptColor = drs.stim.promptColors{2};
iconTex = Screen('MakeTexture',win,iconMatrix);
Screen('DrawTexture',win,iconTex,[],drs.stim.box.prompt);

SetTextStyle(largetext);
DrawText(promptText, 0, promptColor);

SetTextStyle(smalltext);
DrawText('If you see this, you''ll need to decide \nif the next set of words can change.', 1);
DrawContinue([], 3);

drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);
SetTextStyle(smalltext);
DrawContinue('(press left for yes or right for no)', 3);

% flip the screen to show trait
DrawText('Let''s practice the change task! ', 0, drs.stim.yellow);
DrawContinue('(press any button to start the practice)', 3);

FlushEvents('keyDown');

% this is needed on windows, unneeded on macos, untested on linux
if ispc
    KbQueueReserve(2,1,-1);
end

try
    runSVC_core(subject, keys, win)
catch exception
    Screen('closeall');
    ShowCursor;
    rethrow(exception);
end

FlushEvents('keyDown');
%% Explain DSD
if strcmp(discoSide, 'Right')
    targets = [1 2 2 4];
    privatetext = '(press left to keep it private)';
    sharetext = '(press right to share with your friend)';
elseif strcmp(discoSide, 'Left')
    targets = [2 1 2 4];
    privatetext = '(press left to share with your friend)';
    sharetext = '(press right to keep it private)';
end

statement = 'like robots';
%%

SetTextStyle(smalltext); 
DrawText('Sharing Task: First, you''ll see a brief statement.', -2);
DrawText('Decide if this statement describes you.',-1, drs.stim.yellow);
DrawText('You''ll have about 4 seconds to decide.',0, drs.stim.yellow);
DrawContinue;

WaitSecs(1);

%%
%choiceResponse=1;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,statement);

SetTextStyle(smalltext); 
DrawContinue('(press left for yes)',3);

drawDiscoFeedback(win,drs.stim,targets,statement,1);
WaitSecs(1);
%%

%choiceResponse=2;
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,statement);

SetTextStyle(smalltext); 
DrawContinue('(press right for no)', 3);

drawDiscoFeedback(win,drs.stim,targets,statement,2);
WaitSecs(1);
%%
SetTextStyle(smalltext); 
DrawText('Next, decide whether to share this statement\nwith your friend or keep it private, \n\n(with 2-4 pennies presented beneath the text)... ', ...
    -2, drs.stim.white);
DrawText('At the end of the task, you''ll be paid \n\nthe number of pennies you earn', ...
    0, drs.stim.yellow);
DrawContinue;

%%

drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets,statement,2);

SetTextStyle(smalltext); 
DrawContinue(privatetext,3);

drawChoiceFeedback(win,drs.stim,targets,statement,2,1);
WaitSecs(1);
%%
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets,statement,2);

SetTextStyle(smalltext); 
DrawContinue(sharetext,3);

drawChoiceFeedback(win,drs.stim,targets,statement,2,2);
WaitSecs(1);

%%

SetTextStyle(smalltext); 
DrawText('Don''t rush, but choose quickly \n\nbecause you only have about 3 seconds ',...
    -2, drs.stim.yellow);
DrawContinue('(press any button)');
WaitSecs(1);

%%
DrawText('Let''s practice the sharing task!', 0, drs.stim.yellow);
DrawContinue('(press any button to start the practice)',3);
FlushEvents('keyDown');

if ispc
    KbQueueReserve(2,1,-1);
end

try
    runDSD_core(subject, keys, win);
catch exception
    Screen('closeall');
    ShowCursor;
    rethrow(exception);
end

Screen('CloseAll')

%% added by jcs
function SetTextStyle(size)
    Screen('TextSize', win, floor(size * drs.stim.box.yratio)); 
    Screen('TextFont', win, 'Arial');
    Screen('TextStyle',win,0);
end

% only flips screen if it's a "continue"
% could return [VBLTimestamp, StimulusOnsetTime] from flip
% but those values never used
function DrawText(text, vshift, color)
    %defaults
    if nargin < 2 || isempty(vshift)
        vshift = 0;
    end
    if nargin < 3 || isempty(color)
        color = drs.stim.white;
    end
    vpos = drs.stim.box.yCenter + vshift*drs.stim.box.unit;
    DrawFormattedText(win, text, 'center', vpos, color);

end

function DrawContinue(continue_text, vshift)
    if nargin < 1 || isempty(continue_text)
        continue_text = '(press any button to continue)';
    end
    if nargin < 2 || isempty(vshift)
        vshift = 2;
    end
    
    DrawText(continue_text, vshift);
    Screen('Flip',win);
    GetChar();
end

end
