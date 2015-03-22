function [pu,fit,nullfit]=compute_internal_values(stim,resp)

% somewhere here make sure stim and resp for the fminsearch are in the
% correct format
% calculate observed probability of responses (to use as input to fminsearch)
%pA = sum(resp(:,1)) / length(resp);
%pB = sum(resp(:,2)) / length(resp);
[pu,fit]=fminsearch(@comp_val,[.5 .5],[],stim,resp);
% compute the fit of the stupid model (null model) that assumes no internal
% values and always going for the more expensive option
nullfit = comp_val([0 0],stim,resp);

function like=comp_val(p,stim,resp)

for t=1:length(stim)
    which_resp = find(resp(t,:)==1);
    which_noselect = find(resp(t,:)==0);
    p_resp(t) = (stim(which_resp)+p(which_resp))./((stim(which_resp)+p(which_resp))+(stim(which_noselect)+p(which_noselect)));
end

like = -2*sum(log(p_resp));

% usage for finding the internal values: [pu,fit]=fminsearch(@comp_val,[1 1 1],[],stim,resp)
