function [ keys ] = initKeys()
% % INITKEYS.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   queries PsychHID('Devices') & sets device values
%   in a structure called keys.
%
% note: you'll need to replace the vendorID with whatever works for your
% keyboard. Find out by doing >> devices = PsychHID('Devices') and poking
% around the devices structure
% kludge for screen during multiband calibration (shortened for debug)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: wem3
%   acknowledgements: Andrew Cho
%   written: 141031
%   modified: 141104 ~wem3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set up button box / keyboard
devices=PsychHID('Devices');
for deviceCount=1:length(devices),
  % the lcni button box has the usageName 'Keyboard' and the product 'Xkeys'
  if (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).product,'Xkeys')),
    inputDevice = deviceCount;
    fprintf('button box detected\n using device #%d: %s\n',inputDevice,devices(inputDevice).product);
    bbox = 1;
    break,
  end

  if (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Microsoft')),
    inputDevice = deviceCount;
    fprintf('Using Device #%d: internal %s\n',inputDevice,devices(inputDevice).usageName);
    bbox = 0;
    break,
  end
end

keys.device = devices(inputDevice);
keys.deviceNum = inputDevice;
keys.space=KbName('SPACE');
keys.esc=KbName('ESCAPE');
keys.right=KbName('RightArrow');
keys.left=KbName('LeftArrow');
keys.up=KbName('UpArrow');
keys.down=KbName('DownArrow');
keys.shift=KbName('RightShift');
keys.kill = KbName('k');

if bbox == 1;
  keys.trigger = 52; % trigger pulse / TR signal key ('`') for LCNI scanner
  keys.b1 = KbName('1');    % Button Box 1
  keys.b2 = KbName('2');    % Button Box 2
  keys.b3 = KbName('3');    % Button Box 3
  keys.b4 = KbName('4');    % Button Box 4
  keys.b5 = KbName('5');    % Button Box 5
  keys.b6 = KbName('6');    % Button Box 6
  keys.b7 = KbName('7');    % Button Box 7
  keys.b8 = KbName('8');    % Button Box 8
  keys.b9 = KbName('9');    % Button Box 9
  keys.b0 = KbName('0');    % Button Box 0
  keys.buttons = (89:98);

elseif bbox == 0;
  keys.trigger = KbName('t'); % use 't' as KbTrigger
  keys.b1 = KbName('1!');   % Keyboard 1
  keys.b2 = KbName('2@');   % Keyboard 2
  keys.b3 = KbName('3#');   % Keyboard 3
  keys.b4 = KbName('4$');   % Keyboard 4
  keys.b5 = KbName('5%');   % Keyboard 5
  keys.b6 = KbName('6^');   % Keyboard 6
  keys.b7 = KbName('7&');   % Keyboard 7
  keys.b8 = KbName('8*');   % Keyboard 8
  keys.b9 = KbName('9(');   % Keyboard 9
  keys.b0 = KbName('0)');   % Keyboard 0
  keys.buttons = (30:39);
end

% to disable detection of the trigger pulse:
% olddisabledkeys=DisableKeysForKbCheck([KbName(52), KbName('0)')])

% to re-enable detection of the trigger pulse:
% olddisabledkeys=DisableKeysForKbCheck([])
end