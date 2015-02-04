function avg_pred_error = rwmodel(stim, resp, fb, learning_rate, nruns)

if ~exist('nruns'),
    nruns = 1000;
end

% load('hot_cold');
% colormap(hot_cold);

nstim = length(unique(stim));  % number of stimuli

avg_pred_error = zeros(nruns, nstim);

rand('twister',sum(100*clock))

for x=1:nruns,
    prediction_errors = rwmodel_estimate(stim, resp, fb, learning_rate);
    avg_pred_error(x,:) = prediction_errors;
end;

avg_pred_error = squeeze(mean(avg_pred_error,1)); 


figure(1)
bar(avg_pred_error)
axis([0, (length(avg_pred_error) + 1) 0 1])
title('simulated learning prediction error')
xlabel('condition')
ylabel('percentage deviated')

