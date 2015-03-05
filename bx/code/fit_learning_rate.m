%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% wem3 style
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subject_ids = subject_numbers;
for sCount = 1:length(subject_ids)   
    thisSub = subject_ids{sCount};
    subject_id = thisSub;
    % concatenate runs for reward learning models (only clean trials)
    sess = drs(sCount).combo.rpe.sess;
    block = drs(sCount).combo.rpe.block;
    stim = drs(sCount).combo.rpe.stim;
    stim_onset = drs(sCount).combo.rpe.stim_onset;
    fb_onset = drs(sCount).combo.rpe.fb_onset;
    rt = drs(sCount).combo.rpe.rt;
    reward = drs(sCount).combo.rpe.reward;
    resp = drs(sCount).combo.rpe.resp;
    trial_dur = drs(sCount).combo.rpe.trial_dur;
    resp(resp==1)=0;
    resp(resp==2)=1;
    fb = drs(sCount).combo.rpe.fb;
    fb(fb==1)=0;
    fb(fb==2)=1;
    num_trials = length(sess);

    % Define variables for sub_ev_sum and sub_pe to make sure right length
    % do em separately, rpe first? 
    % is ev_sum for "summary" or sum as in "plus that mofo?"
    sub_ev_sum=-99*ones(length(subject_ids),num_trials);
    sub_pe=-99*ones(length(subject_ids),num_trials); 
    sub_ev_sum_rand=-99*ones(length(subject_ids),num_trials);
    sub_ev_sum_pred=-99*ones(length(subject_ids),num_trials);
    sub_pe_rand=-99*ones(length(subject_ids),num_trials);
    sub_pe_pred=-99*ones(length(subject_ids),num_trials);

    % do a grid search to find best learning rate
    ssd_figure = figure(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    learning_rate = (0.02:.02:.6);
    ssd = zeros(1, length(learning_rate));
    ssd_var = zeros(1, length(learning_rate));

    for lr = 1:length(learning_rate)
        disp(sprintf('simulation %d of %d\n',lr,length(learning_rate)));
        avg_pred_error = rwmodel(stim', resp', fb', (learning_rate(lr)), 100);
        ssd(lr) = mean(avg_pred_error);
        ssd_var(lr) = var(avg_pred_error);
    end

    optimal_ssd = find(ssd == min(ssd));
    % This is the actual optimal ssd for the learning rate, but using this
    % tends to produce very small learning rates, so instead use the below
    % equation, which finds the highest learning rate within 10% of the
    % actual best learning rate, to increase the variance

    best_ssd = max(find(ssd <= (min(ssd) * 1.1)));
    
    figure(1 + sCount)
    figure(ssd_figure)
    hold on
    plot(learning_rate, ssd);
    title(sprintf('subject %d',sCount))
    xlabel('learning rate')
    ylabel('ssd')
    plot(learning_rate(best_ssd), ssd(best_ssd), 'ro')
    plot(learning_rate, ssd_var, 'k-');
    hold off


    disp(sprintf('optimum learning rate = %0.5f\n', learning_rate(best_ssd)));
        
    % Make variable that is all subjects' learning rates and print it to a textfile
    sub_learning_rate(sCount)=learning_rate(best_ssd);
    sub_learning_rate_actual(sCount)=learning_rate(optimal_ssd);

    %% Calculate Expected Value and Prediction Error after finding best fit

    [ev_choice ev_diff ev_sum pe] = (rwmodel_prederr(stim, resp, fb, learning_rate(best_ssd)));
    % Make variable that is all subjects' ev_sum and pe and print it to a textfile
    sub_ev_sum(sCount,1:length(ev_sum))=ev_sum;
    sub_pe(sCount,1:length(pe))=pe;
    % Also do for each stimulus type separatey:
        % Rand (3,4)
        % Pred (1,2,5,6)
        
    sub_ev_sum_rand(sCount,1:length(find(stim==3 | stim==4))) = ev_sum(find(stim==3 | stim==4));
    sub_ev_sum_pred(sCount,1:length(find(stim<3 | stim>4))) = ev_sum(find(stim<3 | stim>4));
    sub_pe_rand(sCount,1:length(find(stim==3 | stim==4))) = pe(find(stim==3 | stim==4));
    sub_pe_pred(sCount,1:length(find(stim<3 | stim>4))) = pe(find(stim<3 | stim>4));
   
    % pe = pe.^2;
    % center vector--demean vector to use as a regressor! 
	% Only if use all trials in one big regressor
    % ev = ev - mean(ev);
    % pe = pe - mean(pe);
    
    trialctr = 1;
	    for rCount = 1:2;
            thisRun = ['run',num2str(rCount)];
            % wem3 hacks:
            noresp_run1 = length(drs(sCount).rpe(1).skip_trials);
            noresp_run2 = length(drs(sCount).rpe(2).skip_trials);
        % After everything calculated, split variables into 2 columns so can have run 1
        % and run 2 separated
            if rCount==1,
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
            elseif rCount==2,
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
        
        % Make onsets and durations for all stimulus/fb types
        % Stim onsets
        % this is ugly as fuck, but I'm leaving it and just making it cleaner below
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
        
                % stimulus onsets
        task.onsets.stim.hilo = stim_hplr_ons;
        task.onsets.stim.hihi = stim_hphr_ons;
        task.onsets.stim.ralo = stim_rplr_ons;
        task.onsets.stim.rahi = stim_rphr_ons;
        % choice onsets
        task.onsets.choice.hilo = choice_hplr_ons;
        task.onsets.choice.hihi = choice_hphr_ons;
        task.onsets.choice.ralo = choice_rplr_ons;
        task.onsets.choice.rahi = choice_rphr_ons;
        % feedback onsets
        task.onsets.fb_pos.hilo = fb_pos_hplr_ons;
        task.onsets.fb_pos.hihi = fb_pos_hphr_ons;
        task.onsets.fb_pos.ralo = fb_pos_rplr_ons;
        task.onsets.fb_pos.rahi = fb_pos_rphr_ons;
        task.onsets.fb_neg.hilo = fb_neg_hplr_ons;
        task.onsets.fb_neg.hihi = fb_neg_hphr_ons;
        task.onsets.fb_neg.ralo = fb_neg_rplr_ons;
        task.onsets.fb_neg.rahi = fb_neg_rphr_ons;
        % stim durations
        task.durations.stim.hilo = stim_hplr_dur;
        task.durations.stim.hihi = stim_hphr_dur;
        task.durations.stim.ralo = stim_rplr_dur;
        task.durations.stim.rahi = stim_rphr_dur;
        % choice durations
        task.durations.choice.hilo = choice_hplr_dur;
        task.durations.choice.hihi = choice_hphr_dur;
        task.durations.choice.ralo = choice_rplr_dur;
        task.durations.choice.rahi = choice_rphr_dur;
        % stimulus expected value (pmod can only be ev at stim & choice)
        task.pmod.stim.hilo = stim_hplr_ev;
        task.pmod.stim.hihi = stim_hphr_ev;
        task.pmod.stim.ralo = stim_rplr_ev;
        task.pmod.stim.rahi = stim_rphr_ev;
        % choice expected value
        task.pmod.choice.hilo = choice_hplr_ev;
        task.pmod.choice.hihi = choice_hphr_ev;
        task.pmod.choice.ralo = choice_rplr_ev;
        task.pmod.choice.rahi = choice_rphr_ev;
        % positive prediction error (pmod at feedback can only be pe)
        task.pmod.fb_pos.hilo = fb_pos_hplr_pe;
        task.pmod.fb_pos.hihi = fb_pos_hphr_pe;
        task.pmod.fb_pos.ralo = fb_pos_rplr_pe;
        task.pmod.fb_pos.rahi = fb_pos_rphr_pe;
        % negative prediction error
        task.pmod.fb_neg.hilo = fb_neg_hplr_pe;
        task.pmod.fb_neg.hihi = fb_neg_hphr_pe;
        task.pmod.fb_neg.ralo = fb_neg_rplr_pe;
        task.pmod.fb_neg.rahi = fb_neg_rphr_pe;
        % same as pmods as above, but mean centered
        task.pmod.stim.mc_hilo = stim_hplr_ev_demean;
        task.pmod.stim.mc_hihi = stim_hphr_ev_demean;
        task.pmod.stim.mc_ralo = stim_rplr_ev_demean;
        task.pmod.stim.mc_rahi = stim_rphr_ev_demean;
        task.pmod.choice.mc_hilo = choice_hplr_ev_demean;
        task.pmod.choice.mc_hihi = choice_hphr_ev_demean;
        task.pmod.choice.mc_ralo = choice_rplr_ev_demean;
        task.pmod.choice.mc_rahi = choice_rphr_ev_demean;
        task.pmod.fb_pos.mc_hilo = fb_pos_hplr_pe_demean;
        task.pmod.fb_pos.mc_hihi = fb_pos_hphr_pe_demean;
        task.pmod.fb_pos.mc_ralo = fb_pos_rplr_pe_demean;
        task.pmod.fb_pos.mc_rahi = fb_pos_rphr_pe_demean;
        task.pmod.fb_neg.mc_hilo = fb_neg_hplr_pe_demean;
        task.pmod.fb_neg.mc_hihi = fb_neg_hphr_pe_demean;
        task.pmod.fb_neg.mc_ralo = fb_neg_rplr_pe_demean;
        task.pmod.fb_neg.mc_rahi = fb_neg_rphr_pe_demean;
    
    % nest task into rpe structure    
    rpe(rCount) = task;
    end
    
    clear task;
end
