% use ButtonSetup to define keys file
function k = ButtonLoad(keyfile)
    load(keyfile, 'keys');
    k = keys;
    k.keyboard_index = GetKeyboardIndices(k.keyboard_name);
    k.trigger_index = GetKeyboardIndices([], [], k.trigger_loc);
    

    k.left_index = GetKeyboardIndices([], [], k.left_loc);
    k.right_index = GetKeyboardIndices([], [], k.right_loc);
    
    % convenience - they are only different in the mock
    k.response_indices = unique([k.left_index, k.right_index]);
end

