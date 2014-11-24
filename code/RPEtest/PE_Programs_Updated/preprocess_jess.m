function [stim, resp, rt, fb, stim_onset, fb_onset, reward, noresp_run1, noresp_run2] =  preprocess_jess(fname_, data_path_)
% Function to preprocess RP data before putting it through Don's model,
% made by Don; this is called by fit_learning rate
% Commented by Jess 1/8/09

% Note: data_path takes the form: '../jess_data/'
% It needs ' ' on either end, and the / after the last directory
% fname must be a cell, not a char
% This inputs each file and outputs variables listing stim (1-6), sub resp,
% fb received (outcome, 0 or 1), fb onset time, and reward magnitude (10 or 50)

% preprocess the data


        % rec_task columns: 1=blocktype (always 1)
        %                   2=list order number
        %                   3-trial number
        %                   4=trial duration
        %                   5-absolute time from start of task until stim
        %                   6-response
        %                   7-RT
        %                   8-stimulus
        %                   9-outcome (0 if eastern, 1 if northern)
        %                   10-prob of stim being associated with northern
        %                   11-magnitude of reward
        %                   12-reward amount-what subject actually gets
        %                   13-absolute time from start of task until fb



load([data_path_ char(fname_(1))])
rec_task1=rec_task;
load([data_path_ char(fname_(2))])
rec_task2=rec_task;

rec_task=[rec_task1; rec_task2];

ntrials=length(rec_task);

stim=0;
resp=0;
rt=0;
fb=0;
mag=fb;
trialnum=fb;
onset=fb;
sess=0;
fb_onset = 0;
noresp_run1=0;
noresp_run2=0;
ctr=1;
for x=1:ntrials,
%      Use to skip trials where subject didn't respond, since can't really
%      model what they chose to do/prediction error
     
     if isempty(rec_task{x,6}),
         if x>length(rec_task1),
             noresp_run2=noresp_run2+1;
         else,
             noresp_run1=noresp_run1+1;
         end;
         continue;
     end;
     
     if rec_task{x,8}>0,
        stim(ctr)=rec_task{x,8};
     else,
         continue
     end
     
     if strcmp(rec_task{x,6},'b'),
         resp(ctr)=1;
     elseif strcmp(rec_task{x,6},'y'),
         resp(ctr)=0;
     else,
         continue
     end;
     
     if x>length(rec_task1),
         sess(ctr)=2;
     else,
         sess(ctr)=1;
     end;
     
     rt(ctr) = rec_task{x,7};
     reward(ctr) = rec_task{x,11};
     fb(ctr) = rec_task{x,9};
     mag(ctr) = rec_task{x,11};
     trialnum(ctr) = x;
     stim_onset(ctr) = rec_task{x,5};
     fb_onset(ctr) = rec_task{x,13};
     ctr = ctr + 1;
end;

     