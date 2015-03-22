% input = dsd: single subject, 90 x 14 table 
% 'subID'         1. string w/ subID
% 'sess'          2. functional run (1 or 2 except for drs016)
% 'tnum'          3. trial number for that run
% 'pickTarget'    4. categorical array describing target chosen
% 'dumpTarget'    5. categorical array describing target discarded
% 'pickCoin'      6. ordinal array for coins chosen
% 'dumpCoin'      7. ordinal array for coins discarded
% 'pickValue'     8. float value of coins chosen
% 'dumpValue'     9. float value of coins discarded
% 'discoResponse' 10. logical array for yes/no response
% 'choiceOnset'   11. onset time of the choice stimulus
% 'choiceRT'      12. reaction time for choice
% 'discoOnset'    13. onset time of the disclosure stimulus
% 'discoRT'       14. reaction time for disclosure

picks = [d.pickTarget=='self',d.pickTarget=='friend',d.pickTarget=='parent'];
dumps = [d.dumpTarget=='self',d.dumpTarget=='friend',d.dumpTarget=='parent'];
pickCoin = [d.pickValue(d.pickTarget=='self'),...
  d.pickValue(d.pickTarget=='friend'),...
  d.pickValue(d.pickTarget=='parent')];
dumpCoin = [d.dumpValue(d.pickTarget=='self'),...
  d.dumpValue(d.pickTarget=='friend'),...
  d.dumpValue(d.pickTarget=='parent')];

%%
stimSF=double([d.pickValue((d.pickTarget=='self'&d.dumpTarget=='friend')|(d.pickTarget=='friend'&d.dumpTarget=='self')),...
  d.dumpValue((d.pickTarget=='self'&d.dumpTarget=='friend')|(d.pickTarget=='friend'&d.dumpTarget=='self'))]);
respSF = [d.pickTarget((d.pickTarget=='self'&d.dumpTarget=='friend')|(d.pickTarget=='friend'&d.dumpTarget=='self'))=='self',...
  d.pickTarget((d.pickTarget=='self'&d.dumpTarget=='friend')|(d.pickTarget=='friend'&d.dumpTarget=='self'))=='friend'];
stimSP=double([d.pickValue((d.pickTarget=='self'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='self')),...
  d.dumpValue((d.pickTarget=='self'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='self'))]);
respSP = [d.pickTarget((d.pickTarget=='self'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='self'))=='self',...
  d.pickTarget((d.pickTarget=='self'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='self'))=='parent'];
stimFP=double([d.pickValue((d.pickTarget=='friend'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='friend')),...
  d.dumpValue((d.pickTarget=='friend'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='friend'))]);
respFP = [d.pickTarget((d.pickTarget=='friend'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='friend'))=='friend',...
  d.pickTarget((d.pickTarget=='friend'&d.dumpTarget=='parent')|(d.pickTarget=='parent'&d.dumpTarget=='friend'))=='parent'];
%%
pChooseSelf   = sum(d.pickTarget=='self') / length(d.pickTarget=='self');
pChooseFriend = sum(d.pickTarget=='friend') / length(d.pickTarget=='friend');
pChooseParent = sum(d.pickTarget=='parent') / length(d.pickTarget=='parent');
pSELFparent = sum(stimSP(:,1)) / length(stimSP);
pPARENTself = sum(stimSP(:,2)) / length(stimSP);
pSELFfriend = sum(stimSF(:,1)) / length(stimSF);
pFRIENDself = sum(stimSF(:,2)) / length(stimSF);
pFRIENDparent = sum(stimFP(:,1)) / length(stimFP);
pPARENTfriend = sum(stimFP(:,1)) / length(stimFP);

%%
for tCount=1:length(x);
  if x(tCount,1)==1 
    if x(tCount,2)==1;
      y(tCount)=1;
    elseif x(tCount,3)==1;
      y(tCount)=2;
    end
  elseif x(tCount,3)==1;
    y(tCount)=3;
  end
end
  