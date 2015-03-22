% script to call DRS cleaning functions & store a structure for all 3 tasks
data_path = '/Users/wem3/Desktop/DRS/task/output';
[dsdSub dsdOmni] = makeDSDtables(data_path);
[rpeSub rpeOmni] = makeRPEtables(data_path);
[svcSub svcOmni] = makeSVCtables(data_path);
drs.omni.dsd = dsdOmni(dsdOmni.subID~='drs004',:);
drs.omni.rpe = rpeOmni(dsdOmni.subID~='drs004',:);
drs.omni.svc = svcOmni(dsdOmni.subID~='drs004',:);
drs.sub.dsd = dsdSub(1:3,5:end);
drs.sub.rpe = rpeSub(1:3,5:end);
drs.sub.svc = svcSub(1:3,5:end);
save drsBX.mat drs