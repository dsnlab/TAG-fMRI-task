function [ DSDvals, fit, nullFit ] = computeDSDvalue( coinMatrix , targetMatrix )

[DSDvals,fit]=fminsearch(@comp_val,[1 1 1],[],coinMatrix,targetMatrix);
% compute the fit of the stupid model (null model) that assumes no internal
% values and always going for the more expensive option
nullFit = comp_val([0 0 0],coinMatrix,targetMatrix);

function like=comp_val(p,coinMatrix,targetMatrix)
% p=[x,y,z] internal values for sharing with mom, friend, and private
% coinMatrix = [val_mom, val_friend, val_private]; use "nan" for whatever was not
% a choice
% targetMatrix = [target_mom, target_friend, target_private]; use "1" for the selected,
% use "0" for not selected, use "nan" for whatever was not a choice
for t=1:length(coinMatrix)
    target = find(targetMatrix(t,:)==1);
    dumpee = find(targetMatrix(t,:)==0);
    p_target(t) = (coinMatrix(target)+p(target))./((coinMatrix(target)+p(target))+(coinMatrix(dumpee)+p(dumpee)));
end
like = -2*sum(log(p_target));

% usage for finding the internal values: [pu,fit]=fminsearch(@comp_val,[1 1 1],[],coinMatrix,target)
