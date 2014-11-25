function drawChoiceFeedback(win,stim,targets,choiceResponse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawChoiceFeedback.m: draw a frame around the subject's choice
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handGlow = (0.55:0.05:1);
handFade = flip(0:0.05:0.45);
% fadeVector is a vector we'll use to construct a gradient of transparencies
fadeVector = (0.3:0.075:1);

%% now fade the non-chosen box
for fadeCount = 1:length(fadeVector)
  switch choiceResponse
  case 0
    alphas = [handFade(fadeCount) handFade(fadeCount)];
    fadeBox = [0 0 stim.box.xDim stim.box.statement(2)];
  case 1
    alphas = [handGlow(fadeCount) handFade(fadeCount)];
    fadeBox = [stim.box.xCenter 0 stim.box.xDim stim.box.statement(2)];
  case 2
    alphas = [handFade(fadeCount) handGlow(fadeCount)];
    fadeBox = [0 0 stim.box.xCenter stim.box.statement(2)];
  end
  % chosen box
  drawHands(win,stim,targets,alphas);
  drawChoice(win,stim,targets);
  Screen('FillRect',win,[stim.bg(1:3) fadeVector(fadeCount)], fadeBox);
  WaitSecs(0.025);
  Screen('Flip',win);
  % adjust to acheive desired fade
end

return