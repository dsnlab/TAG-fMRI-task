% use ButtonSetup to define keys file
function k = ButtonLoad(keyfile)
    if nargin < 1
    	keyfile = LoadKeyfile;
    end
    if ~keyfile
        error("No keyfile");
    end
    
    devices_found = 0;
    while ~devices_found     
        load(keyfile, 'keys');
        k = keys;
        k.keyboard_index = GetKeyboardIndices([], [], k.keyboard_loc);
        k.trigger_index = GetKeyboardIndices([], [], k.trigger_loc);
        k.left_index = GetKeyboardIndices([], [], k.left_loc);
        k.right_index = GetKeyboardIndices([], [], k.right_loc);
        
        devices_found = length([k.keyboard_index, k.trigger_index, ...
            k.left_index, k.right_index]) == 4;
        
        if ~devices_found
            answer = questdlg('Unable to find devices.', ...
                'Warning', ...
            'Try another file', 'Ignore', 'Run Setup', 'Run Setup');
        
            switch answer
                case 'Try another file'
                    keyfile = LoadKeyfile;
                case 'Run Setup'
                    keyfile = ButtonSetup;
                case 'Ignore'
                    devices_found = 1;
            end
        end   
    end
    % convenience - they are only different in the mock
    k.response_indices = unique([k.left_index, k.right_index]);
end

function kfile = LoadKeyfile
    disp("Select keyfile");
    [kfilename, kdir] = uigetfile(pwd, 'Select key file', '*.mat');
    kfile = fullfile(kdir, kfilename);
    if ~kfile
     answer = questdlg('Run button setup?', ...
            'No keyfile', ...
            'Yes', 'No', 'Yes');
        
         switch answer
             case 'Yes'
                 kfile = ButtonSetup;
             case 'No'
                 return;
         end
    end
end
