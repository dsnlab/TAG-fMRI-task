function [subIDlist,rawData,columnHeaders] = rawDRS (task,data_path);
% RAWDRS.M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   usage: [subIDlist,rawData] = rawDRS [data_path]
%   input: task = string (dsd,rpe,svc)
%          data_path = string, path to raw .mat output from run(DSD|RPE|SVC).m
%
%   author: wem3
%   written: 150319
%   modified: 150319 ~wem3
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output_files = dir([data_path,filesep,'*',task,'*.mat']);
subIDlist = {};

for sCount = 1:length(output_files)
    subIDlist{sCount} = (output_files(sCount).name(1:6));
end
subject_data_files = {};
run1_files = 1:2:(2*length(subIDlist));
run2_files = 2:2:(2*length(subIDlist));
subIDlist = unique(subIDlist);
subTables=cell(1,length(subIDlist));
for sCount = 1:length(subIDlist)
    load(output_files(run1_files(sCount)).name);
    r1=task.output.raw;
    load(output_files(run2_files(sCount)).name); 
    r2=task.output.raw;
    raw=[r1;r2];
    sess=[ones(length(r1),1);2.*ones(length(r2),1)];
    subNum=sCount.*ones(length(sess),1);
    if length(sess)==90 % if it's the DSD task, we need to replace '5' w/ '0' in the coin output
      raw(raw(:,5)==5,5)=0;
      raw(raw(:,6)==5,6)=0;
    end
    rawData(:,:,sCount) = [subNum,sess,raw];
end


columnHeaders ={...
'subNum',...            %  1. (NOT the same as subID, which is a string)
'sess',...              %  2. functional run number
'tnum',...              %  3. trial number
'tcond',...             %  4. choice condition: 1 == self, 2 == friend, 3 == parent
'leftTarget',...        %  5. left target
'rightTarget',...       %  6. right target
'leftCoin',...          %  7. left coin
'rightCoin',...         %  8. right coin
'choiceOnset',...       %  9. stimulus onset for choice
'choiceResponse',...    % 10. response to choice (1 == left, 2 == right)
'choiceRT',...          % 11. reaction time for choice
'discoOnset',...        % 12. onset for disclosure statement
'discoResponse',...     % 13. response to disclosure (1 == yes, 2 == no)
'discoRT',...           % 14. reaction time for disclosure
'payout'};              % 15. payout


