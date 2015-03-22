function [ev_choice ev_diff ev_sum pe] = modelRPEparams(stim, resp, fb)
fb(fb==1)=0;
fb(fb==2)=1;
resp(resp==1)=0;
resp(resp==2)=1;
%% fit learning rates
learning_rate = (0.02:.02:.6);
ssd = zeros(1, length(learning_rate));
ssd_var = zeros(1, length(learning_rate));
for lr = 1:length(learning_rate)
    disp(sprintf('simulation %d of %d\n',lr,length(learning_rate)));
    avg_pred_error = rwmodel(stim', resp', fb', (learning_rate(lr)), 1000);
    ssd(lr) = mean(avg_pred_error);
    ssd_var(lr) = var(avg_pred_error);
end
optimal_ssd = find(ssd == min(ssd));
best_ssd = max(find(ssd <= (min(ssd) * 1.1)));
[ev_choice ev_diff ev_sum pe] = (rwmodel_prederr(stim, resp, fb, learning_rate(best_ssd)));
disp(sprintf('optimum learning rate = %0.5f\n', learning_rate(best_ssd)));