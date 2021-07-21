% sets common screen settings
% sets Psych imaging config
% returns window handle

function myWindow = initWindow()
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'VisualDebugLevel', 1);
    
    % for some reason this is needed ONLY for the dsnlab login on the mock
    % For other users, the new text renderer is fine
    if IsOSX
        Screen('Preference','TextRenderer', 0)
    end

    % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
    PsychDefaultSetup(2); 
    screenNumber = max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseRetinaResolution');
    load('DRSstim.mat', 'stim');
    disp('be patient')
    [myWindow,~] = PsychImaging('OpenWindow',screenNumber, stim.bg);
    Screen('BlendFunction', myWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
end