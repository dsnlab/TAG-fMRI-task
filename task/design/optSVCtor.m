optDesPath=genpath('/Users/wem3/matlab/grimoire/OptimizeDesign11');
scnPath=genpath('/Users/wem3/matlab/grimoire/SCN_Core_Support/');
addpath(optDesPath,scnPath);
clear Models, clear MM

GA.conditions = [1 2];
GA.freqConditions = [.4 .4];
GA.scanLength = 282;  
GA.ISI = 4.7;  
GA.TR = 2; 
GA.doepochs = 0;
GA.numhox = 0;
GA.hoxrange = [];
nmodels = 100; 
GA.cbalColinPowerWeights = [2 5 1 4];	% 1 = cbal, 2 = eff, 3 = hrf shape, 4 = freq
GA.numGenerations = 10000; 
GA.sizeGenerations = 40;  
GA.maxTime = 120;						
GA.alph = 2.7; 
GA.plotFlag = 0; 
GA.lowerLimit = [];  
GA.HPlength = [120]; 
GA.LPsmooth = ['hrf']; 
GA.maxOrder = 3;   
GA.NumStimthresh = [];      % maximum number of repeats of any one event type in a row
GA.maxCbalDevthresh = []; 	% maximum acceptable counterbalancing deviation (actual freq - expected freq)
GA.maxFreqDevthresh = [];   % maximum acceptable deviation from input frequencies (GA.freqConditions)
GA.contrasts = [...
  1     1    -1    -1
  1     0    -1     0
  0     1     0    -1
  ]; 
% GA.contrasts = [...
%      1     1    -1    -1     1     1    -1    -1
%      1     0    -1     0     1     0    -1     0
%      0     1     0    -1     0     1     0    -1
%      1    -1     1    -1     1    -1     1    -1
%      ];
GA.contrastweights = [4 2 2];	                      
AutocorrelationFileName = 'myscannerxc';
GA.restlength = [1]; 
GA.restevery = [4]; 
GA.trans2switch = 0; 
GA.trans2block = 1; 
GA.dofirst = 0; 
GA.nonlinthreshold = []; 
% ---------------------------------------------------------------
%
% * E N D   U S E R   I N P U T
%
% ---------------------------------------------------------------
eval(['load ' AutocorrelationFileName]);  
GA.xc = myscannerxc;





% =============================================
% * vary by parameter - set this in this script
% * if running multiple models, nmodels > 1
% ---------------------------------------------

varyparam = 0;
fieldname = 'alph';		% or 'freqConditions(end), etc.
incrementby = 0.3;
incrementevery = 5;		% every n models
contrastsofinterest = 1;% contrasts or predictors, if no cons specified

% =============================================


if varyparam
	eval(['paramvalue = GA.' fieldname ';'])
	drsp(' ');drsp('* *********************************************************************')
	drsp('*  You have selected to vary a parameter across models in ga_gui_script')
	drsp(['*  GA.' fieldname ' starting at ' num2str(paramvalue)]) 
	drsp('* *********************************************************************')
end


for nm = 1:nmodels

   eval(['diary model' num2str(nm) '.log'])
   drsp(['Starting Model ' num2str(nm)])
    % freqConditions

  M = optimizeGA(GA);


   Models(:,nm) = M.stimlist;
   MM{nm} = M;
   save GAworkspace
   
   if varyparam
   	if isfield(M,'consebeta'),
		Fit(1,nm) = mean(M.consebeta(contrastsofinterest));
	else 
		Fit(1,nm) = mean(M.sebeta(contrastsofinterest));
	end
   	eval(['Fit(2,nm) = GA.' fieldname ';'])
   	FC(nm,:) = GA.freqConditions;
   	ALPH(nm,:) = GA.alph;
	str = ['if mod(nm,' num2str(incrementevery) ') == 0,GA.' fieldname ' = GA.' fieldname '+' num2str(incrementby) ';,end']
   	eval(str);
	eval(['paramvalue = GA.' fieldname ';'])
	drsp('* *********************************************************************')
	drsp('*  Varying parameter option on.')
	drsp(['*  GA.' fieldname ' is now ' num2str(paramvalue)]) 
	drsp('* *********************************************************************')
   end

   eval(['save model' num2str(nm) '_' M.date ' M'])
   save GAworkspace
   diary off
   fprintf('\n')
end

M.stimPerCondition = [...
  length(M.stimlist(M.stimlist==1)),...
  length(M.stimlist(M.stimlist==2)),...
  length(M.stimlist(M.stimlist==3)),...
  length(M.stimlist(M.stimlist==4)),...
  length(M.stimlist(M.stimlist==0))...
]