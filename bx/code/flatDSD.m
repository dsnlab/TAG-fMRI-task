function [dsdMatrix] = flatDSD (drsStructure)

drs = drsStructure;
columnHeads = {'sess','choiceOns','choiceRT','choseSelf','choseFriend','choseParent','coinSelf','coinFriend','coinParent','discoOns','discoRT','skipped'};
dsdMatrix = {};
for sCount = 1:length(drs);
    if sCount < 10;
        thisSub = ['drs00',num2str(sCount)];
    elseif sCount < 100;
        thisSub = ['drs0',num2str(sCount)];
    end
    sess = [ones(length(drs(sCount).dsd(1).choice.onsets),1) ; 2.*ones(length(drs(sCount).dsd(2).choice.onsets),1)];
    choiceOns = [drs(sCount).dsd(1).choice.onsets ; 432+drs(sCount).dsd(2).choice.onsets];
    choiceRT = [drs(sCount).dsd(1).choice.rt ; drs(sCount).dsd(2).choice.rt];
    discoOns = [drs(sCount).dsd(1).disco.onsets ; 432+drs(sCount).dsd(2).disco.onsets];
    discoRT = [drs(sCount).dsd(1).disco.rt ; drs(sCount).dsd(2).disco.rt];
    targetChosen = [drs(sCount).dsd(1).choice.targetChosen ; drs(sCount).dsd(2).choice.targetChosen];
    targetDumped = [drs(sCount).dsd(1).choice.targetDumped ; drs(sCount).dsd(2).choice.targetDumped];
    coinChosen = [drs(sCount).dsd(1).choice.coinChosen ; drs(sCount).dsd(2).choice.coinChosen];
    coinDumped = [drs(sCount).dsd(1).choice.coinDumped ; drs(sCount).dsd(2).choice.coinDumped];
    skips = zeros(length(sess),1);
    choiceMatrix = nan(length(sess),3);
    coinMatrix = choiceMatrix;
    for tCount = 1:length(choiceMatrix);
        target = targetChosen(tCount);
        dumpee = targetDumped(tCount);
        if isnan(target)
            skips(tCount) = 1;
        else
            choiceMatrix(tCount,target) = 1;
            choiceMatrix(tCount,dumpee) = 0;
            coinMatrix(tCount,target) = coinChosen(tCount);
            coinMatrix(tCount,dumpee) = coinDumped(tCount);
        end
    end

    dsdMatrix{sCount} = [sess choiceOns choiceRT choiceMatrix coinMatrix discoOns discoRT skips];
end

end



