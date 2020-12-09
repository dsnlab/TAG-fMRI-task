% I had hoped to store the indices but they are far too unstable.
% Will need to store the locationID from PsychHID('Devices')
% Will need another function to load the keys structure and grab the
% correct index
function keyfile = ButtonSetup()
    KbName('UnifyKeyNames');

    % in case someone left us in a bad state
    DisableKeysForKbCheck([]); 

    % all keys should be the integer values!
    % defaults
    keys.trigger = 52;

    % These are referenced in the original initkeys, but this module doesn't
    % change them. Not sure if they are still needed.
    keys.space=KbName('SPACE');
    keys.esc=KbName('ESCAPE');
    keys.right=KbName('RightArrow');
    keys.left=KbName('LeftArrow');
    keys.up=KbName('UpArrow');
    keys.down=KbName('DownArrow');
    keys.shift=KbName('RightShift');
    keys.kill = KbName('k');

    % no! bad! redundant with b0-b9 (at best!)
    % keys.buttons = (30:39);

    f = uifigure('Name', 'Device Setup', ...
        'KeyPressFcn', @myKeyPress, ...
        'UserData', '');

    label = uilabel(f);
    label.FontSize = 16;
    label.Position = [20 200 500 100];
    label.Text = "Open keyboard mat file";

    [indices, names, infos] = GetKeyboardIndices();

    for kn = 1:length(indices)
        KbQueueCreate(indices(kn));
        KbQueueStart(indices(kn));
    end

    response = uiconfirm(f, 'Open existing keyboard mat file?', 'Open file', ...
        'Options',{'Yes','No'});

    if strcmp(response, 'Yes')
        keyfile = uigetfile('*.mat', 'Open file');
        if keyfile
            load(keyfile);
        end
    end

    orig_keys = keys;

    figure(f);
    label.Text = "Click anywhere in this space, then press any button on your keyboard";

    [~, i] = WaitForKbPress(f, indices);

    keyboard_index = indices(i);
    info = struct2table(infos{i}, 'AsArray', true);
    keys.keyboard_loc = info.locationID;
    keys.keyboard_name = names(i);

    label.Text = ["Press any button on the triggering device" ...
        "(button control box for scanner, keyboard for mock or test mode)"];

    [~, i] = WaitForKbPress(f, indices);

    trigger_index = indices(i);
    info = struct2table(infos{i}, 'AsArray', true);
    keys.trigger_loc = info.locationID;
    keys.trigger_name = names(i);


    str1 = "Triggering device = " + keys.trigger_name;
    str2 = "Trigger key is " + KbName(keys.trigger) ...
        + sprintf(' (%d)', keys.trigger);
    str3 = "Press enter to confirm trigger key, space to change trigger key";

    label.Text = [str1, str2, str3];

    response = WaitForKeypress(f);

    switch response
        case 'escape'
            quit
        case 'space'
            label.Text = "Prepare trigger device and press enter when ready";
            response = '';
            while not(strcmp(response, 'return'))
                response = WaitForKeypress(f);
            end
            KbQueueFlush(trigger_index);
            label.Text = "Waiting for trigger";
            WaitForKeypress(f);
            [~, keyCode] = KbQueueCheck(trigger_index);

            label.Text = ["Trigger detected: " + KbName(keyCode) ...
                 + sprintf(' (%d)', KbName(KbName(keyCode))), ...
                "Press enter to continue."];

            keys.trigger = KbName(KbName(keyCode));
            response = '';
            while not(strcmp(response, 'return'))
                response = WaitForKeypress(f);
            end


    end

    for kn = 1:length(indices)
        KbQueueFlush(indices(kn));
    end

    str1 = "Press left response buttons from left to right: ";
    label.Text = str1;
    [keys.b0, i] = WaitForKbPress(f, indices);
    left_index = indices(i);
    info = struct2table(infos{i}, 'AsArray', true);
    keys.left_loc = info.locationID;
    keys.left_name = names(i);
    label.Text = str1 + KbName(keys.b0);
    keys.b1 = WaitForKbPress(f, indices);
    label.Text = str1 + KbName(keys.b1);
    keys.b2 = WaitForKbPress(f, indices);
    label.Text = str1 + KbName(keys.b2);
    keys.b3 = WaitForKbPress(f, indices);
    label.Text = str1 + KbName(keys.b3);
    keys.b4 = WaitForKbPress(f, indices);
    %label.Text = str1 + KbName(keys.b4);

    str2 = "Press right response buttons from left to right: ";
    label.Text = [ str1 + KbName(keys.b4), str2];
    [keys.b5, i] = WaitForKbPress(f, indices);

    right_index = indices(i);
    info = struct2table(infos{i}, 'AsArray', true);
    keys.right_loc = info.locationID;
    keys.right_name = names(i);

    label.Text = [ str1 + KbName(keys.b4), str2 + KbName(keys.b5)];
    keys.b6 = WaitForKbPress(f, indices);
    label.Text = [ str1 + KbName(keys.b4), str2 + KbName(keys.b6)];
    keys.b7 = WaitForKbPress(f, indices);
    label.Text = [ str1 + KbName(keys.b4), str2 + KbName(keys.b7)];
    keys.b8 = WaitForKbPress(f, indices);
    label.Text = [ str1 + KbName(keys.b4), str2 + KbName(keys.b8)];
    keys.b9 = WaitForKbPress(f, indices);
    label.Text = [ str1 + KbName(keys.b4), str2 + KbName(keys.b9)];

    for kn = 1:length(indices)
        KbQueueRelease(indices(kn));
    end

    if isequal(keys, orig_keys)
        message = 'Keys unchanged. Write new file anyway?';
    else
        message = 'Keys changed. Write new file?';
    end

    response = uiconfirm(f, message, 'Confirm choice',...
        'Options',{'Yes','No'});
    delete(f);

    if strcmp(response, 'Yes')
        [filename, path] = uiputfile('*.mat', 'Save file');
        keyfile = fullfile(path, filename);
        if filename
            save(keyfile, 'keys');
        end
    end
end

function myKeyPress(hFig, EventData)
    set(hFig, 'UserData', EventData.Key)
    
end

% wait for a keypress and return it, matlab style
function keyname = WaitForKeypress(hFig)
    set(hFig, 'UserData', '');
    waitfor(hFig, 'UserData');
    keyname = hFig.UserData;
end    

% wait for a keypress and get the device & key using psychtoolbox
% returned index must be converted to device number/name!
% keyname will be the int version
function [keyname, device] = WaitForKbPress(hFig, device_indices)
    WaitForKeypress(hFig);
    for kn = 1:length(device_indices)
        [pressed, firstpress] = KbQueueCheck(device_indices(kn));
        if pressed 
            keyname = KbName(KbName(firstpress));
            device = kn;
        end
    end
end



