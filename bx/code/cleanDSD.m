function [dsdHeaders dsdTrials trialIndex flatStim flatResp] = cleanDSD(raw);
% CLEANDSD.M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   usage: [dsdHeaders dsdTrials trialIndex flatChoice flatDisco] = cleanDSD(raw)
%   input: raw - [90 trials x 15 predictors] page from rawDRS
%
%   author: wem3
%   written: 150320
%   modified: 150321 ~wem3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subNum = raw(:,1);
sess = raw(:,2);
tnum = raw(:,3);
tcond = raw(:,4);
tPairs = raw(:,[5 6]);
tRev = raw(:,[6 5]);
cPairs = raw(:,[7 8]);
cRev = raw(:,[8 7]);
cResp = raw(:,10);
disco = raw(:,13);
choiceOnset = raw(:,9);
choiceRT = raw(:,11);
discoOnset = raw(:,12);
discoRT = raw(:,14);
for tCount = 1:length(raw)
    if cResp(tCount)==0
        pick(tCount,1) = nan;
        dump(tCount,1) = nan;
        pickCoin(tCount,1) = nan;
        dumpCoin(tCount,1) = nan;
    else
        pick(tCount,1) = tPairs(tCount,cResp(tCount));
        dump(tCount,1) = tRev(tCount,cResp(tCount));
        pickCoin(tCount,1) = cPairs(tCount,cResp(tCount));
        dumpCoin(tCount,1) = cRev(tCount,cResp(tCount));
    end

    if disco(tCount,1)==0
        disco(tCount,1) = nan;
    end
end

diffCoin = pickCoin - dumpCoin;
% make a cell array to hold data for each subject
dsdHeaders = {'subNum','sess','tcond','pick','dump','pickCoin','dumpCoin','diffCoin','disco','choiceOnset','choiceRT','discoOnset','discoRT'};
dsdTrials = [subNum,sess,tcond,pick,dump,pickCoin,dumpCoin,diffCoin,disco,choiceOnset,choiceRT,discoOnset,discoRT];
% call flattenDSDchoice|response to make binary trial matrices (design matrix style)
flatStim = flattenDSDchoice(tPairs,cPairs);
flatResp = flattenDSDresponse(pick,pickCoin);
% make a structure to hold trial indices (for quick grabbin' later)
% conditions
trialIndex.SvF = find(tcond==1)';
trialIndex.SvP = find(tcond==2)';
trialIndex.FvP = find(tcond==3)';
% chose target:
trialIndex.S = find(pick==1)';
trialIndex.F = find(pick==2)';
trialIndex.P = find(pick==3)';
% chose target: (capital chosen, lowercase dumped)
trialIndex.Sf = find(pick==1 & dump==2)';
trialIndex.Fs = find(pick==2 & dump==1)';
trialIndex.Sp = find(pick==1 & dump==3)';
trialIndex.Ps = find(pick==3 & dump==1)';
trialIndex.Fp = find(pick==3 & dump==2)';
trialIndex.Pf = find(pick==2 & dump==3)';
% chose target per monetary comparison
trialIndex.Sls = find(pick==1 & dump==2 & (pickCoin < dumpCoin))';
trialIndex.Smo = find(pick==2 & dump==1 & (pickCoin > dumpCoin))';
trialIndex.Seq = find(pick==1 & dump==3 & (pickCoin == dumpCoin))';
trialIndex.Fls = find(pick==3 & dump==1 & (pickCoin < dumpCoin))';
trialIndex.Fmo = find(pick==3 & dump==2 & (pickCoin > dumpCoin))';
trialIndex.Feq = find(pick==2 & dump==3 & (pickCoin == dumpCoin))';
trialIndex.Pls = find(pick==3 & dump==1 & (pickCoin < dumpCoin))';
trialIndex.Pmo = find(pick==3 & dump==2 & (pickCoin > dumpCoin))';
trialIndex.Peq = find(pick==2 & dump==3 & (pickCoin == dumpCoin))';
% disco yes/no by target
trialIndex.yesS = find(pick==1 & disco==1)';
trialIndex.yesF = find(pick==1 & disco==2)';
trialIndex.yesP = find(pick==1 & disco==3)';
trialIndex.noS = find(pick==2 & disco==1)';
trialIndex.noF = find(pick==2 & disco==2)';
trialIndex.noP = find(pick==2 & disco==3)';
end