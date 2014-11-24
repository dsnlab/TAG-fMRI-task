%%%% Program made by Don, updated by Jess to include more regressors 1/8/09
%%%% Whittled down to 6 regressors (no longer separate stim types, and no
%%%% choice) by Jess on 4/16/09


% fnames = [];
% 
% fnames{1}={'./jess_data/30009_rp_run1_24-Jul-2006_18-38.mat', './jess_data/30009_rp_run2_24-Jul-2006_18-47.mat'};
% fnames{2}={'./jess_data/30017_rp_run1_21-Aug-2006_14-55.mat', './jess_data/30017_rp_run2_21-Aug-2006_15-02.mat'};
% fnames{3}={'./jess_data/30033_rp_run1_06-Jan-2007_16-54.mat', './jess_data/30033_rp_run2_06-Jan-2007_17-01.mat'};
% fnames{4}={'./jess_data/30046_rp_run1_17-Feb-2007_19-01.mat', './jess_data/30046_rp_run2_17-Feb-2007_19-10.mat'};

data_path = '../../jess_data/';
[fnames, subject_ids] = load_data(data_path); % calls load data function Don made, make sure path is accurate!


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

    % best_ssd = find(ssd == min(ssd));

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


    %% Calculate Expcted Value and Prediction Error after finding best fit

    [ev_choice ev_diff ev_sum pe] = (rwmodel_prederr(stim, resp, fb, learning_rate(best_ssd)));
    % pe = pe.^2;
    % center vector--demean vector to use as a regressor! 
	% Only if use all trials in one big regressor
    % ev = ev - mean(ev);
    % pe = pe - mean(pe);
    
    trialctr = 1;
   
	%%%%%% NOTE!!! STILL DEMEAN THE REGRESSORS WITHIN EACH ONSET FILE AFTER CHECKING TO MAKE SURE EVERYTHING IS NEG/POS AS IT SHOULD BE IF RUN PROGRAM AS IS, WITHOUT ANYTHING DEMEANED!!!!
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
        % Demean parametric regressors and use these!
        ev_sum_temp_demean=ev_sum_temp-mean(ev_sum_temp);      
        ev_diff_temp_demean=ev_diff_temp-mean(ev_diff_temp);
        pe_pos_temp=pe_temp(find(resp_temp==fb_temp));
        pe_neg_temp=pe_temp(find(resp_temp~=fb_temp));
        pe_pos_temp_demean=pe_pos_temp-mean(pe_pos_temp);
        pe_neg_temp_demean=pe_neg_temp-mean(pe_neg_temp);
        
        % NOTES ABOUT THE ONSET FILES!!!!!
        % Make different onset files for each of the stimulus types and
        % pos/neg prederr
        % FOR ONSET FILES
        % col 1: onset times
        % col 2: length of time to look at each trial
        % col 3: weighting of factor (1 or weighted)

        % Onset Files to Make:
        % STIMULUS ONSET (1 file):--col 1 = stim_onset; col 2 = length of time stim up (fb_onset-stim_onset); col 3 = 1
        % STIMULUS ONSET PARAMETRIC (1 file):--col 1 = stim_onset; col 2 = length of time stim up (fb_onset-stim_onset); col 3 = ev_sum
        % PREDERR ONSET (2 files):--col 1 = fb_onset; col 2 = 1.25 (constant); col 3 = 1
        %     Positive PE
        %     Negative PE
        % PREDERR ONSET PARAMETRIC (2 files):--col 1 = fb_onset; col 2 = 1.25 (constant); col 3 = pe
        %     Positive PE
        %     Negative PE
        
        % Create onset file names
        % Stim onsets
        stim_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_stim_onsets.txt',subject_id ,f);
        stim_ev_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_stim_ev_onsets_demean.txt',subject_id ,f);
        % FB onsets
        fb_pos_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_fb_pos_onsets.txt',subject_id ,f);
        fb_neg_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_fb_neg_onsets.txt',subject_id ,f);
        fb_pos_pe_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_fb_pos_pe_onsets_demean.txt',subject_id ,f);
        fb_neg_pe_ons_name = sprintf('../../onset_files_new_6regressors/%s_run%d_fb_neg_pe_onsets_demean.txt',subject_id ,f);
        
        % Open textfiles to write onset information to them
        % Stim onsets
        fid_stim = fopen(stim_ons_name, 'w');
        fid_stim_ev = fopen(stim_ev_ons_name, 'w');
        % FB onsets
        fid_fb_pos = fopen(fb_pos_ons_name, 'w');
        fid_fb_neg = fopen(fb_neg_ons_name, 'w');
        fid_fb_pos_pe = fopen(fb_pos_pe_ons_name, 'w');
        fid_fb_neg_pe = fopen(fb_neg_pe_ons_name, 'w');
        
        % Make onsets and durations for all stimulus/fb types
        % Stim onsets
        stim_ons=stim_onset_temp;
        stim_dur=fb_onset_temp - stim_onset_temp;
        stim_ev=ev_sum_temp_demean;
        % FB onsets (don't need separate dur variable, because all FB = 1.25 sec)
        fb_dur=1.25;
        fb_pos_ons=fb_onset_temp(find(resp_temp==fb_temp));
        fb_neg_ons=fb_onset_temp(find(resp_temp~=fb_temp));
        fb_pos_pe=pe_pos_temp_demean;
        fb_neg_pe=pe_neg_temp_demean;
        
        % Print the onset textfiles
        % Stim onsets
        for n=1:length(stim_ons),
            fprintf(fid_stim,'%0.4f\t%0.4f\t1\n',stim_ons(n),stim_dur(n));
        end;
        for n=1:length(stim_ons),
            fprintf(fid_stim_ev,'%0.4f\t%0.4f\t%0.4f\n',stim_ons(n),stim_dur(n),stim_ev(n));
        end;
        % FB onsets
        for n=1:length(fb_pos_ons),
            fprintf(fid_fb_pos,'%0.4f\t1.25\t1\n',fb_pos_ons(n));
        end;
        for n=1:length(fb_neg_ons),
            fprintf(fid_fb_neg,'%0.4f\t1.25\t1\n',fb_neg_ons(n));
        end;
        for n=1:length(fb_pos_ons),
            fprintf(fid_fb_pos_pe,'%0.4f\t1.25\t%0.4f\n',fb_pos_ons(n),fb_pos_pe(n));
        end;
        for n=1:length(fb_neg_ons),
            fprintf(fid_fb_neg_pe,'%0.4f\t1.25\t%0.4f\n',fb_neg_ons(n),fb_neg_pe(n));
        end;
        
        %%% I THINK ALL ABOVE IS CORRECT BUT HAVEN"T CHECKED YET, RUN IT
        %%% AND CHECK WITH WHAT I ALREADY DID!!!!!!!!!
        
        % Close onset txt files
        % Stim onsets
        fclose(fid_stim);
        fclose(fid_stim_ev);
        % FB onsets
        fclose(fid_fb_pos);
        fclose(fid_fb_neg);
        fclose(fid_fb_pos_pe);
        fclose(fid_fb_neg_pe);
        
    end

end