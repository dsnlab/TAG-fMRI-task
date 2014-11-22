%% pick a trial to show
tCount =7;
%% set variables for this trial
targets = [trialMatrix{3}(tCount),trialMatrix{4}(tCount),trialMatrix{5}(tCount),trialMatrix{6}(tCount)];
choiceJitter = trialMatrix{7}(tCount);
discoJitter = trialMatrix{8}(tCount);
statement = trialMatrix{9}{tCount};
choiceResponse = 0;
choiceRT = NaN;
discoRT = NaN;
chose = 0;
disclosed = 0;
multiChoiceResponse = [];
multiChoiceRT =[];
multiDiscoResponse = [];
multiDiscoRT =[];
%% draw initial DSD choice
drawHands(win,drs.stim,targets,[0.5 0.5]);
drawChoice(win,drs.stim,targets);
Screen('FillRect',win,[drs.stim.bg(1:3) 0.1], [drs.stim.box.choice{1}(1) drs.stim.box.choice{1}(2) drs.stim.box.choice{2}(3) drs.stim.box.choice{2}(4)]);
Screen('FillRect',win,[drs.stim.bg(1:3) 0.5], [drs.stim.box.coin{1}(1) drs.stim.box.coin{1}(2) drs.stim.box.coin{2}(3) drs.stim.box.coin{2}(4)]);
Screen('Flip',win);
dsdImage1=Screen('GetImage',win);
%% draw DSD choice feedback
choiceResponse=1;
drawChoiceFeedback(win,drs.stim,targets,choiceResponse);
dsdImage2=Screen('GetImage',win);
%%  draw DSD disclosure statement (aka 'disco)
drawYesNo(win,drs.stim,[0.5 0.5]);
drawDisco(win,drs.stim,targets,statement,choiceResponse);
Screen('Flip',win);
dsdImage3=Screen('GetImage',win);
%% draw disco feedback
discoResponse=2;
drawDiscoFeedback(win,drs.stim,targets,statement,choiceResponse,discoResponse);
dsdImage4=Screen('GetImage',win);
%% crop images so they aren't so huge
dsdImage1=dsdImage1((151:930),(301:1620),:);
imwrite(dsdImage1,'dsdImage1.png')
dsdImage2=dsdImage2((151:930),(301:1620),:);
imwrite(dsdImage2,'dsdImage2.png')
dsdImage3=dsdImage3((151:930),(301:1620),:);
imwrite(dsdImage3,'dsdImage3.png')
dsdImage4=dsdImage4((151:930),(301:1620),:);
imwrite(dsdImage4,'dsdImage4.png')