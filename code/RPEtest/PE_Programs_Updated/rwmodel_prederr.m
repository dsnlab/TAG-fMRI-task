function [expval_choice expval_diff expval_sum prederr] = rwmodel_prederr(stim, resp, fb, learning_rate)
% Function to calculate prediction error at each trial, made by Don,
% updated by Jess 1/8/09 to add comments and include more regressors
% this is called by fit_learning rate



nstim = length(unique(stim));  % number of stimuli
nresp = length(unique(resp));
ntrials = length(resp);

eps = learning_rate;


prederr = zeros(1, ntrials);
predresp = zeros(1, ntrials);


V_ij = zeros(nresp, nstim);  % weights from inputs i to output
delta_V = zeros(nresp, nstim);

% learn by delta rule
for t = 1:ntrials
    
    stimvec = zeros(nstim,1);
    stimvec(stim(t)) = 1;
    % o is the expected outcome of the trial based on the model
    o = V_ij * stimvec;

    % Says if weighted toward 1 or 0, make that the optimal response, but
    % if the two responses are equal, randomly pick one (if rand > .5,
    % response = 0, if rand <= .5, resp = 1)
    % Expval is the expected value of the choice made
    if o(1) == o(2) && rand > 0.5,  % guess
        predresp(t) = 0;
		expval_choice(t) = o(1);
    elseif o(1) > o(2),
        predresp(t) = 0;
		expval_choice(t) = o(1);
    else
        predresp(t) = 1;
		expval_choice(t) = o(2);
    end
    
	% Calculate the expected outcome of each stimulus (before making choice). 
    % Use either the difference b/w the 2 options or their sum; if uncorr, use both
    expval_diff(t) = abs(o(1) - o(2));
    expval_sum(t) = abs(o(1) + o(2));
    
    % output_desired is the actual outcome of the trial
    % This is a 1x2 vector, with a 1 for the response that was rewarded and
    % a -1 for the response that wasn't (response 0 in 1st column, response
    % 1 in 2nd column)
    output_desired = ones(1,nresp) * -1;
    output_desired(fb(t) + 1) = 1;

    % resp_actual is the actual subject response, used to update the
    % expected outcomes
    % This is a 1x2 vector, with a 1 for the subject's actual response 
    % (response 0 in 1st column, response 1 in 2nd column)
    resp_actual = zeros(1, nresp);
    resp_actual(resp(t) + 1) = 1;

    % a measure of the amount learned on the trial, weighted by learning
    % rate, sub response, prediction error, and stimulus
    for i = 1:nresp
        for j = 1:nstim
            delta_V(i, j) = eps * resp_actual(i) * (output_desired(i) - o(i)) * stimvec(j);
        end
    end
	
    % prederr is the difference between the actual outcome and the model's
    % expected outcome
    % By doing find(resp_actual), that gives you the column where the
    % response was (where resp_actual is 1, not 0), and then you see if the
    % actual output matched that (if it did, value = 1, if it didn't value
    % = -1)
    prederr(t) = output_desired(find(resp_actual)) - o(find(resp_actual));
    
%     if predresp(t) == resp(t)
%         disp(sprintf('Trial %d Correct!\n',t))
%     else
%         disp(sprintf('Trial %d Incorrect(%f, %f)!\n',t,abs(o(1) - o(2)),prederr(t)))
%     end
%     
    
    % update the weights after each trial by the amount learned on that
    % trial
    V_ij = V_ij + delta_V;
end;


