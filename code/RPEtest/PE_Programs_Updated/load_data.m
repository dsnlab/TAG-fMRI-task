function [subject_data_files, subject_numbers] = load_data(data_path)
% Function to load all RP input data, made by Don; this is called by
% fit_learning rate
% Commented by Jess, 1/8/09

% Note: data_path takes the form: '../jess_data/'
% It needs ' ' on either end, and the / after the last directory


data_files = dir([data_path '*_rp_run*.mat']);

subject_numbers = {};

for i = 1:length(data_files)
    temp = (regexpi(data_files(i).name, '(.*)_rp_run*','tokens'));
    subject_numbers{i} = char(temp{1});
end

subject_numbers = unique(subject_numbers);

subject_data_files = {};

for i = 1:length(subject_numbers)
   temp = dir([data_path subject_numbers{i} '_rp_run*.mat']);
   assert(length(temp) == 2);
   subject_data_files{i} = {temp(1).name, temp(2).name}; 
end

