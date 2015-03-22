for sCount = 1:length(dsdSub);
d = dsdSub{sCount};
pickSa(sCount,1) = sum(d.pickTarget=='self');
pickFa(sCount,1) = sum(d.pickTarget=='friend');
pickPa(sCount,1) = sum(d.pickTarget=='parent');
dumpSa(sCount,1) = sum(d.dumpTarget=='self');
dumpFa(sCount,1) = sum(d.dumpTarget=='friend');
dumpPa(sCount,1) = sum(d.dumpTarget=='parent');
pickSf(sCount,1) = sum(d.pickTarget(d.dumpTarget=='friend')=='self');
pickSp(sCount,1) = sum(d.pickTarget(d.dumpTarget=='parent')=='self');
pickFs(sCount,1) = sum(d.pickTarget(d.dumpTarget=='self')=='friend');
pickFp(sCount,1) = sum(d.pickTarget(d.dumpTarget=='parent')=='friend');
pickPs(sCount,1) = sum(d.pickTarget(d.dumpTarget=='self')=='parent');
pickPf(sCount,1) = sum(d.pickTarget(d.dumpTarget=='friend')=='parent');

pickSaRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget=='self'));
pickFaRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget=='friend'));
pickPaRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget=='parent'));
dumpSaRT(sCount,1) = nanmean(d.choiceRT(d.dumpTarget=='self'));
dumpFaRT(sCount,1) = nanmean(d.choiceRT(d.dumpTarget=='friend'));
dumpPaRT(sCount,1) = nanmean(d.choiceRT(d.dumpTarget=='parent'));
pickSfRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='friend')=='self'));
pickSpRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='parent')=='self'));
pickFsRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='self')=='friend'));
pickFpRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='parent')=='friend'));
pickPsRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='self')=='parent'));
pickPfRT(sCount,1) = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='friend')=='parent'));

tGainSa(sCount,1) = sum(d.pickValue(d.pickTarget=='self'));
tGainFa(sCount,1) = sum(d.pickValue(d.pickTarget=='friend'));
tGainPa(sCount,1) = sum(d.pickValue(d.pickTarget=='parent'));
tGainSf(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='self'));
tGainSp(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='self'));
tGainFs(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='friend'));
tGainFp(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='friend'));
tGainPs(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='parent'));
tGainPf(sCount,1) = sum(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='parent'));

tLossSa(sCount,1) = sum(d.dumpValue(d.pickTarget=='self'));
tLossFa(sCount,1) = sum(d.dumpValue(d.pickTarget=='friend'));
tLossPa(sCount,1) = sum(d.dumpValue(d.pickTarget=='parent'));
tLossSf(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='self'));
tLossSp(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='self'));
tLossFs(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='friend'));
tLossFp(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='friend'));
tLossPs(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='parent'));
tLossPf(sCount,1) = sum(d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='parent'));

mGainSa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='self'));
mGainFa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='friend'));
mGainPa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='parent'));
mGainSf(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='self'));
mGainSp(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='self'));
mGainFs(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='friend'));
mGainFp(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='friend'));
mGainPs(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='parent'));
mGainPf(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='parent'));

mLossSa(sCount,1) = nanmean(d.dumpValue(d.pickTarget=='self'));
mLossFa(sCount,1) = nanmean(d.dumpValue(d.pickTarget=='friend'));
mLossPa(sCount,1) = nanmean(d.dumpValue(d.pickTarget=='parent'));
mLossSf(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='self'));
mLossSp(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='self'));
mLossFs(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='friend'));
mLossFp(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='friend'));
mLossPs(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='parent'));
mLossPf(sCount,1) = nanmean(d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='parent'));

mDiffSa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='self')-d.dumpValue(d.pickTarget=='self'));
mDiffFa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='friend')-d.dumpValue(d.pickTarget=='friend'));
mDiffPa(sCount,1) = nanmean(d.pickValue(d.pickTarget=='parent')-d.dumpValue(d.pickTarget=='parent'));
mDiffSf(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='self')-d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='self'));
mDiffSp(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='self')-d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='self'));
mDiffFs(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='friend')-d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='friend'));
mDiffFp(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='parent')=='friend')-d.dumpValue(d.pickTarget(d.dumpTarget=='parent')=='friend'));
mDiffPs(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='self')=='parent')-d.dumpValue(d.pickTarget(d.dumpTarget=='self')=='parent'));
mDiffPf(sCount,1) = nanmean(d.pickValue(d.pickTarget(d.dumpTarget=='friend')=='parent')-d.dumpValue(d.pickTarget(d.dumpTarget=='friend')=='parent'));
end
subID={'drs001','drs002','drs003','drs005','drs006','drs007','drs008','drs009','drs010','drs011','drs012','drs013','drs014','drs015','drs016','drs017','drs018','drs019','drs020','drs021','drs022','drs023','drs024','drs025'};
subID=subID';
dsdSummary=table(subID,pickSa,pickFa,pickPa,dumpSa,dumpFa,dumpPa,...
  pickSf,pickSp,pickFs,pickFp,pickPs,pickPf,...
  pickSaRT,pickFaRT,pickPaRT,dumpSaRT,dumpFaRT,dumpPaRT,...
  pickSfRT,pickSpRT,pickFsRT,pickFpRT,pickPsRT,pickPfRT,...
  tGainSa,tGainFa,tGainPa,tGainSf,tGainSp,tGainFs,tGainFp,tGainPs,tGainPf,...
  tLossSa,tLossFa,tLossPa,tLossSf,tLossSp,tLossFs,tLossFp,tLossPs,tLossPf,...
  mGainSa,mGainFa,mGainPa,mGainSf,mGainSp,mGainFs,mGainFp,mGainPs,mGainPf,...
  mLossSa,mLossFa,mLossPa,mLossSf,mLossSp,mLossFs,mLossFp,mLossPs,mLossPf,...
  mDiffSa,mDiffFa,mDiffPa,mDiffSf,mDiffSp,mDiffFs,mDiffFp,mDiffPs,mDiffPf);


% pickSeq(sCount,1) = sum(d.pickTarget(d.pickValue==d.dumpValue)=='self');
% pickSmore(sCount,1) = sum(d.pickTarget(d.pickValue>d.dumpValue)=='self');
% pickSless(sCount,1) = sum(d.pickTarget(d.pickValue<d.dumpValue)=='self');
% pickFeq(sCount,1) = sum(d.pickTarget(d.pickValue==d.dumpValue)=='friend');
% pickFmore(sCount,1) = sum(d.pickTarget(d.pickValue>d.dumpValue)=='friend');
% pickFless(sCount,1) = sum(d.pickTarget(d.pickValue<d.dumpValue)=='friend');
% pickPeq(sCount,1) = sum(d.pickTarget(d.pickValue==d.dumpValue)=='parent');
% pickPmore(sCount,1) = sum(d.pickTarget(d.pickValue>d.dumpValue)=='parent');
% pickPless(sCount,1) = sum(d.pickTarget(d.pickValue<d.dumpValue)=='parent');
% dsdPickFreqs = table(pickStot,pickFtot,pickPtot,pickSf,pickSp,pickFs,pickFp,pickPs,pickPf,pickSeq,pickSmore,pickSless,pickFeq,pickFmore,pickFless,pickPeq,pickPmore,pickPless);
% freqs(sCount,:) = [sTot fTot pTot Sf Sp Fs Fp Ps Pf sEq fEq pEq sMore fMore pMore sLess fLess pLess];
% aEq = nanmean(d.choiceRT(d.pickValue==d.dumpValue));
% aMore = nanmean(d.choiceRT(d.pickValue>d.dumpValue));
% aLess = nanmean(d.choiceRT(d.pickValue<d.dumpValue));
% sTot = nanmean(d.choiceRT(d.pickTarget=='self'));
% Sf = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='friend')=='self'));
% Sp = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='parent')=='self'));
% sEq = nanmean(d.choiceRT(d.pickTarget(d.pickValue==d.dumpValue)=='self'));
% sMore = nanmean(d.choiceRT(d.pickTarget(d.pickValue>d.dumpValue)=='self'));
% sLess = nanmean(d.choiceRT(d.pickTarget(d.pickValue<d.dumpValue)=='self'));
% fTot = nanmean(d.choiceRT(d.pickTarget=='friend'));
% Fs = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='self')=='friend'));
% Fp = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='parent')=='friend'));
% fEq = nanmean(d.choiceRT(d.pickTarget(d.pickValue==d.dumpValue)=='friend'));
% fMore = nanmean(d.choiceRT(d.pickTarget(d.pickValue>d.dumpValue)=='friend'));
% fLess = nanmean(d.choiceRT(d.pickTarget(d.pickValue<d.dumpValue)=='friend'));
% pTot = nanmean(d.choiceRT(d.pickTarget=='parent'));
% Ps = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='self')=='parent'));
% Pf = nanmean(d.choiceRT(d.pickTarget(d.dumpTarget=='friend')=='parent'));
% pEq = nanmean(d.choiceRT(d.pickTarget(d.pickValue==d.dumpValue)=='parent'));
% pMore = nanmean(d.choiceRT(d.pickTarget(d.pickValue>d.dumpValue)=='parent'));
% pLess = nanmean(d.choiceRT(d.pickTarget(d.pickValue<d.dumpValue)=='parent'));
% RTs(sCount,:) = [sTot fTot pTot Sf Sp Fs Fp Ps Pf sEq fEq pEq sMore fMore pMore sLess fLess pLess aEq aMore aLess];
