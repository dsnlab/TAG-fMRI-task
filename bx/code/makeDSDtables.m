function [subTables dsdTable] = makeDSDtables(data_path)
%MAKEDSDTABLE.M
% Usage: dsdTable = makeDSDtable ( data_path )
% data_path is a directory w/ raw text output from runDSD.m
% makeDSDtable loads all raw DRS data, does some cleaning,
% and stores a cell w/ individual trial-based tables per-subejct
% and a mammoth table object with all trials
% ~#wem3#~ [20150311]

% Note: data_path wants a Unix-style path.
% If you're using PathFinder like wise people do, you can just
% browse to the folder, right-click and Copy File Path (UNIX)).
dsdTable=[];
dsd_data_files = dir([data_path,filesep,'*dsd*output*.txt']);
subject_numbers = {};
targetNames = {'self','friend','parent'};
coinNames = {'1','2','3','4','0'};
discoNames = {'yes','no'};
for sCount = 1:length(dsd_data_files)
    subject_numbers{sCount} = (dsd_data_files(sCount).name(1:6));
end
subject_data_files = {};
run1_files = 1:2:(2*length(subject_numbers));
run2_files = 2:2:(2*length(subject_numbers));
subject_numbers = unique(subject_numbers);
subTables=cell(1,length(subject_numbers));
for sCount = 1:length(subject_numbers)
    dsd1file = dsd_data_files(run1_files(sCount)).name;
    dsd2file = dsd_data_files(run2_files(sCount)).name; 
    % rpe_data_files(run1_files(sCount)).name;
    % rpe_data_files(run2_files(sCount)).name;
    % svc_data_files(run1_files(sCount)).name;
    % svc_data_files(run2_files(sCount)).name;
    %%
    fid=fopen(dsd1file);
    dsd1=textscan(fid,'%u %u %u %u %u %u %f %u %f %f %u %f %u %s\n','Delimiter',',');
    fclose(fid);
    fid=fopen(dsd2file);
    dsd2=textscan(fid,'%u %u %u %u %u %u %f %u %f %f %u %f %u %s\n','Delimiter',',');
    %%
    sess=[ones(length(dsd1{1,1}),1);2*ones(length(dsd2{1,1}),1)];
    tnum=[dsd1{1,1};dsd2{1,1}];
    targetPairs=[dsd1{1,3},dsd1{1,4};dsd2{1,3},dsd2{1,4}];
    targetPairsRev=[dsd1{1,4},dsd1{1,3};dsd2{1,4},dsd2{1,3}];
    coinPairs=[dsd1{1,5},dsd1{1,6};dsd2{1,5},dsd2{1,6}];
    coinPairsRev=[dsd1{1,6},dsd1{1,5};dsd2{1,6},dsd2{1,5}];
    choiceOnset=[dsd1{1,7};dsd2{1,7}];
    choiceResponse=[dsd1{1,8};dsd2{1,8}];
    choiceRT=[dsd1{1,9};dsd2{1,9}];
    discoOnset=[dsd1{1,10};dsd2{1,10}];
    discoResponse=[dsd1{1,11};dsd2{1,11}];
    discoRT=[dsd1{1,12};dsd2{1,12}];

    nanDex=(choiceResponse==0);
    choiceResponse(nanDex)=1;

    subID = sCount.*ones(length(tnum),1);
    for tCount = 1:length(tnum);
        pickTarget(tCount,1)=targetPairs(tCount,choiceResponse(tCount));
        dumpTarget(tCount,1)=targetPairsRev(tCount,choiceResponse(tCount));
        pickCoin(tCount,1)=coinPairs(tCount,choiceResponse(tCount));
        dumpCoin(tCount,1)=coinPairsRev(tCount,choiceResponse(tCount));
    end
    pickTarget(nanDex)=NaN;
    dumpTarget(nanDex)=NaN;    
    pickCoin(nanDex)=NaN;
    dumpCoin(nanDex)=NaN;
    pickValue=pickCoin;
    dumpValue=dumpCoin;    
    pickValue(pickCoin==5)=0;
    dumpValue(dumpCoin==5)=0;
    thisTable = table(subID,sess,tnum,pickTarget,dumpTarget,pickCoin,dumpCoin,pickValue,dumpValue,discoResponse,choiceOnset,choiceRT,discoOnset,discoRT);
    tVals=1:3; cVals=1:5; dVals=1:2;sVals=1:length(subject_numbers);
    thisTable.subID=categorical(subID,sVals,subject_numbers);
    thisTable.pickTarget=categorical(pickTarget,tVals,targetNames);
    thisTable.dumpTarget=categorical(dumpTarget,tVals,targetNames);
    thisTable.pickCoin=categorical(pickCoin,cVals,coinNames);
    thisTable.dumpCoin=categorical(dumpCoin,cVals,coinNames);
    thisTable.discoResponse=categorical(discoResponse,dVals,discoNames);
    subTables{sCount}=thisTable;
    dsdTable=[dsdTable;thisTable];
    clear ('thisTable','subID','sess','tnum','pickTarget','dumpTarget','pickCoin','dumpCoin','pickValue','dumpValue','discoResponse','choiceOnset','choiceRT','discoOnset','discoRT');
end



