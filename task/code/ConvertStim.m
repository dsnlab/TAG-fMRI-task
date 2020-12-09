function newstimbox = ConvertStim(oldstimbox, screen)
    screenres = Screen('Resolution', screen);
    newstimbox = oldstimbox

    newstimbox.xDim = screenres.width;
    newstimbox.yDim = screenres.height;
    
    xratio = newstimbox.xDim/oldstimbox.xDim;
    yratio = newstimbox.yDim/oldstimbox.yDim;
    
    newstimbox.xCenter = floor(oldstimbox.xCenter * xratio);
    newstimbox.yCenter = floor(oldstimbox.yCenter * yratio);
    
    newstimbox.choice = ConvertBox(oldstimbox.choice, xratio, yratio);
    newstimbox.coin = ConvertBox(oldstimbox.coin, xratio, yratio);
    newstimbox.hand = ConvertBox(oldstimbox.hand, xratio, yratio);
    newstimbox.yesno = ConvertBox(oldstimbox.yesno, xratio, yratio);
    newstimbox.resp = ConvertBox(oldstimbox.resp, xratio, yratio);
    newstimbox.statement = ConvertBox(oldstimbox.statement, xratio, yratio);
    newstimbox.prompt = ConvertBox(oldstimbox.prompt, xratio, yratio);
    newstimbox.alien = ConvertBox(oldstimbox.alien, xratio, yratio);
    newstimbox.payout = ConvertBox(oldstimbox.payout, xratio, yratio);
end

function newbox = ConvertBox(oldbox, xratio, yratio)
    if iscell(oldbox)
        newbox = cell2mat(oldbox);
    else
        newbox = oldbox;
    end
    newbox(1:2:end) = floor(newbox(1:2:end)*xratio);
    newbox(2:2:end) = floor(newbox(2:2:end)*yratio);
    if iscell(oldbox)
        newbox = mat2cell(newbox, [1], [4,4]);
    end
end
