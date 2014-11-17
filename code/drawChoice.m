function drawChoice(win, stim, targets)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawChoice.m: draw targets & coins for dsd
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('TextSize', win, 60);
Screen('TextFont', win, 'Arial');
Screen('TextStyle', win,1);
leftCoin = Screen('MakeTexture',win,stim.coins{targets(3)});
rightCoin = Screen('MakeTexture',win,stim.coins{targets(4)});
% draw left target
DrawFormattedText( win,...
  stim.targetText{targets(1)}, 'center', 'center',...
  stim.targetColors{targets(1)},...
  [],[],[],[],[], stim.box.choice{1} );
% draw right target
DrawFormattedText(win,...
  stim.targetText{targets(2)}, 'center', 'center',...
  stim.targetColors{targets(2)},...
  [],[],[],[],[],stim.box.choice{2} );
% draw the left coins
Screen('DrawTexture',win,leftCoin,[],stim.box.coin{1});
% draw the right coins
Screen('DrawTexture',win,rightCoin,[],stim.box.coin{2});

return;