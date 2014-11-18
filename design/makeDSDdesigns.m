%% load up the 200 optimized sequences, assign 4 per 'design'
% target: run1, run2
% coins: run1, run2
% eat a test fart
GAdir = '/Users/wem3/Desktop/DRS/design/GAoutput';
targetDirectory = '/Users/wem3/Desktop/DRS/task/input';
for kCount = 1:50
  designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount), '.mat']);
  load(designFile)
  run1.target.ovf = Out.bestOVF;
  run1.target.sequence = Out.bestList;
  designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount + 50), '.mat']);
  load(designFile)
  run2.target.ovf = Out.bestOVF;
  run2.target.sequence = Out.bestList;
  designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount + 100), '.mat']);
  load(designFile)
  run1.coin.ovf = Out.bestOVF;
  run1.coin.sequence = Out.bestList(Out.bestList~=0);
  designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount + 150), '.mat']);
  load(designFile)
  run2.coin.ovf = Out.bestOVF;
  run2.coin.sequence = Out.bestList(Out.bestList~=0);
  dsdDesign(kCount).run1 = run1;
  dsdDesign(kCount).run2 = run2;
end

%% assign positions and coin values
% randomize left/right, optimize coin values (1 = aIsMore,
% 2 = bIsMore, 3 = eqPair)
% more, targets are equal)
% one pair for each comparison, each way (i.e., [1 3] and [3 1] are
% separate pairings, so that each comparison is equally represented
% in each condition)
coinPairs = [1,1; 1,2; 1,3; 1,4; 1,0; 2,1; 2,2; 2,3; 2,4; 2,0; 3,1; 3,2; 3,3; 3,4; 3,0; 4,1; 4,2; 4,3; 4,4; 4,0; 0,1; 0,2; 0,3; 0,4; 0,0; 1,1; 2,2; 3,3; 4,4; 0,0];
leftIsMoreCount = 1;
rightIsMoreCount = 1;
eqCount = 1;
eqPairs = nan(10,2);
leftIsMorePairs = nan(10,2);
rightIsMorePairs = nan(10,2);
for cCount = 1:length(coinPairs)
   if (coinPairs(cCount,1)==coinPairs(cCount,2))
       eqPairs(eqCount,:)=coinPairs(cCount,:);
       eqCount = eqCount + 1;
   elseif (coinPairs(cCount,1)>coinPairs(cCount,2))
       leftIsMorePairs(leftIsMoreCount,:)=coinPairs(cCount,:);
       leftIsMoreCount = leftIsMoreCount + 1;
   elseif (coinPairs(cCount,1)<coinPairs(cCount,2))
       rightIsMorePairs(rightIsMoreCount,:)=coinPairs(cCount,:);
       rightIsMoreCount = rightIsMoreCount + 1;
   end
end

% add statements to designs at random
statementFile = '/Users/wem3/Desktop/DRS/task/materials/statements.txt';
rawStatements(:,1) = textread(statementFile,'%s','delimiter','\n');
numTrials = length(rawStatements)/2;
rawStatements = Shuffle(rawStatements);
%% convert the 0s in the sequence into + 8sec durations for previous trial,
% get jittered durations (m = 1.5s)
rawJitter = (0.5:.0225:1.5)';
choiceJitter = (0.3:0.009:0.7)';

for dCount = 1:50
    rawStatements=Shuffle(rawStatements);
    for rCount = 1:2;
        thisRun = (['run',num2str(rCount)]);
        dsdDesign(dCount).(thisRun).statement = rawStatements( (1:45)+ 45*(rCount-1)  );
        rawJitter = Shuffle(rawJitter);
        choiceJitter = Shuffle(choiceJitter);
        adjJitter = NaN(45,1);
        condition = NaN(45,1);
        zCount = 0;
        rawTarget = dsdDesign(dCount).(thisRun).target.sequence;
        for eCount = 1:length(rawTarget)
            if rawTarget(eCount) == 0
                zCount = zCount + 1;
                adjJitter(eCount - zCount) = (rawJitter(eCount - zCount) + 8);
            else
                adjJitter(eCount - zCount) = rawJitter(eCount - zCount);
            end
        end
        dsdDesign(dCount).(thisRun).condition = rawTarget(rawTarget~=0);
        dsdDesign(dCount).(thisRun).choiceJitter = choiceJitter;
        dsdDesign(dCount).(thisRun).discoJitter = adjJitter;
        condition = dsdDesign(dCount).(thisRun).condition;
        % some temporary NaN vectors
        targetA = nan(45,1);
        targetB = nan(45,1);
        leftoRighto = rand(45,1);
        for tCount = 1:length(condition)
            if condition(tCount) == 1;
                targetA(tCount) = 1;
                targetB(tCount) = 2;
            elseif condition(tCount) == 2;
                targetA(tCount) = 1;
                targetB(tCount) = 3;
            elseif condition(tCount) == 3;
                targetA(tCount) = 2;
                targetB(tCount) = 3;
            else
                error('What the fucking fuck?!')
            end
        end

        coinA = nan(45,1);
        coinB = nan(45,1);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        % get a different randomized order of coin pairs for each subCondition
        run1t1c1 = Apairs((1:5), :);
        run2t1c1 = Apairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t1c2 = Bpairs((1:5), :);
        run2t1c2 = Bpairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t1c3 = Epairs((1:5), :);
        run2t1c3 = Epairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t2c1 = Apairs((1:5), :);
        run2t2c1 = Apairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t2c2 = Bpairs((1:5), :);
        run2t2c2 = Bpairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t2c3 = Epairs((1:5), :);
        run2t2c3 = Epairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t3c1 = Apairs((1:5), :);
        run2t3c1 = Apairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t3c2 = Bpairs((1:5), :);
        run2t3c2 = Bpairs((6:10),:);
        Apairs = leftIsMorePairs(Shuffle(1:10),:);
        Bpairs = rightIsMorePairs(Shuffle(1:10),:);
        Epairs = eqPairs(Shuffle(1:10),:);
        run1t3c3 = Epairs((1:5), :);
        run2t3c3 = Epairs((6:10),:);

        t1c1Count = 1;
        t1c2Count = 1;
        t1c3Count= 1;
        t2c1Count = 1;
        t2c2Count = 1;
        t2c3Count= 1;
        t3c1Count = 1;
        t3c2Count = 1;
        t3c3Count= 1;


        for tCount = 1:45 % (there are 45 trials, screw generalizing this)
            switch condition(tCount)
                case 1
                    switch dsdDesign(dCount).(thisRun).coin.sequence(tCount)
                        case 1
                            coinA(tCount) = run1t1c1(1,1);
                            coinB(tCount) = run1t1c1(1,2);
                            run1t1c1 = popArray(run1t1c1);

                        case 2
                            coinA(tCount) = run1t1c2(1,1);
                            coinB(tCount) = run1t1c2(1,2);
                            run1t1c2 = popArray(run1t1c2);
                        case 3
                            coinA(tCount) = run1t1c3(1,1);
                            coinB(tCount) = run1t1c3(1,2);
                            run1t1c3 = popArray(run1t1c3);
                    end

                case 2
                    switch dsdDesign(dCount).(thisRun).coin.sequence(tCount)
                        case 1
                            coinA(tCount) = run1t2c1(1,1);
                            coinB(tCount) = run1t2c1(1,2);
                            run1t2c1 = popArray(run1t2c1);
                        case 2
                            coinA(tCount) = run1t2c2(1,1);
                            coinB(tCount) = run1t2c2(1,2);
                            run1t2c2 = popArray(run1t2c2);
                        case 3
                            coinA(tCount) = run1t2c3(1,1);
                            coinB(tCount) = run1t2c3(1,2);
                            run1t2c3 = popArray(run1t2c3);
                    end

                case 3
                    switch dsdDesign(dCount).(thisRun).coin.sequence(tCount)
                        case 1
                            coinA(tCount) = run1t3c1(1,1);
                            coinB(tCount) = run1t3c1(1,2);
                            run1t3c1 = popArray(run1t3c1);
                        case 2
                            coinA(tCount) = run1t3c2(1,1);
                            coinB(tCount) = run1t3c2(1,2);
                            run1t3c2 = popArray(run1t3c2);
                        case 3
                            coinA(tCount) = run1t3c3(1,1);
                            coinB(tCount) = run1t3c3(1,2);
                            run1t3c3 = popArray(run1t3c3);
                    end
            end

            % randomly determine screen position

            if (leftoRighto(tCount) >= 0.5)
                leftCoin(tCount,1) = coinA(tCount);
                rightCoin(tCount,1) = coinB(tCount);
                leftTarget(tCount,1) = targetA(tCount);
                rightTarget(tCount,1) = targetB(tCount);
            elseif (leftoRighto(tCount) < 0.5)
                leftCoin(tCount,1) = coinB(tCount);
                rightCoin(tCount,1) = coinA(tCount);
                leftTarget(tCount,1) = targetB(tCount);
                rightTarget(tCount,1) = targetA(tCount);
            end

        end
        leftCoin(leftCoin==0) = 5;
        rightCoin(rightCoin==0) = 5;
        dsdDesign(dCount).(thisRun).leftCoin=leftCoin;
        dsdDesign(dCount).(thisRun).rightCoin=rightCoin;
        dsdDesign(dCount).(thisRun).leftTarget=leftTarget;
        dsdDesign(dCount).(thisRun).rightTarget=rightTarget;
    end
end

% because having double rests at the end makes the loop funky, manually fix
% sub007.run2:
dsdDesign(7).run2.discoJitter(45) = dsdDesign(7).run2.discoJitter(45) + 8;
save dsdDesigns.mat dsdDesign

caBut('dsdDesign','targetDirectory');
% note, made a separate loop to write output b/c sub007 is funky. Surely, this
% could be adressed programatically, but I only have time for pragmatic address...
for dCount = 1:50
    if dCount < 10
        subID = ['drs00',num2str(dCount)];
    elseif dCount >= 10
        subID = ['drs0',num2str(dCount)];
    end
    for rCount = 1:2
        thisRun = (['run',num2str(rCount)]);
        condition = dsdDesign(dCount).(thisRun).condition;
        leftTarget = dsdDesign(dCount).(thisRun).leftTarget;
        rightTarget = dsdDesign(dCount).(thisRun).rightTarget;  
        leftCoin = dsdDesign(dCount).(thisRun).leftCoin;
        rightCoin = dsdDesign(dCount).(thisRun).rightCoin;
        statement = dsdDesign(dCount).(thisRun).statement;
        choiceJitter = dsdDesign(dCount).(thisRun).choiceJitter;
        discoJitter = dsdDesign(dCount).(thisRun).discoJitter;

        for tCount = 1:45
          fid = fopen([targetDirectory,filesep,subID,'_dsd_','run',num2str(rCount),'_input.txt'],'a');

          fprintf(fid,'%u,%u,%u,%u,%u,%u,%4.3f,%4.3f,%s\n',tCount,condition(tCount),leftTarget(tCount),rightTarget(tCount),leftCoin(tCount),rightCoin(tCount),choiceJitter(tCount),discoJitter(tCount),statement{tCount});
          fclose(fid);
        end
    end
end
