%% make paradigm images for SVC figures
drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);Screen('Flip',win);
svcImage1=Screen('GetImage',win);
traitResponse=1;
drawTraitFeedback(win,drs.stim,trait,condition,traitResponse);
svcImage2=Screen('GetImage',win);
tCount=5;
drawTrait(win,drs.stim,trait,condition,[0.5 0.5]);Screen('Flip',win);
svcImage3=Screen('GetImage',win);
traitResponse=2;
drawTraitFeedback(win,drs.stim,trait,condition,traitResponse);
svcImage4=Screen('GetImage',win);
%% crop images so they aren't so huge
svcImage1=svcImage1((151:930),(301:1620),:);
imwrite(svcImage1,'svcImage1.png')
svcImage2=svcImage2((151:930),(301:1620),:);
imwrite(svcImage2,'svcImage2.png')
svcImage3=svcImage3((151:930),(301:1620),:);
imwrite(svcImage3,'svcImage3.png')
svcImage4=svcImage4((151:930),(301:1620),:);
imwrite(svcImage4,'svcImage4.png')

