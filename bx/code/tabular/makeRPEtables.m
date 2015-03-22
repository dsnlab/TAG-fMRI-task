function [subTables rpeTable] = makeRPEtables(data_path)
%MAKERPETABLES.M
% Usage: [subTables groupTable] = makeRPEtable ( data_path )
% data_path is a directory w/ raw text output from runRPE.m
% makeRPEtable loads all raw RPE data, does some cleaning,
% and stores a cell array with one table / subject as well as 
% a mammoth table object for all trials / all subjects
% ~#wem3#~ [20150311]

%% initialize variables, get data files
rpeTable=[];
rpe_data_files = dir([data_path,filesep,'*rpe*output*.txt']);
% note: we need the input files b/c output .txt foolishly does not include the 
% 'outcome' column (.mat style output does, but this function is for .txt)
% this assumes that the input directory is at the same level as the output 
% (e.g., ~/DRS/task)
input_path=([data_path(1:(end-6)),'input']);
rpe_input_files = dir([input_path,filesep,'*rpe*input*.txt']);
subject_numbers = {};
stimNames = {'lux2','lux4','sto2','sto4','raz2','raz4'};
respNames = {'Lux','Raz'};
%% loop over subjects to get subIDs
for sCount = 1:length(rpe_data_files)
    subject_numbers{sCount} = (rpe_data_files(sCount).name(1:6));
end
subject_data_files = {}; % cell to hold filenames
run1_files = 1:2:(2*length(subject_numbers)); % index vector
run2_files = 2:2:(2*length(subject_numbers)); % index vector
subject_numbers = unique(subject_numbers); % dump the extra copy of subID
subTables=cell(1,length(subject_numbers)); % cell to hold per-sub tables
%% loop over subjects to load/clean the data
for sCount = 1:length(subject_numbers) 
    rpe1file = rpe_data_files(run1_files(sCount)).name;
    rpe2file = rpe_data_files(run2_files(sCount)).name;
    inputfile = rpe_input_files(sCount).name;
    fid=fopen(inputfile);
    inp=textscan(fid,'%f %f %f %f %f\n','Delimiter',',');
    fclose(fid);
    fb=[inp{1,5};inp{1,5}];
    clear inp;
    fid=fopen(rpe1file);
    rpe1=textscan(fid,'%f %f %f %f %f %f %f %f %f\n','Delimiter',',');
    fclose(fid);
    fid=fopen(rpe2file);
    rpe2=textscan(fid,'%f %f %f %f %f %f %f %f %f\n','Delimiter',',');
    %%
    sess=[ones(length(rpe1{1,1}),1);2*ones(length(rpe2{1,1}),1)];
    subID=sCount.*ones(length(sess),1);
    tnum=[rpe1{1,1};rpe2{1,1}];
    stim=[rpe1{1,2};rpe2{1,2}];
    magVec = [2 4 2 4 2 4];
    mag = magVec(stim)';
    block=([ones(1,24),2.*ones(1,24),3.*ones(1,24),4.*ones(1,24),5.*ones(1,24),6.*ones(1,24)])';
    stimOns=[rpe1{1,3};rpe2{1,3}];
    resp=[rpe1{1,4};rpe2{1,4}];
    RT=[rpe1{1,5};rpe2{1,5}];
    fbOns=[rpe1{1,6};rpe2{1,6}];
    reward=[rpe1{1,7};rpe2{1,7}];
    pRaz=[rpe1{1,8};rpe2{1,8}];
    tDur=[rpe1{1,9};rpe2{1,9}];
    accuracy = (resp==fb);
    [ev_choice ev_diff ev_sum pe] = modelRPEparams(stim, resp, fb);
    ev_choice=ev_choice';
    ev_diff=ev_diff';
    ev_sum=ev_sum';
    pe=pe';
    thisTable = table(subID,sess,tnum,block,stim,resp,fb,reward,accuracy,mag,ev_choice,ev_sum,ev_diff,pe,stimOns,RT,fbOns,tDur,pRaz);
    %thisTable = table(subID,sess,tnum,block,stim,resp,fb,reward,accuracy,mag,stimOns,RT,fbOns,tDur,pRaz);
    aVals=1:6;dVals=1:2;sVals=1:length(subject_numbers);
    thisTable.subID=categorical(subID,sVals,subject_numbers);
    thisTable.block=categorical(block,[1:6],'Ordinal',true);
    thisTable.sess=categorical(sess,[1:2],'Ordinal',true);
    thisTable.tnum=categorical(tnum,[1:72],'Ordinal',true);
    thisTable.stim=categorical(stim,aVals,stimNames);
    thisTable.resp=categorical(resp,dVals,respNames);
    thisTable.reward=categorical(reward,[0 2 4],'Ordinal',true);
    thisTable.mag=categorical(mag,[2 4],'Ordinal',true);
    thisTable.fb=categorical(fb,dVals,respNames);
    subTables{sCount}=thisTable;
    rpeTable=[rpeTable;thisTable];
end



