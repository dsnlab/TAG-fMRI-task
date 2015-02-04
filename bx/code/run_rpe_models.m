function [drs] = run_rpe_models
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% run_rpe_models.m: calculate per-trial EV & PE from raw data
%
%               ~wem3 - 141218
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
data_path = '~/Desktop/DRS/task/output/';
[subject_data_files, subject_numbers] = load_data(data_path);
[drs] = clean_rpe(data_path, subject_data_files, subject_numbers);
fit_learning_rate;