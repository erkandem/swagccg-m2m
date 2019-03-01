% added for testing purposes
%
% script to work like $source .venv/bin/actvate
% by executing the script the scripts and functions on the
% paths below will be added (temporarily) to the top of the
% MatLab search path.
% if "savepath" isn't run, the search paths entries are
% going to be removed.
%
%
%

root_path = pwd();
addpath(fullfile(root_path, 'swagccg'));
addpath(fullfile(root_path, 'swagccg', 'src'));
addpath(fullfile(root_path, 'swagccg', 'tests'));
addpath(fullfile(root_path, 'swagccg', 'rdir'));
addpath(fullfile(root_path, 'swagccg', 'jsonlab_master'));
addpath(fullfile(root_path, 'swagccg', 'urlread2'));
addpath(fullfile(root_path, 'swagccg', 'urlread2_fragments'));

