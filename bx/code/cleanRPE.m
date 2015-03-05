function [drs] = clean_rpe(data_path, subject_data_files, subject_numbers)

for sCount = 1:(length(subject_numbers))
  for rCount = 1:2
    thisSub = subject_numbers{sCount};
    thisRun = ['run',num2str(rCount)];
    load([data_path, filesep, subject_data_files{sCount}{rCount}]);

    fb = task.input.outcome;
    stim = task.input.condition;
    stim_onset = NaN(1,length(task.output.raw))';
    reward = NaN(1,length(task.output.raw))';
    prob = NaN(1,length(task.output.raw))';
    trial_dur = NaN(1,length(task.output.raw))';
    accuracy = NaN(1,length(task.output.raw))';
    mag = NaN(1,length(task.output.raw))';
    trial_dur = NaN(1,length(task.output.raw))';

    clean_trials = (1:72);
    
    if isfield(task.output,'skips')    
      skip_trials = task.output.skips;
    else
      skip_trials = [];
    end

    if ~isempty(skip_trials)
      for skipCount = 1:length(skip_trials)
        clean_trials(skip_trials(skipCount))=0;
      end
      clean_trials=clean_trials(clean_trials~=0);
    end
    block_nums = ([ones(1,24),2.*ones(1,24),3.*ones(1,24),4.*ones(1,24),5.*ones(1,24),6.*ones(1,24)])';
    for tCount = 1:length(fb)
      trial_num = task.output.raw(tCount,1);
      stim_onset(tCount) = task.output.raw(tCount,3)';
      resp(tCount) = task.output.raw(tCount,4);
      rt(tCount) = task.output.raw(tCount,5);
      fb_onset(tCount) = task.output.raw(tCount,6);
      reward(tCount) = task.output.raw(tCount,7);
      prob(tCount) = task.probabilities(stim(tCount));
      mag(tCount) = task.magnitudes(stim(tCount));
      trial_dur(tCount) = task.output.raw(tCount,9);

      if resp(tCount) == fb(tCount)
        accuracy(tCount) = 1;
      elseif resp(tCount) ~= fb(tCount)
        accuracy(tCount) = 0;
      end
    end

    stim_skip_onset = stim_onset(skip_trials);
    fb_skip_onset = fb_onset(skip_trials);

    task.stim = stim;
    task.stim_onset = stim_onset;
    task.resp = resp';
    task.rt = rt';
    task.fb = fb;
    task.accuracy = accuracy;
    task.fb_onset = fb_onset';
    task.reward = reward;
    task.mag = mag;
    task.prob = prob;
    task.trial_dur = trial_dur;
    task.clean_trials = clean_trials;
    task.skip_trials = skip_trials;
    
    if ~isempty(task.skip_trials)
      task.stim_skip_onset = stim_onset(skip_trials);
      task.fb_skip_onset = fb_onset(skip_trials);
    else
      task.stim_skip_onset = [];
      task.fb_skip_onset = [];
    end

  % put run specific task structure in rpe structure
  rpe(rCount) = task;
  
  end
  % put rpe structure in drs structure
  drs(sCount).rpe = rpe;

  
  run1_block_nums = ([ones(1,24),2.*ones(1,24),3.*ones(1,24)])';
  run2_block_nums = ([4.*ones(1,24),5.*ones(1,24),6.*ones(1,24)])';
  sess1 = ones(length(drs(sCount).rpe(1).clean_trials),1);
  sess2 = 2.*(ones(length(drs(sCount).rpe(2).clean_trials),1));
  %drs(sCount).combo.rpe.sess = vertcat( ones(length(drs(sCount).rpe(1).clean_trials),1) , 2.*(ones(length(drs(sCount).rpe(2).clean_trials,1))) );
  drs(sCount).combo.rpe.sess = vertcat(sess1,sess2);
  drs(sCount).combo.rpe.block = vertcat( run1_block_nums(drs(sCount).rpe(1).clean_trials) , run2_block_nums(drs(sCount).rpe(2).clean_trials));
  drs(sCount).combo.rpe.stim_onset = vertcat(drs(sCount).rpe(1).stim_onset(drs(sCount).rpe(1).clean_trials), drs(sCount).rpe(2).stim_onset(drs(sCount).rpe(2).clean_trials));  
  drs(sCount).combo.rpe.fb_onset = vertcat(drs(sCount).rpe(1).fb_onset(drs(sCount).rpe(1).clean_trials), drs(sCount).rpe(2).fb_onset(drs(sCount).rpe(2).clean_trials));  
  combo_params = {'stim','resp','fb','rt','accuracy','reward','mag','prob','trial_dur'};
  for x = 1:length(combo_params);
    drs(sCount).combo.rpe.(combo_params{x}) = vertcat(drs(sCount).rpe(1).(combo_params{x})(drs(sCount).rpe(1).clean_trials), drs(sCount).rpe(2).(combo_params{x})(drs(sCount).rpe(2).clean_trials));
  end

end
