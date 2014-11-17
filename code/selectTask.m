function [ task ] = selectTask(drs)
% % SELECTTASK.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   usage: [ ] = selectTask(drs)
%
%   inputFile = .txt needed to to run chosen drs task in PTB-3
%
%   input: drs = subject info structure (as stored in 'drs001_info.mat')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author: wem3
%   written: 141115
%   modified: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%    getSubInfo.m (or a saved info structure output from getSubInfo.m)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% Construct a questdlg with three options
task.name = questdlg('Which experiment?',...
 'Select Task: ', ...
'dsd','rpe','svc','dsd');
task.sess = questdlg('Which session?',...
  'Select Run: ', ...
  'run1','run2','run0','run1');
task.input.file = [drs.input,filesep,drs.subID,'_',taskChoice,'_',runChoice,'.txt'];


