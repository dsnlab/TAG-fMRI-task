%%%% Program made by Don, updated by Jess to include more regressors 1/8/09


% fnames = [];
% 
% fnames{1}={'./jess_data/30009_rp_run1_24-Jul-2006_18-38.mat', './jess_data/30009_rp_run2_24-Jul-2006_18-47.mat'};
% fnames{2}={'./jess_data/30017_rp_run1_21-Aug-2006_14-55.mat', './jess_data/30017_rp_run2_21-Aug-2006_15-02.mat'};
% fnames{3}={'./jess_data/30033_rp_run1_06-Jan-2007_16-54.mat', './jess_data/30033_rp_run2_06-Jan-2007_17-01.mat'};
% fnames{4}={'./jess_data/30046_rp_run1_17-Feb-2007_19-01.mat', './jess_data/30046_rp_run2_17-Feb-2007_19-10.mat'};

data_path = '../../jess_data/';
[fnames, subject_ids] = load_data(data_path); % calls load data function Don made, make sure path is accurate!

% Define variables for sub_ev_sum and sub_pe to make sure right length
num_trials=144; % use number of trials, not sure why some subs have 143 and some have 144 for length of variables...
sub_ev_sum=-99*ones(length(fnames),num_trials);
sub_pe=-99*ones(length(fnames),num_trials); 
sub_ev_sum_rand=-99*ones(length(fnames),num_trials);
sub_ev_sum_pred=-99*ones(length(fnames),num_trials);
sub_pe_rand=-99*ones(length(fnames),num_trials);
sub_pe_pred=-99*ones(length(fnames),num_trials);

% do a grid search to find best learning rate
% learning_rate = 0.0005:0.00025:0.005;
ssd_figure = figure(2);

for cf = 1:length(fnames)   

    fname = fnames{cf};
    
    subject_id = subject_ids{cf};
    
    [stim, resp, rt, fb, stim_onset, fb_onset, reward, noresp_run1, noresp_run2] =  preprocess_jess(fname, data_path);

    learning_rate = 0.02:0.02:.6;

    ssd = zeros(1, length(learning_rate));
    ssd_var = zeros(1, length(learning_rate));

    for lr = 1:length(learning_rate)
        disp(sprintf('simulation %d of %d\n',lr,length(learning_rate)));
        avg_pred_error = rwmodel(stim, resp, fb, learning_rate(lr), 100);
        ssd(lr) = mean(avg_pred_error);
        ssd_var(lr) = var(avg_pred_error);
    end

    optimal_ssd = find(ssd == min(ssd));
    % This is the actual optimal ssd for the learning rate, but using this
    % tends to produce very small learning rates, so instead use the below
    % equation, which finds the highest learning rate within 10% of the
    % actual best learning rate, to increase the variance

    best_ssd = max(find(ssd <= (min(ssd) * 1.1)));
    
%     figure(1 + cf)
    figure(ssd_figure)
    hold on
    plot(learning_rate, ssd);
    title(sprintf('subject %d',cf))
    xlabel('learning rate')
    ylabel('ssd')
    plot(learning_rate(best_ssd), ssd(best_ssd), 'ro')
    plot(learning_rate, ssd_var, 'k-');
    hold off


    disp(sprintf('optimum learning rate = %0.5f\n', learning_rate(best_ssd)));
        
    % Make variable that is all subjects' learning rates and print it to a textfile
    sub_learning_rate(cf)=learning_rate(best_ssd);
    sub_learning_rate_actual(cf)=learning_rate(optimal_ssd);
    
    %% Calculate Expected Value and Prediction Error after finding best fit

    [ev_choice ev_diff ev_sum pe] = (rwmodel_prederr(stim, resp, fb, learning_rate(best_ssd)));
    % Make variable that is all subjects' ev_sum and pe and print it to a textfile
    sub_ev_sum(cf,1:length(ev_sum))=ev_sum;
    sub_pe(cf,1:length(pe))=pe;
    % Also do for each stimulus type separatey:
        % Rand (3,4)
        % Pred (1,2,5,6)
        
    sub_ev_sum_rand(cf,1:length(find(stim==3 | stim==4)))=ev_sum(find(stim==3 | stim==4));
    sub_ev_sum_pred(cf,1:length(find(stim<3 | stim>4)))=ev_sum(find(stim<3 | stim>4));
    sub_pe_rand(cf,1:length(find(stim==3 | stim==4)))=pe(find(stim==3 | stim==4));
    sub_pe_pred(cf,1:length(find(stim<3 | stim>4)))=pe(find(stim<3 | stim>4));
   
    % pe = pe.^2;
    % center vector--demean vector to use as a regressor! 
	% Only if use all trials in one big regressor
    % ev = ev - mean(ev);
    % pe = pe - mean(pe);
    
    trialctr = 1;
   
	    for f = 1:length(fname)
        
        
        % Don had as an error check, not sure how to do it without using trialcounter (I'm not), so leave out for now.       
%         old_outfile = false;
% 
%         for x = trialctr:length(pe)
%             if ((trialctr > 1) & (fb_onset(trialctr) < fb_onset(trialctr - 1)) & old_outfile)
%                 break
%             end
% 
%         end


        % After everything calculated, split variables into 2 columns so can have run 1
        % and run 2 separated
        if f==1,
            stim_temp=stim(1:(72-noresp_run1));
            resp_temp=resp(1:(72-noresp_run1));
            rt_temp=rt(1:(72-noresp_run1));
            fb_temp=fb(1:(72-noresp_run1));
            stim_onset_temp=stim_onset(1:(72-noresp_run1));
            fb_onset_temp=fb_onset(1:(72-noresp_run1));
            reward_temp=reward(1:(72-noresp_run1));
            ev_choice_temp=ev_choice(1:(72-noresp_run1));
            ev_sum_temp=ev_sum(1:(72-noresp_run1));
            ev_diff_temp=ev_diff(1:(72-noresp_run1)); % note, not using this for now!
            pe_temp=pe(1:(72-noresp_run1));
        elseif f==2,
            stim_temp=stim((72-noresp_run1+1):length(stim));
            resp_temp=resp((72-noresp_run1+1):length(resp));
            rt_temp=rt((72-noresp_run1+1):length(rt));
            fb_temp=fb((72-noresp_run1+1):length(fb));
            stim_onset_temp=stim_onset((72-noresp_run1+1):length(stim_onset));
            fb_onset_temp=fb_onset((72-noresp_run1+1):length(fb_onset));
            reward_temp=reward((72-noresp_run1+1):length(reward));
            ev_choice_temp=ev_choice((72-noresp_run1+1):length(ev_choice));
            ev_sum_temp=ev_sum((72-noresp_run1+1):length(ev_sum));
            ev_diff_temp=ev_diff((72-noresp_run1+1):length(ev_diff)); % note, not using this for now!
            pe_temp=pe((72-noresp_run1+1):length(pe));
        end;        
     
        % NOTES ABOUT THE ONSET FILES!!!!!
        % Make different onset files for each of the stimulus types and
        % pos/neg prederr
        % FOR ONSET FILES
        % col 1: onset times
        % col 2: length of time to look at each trial
        % col 3: weighting of factor (1 or weighted)

        % Onset Files to Make:
        % STIMULUS ONSET (4 files):--col 1 = stim_onset; col 2 = length of time stim up before resp (rt); col 3 = 1
        %     High Prob-Low Rew (1,5)
        %     High Prob-High Rew (2,6)
        %     Rand Prob-Low Rew (3)
        %     Rand Prob-High Rew (4)
        % STIMULUS ONSET PARAMETRIC (4 files):--col 1 = stim_onset; col 2 = length of time stim up before resp (rt); col 3 = ev_sum
        %     High Prob-Low Rew (1,5)
        %     High Prob-High Rew (2,6)
        %     Rand Prob-Low Rew (3)
        %     Rand Prob-High Rew (4)
        % CHOICE ONSET (4 files):--col 1 = stim_onset+rt; col 2 = length of time b/w response and fb (fb_onset-stim_onset-rt); col 3 = 1
        %     High Prob-Low Rew (1,5)
        %     High Prob-High Rew (2,6)
        %     Rand Prob-Low Rew (3)
        %     Rand Prob-High Rew (4)
        % CHOICE ONSET PARAMETRIC (4 files):--col 1 = stim_onset+rt; col 2 = length of time b/w response and fb (fb_onset-stim_onset-rt); col 3 = ev_choice
        %     High Prob-Low Rew (1,5)
        %     High Prob-High Rew (2,6)
        %     Rand Prob-Low Rew (3)
        %     Rand Prob-High Rew (4)
        % PREDERR ONSET (8 files):--col 1 = fb_onset; col 2 = 1.25 (constant); col 3 = 1
        %     Positive PE for each of 4 stim groups
        %     Negative PE for each of 4 stim groups
        % PREDERR ONSET PARAMETRIC (8 files):--col 1 = fb_onset; col 2 = 1.25 (constant); col 3 = pe
        %     Positive PE for each of 4 stim groups
        %     Negative PE for each of 4 stim groups
        
        % Create onset file names
        % Stim onsets
        stim_hplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_hplr_onsets.txt',subject_id ,f);
        stim_hphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_hphr_onsets.txt',subject_id ,f);
        stim_rplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_rplr_onsets.txt',subject_id ,f);
        stim_rphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_rphr_onsets.txt',subject_id ,f);
        stim_hplr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_hplr_ev_onsets.txt',subject_id ,f);
        stim_hphr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_hphr_ev_onsets.txt',subject_id ,f);
        stim_rplr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_rplr_ev_onsets.txt',subject_id ,f);
        stim_rphr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_stim_rphr_ev_onsets.txt',subject_id ,f);
        % Choice onsets
        choice_hplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_hplr_onsets.txt',subject_id ,f);
        choice_hphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_hphr_onsets.txt',subject_id ,f);
        choice_rplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_rplr_onsets.txt',subject_id ,f);
        choice_rphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_rphr_onsets.txt',subject_id ,f);
        choice_hplr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_hplr_ev_onsets.txt',subject_id ,f);
        choice_hphr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_hphr_ev_onsets.txt',subject_id ,f);
        choice_rplr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_rplr_ev_onsets.txt',subject_id ,f);
        choice_rphr_ev_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_choice_rphr_ev_onsets.txt',subject_id ,f);
        % FB onsets
        fb_pos_hplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_hplr_onsets.txt',subject_id ,f);
        fb_pos_hphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_hphr_onsets.txt',subject_id ,f);
        fb_pos_rplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_rplr_onsets.txt',subject_id ,f);
        fb_pos_rphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_rphr_onsets.txt',subject_id ,f);
        fb_neg_hplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_hplr_onsets.txt',subject_id ,f);
        fb_neg_hphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_hphr_onsets.txt',subject_id ,f);
        fb_neg_rplr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_rplr_onsets.txt',subject_id ,f);
        fb_neg_rphr_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_rphr_onsets.txt',subject_id ,f);
        fb_pos_hplr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_hplr_pe_onsets.txt',subject_id ,f);
        fb_pos_hphr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_hphr_pe_onsets.txt',subject_id ,f);
        fb_pos_rplr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_rplr_pe_onsets.txt',subject_id ,f);
        fb_pos_rphr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_pos_rphr_pe_onsets.txt',subject_id ,f);
        fb_neg_hplr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_hplr_pe_onsets.txt',subject_id ,f);
        fb_neg_hphr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_hphr_pe_onsets.txt',subject_id ,f);
        fb_neg_rplr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_rplr_pe_onsets.txt',subject_id ,f);
        fb_neg_rphr_pe_ons_name = sprintf('../../onset_files_new_demean/%s_run%d_fb_neg_rphr_pe_onsets.txt',subject_id ,f);
        
        % Open textfiles to write onset information to them
        % Stim onsets
        fid_stim_hplr = fopen(stim_hplr_ons_name, 'w');
        fid_stim_hphr = fopen(stim_hphr_ons_name, 'w');
        fid_stim_rplr = fopen(stim_rplr_ons_name, 'w');
        fid_stim_rphr = fopen(stim_rphr_ons_name, 'w');
        fid_stim_hplr_ev = fopen(stim_hplr_ev_ons_name, 'w');
        fid_stim_hphr_ev = fopen(stim_hphr_ev_ons_name, 'w');
        fid_stim_rplr_ev = fopen(stim_rplr_ev_ons_name, 'w');
        fid_stim_rphr_ev = fopen(stim_rphr_ev_ons_name, 'w');
        % Choice onsets
        fid_choice_hplr = fopen(choice_hplr_ons_name, 'w');
        fid_choice_hphr = fopen(choice_hphr_ons_name, 'w');
        fid_choice_rplr = fopen(choice_rplr_ons_name, 'w');
        fid_choice_rphr = fopen(choice_rphr_ons_name, 'w');
        fid_choice_hplr_ev = fopen(choice_hplr_ev_ons_name, 'w');
        fid_choice_hphr_ev = fopen(choice_hphr_ev_ons_name, 'w');
        fid_choice_rplr_ev = fopen(choice_rplr_ev_ons_name, 'w');
        fid_choice_rphr_ev = fopen(choice_rphr_ev_ons_name, 'w');
        % FB onsets
        fid_fb_pos_hplr = fopen(fb_pos_hplr_ons_name, 'w');
        fid_fb_pos_hphr = fopen(fb_pos_hphr_ons_name, 'w');
        fid_fb_pos_rplr = fopen(fb_pos_rplr_ons_name, 'w');
        fid_fb_pos_rphr = fopen(fb_pos_rphr_ons_name, 'w');
        fid_fb_neg_hplr = fopen(fb_neg_hplr_ons_name, 'w');
        fid_fb_neg_hphr = fopen(fb_neg_hphr_ons_name, 'w');
        fid_fb_neg_rplr = fopen(fb_neg_rplr_ons_name, 'w');
        fid_fb_neg_rphr = fopen(fb_neg_rphr_ons_name, 'w');
        fid_fb_pos_hplr_pe = fopen(fb_pos_hplr_pe_ons_name, 'w');
        fid_fb_pos_hphr_pe = fopen(fb_pos_hphr_pe_ons_name, 'w');
        fid_fb_pos_rplr_pe = fopen(fb_pos_rplr_pe_ons_name, 'w');
        fid_fb_pos_rphr_pe = fopen(fb_pos_rphr_pe_ons_name, 'w');
        fid_fb_neg_hplr_pe = fopen(fb_neg_hplr_pe_ons_name, 'w');
        fid_fb_neg_hphr_pe = fopen(fb_neg_hphr_pe_ons_name, 'w');
        fid_fb_neg_rplr_pe = fopen(fb_neg_rplr_pe_ons_name, 'w');
        fid_fb_neg_rphr_pe = fopen(fb_neg_rphr_pe_ons_name, 'w');
        
        % Make onsets and durations for all stimulus/fb types
        % Stim onsets
        stim_hplr_ons=stim_onset_temp(find(stim_temp==1 | stim_temp==5));
        stim_hphr_ons=stim_onset_temp(find(stim_temp==2 | stim_temp==6));
        stim_rplr_ons=stim_onset_temp(find(stim_temp==3));
        stim_rphr_ons=stim_onset_temp(find(stim_temp==4));
        stim_hplr_dur=rt_temp(find(stim_temp==1 | stim_temp==5));
        stim_hphr_dur=rt_temp(find(stim_temp==2 | stim_temp==6));
        stim_rplr_dur=rt_temp(find(stim_temp==3));
        stim_rphr_dur=rt_temp(find(stim_temp==4));
        stim_hplr_ev=ev_sum_temp(find(stim_temp==1 | stim_temp==5));
        stim_hplr_ev_demean=stim_hplr_ev-mean(stim_hplr_ev);
        stim_hphr_ev=ev_sum_temp(find(stim_temp==2 | stim_temp==6));
        stim_hphr_ev_demean=stim_hphr_ev-mean(stim_hphr_ev);
        stim_rplr_ev=ev_sum_temp(find(stim_temp==3));
        stim_rplr_ev_demean=stim_rplr_ev-mean(stim_rplr_ev);
        stim_rphr_ev=ev_sum_temp(find(stim_temp==4));
        stim_rphr_ev_demean=stim_rphr_ev-mean(stim_rphr_ev);
        % Choice onsets
        choice_hplr_ons=stim_onset_temp(find(stim_temp==1 | stim_temp==5)) + rt_temp(find(stim_temp==1 | stim_temp==5));
        choice_hphr_ons=stim_onset_temp(find(stim_temp==2 | stim_temp==6)) + rt_temp(find(stim_temp==2 | stim_temp==6));
        choice_rplr_ons=stim_onset_temp(find(stim_temp==3)) + rt_temp(find(stim_temp==3));
        choice_rphr_ons=stim_onset_temp(find(stim_temp==4)) + rt_temp(find(stim_temp==4));
        choice_hplr_dur=fb_onset_temp(find(stim_temp==1 | stim_temp==5)) - stim_onset_temp(find(stim_temp==1 | stim_temp==5)) - rt_temp(find(stim_temp==1 | stim_temp==5));
        choice_hphr_dur=fb_onset_temp(find(stim_temp==2 | stim_temp==6)) - stim_onset_temp(find(stim_temp==2 | stim_temp==6)) - rt_temp(find(stim_temp==2 | stim_temp==6));
        choice_rplr_dur=fb_onset_temp(find(stim_temp==3)) - stim_onset_temp(find(stim_temp==3)) - rt_temp(find(stim_temp==3));
        choice_rphr_dur=fb_onset_temp(find(stim_temp==4)) - stim_onset_temp(find(stim_temp==4)) - rt_temp(find(stim_temp==4));
        choice_hplr_ev=ev_choice_temp(find(stim_temp==1 | stim_temp==5));
        choice_hplr_ev_demean=choice_hplr_ev-mean(choice_hplr_ev);
        choice_hphr_ev=ev_choice_temp(find(stim_temp==2 | stim_temp==6));
        choice_hphr_ev_demean=choice_hphr_ev-mean(choice_hphr_ev);
        choice_rplr_ev=ev_choice_temp(find(stim_temp==3));
        choice_rplr_ev_demean=choice_rplr_ev-mean(choice_rplr_ev);
        choice_rphr_ev=ev_choice_temp(find(stim_temp==4));
        choice_rphr_ev_demean=choice_rphr_ev-mean(choice_rphr_ev);
        % FB onsets (don't need separate dur variable, because all FB = 1.25 sec)
        fb_dur=1.25;
        fb_pos_hplr_ons=fb_onset_temp(find((stim_temp==1 | stim_temp==5) & (resp_temp==fb_temp)));
        fb_pos_hphr_ons=fb_onset_temp(find((stim_temp==2 | stim_temp==6) & (resp_temp==fb_temp)));
        fb_pos_rplr_ons=fb_onset_temp(find((stim_temp==3) & (resp_temp==fb_temp)));
        fb_pos_rphr_ons=fb_onset_temp(find((stim_temp==4) & (resp_temp==fb_temp)));
        fb_neg_hplr_ons=fb_onset_temp(find((stim_temp==1 | stim_temp==5) & (resp_temp~=fb_temp)));
        fb_neg_hphr_ons=fb_onset_temp(find((stim_temp==2 | stim_temp==6) & (resp_temp~=fb_temp)));
        fb_neg_rplr_ons=fb_onset_temp(find((stim_temp==3) & (resp_temp~=fb_temp)));
        fb_neg_rphr_ons=fb_onset_temp(find((stim_temp==4) & (resp_temp~=fb_temp)));
        fb_pos_hplr_pe=pe_temp(find((stim_temp==1 | stim_temp==5) & (resp_temp==fb_temp)));
        fb_pos_hplr_pe_demean=fb_pos_hplr_pe-mean(fb_pos_hplr_pe);
        fb_pos_hphr_pe=pe_temp(find((stim_temp==2 | stim_temp==6) & (resp_temp==fb_temp)));
        fb_pos_hphr_pe_demean=fb_pos_hphr_pe-mean(fb_pos_hphr_pe);
        fb_pos_rplr_pe=pe_temp(find((stim_temp==3) & (resp_temp==fb_temp)));
        fb_pos_rplr_pe_demean=fb_pos_rplr_pe-mean(fb_pos_rplr_pe);
        fb_pos_rphr_pe=pe_temp(find((stim_temp==4) & (resp_temp==fb_temp)));
        fb_pos_rphr_pe_demean=fb_pos_rphr_pe-mean(fb_pos_rphr_pe);
        fb_neg_hplr_pe=pe_temp(find((stim_temp==1 | stim_temp==5) & (resp_temp~=fb_temp)));
        fb_neg_hplr_pe_demean=fb_neg_hplr_pe-mean(fb_neg_hplr_pe);
        fb_neg_hphr_pe=pe_temp(find((stim_temp==2 | stim_temp==6) & (resp_temp~=fb_temp)));
        fb_neg_hphr_pe_demean=fb_neg_hphr_pe-mean(fb_neg_hphr_pe);
        fb_neg_rplr_pe=pe_temp(find((stim_temp==3) & (resp_temp~=fb_temp)));
        fb_neg_rplr_pe_demean=fb_neg_rplr_pe-mean(fb_neg_rplr_pe);
        fb_neg_rphr_pe=pe_temp(find((stim_temp==4) & (resp_temp~=fb_temp)));
        fb_neg_rphr_pe_demean=fb_neg_rphr_pe-mean(fb_neg_rphr_pe);
        
        % Print the onset textfiles
        % Stim onsets
        for n=1:length(stim_hplr_ons),
            fprintf(fid_stim_hplr,'%0.4f\t%0.4f\t1\n',stim_hplr_ons(n),stim_hplr_dur(n));
        end;
        for n=1:length(stim_hphr_ons),
            fprintf(fid_stim_hphr,'%0.4f\t%0.4f\t1\n',stim_hphr_ons(n),stim_hphr_dur(n));
        end;
        for n=1:length(stim_rplr_ons),
            fprintf(fid_stim_rplr,'%0.4f\t%0.4f\t1\n',stim_rplr_ons(n),stim_rplr_dur(n));
        end;
        for n=1:length(stim_rphr_ons),
            fprintf(fid_stim_rphr,'%0.4f\t%0.4f\t1\n',stim_rphr_ons(n),stim_rphr_dur(n));
        end;
        for n=1:length(stim_hplr_ons),
            fprintf(fid_stim_hplr_ev,'%0.4f\t%0.4f\t%0.4f\n',stim_hplr_ons(n),stim_hplr_dur(n),stim_hplr_ev_demean(n));
        end;
        for n=1:length(stim_hphr_ons),
            fprintf(fid_stim_hphr_ev,'%0.4f\t%0.4f\t%0.4f\n',stim_hphr_ons(n),stim_hphr_dur(n),stim_hphr_ev_demean(n));
        end;
        for n=1:length(stim_rplr_ons),
            fprintf(fid_stim_rplr_ev,'%0.4f\t%0.4f\t%0.4f\n',stim_rplr_ons(n),stim_rplr_dur(n),stim_rplr_ev_demean(n));
        end;
        for n=1:length(stim_rphr_ons),
            fprintf(fid_stim_rphr_ev,'%0.4f\t%0.4f\t%0.4f\n',stim_rphr_ons(n),stim_rphr_dur(n),stim_rphr_ev_demean(n));
        end;
        % Choice onsets
        for n=1:length(choice_hplr_ons),
            fprintf(fid_choice_hplr,'%0.4f\t%0.4f\t1\n',choice_hplr_ons(n),choice_hplr_dur(n));
        end;
        for n=1:length(choice_hphr_ons),
            fprintf(fid_choice_hphr,'%0.4f\t%0.4f\t1\n',choice_hphr_ons(n),choice_hphr_dur(n));
        end;
        for n=1:length(choice_rplr_ons),
            fprintf(fid_choice_rplr,'%0.4f\t%0.4f\t1\n',choice_rplr_ons(n),choice_rplr_dur(n));
        end;
        for n=1:length(choice_rphr_ons),
            fprintf(fid_choice_rphr,'%0.4f\t%0.4f\t1\n',choice_rphr_ons(n),choice_rphr_dur(n));
        end;
        for n=1:length(choice_hplr_ons),
            fprintf(fid_choice_hplr_ev,'%0.4f\t%0.4f\t%0.4f\n',choice_hplr_ons(n),choice_hplr_dur(n),choice_hplr_ev_demean(n));
        end;
        for n=1:length(choice_hphr_ons),
            fprintf(fid_choice_hphr_ev,'%0.4f\t%0.4f\t%0.4f\n',choice_hphr_ons(n),choice_hphr_dur(n),choice_hphr_ev_demean(n));
        end;
        for n=1:length(choice_rplr_ons),
            fprintf(fid_choice_rplr_ev,'%0.4f\t%0.4f\t%0.4f\n',choice_rplr_ons(n),choice_rplr_dur(n),choice_rplr_ev_demean(n));
        end;
        for n=1:length(choice_rphr_ons),
            fprintf(fid_choice_rphr_ev,'%0.4f\t%0.4f\t%0.4f\n',choice_rphr_ons(n),choice_rphr_dur(n),choice_rphr_ev_demean(n));
        end;
        % FB onsets
        for n=1:length(fb_pos_hplr_ons),
            fprintf(fid_fb_pos_hplr,'%0.4f\t1.25\t1\n',fb_pos_hplr_ons(n));
        end;
        for n=1:length(fb_pos_hphr_ons),
            fprintf(fid_fb_pos_hphr,'%0.4f\t1.25\t1\n',fb_pos_hphr_ons(n));
        end;
        for n=1:length(fb_pos_rplr_ons),
            fprintf(fid_fb_pos_rplr,'%0.4f\t1.25\t1\n',fb_pos_rplr_ons(n));
        end;
        for n=1:length(fb_pos_rphr_ons),
            fprintf(fid_fb_pos_rphr,'%0.4f\t1.25\t1\n',fb_pos_rphr_ons(n));
        end;
        for n=1:length(fb_neg_hplr_ons),
            fprintf(fid_fb_neg_hplr,'%0.4f\t1.25\t1\n',fb_neg_hplr_ons(n));
        end;
        for n=1:length(fb_neg_hphr_ons),
            fprintf(fid_fb_neg_hphr,'%0.4f\t1.25\t1\n',fb_neg_hphr_ons(n));
        end;
        for n=1:length(fb_neg_rplr_ons),
            fprintf(fid_fb_neg_rplr,'%0.4f\t1.25\t1\n',fb_neg_rplr_ons(n));
        end;
        for n=1:length(fb_neg_rphr_ons),
            fprintf(fid_fb_neg_rphr,'%0.4f\t1.25\t1\n',fb_neg_rphr_ons(n));
        end;
        for n=1:length(fb_pos_hplr_ons),
            fprintf(fid_fb_pos_hplr_pe,'%0.4f\t1.25\t%0.4f\n',fb_pos_hplr_ons(n),fb_pos_hplr_pe_demean(n));
        end;
        for n=1:length(fb_pos_hphr_ons),
            fprintf(fid_fb_pos_hphr_pe,'%0.4f\t1.25\t%0.4f\n',fb_pos_hphr_ons(n),fb_pos_hphr_pe_demean(n));
        end;
        for n=1:length(fb_pos_rplr_ons),
            fprintf(fid_fb_pos_rplr_pe,'%0.4f\t1.25\t%0.4f\n',fb_pos_rplr_ons(n),fb_pos_rplr_pe_demean(n));
        end;
        for n=1:length(fb_pos_rphr_ons),
            fprintf(fid_fb_pos_rphr_pe,'%0.4f\t1.25\t%0.4f\n',fb_pos_rphr_ons(n),fb_pos_rphr_pe_demean(n));
        end;
        for n=1:length(fb_neg_hplr_ons),
            fprintf(fid_fb_neg_hplr_pe,'%0.4f\t1.25\t%0.4f\n',fb_neg_hplr_ons(n),fb_neg_hplr_pe_demean(n));
        end;
        for n=1:length(fb_neg_hphr_ons),
            fprintf(fid_fb_neg_hphr_pe,'%0.4f\t1.25\t%0.4f\n',fb_neg_hphr_ons(n),fb_neg_hphr_pe_demean(n));
        end;
        for n=1:length(fb_neg_rplr_ons),
            fprintf(fid_fb_neg_rplr_pe,'%0.4f\t1.25\t%0.4f\n',fb_neg_rplr_ons(n),fb_neg_rplr_pe_demean(n));
        end;
        for n=1:length(fb_neg_rphr_ons),
            fprintf(fid_fb_neg_rphr_pe,'%0.4f\t1.25\t%0.4f\n',fb_neg_rphr_ons(n),fb_neg_rphr_pe_demean(n));
        end;
        
        % Close onset txt files
        % Stim onsets
        fclose(fid_stim_hplr);
        fclose(fid_stim_hphr);
        fclose(fid_stim_rplr);
        fclose(fid_stim_rphr);
        fclose(fid_stim_hplr_ev);
        fclose(fid_stim_hphr_ev);
        fclose(fid_stim_rplr_ev);
        fclose(fid_stim_rphr_ev);
        % Choice onsets
        fclose(fid_choice_hplr);
        fclose(fid_choice_hphr);
        fclose(fid_choice_rplr);
        fclose(fid_choice_rphr);
        fclose(fid_choice_hplr_ev);
        fclose(fid_choice_hphr_ev);
        fclose(fid_choice_rplr_ev);
        fclose(fid_choice_rphr_ev);
        % FB onsets
        fclose(fid_fb_pos_hplr);
        fclose(fid_fb_pos_hphr);
        fclose(fid_fb_pos_rplr);
        fclose(fid_fb_pos_rphr);
        fclose(fid_fb_neg_hplr);
        fclose(fid_fb_neg_hphr);
        fclose(fid_fb_neg_rplr);
        fclose(fid_fb_neg_rphr);
        fclose(fid_fb_pos_hplr_pe);
        fclose(fid_fb_pos_hphr_pe);
        fclose(fid_fb_pos_rplr_pe);
        fclose(fid_fb_pos_rphr_pe);
        fclose(fid_fb_neg_hplr_pe);
        fclose(fid_fb_neg_hphr_pe);
        fclose(fid_fb_neg_rplr_pe);
        fclose(fid_fb_neg_rphr_pe);
        
    end

end

%Print list of subject's learning rates to a textfile
fid=fopen('learning_rates.txt','w');
for cf=1:length(fnames),
    fprintf(fid,'%s\t%0.4f\t%0.4f\n',subject_ids{cf},sub_learning_rate(cf),sub_learning_rate_actual(cf));
end;
fclose(fid);

%For each subject, print ev_sum and pe for each trial to a textfile
fid2=fopen('ev_sum_pe.txt','w');
for cf=1:length(fnames),
    fprintf(fid2,'%s\t',subject_ids{cf});
    for n=1:num_trials,
        fprintf(fid2,'%0.4f\t',sub_ev_sum(cf,n));
    end;
    fprintf(fid2,'\n');
    fprintf(fid2,'%s\t',subject_ids{cf});
    for n=1:num_trials,
        fprintf(fid2,'%0.4f\t',sub_pe(cf,n));
    end;
    fprintf(fid2,'\n');
end;
fclose(fid2);