function newstimbox = ConvertStim(oldstimbox, screen)
    screenres = Screen('Resolution', screen);
    newstimbox = oldstimbox;

    newstimbox.xDim = screenres.width;
    newstimbox.yDim = screenres.height;
    
    xratio = newstimbox.xDim/oldstimbox.xDim;
    yratio = newstimbox.yDim/oldstimbox.yDim;
    
    newstimbox.xratio = xratio;
    newstimbox.yratio = yratio;
    
    newstimbox.bigtext = floor(100*yratio);
    newstimbox.smalltext = floor(60*yratio);
    newstimbox.unit = floor(oldstimbox.unit * yratio);
    
    newstimbox.xCenter = floor(oldstimbox.xCenter * xratio);
    newstimbox.yCenter = floor(oldstimbox.yCenter * yratio);
    
    newstimbox.choice = ConvertBox(oldstimbox.choice);
    newstimbox.coin = ConvertBox(oldstimbox.coin);
    newstimbox.hand = ConvertBox(oldstimbox.hand);
    newstimbox.yesno = ConvertBox(oldstimbox.yesno);
    newstimbox.resp = ConvertBox(oldstimbox.resp);
    newstimbox.statement = ConvertBox(oldstimbox.statement);
    newstimbox.prompt = ConvertBox(oldstimbox.prompt);
    newstimbox.alien = ConvertBox(oldstimbox.alien);
    newstimbox.payout = ConvertBox(oldstimbox.payout);
    
    function newbox = ConvertBox(oldbox)
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

end
