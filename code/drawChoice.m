function drawChoice(win, drs, targets, choices)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawChoice.m: draw targets & coins for dsd
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

leftCoin = Screen('MakeTexture',win,drs.stim.coins{targets(3)});
rightCoin = Screen('MakeTexture',win,drs.stim.coins{targets(4)});

switch choices
  case 2
    Screen('DrawTexture',win,leftCoin,[],drs.stim.box.L.coin,[],[],0.8);
    Screen('DrawTexture',win,rightCoin,[],drs.stim.box.R.coin,[],[],0.8);
    DrawFormattedText(win, drs.targetText{targets(1)}, 'center',...
      'center', [drs.targetColors{targets(1)}(1:3) 0.8] ,[],[],[],[],[],drs.stim.box.L.choice);
    DrawFormattedText(win, drs.targetText{targets(2)}, 'center',...
      'center', [drs.targetColors{targets(2)}(1:3) 0.8],[],[],[],[],[],drs.stim.box.R.choice);
  case 1
    Screen('DrawTexture',win,rightCoin,[],box.R.coin);
    DrawFormattedText(win, drs.targetText{targets(1)}, 'center',...
      'center', drs.targetColors{targets(2)},[],[],[],[],[],drs.stim.box.R.choice);
  case 0
    Screen('DrawTexture',win,leftCoin,[],box.L.coin);
    DrawFormattedText(win, drs.targetText{targets(2)}, 'center',...
      'center', drs.targetColors{targets(1)} ,[],[],[],[],[],drs.stim.box.L.choice);
end

return