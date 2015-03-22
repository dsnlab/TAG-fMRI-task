cac;

[subIDlist,rawData,rawHeaders] = rawDRS ('dsd',pwd);

dsdTrials = cell(1,length(subIDlist));
for sCount = 1:length(subIDlist)
  [dsdHeaders,...
    dsdTrials{sCount},...
    tdex(1,sCount),...
    flatStim(:,:,sCount),...
    flatResp(:,:,sCount)] = cleanDSD(rawData(:,:,sCount));
end

clear sCount

save('/Users/wem3/Desktop/DRS/bx/cleanDSDbx.mat');
