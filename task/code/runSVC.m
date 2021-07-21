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

    % get subject info
    prompt = {...
    'sub num: ',...
    'wave num: ',...
    'run num: '};
    dTitle = 'Input Subject, Wave, and Run Number';
    nLines = 1;
    % defaults
    def = {'', '', ''};
    manualInput = inputdlg(prompt,dTitle,nLines,def);

    subject.number = str2double(manualInput{1});
    subject.wave = str2double(manualInput{2});
    subject.run = str2double(manualInput{3});

    % initialize hardware
    keys = ButtonLoad();
    win = initWindow();
    
    task = runSVC_core(subject, keys, win);

    Screen('Close', win);
end
