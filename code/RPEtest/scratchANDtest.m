% Scratch & Test for RPE task
%%
	KbQueueCreate;
	% Perform some other initializations, etc
	startTime=GetSecs;
	KbQueueStart;
	% Do some other computations, display things on screen, play sounds, etc
	[ pressed, firstPress]=KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
	if pressed
		pressedCodes=find(firstPress);
		for i=1:size(pressedCodes,2)
			fprintf('The %s key was pressed at time %.3f seconds\n', KbName(pressedCodes(i)), firstPress(pressedCodes(i))-startTime);
		end
	else
		fprintf('No key presses were detected\n');
	end
	% Do additional computations, possibly including more calls to KbQueueCheck, etc
	KbQueueRelease;

%% Identify Input Device

inputDevice = 5;

handBox = input('Left or Right handed? 1 for Left, 2 for Right: ');

if handBox == 1;
    keys = [2,3];
elseif handBox == 2;
    keys = [6,7];
end

%% set up device (this doesn't seem to work)
%
% instructions retrieved from:
%
% http://cbs.fas.harvard.edu/science/core-facilities/neuroimaging/information-investigators/matlabfaq#device_num
%
deviceString='XKeys';%% name of the scanner trigger box

[id,name] = GetKeyboardIndices;% get a list of all devices connected

device=0;

for i=1:length(name)%for each possible device

 if strcmp(name{i},deviceString)%compare the name to the name you want

 device=id(i);%grab the correct id, and exit loop

 break;

 end

end

if device==0%%error checking

 error('No device by that name was detected');

end

%% hard coded start?

MRI=1;
numDevices=PsychHID('NumDevices');
devices=PsychHID('Devices');
button_box=1;
trigger=([52]);
inputDevice=4;
if button_box
experiment_start_time=KbTriggerWait(trigger,inputDevice);
DisableKeysForKbCheck(trigger); % So trigger is no longer detected
else
KbWait(homeDevice);  % wait for keypress
experiment_start_time=GetSecs;
end

%% To detect all keypresses from the default device and when they occurred relative to some start time:
KbQueueCreate;
% Perform some other initializations, etc
startTime=GetSecs;
KbQueueStart;
% Do some other computations, display things on screen, play sounds, etc
[ pressed, firstPress]=KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
if pressed
    pressedCodes=find(firstPress);
    for i=1:size(pressedCodes,2)
        fprintf('The %s key was pressed at time %.3f seconds\n', KbName(pressedCodes(i)), firstPress(pressedCodes(i))-startTime);
    end
else
    fprintf('No key presses were detected\n');
end
% Do additional computations, possibly including more calls to KbQueueCheck, etc
KbQueueRelease;
    
%% To detect keypresses involving only the 'r', 'g', 'b' and 'y' keys on the default device:
keysOfInterest=zeros(1,256);
keysOfInterest(KbName({'r', 'g', 'b', 'y'}))=1;
KbQueueCreate(-1, keysOfInterest);
% Perform some other initializations
KbQueueStart;
% Perform some other tasks while key events are being recorded
[ pressed, firstPress]=KbQueueCheck; % Collect keyboard events since KbQueueStart was invoked
if pressed
    if firstPress(KbName('r'))
        % Handle press of 'r' key
    end
    if firstPress(KbName('g'))
        % Handle press of 'g' key
    end
    if firstPress(KbName('b'))
        % Handle press of 'b' key
    end
    if firstPress(KbName('y'))
        % Handle press of 'y' key
    end
end
% Do additional computations
KbQueueRelease;
    
%% To detect a 't' trigger from an fMRI scanner using a Fiber Optic Response Pad and then process events from the 'r', 'g', 'b' and 'y' keys:
psychtoolbox_forp_id=-1;

Devices = PsychHID('Devices');
% Loop through all KEYBOARD devices with the vendorID of FORP's vendor:
for i=1:size(Devices,2)
    if (strcmp(devices(i).usageName,'Keyboard') && strcmp(devices(i).product,'Xkeys')),
        psychtoolbox_forp_id=i;
        break;
    end
end

if psychtoolbox_forp_id==-1;
    error('No FORP-Device detected on your system');
end
keysOfInterest=zeros(1,256);
keysOfInterest(KbName([52]))=1;
KbQueueCreate(psychtoolbox_forp_id, keysOfInterest);    % First queue
% Perform other initializations
KbQueueStart;
KbQueueWait; % Wait until the 't' key signal is sent
keysOfInterest=zeros(1,256);
keysOfInterest(KbName({'r', 'g', 'b', 'y'}))=1;
KbQueueCreate(psychtoolbox_forp_id, keysOfInterest);    % New queue
% Perform some other initializations
KbQueueStart;
% Perform some other tasks while key events are being recorded
[ pressed, firstPress]=KbQueueCheck;    % Collect keyboard events since KbQueueStart was invoked
if pressed
    if firstPress(KbName('r'))
        % Handle press of 'r' key
    end
    if firstPress(KbName('g'))
        % Handle press of 'g' key
    end
    if firstPress(KbName('b'))
        % Handle press of 'b' key
    end
    if firstPress(KbName('y'))
        % Handle press of 'y' key
    end
end
% Do additional computations
KbQueueRelease;
    
%% To detect a 't' trigger from an fMRI scanner via a Fiber Optic Response Pad without creating a persistent queue:
psychtoolbox_forp_id=-1;

Devices = PsychHID('Devices');
% Loop through all KEYBOARD devices with the vendorID of FORP's vendor:
for i=1:size(Devices,2)
    if (strcmp(devices(i).usageName,'Keyboard') && strcmp(devices(i).product,'Xkeys')),
        psychtoolbox_forp_id=i;
        break;
    end
end

if psychtoolbox_forp_id==-1;
    error('No FORP-Device detected on your system');
end
% Note that KbTriggerWait will not respond to interrupts reliably--
% if no trigger is generated, you may have to kill Matlab to break out
% of the call to KbTriggerWait
KbTriggerWait(KbName('t'), psychtoolbox_forp_id);
% Trigger has been detected, proceed with other tasks

    