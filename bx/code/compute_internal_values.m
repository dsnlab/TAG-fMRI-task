function [pu,fit,nullfit]=compute_internal_values(stim,resp)

% somewhere here make sure stim and resp for the fminsearch are in the
% correct format

[pu,fit]=fminsearch(@comp_val,[1 1 1],[],stim,resp);
% compute the fit of the stupid model (null model) that assumes no internal
% values and always going for the more expensive option
nullfit = comp_val([0 0 0],stim,resp);

function like=comp_val(p,stim,resp)

% p=[x,y,z] internal values for sharing with mom, friend, and private
% stim = [val_mom, val_friend, val_private]; use "nan" for whatever was not
% a choice
% resp = [resp_mom, resp_friend, resp_private]; use "1" for the selected,
% use "0" for not selected, use "nan" for whatever was not a choice

for t=1:length(stim)
    which_resp = find(resp(t,:)==1);
    which_noselect = find(resp(t,:)==0);
    p_resp(t) = (stim(which_resp)+p(which_resp))./((stim(which_resp)+p(which_resp))+(stim(which_noselect)+p(which_noselect)));
end

like = -sum(log(p_resp));

% usage for finding the internal values: [pu,fit]=fminsearch(@comp_val,[1 1 1],[],stim,resp)
