function [drs] = raw_data_to_drs(data_path)
% Function to load all DRS data and store as a structure
% modified by wem3, 2/18/15

% Note: data_path wants a Unix-style path.
% It needs ' ' on either end, and the / after the last directory
% If you're using PathFinder like wise people do, you can just
% browse to the folder, right-click and Copy File Path (UNIX)).
sub_info_files = dir([data_path,filesep,'*info*.mat']);
dsd_data_files = dir([data_path,filesep,'*dsd*.mat']);
rpe_data_files = dir([data_path,filesep,'*rpe*.mat']);
svc_data_files = dir([data_path,filesep,'*svc*.mat']);
subject_numbers = {};

for sCount = 1:length(sub_info_files)
    subject_numbers{sCount} = (sub_info_files(sCount).name(1:6));
end

subject_data_files = {};
run1_files = 1:2:(2*length(subject_numbers));
run2_files = 2:2:(2*length(subject_numbers));
%subject_numbers = unique(subject_numbers);

for sCount = 1:length(subject_numbers)
  subject_data_files{sCount} = {dsd_data_files(run1_files(sCount)).name, dsd_data_files(run2_files(sCount)).name; 
                            rpe_data_files(run1_files(sCount)).name, rpe_data_files(run2_files(sCount)).name;
                            svc_data_files(run1_files(sCount)).name, svc_data_files(run2_files(sCount)).name};
  for rCount = 1:2;
    load(subject_data_files{sCount}{1,rCount});
    drs(sCount).dsd(rCount) = task;
    clear task
    
    load(subject_data_files{sCount}{2,rCount});
    task.output.raw = task.output.raw(:,[1:9]);
    drs(sCount).rpe(rCount) = task;
    clear task
    
    load(subject_data_files{sCount}{3,rCount});
    task.output.raw = task.output.raw(:,[1:7]);
    drs(sCount).svc(rCount) = task;
    clear task
  end

end



