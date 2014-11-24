function prediction_errors = rwmodel_estimate(stim, resp, fb, learning_rate)


nstim = length(unique(stim));  % number of stimuli
stim_values = sort(unique(stim));

nresp = length(unique(resp));
ntrials = length(resp);

eps = learning_rate;

weight_rand_scale = 1;


prederr = zeros(1, ntrials);
predresp = zeros(1, ntrials);

% TODO : Make less hackish bias adjustment (e.g. robust for more than 2 responses)
bias_resp = mean(resp) - .5;

V_ij(1,:) = weight_rand_scale * ((2-bias_resp) * rand(1,nstim) - (1 + bias_resp/2));
V_ij(2,:) = weight_rand_scale * ((2-bias_resp) * rand(1,nstim) - (1 - bias_resp/2));    


delta_V = zeros(nresp, nstim);

% learn by delta rule
for t = 1:ntrials
    
    stimvec = zeros(nstim, 1);
    stimvec(find(stim(t) == stim_values)) = 1;
    o = V_ij * stimvec;

    if o(1) == o(2) && rand > 0.5,  % guess
        predresp(t) = 0;
    elseif o(1) > o(2),
        predresp(t) = 0;
    else
        predresp(t) = 1;
    end

    output_desired = ones(1, nresp) * -1;
    output_desired(fb(t) + 1) = 1;

    resp_actual = zeros(1, nresp);
    resp_actual(resp(t) + 1) = 1;

    
    for i = 1:nresp
        for j = 1:nstim
            delta_V(i,j) = eps * (output_desired(i) - o(i)) * stimvec(j);
        end
    end

    
    if ~isempty(find(delta_V ~= 0, 1))
        prederr(t) = delta_V(find(resp_actual), find(stimvec));
    end

    V_ij = V_ij + delta_V;
end


prediction_errors = zeros(1, nstim);

for i = 1:nstim
   condition_stim = find(stim == stim_values(i));
   prediction_errors(i) = sum((resp(condition_stim) - predresp(condition_stim)).^2)/length(condition_stim);
end


