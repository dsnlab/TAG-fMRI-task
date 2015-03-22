function [subTables svcTable] = makeSVCtables(data_path)
%MAKESVCTABLE.M
% Usage: [subTables groupTable] = makeSVCtable ( data_path )
% data_path is a directory w/ raw text output from runSVC.m
% makeSVCtable loads all raw SVC data, does some cleaning,
% and stores a cell array with one table / subject as well as 
% a mammoth table object for all trials / all subjects
% ~#wem3#~ [20150311]

% Note: data_path wants a Unix-style path.
% If you're using PathFinder like wise people do, you can just
% browse to the folder, right-click and Copy File Path (UNIX)).
svcTable=[];
svc_data_files = dir([data_path,filesep,'*svc*output*.txt']);
subject_numbers = {};
blockNames = {'self','change'};
respNames = {'yes','no'};
adjNames = {'anti','pro'};
for sCount = 1:length(svc_data_files)
    subject_numbers{sCount} = (svc_data_files(sCount).name(1:6));
end
subject_data_files = {};
run1_files = 1:2:(2*length(subject_numbers));
run2_files = 2:2:(2*length(subject_numbers));
subject_numbers = unique(subject_numbers);
subTables=cell(1,length(subject_numbers));
for sCount = 1:length(subject_numbers)
    svc1file = svc_data_files(run1_files(sCount)).name;
    svc2file = svc_data_files(run2_files(sCount)).name; 
    fid=fopen(svc1file);
    svc1=textscan(fid,'%u %u %f %f %u %u %u %s\n','Delimiter',',');
    fclose(fid);
    fid=fopen(svc2file);
    svc2=textscan(fid,'%u %u %f %f %u %u %u %s\n','Delimiter',',');
    %%
    sess=[ones(length(svc1{1,1}),1);2*ones(length(svc2{1,1}),1)];
    subID=sCount.*ones(length(sess),1);
    tnum=[svc1{1,1};svc2{1,1}];
    tcond=[svc1{1,2};svc2{1,2}];
    block=tcond;
    block(block==2)=1;
    block(block==3)=2;
    block(block==4)=2;
    adj=tcond;
    adj(adj==3)=1;
    adj(adj==4)=2;
    onset=[svc1{1,3};svc2{1,3}];
    RT=[svc1{1,4};svc2{1,4}];
    response=[svc1{1,5};svc2{1,5}];
    reverse=[svc1{1,6};svc2{1,6}];
    syllables=[svc1{1,7};svc2{1,7}];
    word=[svc1{1,8};svc2{1,8}];
    response(response==0)=NaN;
    response(response==2)=0;

    thisTable = table(subID,sess,tnum,block,response,adj,syllables,onset,RT,word);
    dVals=1:2;sVals=1:length(subject_numbers);
    thisTable.subID=categorical(subID,sVals,subject_numbers);
    thisTable.block=categorical(block,dVals,blockNames);
    thisTable.adj=categorical(adj,dVals,adjNames);
    subTables{sCount}=thisTable;
    svcTable=[svcTable;thisTable];
    clear ('thisTable','subID','sess','tnum','block','adj','syllables','response','onset','RT');
end



