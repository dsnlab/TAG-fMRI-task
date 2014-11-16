%% set variables for saved design info & target directory (to save .txt files)
svcTextFile = '/Users/wem3/Desktop/DRS/task/materials/svcTraits.txt';
targetDirectory = '/Users/wem3/Desktop/DRS/task/input';
GAoutputDirectory = '/Users/wem3/Desktop/DRS/design/GAoutput';
fid = fopen(svcTextFile,'r');
svcCell = textscan(fid, '%s%u8%u8%u8','Delimiter',',');
fclose(fid);
coolTraits = svcCell{1}(svcCell{2}==1);
goodTraits = svcCell{1}(svcCell{2}==2);

for dCount = 1:50
  %% shuffle em' up & split across runs
  % (we can grab the other info from svcCell using strcmp later...)
  coolTraits = svcCell{1}(svcCell{2}==1);
  goodTraits = svcCell{1}(svcCell{2}==2);
  coolTraits = Shuffle(coolTraits);
  goodTraits = Shuffle(goodTraits);

  scList1 = coolTraits(1:12);
  sgList1 = goodTraits(1:12);
  ccList1 = coolTraits(13:end);
  cgList1 = goodTraits(13:end);
  scList2 = sgList1;
  sgList2 = scList1;
  ccList2 = cgList1;
  cgList2 = ccList1;
  % loop over runs
  for rCount = 1:2;
    thisRun = ['run',num2str(rCount)];
    designFile = [GAoutputDirectory,filesep,(['torSVCdesign_',num2str(dCount + 50*(rCount-1)),'.mat'])];
    load(designFile);  
    svcDesign(dCount).(thisRun).sequence = M.stimlist;
    svcDesign(dCount).(thisRun).condition = ... % strip out the zeros
      svcDesign(dCount).(thisRun).sequence...
        (svcDesign(dCount).(thisRun).sequence~=0);
    ITIs = (Shuffle(0.47:0.027:1.74))'; % sum(ITIs) = 49.563; mean(ITIs) = 1.1014;
    gammaSlice = ... % pad the ISIs w/ 3 events = gamma(4.7) -> the I*S*I
      ([zeros(1,4),... % no long rests in the first 4 trials
      (Shuffle([zeros(1,12),(gamma(4.7))])),...% you gotta
      (Shuffle([zeros(1,13),(gamma(4.7))])),...% keep them
      (Shuffle([zeros(1,12),(gamma(4.7))])),...% seperated
      zeros(1,4)])'; % or the last 4              (hey!)
    svcDesign(dCount).(thisRun).jitter = ITIs+gammaSlice;
    svcJitter = ITIs+gammaSlice;
    condition = svcDesign(dCount).(thisRun).condition;
    word = cell(length(condition),1);
    prompt = word;
    reverse = NaN(length(word));
    syllables = NaN(length(word));
    % assign list per run
    if rCount == 1
      sgList = sgList1;
      scList = scList1;
      cgList = cgList1;
      ccList = ccList1;
    elseif rCount == 2
      sgList = sgList2;
      scList = scList2;
      cgList = cgList2;
      ccList = ccList2;
    end
  % loop over trials
    for tCount = 1:length(word);
      switch condition(tCount)
        case 1
          word{tCount} = sgList{1};
          sgList = popArray(sgList);
          prompt{tCount} = 'true about me?';
        case 2
          word{tCount} = scList{1};
          scList = popArray(scList);
          prompt{tCount} = 'true about me?';
        case 3
          word{tCount} = cgList{1};
          cgList = popArray(cgList);
          prompt{tCount} = 'can this change?';
        case 4
          word{tCount} = ccList{1};
          ccList = popArray(ccList);
          prompt{tCount} = 'can this change?';
      end
      condition = svcDesign(dCount).(thisRun).condition;
      reverse(tCount) = svcCell{3}(strcmp(word{tCount},svcCell{1}));
      syllables(tCount) = svcCell{4}(strcmp(word{tCount},svcCell{1}));
      if dCount < 10
        subID = ['drs00',num2str(dCount)];
      elseif dCount >= 10
        subID = ['drs0',num2str(dCount)];
      end
      stimFileToWrite = [targetDirectory,filesep,subID,'_svc_','run',num2str(rCount),'.txt'];
      fid = fopen([targetDirectory,filesep,subID,'_svc_','run',num2str(rCount),'.txt'],'a');
      formatSpec = '%u,%u,%4.3f,%u,%u,%s\n';
      fprintf(fid, formatSpec, tCount, condition(tCount), svcJitter(tCount), reverse(tCount), syllables(tCount), word{tCount} );
      fclose(fid);
    end
  end
end
saveSVCname = '/Users/wem3/Desktop/drs/design/svcDesigns.mat';
save(saveSVCname,'svcDesign');
