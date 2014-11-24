%%%% Program made by Don, updated by Jess to include more regressors 1/8/09


% fnames = [];
% 
% fnames{1}={'./jess_data/30009_rp_run1_24-Jul-2006_18-38.mat', './jess_data/30009_rp_run2_24-Jul-2006_18-47.mat'};
% fnames{2}={'./jess_data/30017_rp_run1_21-Aug-2006_14-55.mat', './jess_data/30017_rp_run2_21-Aug-2006_15-02.mat'};
% fnames{3}={'./jess_data/30033_rp_run1_06-Jan-2007_16-54.mat', './jess_data/30033_rp_run2_06-Jan-2007_17-01.mat'};
% fnames{4}={'./jess_data/30046_rp_run1_17-Feb-2007_19-01.mat', './jess_data/30046_rp_run2_17-Feb-2007_19-10.mat'};

data_path = '../../jess_data/';
[fnames, subject_ids] = load_data(data_path); % calls load data function Don made, make sure path is accurate!


% do a grid search to find best learning rate
% learning_rate = 0.0005:0.00025:0.005;
ssd_figure = figure(2);

for cf = 1:length(fnames)
    
    fname = fnames{cf};
    
    subject_id = subject_ids{cf};
    
    [stim, resp, fb, stim_onset, fb_onset, reward] =  preprocess_jess(fname, data_path);

    learning_rate = 0.02:0.02:.6;

    ssd = zeros(1, length(learning_rate));
    ssd_var = zeros(1, length(learning_rate));

    for lr = 1:length(learning_rate)
        disp(sprintf('simulation %d of %d\n',lr,length(learning_rate)));
        avg_pred_error = rwmodel(stim, resp, fb, learning_rate(lr), 100);
        ssd(lr) = mean(avg_pred_error);
        ssd_var(lr) = var(avg_pred_error);
    end

    % best_ssd = find(ssd == min(ssd));

    best_ssd = max(find(ssd <= (min(ssd) * 1.1)))


    %% Calculate Expcted Value and Prediction Error after finding best fit

    [ev_choice ev_diff ev_sum pe] = (rwmodel_prederr(stim, resp, fb, learning_rate(best_ssd)));
    % pe = pe.^2;
    % center vector--demean vector to use as a regressor! 
	% Only if use all trials in one big regressor
    % ev = ev - mean(ev);
    % pe = pe - mean(pe);
    
    %% Find correlations to make sure use uncorrelated regressors!
    fprintf('Subject %d\n',cf);
    [r,p]=corr(ev_choice',ev_diff');
    choice_diff_corr(cf,1)=r;
    choice_diff_corr(cf,2)=p;
    [r,p]=corr(ev_choice',ev_sum');
    choice_sum_corr(cf,1)=r;
    choice_sum_corr(cf,2)=p;
    [r,p]=corr(ev_sum',ev_diff')
    sum_diff_corr(cf,1)=r;
    sum_diff_corr(cf,2)=p;
    [r,p]=corr(ev_choice',pe');
    choice_pe_corr(cf,1)=r;
    choice_pe_corr(cf,2)=p;
    [r,p]=corr(ev_diff',pe');
    diff_pe_corr(cf,1)=r;
    diff_pe_corr(cf,2)=p;
    [r,p]=corr(ev_sum',pe');
    sum_pe_corr(cf,1)=r;
    sum_pe_corr(cf,2)=p;

end

save regressor_corr.mat choice_diff_corr choice_sum_corr sum_diff_corr choice_pe_corr diff_pe_corr sum_pe_corr