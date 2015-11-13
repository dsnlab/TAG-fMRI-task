%% set variables for saved design info & target directory (to save .txt files)
svcTextFile = 'materials/svcTraits.txt';
targetDirectory = '../input';
GAoutputDirectory = 'GAoutput';
fid = fopen(svcTextFile,'r');
svcCell = textscan(fid, '%s%u8%u8%u8','Delimiter',',');
fclose(fid);
goodTraits = svcCell{1}(svcCell{2}==1);
withdrwnTraits = svcCell{1}(svcCell{2}==2);
aggTraits = svcCell{1}(svcCell{2}==3);

for dCount = 1
  %% shuffle em' up & split across runs
  % (we can grab the other info from svcCell using strcmp later...)
  aggTraits = Shuffle(aggTraits);
  goodTraits = Shuffle(goodTraits);
  withdrwnTraits = Shuffle(withdrwnTraits);

  saList1 = aggTraits(1:7);
  sgList1 = goodTraits(1:9);
  swList1 = withdrwnTraits(1:9);
  caList1 = aggTraits(8:end);
  cgList1 = goodTraits(10:end);
  cwList1 = withdrwnTraits(10:end);
  scList2 = caList1;
  sgList2 = cgList1;
  soList2 = cwList1;
  ccList2 = saList1;
  cgList2 = sgList1;
  coList2 = swList1;
  % loop over runs
  for rCount = 1:2;
    thisRun = ['run',num2str(rCount)];
    designFile = [GAoutputDirectory,filesep,(['torSVCdesign.mat'])];
    load(designFile);  
    svcDesign(dCount).(thisRun).sequence = M.stimlist;
    svcDesign(dCount).(thisRun).condition = ... % strip out the zeros
      svcDesign(dCount).(thisRun).sequence...
        (svcDesign(dCount).(thisRun).sequence~=0);
    ITIs = (Shuffle(0.47:0.026:1.74))'; %!! Change to gamma sum(ITIs) = 49.563; mean(ITIs) = 1.1014; 
    % pad the ISI by resting after every 5th trial
    gammaSlice = repmat([0 0 0 0 0 4.7], 10, 1);
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
      saList = saList1;
      swList = swList1;
      cgList = cgList1;
      caList = caList1;
      cwList = cwList1;
    elseif rCount == 2
      sgList = sgList2;
      saList = saList2;
      swList = swList2;
      cgList = cgList2;
      caList = caList2;
      cwList = cwList2;
    end
  % loop over trials
    for tCount = 1:length(word);
      switch condition(tCount)
        case 1
          word{tCount} = sgList{1};
          scList = popArray(scList);
          prompt{tCount} = 'true about me?';
        case 2
          word{tCount} = swList{1};
          sgList = popArray(sgList);
          prompt{tCount} = 'true about me?';
        case 3
          word{tCount} = saList{1};
          soList = popArray(soList);
          prompt{tCount} = 'true about me?';    
        case 4
          word{tCount} = cgList{1};
          ccList = popArray(ccList);
          prompt{tCount} = 'can this change?';
        case 5
          word{tCount} = cwList{1};
          cgList = popArray(cgList);
          prompt{tCount} = 'can this change?';
        case 6
          word{tCount} = caList{1};
          coList = popArray(coList);
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
      fid = fopen([targetDirectory,filesep,subID,'_svc_','run',num2str(rCount),'_input.txt'],'a');
      formatSpec = '%u,%u,%4.3f,%u,%u,%s\n';
      fprintf(fid, formatSpec, tCount, condition(tCount), svcJitter(tCount), reverse(tCount), syllables(tCount), word{tCount} );
      fclose(fid);
    end
  end
end
saveSVCname = 'svcDesigns.mat';
save(saveSVCname,'svcDesign');
