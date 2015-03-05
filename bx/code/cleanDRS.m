function [drs] = cleanDRS (drsStructure)

drs = drsStructure;
% looping over subjects && runs for DSD...
for sCount = 1:length(drs);
  if sCount < 10;
    thisSub = ['drs00',num2str(sCount)];
  elseif sCount < 100;
    thisSub = ['drs0',num2str(sCount)];
  end
  for rCount = 1:2;
    targets = drs(sCount).dsd(rCount).output.raw(:,[3 4]);
    coins = drs(sCount).dsd(rCount).output.raw(:,[5 6]);
    choiceOnset = drs(sCount).dsd(rCount).output.raw(:,7);
    choiceResponse = drs(sCount).dsd(rCount).output.raw(:,8);
    choiceRT = drs(sCount).dsd(rCount).output.raw(:,9);
    discoOnset = drs(sCount).dsd(rCount).output.raw(:,10);
    discoResponse = drs(sCount).dsd(rCount).output.raw(:,11);
    discoRT = drs(sCount).dsd(rCount).output.raw(:,12);
    statements = drs(sCount).dsd(rCount).input.statement;
    
    targetChosen = [];
    targetDumped = [];
    coinChosen = [];
    coinDumped = [];
    cSf = [];
    cSp = [];
    cFs = [];
    cFp = [];
    cPs = [];
    cPf = [];
    dSy = [];
    dSn = [];
    dFy = [];
    dFn = [];
    dPy = [];
    dPn = [];
  
    for t = 1:45

      if coins(t,1) == 5;
        coins(t,1) = 0;
      end
      if coins(t,2) == 5;
        coins(t,2) = 0;
      end
      
      if choiceResponse(t)~=0;
        targetChosen(t) = targets(t,choiceResponse(t));
        coinChosen(t) = coins(t,choiceResponse(t));

        if choiceResponse(t) == 1;
          targetDumped(t) = targets(t,2);
          coinDumped(t) = coins(t,2);
        elseif choiceResponse(t) == 2;
          targetDumped(t) = targets(t,1);
          coinDumped(t) = coins(t,1);
        end   
      
      elseif choiceResponse(t)==0;
        targetChosen(t) = NaN;
        coinChosen(t) = NaN; 
      end  
      
    switch targetChosen(t)
      case 1
        switch targetDumped(t)
          case 2
            cSf = [cSf t];
          case 3
            cSp = [cSp t];
        end
        if discoResponse(t) == 1
            dSy = [dSy t];
        elseif discoResponse(t) == 2
            dSn = [dSn t];
        end

      case 2
        switch targetDumped(t)
          case 1
            cFs = [cFs t];
          case 3
            cFp = [cFp t];
        end
        if discoResponse(t) == 1
            dFy = [dFy t];
        elseif discoResponse(t) == 2
            dFn = [dFn t];
        end

      case 3
        switch targetDumped(t)
          case 1
            cPs = [cPs t];
          case 2
            cPf = [cPf t];
        end

        if discoResponse(t) == 1
            dPy = [dPy t];
        elseif discoResponse(t) == 2
            dPn = [dPn t];
        end
    end
  end

  drs(sCount).dsd(rCount).choice.onsets = choiceOnset;
  drs(sCount).dsd(rCount).choice.rt = choiceRT;
  drs(sCount).dsd(rCount).choice.coinChosen = coinChosen';
  drs(sCount).dsd(rCount).choice.coinDumped = coinDumped';
  drs(sCount).dsd(rCount).choice.targetChosen = targetChosen';
  drs(sCount).dsd(rCount).choice.targetDumped = targetDumped';
  drs(sCount).dsd(rCount).choice.trials.Sp = cSp;
  drs(sCount).dsd(rCount).choice.trials.Sf = cSf;
  drs(sCount).dsd(rCount).choice.trials.Fs = cFs;
  drs(sCount).dsd(rCount).choice.trials.Fp = cFp;
  drs(sCount).dsd(rCount).choice.trials.Ps = cPs;
  drs(sCount).dsd(rCount).choice.trials.Pf = cPf;

  drs(sCount).dsd(rCount).disco.onsets = discoOnset;
  drs(sCount).dsd(rCount).disco.rt = discoRT;
  drs(sCount).dsd(rCount).disco.trials.Sy = dSy;
  drs(sCount).dsd(rCount).disco.trials.Sn = dSn;
  drs(sCount).dsd(rCount).disco.trials.Fy = dFy;
  drs(sCount).dsd(rCount).disco.trials.Fn = dFn;
  drs(sCount).dsd(rCount).disco.trials.Py = dPy;
  drs(sCount).dsd(rCount).disco.trials.Pn = dPn;
end
end

for sCount = 1:length(drs)
  for rCount = 1:2

  % 8 reg trial indices by all factors
  sgp = [];
  sgn = [];
  scp = [];
  scn = [];
  cgp = [];
  cgn = [];
  ccp = [];
  ccn = [];

  svcCond = drs(sCount).svc(rCount).output.raw(:,2);
  svcResp = drs(sCount).svc(rCount).output.raw(:,5);
  svcOnset = drs(sCount).svc(rCount).output.raw(:,3);
  svcRT = drs(sCount).svc(rCount).output.raw(:,4);
  svcReverse = drs(sCount).svc(rCount).output.raw(:,6);


  for svcCount = 1:48;
    switch svcCond(t)
    case 1
      if svcReverse(t) == 0;
        if svcResp(t) == 1;
          sgp = [sgp t];
        elseif svcResp(t) == 2;
          sgn = [sgn t];
        end
      elseif svcReverse(t) == 1;
        if svcResp(t) == 2;
          sgp = [sgp t];
        elseif svcResp(t) == 1;
          sgn = [sgn t];
        end
      end
    case 2
      if svcReverse(t) == 0;
        if svcResp(t) == 1;
          scp = [scp t];
        elseif svcResp(t) == 2;
          scn = [scn t];
        end
      elseif svcReverse(t) == 1;
        if svcResp(t) == 2;
          scp = [scp t];
        elseif svcResp(t) == 1;
          scn = [scn t];
        end
      end
    case 3
      if svcReverse(t) == 0;
        if svcResp(t) == 1;
          cgp = [cgp t];
        elseif svcResp(t) == 2;
          cgn = [cgn t];
        end
      elseif svcReverse(t) == 1;
        if svcResp(t) == 2;
          cgp = [cgp t];
        elseif svcResp(t) == 1;
          cgn = [cgn t];
        end
      end
    case 4
      if svcReverse(t) == 0;
        if svcResp(t) == 1;
          ccp = [ccp t];
        elseif svcResp(t) == 2;
          ccn = [ccn t];
        end
      elseif svcReverse(t) == 1;
        if svcResp(t) == 2;
          ccp = [ccp t];
        elseif svcResp(t) == 1;
          ccn = [ccn t];
        end
      end
  end
  drs(sCount).svc(rCount).onsets = svcOnset;
  drs(sCount).svc(rCount).rt = svcRT;
  drs(sCount).svc(rCount).trials.sgp = sgp;
  drs(sCount).svc(rCount).trials.sgn = sgn;
  drs(sCount).svc(rCount).trials.scp = scp;
  drs(sCount).svc(rCount).trials.scn = scn;
  drs(sCount).svc(rCount).trials.cgp = cgp;
  drs(sCount).svc(rCount).trials.cgn = cgn;
  drs(sCount).svc(rCount).trials.ccp = ccp;
  drs(sCount).svc(rCount).trials.ccn = ccn;
end
end
end

% clean RPE is separate here because it was written independently. To merge would be ideal...
for sCount = 1:(length(drs));
  if sCount < 10;
    thisSub = ['drs00',num2str(sCount)];
  elseif sCount < 100;
    thisSub = ['drs0',num2str(sCount)];
  end
  for rCount = 1:2
    thisRun = ['run',num2str(rCount)];
    task = drs(sCount).rpe(rCount);

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
