function [task] = runSVC()
% % RUNSVC.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runSVC()
%
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

    %% set up screen preferences
    if IsOSX
        Screen('Preference','TextRenderer', 0)
    end
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 1);
     
    PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseRetinaResolution');
    [win,~] = PsychImaging('OpenWindow',screenNumber, stim.bg);

    
    task = runSVC_core(subNum, runNum, waveNum, keys, win);

    Screen('Close', win);
end
