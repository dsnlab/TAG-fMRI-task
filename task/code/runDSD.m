function [task] = runDSD()
% % RUNDSD.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runDSD()
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%    (subID)_dsd_(runNum).txt = comma delimited text with per trial input
%    input text columns (%u,%u,%u,%u,%u,%f%f) 
%       1. trialNum
%       2. condition
%           [1-3] = Neutral; [4-6] = Affective;
%           [1,4] = loss to share; [2, 5] = loss to private; [3,6] equal
%       3. leftTarget (self == 1, friend == 2) 
%       4. rightTarget
%       5. leftCoin
%       6. rightCoin
%       7. choiceJitter (%f, amount of time to vary gap b/w choice & disclosure)
%       8. discoJitter (%f, amount of time to vary ITI)
%       9. statement (string w/ self-disclosure statement)
%
%     DRSstim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%     (subID)_info.mat = structure w/ subject specific info
% Output:
%   A stucture named 'task' within which these may be of interest
%
%   task.output.raw:
%       1. Trial Number
%       2. condition
%           [1-3] = Neutral; [4-6] = Affective;
%           [1,4] = loss to share; [2, 5] = loss to private; [3,6] equal
%       3. leftTarget (self == 1, friend == 2) 
%       4. rightTarget
%       5. leftCoin
%       6. rightCoin
%       7. Time since trigger for disclosure (choiceOnset - loopStartTime);
%       8. choiceResponse - Share or not? (leftkeys = 1, rightkeys = 2)
%       9. choiceRT - reaction time
%       10. Time since trigger for statement decisions (discoOnset - loopStartTime);
%       11. discoResponse - endorse or not?  (leftkeys = 1, rightkeys = 2)
%       12. discoRT - reaction time
%       13. payout amount according to choice
%   task.input.statement
%   task.payout
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    keys = ButtonLoad();
    load('DRSstim.mat', 'stim');
    
    %% set up screen preferences, rng
    if IsOSX
        Screen('Preference','TextRenderer', 0)
    end
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 1);

    rng('shuffle'); 
    screenNumber = max(Screen('Screens'));

    PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseRetinaResolution');
    [win,~] = PsychImaging('OpenWindow',screenNumber, stim.bg);
    
    task = runDSD_core(subNum, runNum, waveNum, keys, win);

    Screen('Close', win);
end



