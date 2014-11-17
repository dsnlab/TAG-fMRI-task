function drawYesNo(win,stim,alphas)
leftYesNoMatrix = stim.box.green;
leftYesNoMatrix(:,:,4) = (stim.alpha.yesno{1}) ./255;
leftYesNoBox = stim.box.yesno{1};
leftYesNo = Screen('MakeTexture',win,leftYesNoMatrix);
Screen('DrawTexture',win,leftYesNo,[],leftYesNoBox,[],[],alphas(1));
rightYesNoMatrix = stim.box.red;
rightYesNoMatrix(:,:,4) = (stim.alpha.yesno{2}) ./255;
rightYesNoBox = stim.box.yesno{2};
rightYesNo = Screen('MakeTexture',win,rightYesNoMatrix);
Screen('DrawTexture',win,rightYesNo,[],rightYesNoBox,[],[],alphas(2));
end