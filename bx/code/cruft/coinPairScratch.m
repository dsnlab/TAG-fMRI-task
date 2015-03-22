coinPairs = [...
4 0;4 1;3 0;4 2;3 1;2 0;4 3;3 2;2 1;1 0;...% left is more
0 0;1 1;2 2;3 3;4 4;4 4;3 3;2 2;1 1;0 0;...% equal
0 1;1 2;2 3;3 4;0 2;1 3;2 4;0 3;1 4;0 4];  % right is more

for tCount=1:length(coinPairs)
if stimSP(tCount,2) == coinPair(tCount) &&...
 stimSP(tCount,1)==yCoins(tCount)
  if respFP(tCount,:)==[1 0];spMat(tCount)=1;else


