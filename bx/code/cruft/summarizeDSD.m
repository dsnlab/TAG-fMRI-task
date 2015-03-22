
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
summaryDSD=[];
valueBins={'-4','-3','-2','-1','0','1','2','3','4'};
for sCount = 1:length(dsdSub);
  d = dsdSub{sCount};
  subID=d.subID(1);
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
  for tCount = 1:length(stimSF)
    
  %%
  nSelf   = sum(d.pickTarget=='self');
  nFriend = sum(d.pickTarget=='friend');
  nParent = sum(d.pickTarget=='parent');
  pSelf   = sum(d.pickTarget=='self') / length(d.pickTarget);
  pFriend = sum(d.pickTarget=='friend') / length(d.pickTarget);
  pParent = sum(d.pickTarget=='parent') / length(d.pickTarget);
  cSelf = sum(d.pickValue(d.pickTarget=='self'));
  cFriend = sum(d.pickValue(d.pickTarget=='friend'));
  cParent = sum(d.pickValue(d.pickTarget=='parent'));
  % number of trials by condition
  % probability of choosing by condition
  nSp = sum(respSP(:,1));
  nPs = sum(respSP(:,2));
  nSf = sum(respSF(:,1));
  nFs = sum(respSF(:,2));
  nFp = sum(respFP(:,1));
  nPf = sum(respFP(:,2));
  % probability of choosing by condition
  pSp = sum(respSP(:,1)) / length(respSP);
  pPs = sum(respSP(:,2)) / length(respSP);
  pSf = sum(respSF(:,1)) / length(respSF);
  pFs = sum(respSF(:,2)) / length(respSF);
  pFp = sum(respFP(:,1)) / length(respFP);
  pPf = sum(respFP(:,2)) / length(respFP);
  % total coins earned by condition(ish)
  cSp = sum(stimSP(:,1));
  cPs = sum(stimSP(:,2));
  cSf = sum(stimSF(:,1));
  cFs = sum(stimSF(:,2));
  cFp = sum(stimFP(:,1));
  cPf = sum(stimFP(:,2));
  % slap it in a table
  summaryDSD(sCount,:) = [pSelf,pFriend,pParent,cSelf,cFriend,cParent,...
    nSp,nPs,nSf,nFs,nFp,nPf,...
    pSp,pPs,pSf,pFs,pFp,pPf,...
    cSp,cPs,cSf,cFs,cFp,cPf];
  clear tmp;
end