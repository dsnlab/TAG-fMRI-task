# ~/drs/design:   
## code to optimize fMRI designs for dsd & svc tasks  

###**makeDSDdesigns.m**
Converts optimized DSD design sequences into trial matrices. Outputs omnibus structure ('dsdDesigns.mat') and individualized stimulus files for each subject/run ('~/drs/paradigm/input/drs$$$_dsd_run$.txt') w/ per-trial info.

###**makeSVCdesigns.m**
Converts optimized DSD design sequences into trial matrices. Outputs omnibus structure ('svcDesigns.mat') and individualized stimulus files for each subject/run ('~/drs/paradigm/input/drs$$$_svc_run$.txt') w/ per-trial info.

###**optDSDkao.m**  
Creates multi-objective optimized designs for DSD task. Condition sequence (i.e., private vs. friend, private vs. parent, friend vs. parent) optimized for contrast detection, counterbalancing, hrf estimation, and frequency of event types according to strategy of Kao (2009).  *add cite/link*

Additionally ordered by comparison type ($=, left$isMore, right$isMore) via inedependently optimized sequence.

Not currently in a loop. It was executed 100 times to generate the 'kaoDSDdesign_{$}.mat' files in GAoutput.  

###**optSVCtor.m**  
Creates multi-objective optimized designs for DSD task. Condition sequence (i.e., private vs. friend, private vs. parent, friend vs. parent) optimized for contrast detection, counterbalancing, hrf estimation, and frequency of event types according to strategy of Wager (2002). *add cite/link*

In current form, generates GAworkspace, from which the 'torSVCdesign_{$}.mat' files can be found in the variable MM.



