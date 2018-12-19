% make TAG stimulus
%% set some paths
matDir = 'materials';
taskDir = '../';
coinFile = [matDir,filesep,'coin.png'];
yesFile = [matDir,filesep,'yes-76.png'];
noFile = [matDir,filesep,'no-76.png'];
selfFile = [matDir,filesep,'self-200.png'];
deltaFile = [matDir,filesep,'delta-200.png'];
leftFile = [matDir,filesep,'hand-L-200.png'];
rightFile = [matDir,filesep,'hand-R-200.png'];
% read in the stimuli
[coinImg,~,coinAlpha]=imread(coinFile);
coinImg(:,:,4) = coinAlpha;
coin1 = [zeros(76,105,4),coinImg,zeros(76,105,4)];
coin2 = [zeros(76,70,4),coinImg,zeros(76,10,4),coinImg,zeros(76,70,4)];
coin3 = [zeros(76,35,4),coinImg,zeros(76,10,4),coinImg,zeros(76,10,4),coinImg,zeros(76,35,4)];
coin4 = [coinImg,zeros(76,10,4),coinImg,zeros(76,10,4),coinImg,zeros(76,10,4),coinImg];
coin5 = zeros(size(coin4)); % coin 5 is actually $0.00 
% (it's 5th for convenient indexing)
stim.coins = {coin1, coin2, coin3, coin4, coin5};
%% self icon (for svc)
[~,~,stim.alpha.self] = imread(selfFile);
%% delta icon (for svc)
[~,~,stim.alpha.delta] = imread(deltaFile);
%% yes icon (for svc)
[~,~,stim.alpha.yesno{1}] = imread(yesFile);
%% no icon (for svc)
[~,~,stim.alpha.yesno{2}] = imread(noFile);
%% left icon (for svc)
[~,~,stim.alpha.hand{1}] = imread(leftFile);
%% left icon (for svc)
[~,~,stim.alpha.hand{2}] = imread(rightFile);

%% alien images for rpe
for aCount = 1:6
  alienFile = [matDir,filesep,'alien',num2str(aCount),'.png'];
  [alienImg,~,alienAlpha] = imread(alienFile);
  stim.alpha.alien = alienAlpha;
  alienImg(:,:,4) = alienAlpha;
  stim.alien{aCount}=alienImg;
end

stim.alienText = {'LUX','RAZ'};

% colorscheme
stim.bg     = [29  31  33  255]./255; % bg
stim.grey   = [203 203 203 255]./255; % grey
stim.white  = [255 255 255 255]./255; % white
stim.red    = [244  82  82 255]./255; % red
stim.orange = [252 147  55 255]./255; % orange
stim.yellow = [190 168  36 255]./255;  % yellow (how about 255 241 155?)
stim.green  = [ 60 218  96 255]./255; % aquagreen
stim.sky    = [ 59 190 213 255]./255; % sky
stim.blue   = [ 79  82 230 255]./255; % blurple
stim.pink   = [167  47 187 255]./255; % pinkle
stim.purple = [124  70 241 255]./255; % purple

% set up screen positions
xDim = 1440; % 1920; % hardcoded here, but built to work on 3/4 as well
yDim = 900; % 1080;
unit = xDim/16;
xCenter = xDim/2;
yCenter = yDim/2;
box.xDim = xDim;
box.yDim = yDim;
box.unit = unit;
box.xCenter = xCenter;
box.yCenter = yCenter;
% posLR is an N x 3 matrix for making symmetrical boxen 
posLR = [... % [ left x position, y position, right x position ]
(xCenter - 3*unit), (yCenter - 3*unit), (xCenter + 3*unit) % 1. choiceBoxen
(xCenter - 3*unit), (yCenter - 1.5*unit), (xCenter + 3*unit) % 2. coinBoxen
(xCenter - 4*unit), (yCenter + 2*unit), (xCenter + 4*unit) % 3. handBoxen
(xCenter - 2*unit), (yCenter + 0.5*unit), (xCenter + 2*unit) % 4. respBoxen
];
% structure to hold boxen...
box.choice{1} = CenterRectOnPointd([0 0 4*unit unit],posLR(1,1),(yCenter+.25*unit));
box.choice{2} = CenterRectOnPointd([0 0 4*unit unit],posLR(1,3),(yCenter+.25*unit));
box.coin{1} = CenterRectOnPointd([0 0 270 76],posLR(2,1),(yCenter+1.5*unit));
box.coin{2} = CenterRectOnPointd([0 0 270 76],posLR(2,3),(yCenter+1.5*unit));
box.hand{1} = CenterRectOnPointd([0 0 200 200],posLR(3,1),posLR(3,2));
box.hand{2} = CenterRectOnPointd([0 0 200 200],posLR(3,3),posLR(3,2));
box.yesno{1} = CenterRectOnPointd([0 0 76 76],posLR(2,1),posLR(2,2));
box.yesno{2} = CenterRectOnPointd([0 0 76 76],posLR(2,3),posLR(2,2));
box.resp{1} = CenterRectOnPointd([0 0 200 200],posLR(4,1),posLR(4,2));
box.resp{2} = CenterRectOnPointd([0 0 200 200],posLR(4,3),posLR(4,2));
box.statement = CenterRectOnPointd([0 0 6*unit unit],xCenter,posLR(1,2));
box.prompt = CenterRectOnPointd([0 0 200 200],xCenter,(yCenter - 2*unit));
box.alien = CenterRectOnPointd([0 0 200 200],xCenter,(yCenter - unit/2));
box.payout = CenterRectOnPointd([0 0 270 76],xCenter,(yCenter + unit));

%% prefacbricate color boxen (?)
for rgbCount = 1:3
  box.bg(:,:,rgbCount)      = ones(200,200).*stim.bg(rgbCount);
  box.grey(:,:,rgbCount)    = ones(200,200).*stim.grey(rgbCount);
  box.white(:,:,rgbCount)   = ones(200,200).*stim.white(rgbCount);
  box.red(:,:,rgbCount)     = ones(76,76).*stim.red(rgbCount);
  box.orange(:,:,rgbCount)  = ones(200,200).*stim.orange(rgbCount);
  box.yellow(:,:,rgbCount)  = ones(200,200).*stim.yellow(rgbCount);
  box.green(:,:,rgbCount)   = ones(76,76).*stim.green(rgbCount);
  box.sky(:,:,rgbCount)     = ones(200,200).*stim.sky(rgbCount);
  box.blue(:,:,rgbCount)    = ones(200,200).*stim.blue(rgbCount);
  box.pink(:,:,rgbCount)    = ones(200,200).*stim.pink(rgbCount);
  box.purple(:,:,rgbCount)    = ones(200,200).*stim.purple(rgbCount);
end
stim.box = box;

%% aliens for rpe
% for aCount = 1:5
%   alienImg{aCount} = imread(alienFiles{aCount});
% end
% stim.aliens = alienImg;
%caBut('stim');
saveName = [taskDir,filesep,'DRSstim.mat'];
save(saveName,'stim');

