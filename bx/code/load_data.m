function [subject_data_files, subject_numbers] = load_data(data_path)
% Function to load all RP input data, made by Don; this is called by
% fit_learning rate
% Commented by Jess, 1/8/09
% modified by wem3, 3/27/14

% Note: data_path wants a Unix-style path.
% It needs ' ' on either end, and the / after the last directory
% If you're using PathFinder like wise people do, you can just
% browse to the folder, right-click and Copy File Path (UNIX)).
rpe_data_files = dir([data_path,filesep,'*rpe*.mat']);
subject_numbers = {};

for i = 1:length(rpe_data_files)
    temp = (regexpi(rpe_data_files(i).name, '(.*)_rpe_run*','tokens'));
    subject_numbers{i} = char(temp{1});
end

subject_data_files = {};
run1_files = 1:2:length(subject_numbers);
run2_files = 2:2:length(subject_numbers);
subject_numbers = unique(subject_numbers);

for i = 1:length(run1_files)
   subject_data_files{i} = {rpe_data_files(run1_files(i)).name, rpe_data_files(run2_files(i)).name}; 
end

