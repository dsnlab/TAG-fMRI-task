% script to call DRS cleaning functions & store a structure for all 3 tasks
data_path = '/Users/wem3/Desktop/DRS/task/output';
[dsdSub dsdOmni] = makeDSDtables(data_path);
[rpeSub rpeOmni] = makeRPEtables(data_path);
[svcSub svcOmni] = makeSVCtables(data_path);
drs.omni.dsd = dsdOmni;
drs.omni.rpe = rpeOmni;
drs.omni.svc = svcOmni;
drs.sub.dsd = dsdSub;
drs.sub.rpe = rpeSub;
drs.sub.svc = svcSub;
save drsBX.mat drs