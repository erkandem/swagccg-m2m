% write  a  little packaging script
% essentially a zip unzip tool
% take  a look at mpm  and native packaging

current_path = pwd();
addpath('E:\Users\kan\Software\MATLAB\swagccg-m2m\swagccg-m2m\mpm');

%%
cmd = {
    'mpm install urlread2 -u https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2';
    'mpm install jsonlab -u https://github.com/fangq/jsonlab.git -t 1.5.0'};

for i = 1 : numel(cmd)
    eval(cmd{i});
end

cd('E:\Users\kan\Software\MATLAB\swagccg-m2m\swagccg-m2m');
addpath('E:\Users\kan\Software\MATLAB\swagccg-m2m\swagccg-m2m\src')
addpath('E:\Users\kan\Software\MATLAB\swagccg-m2m\swagccg-m2m\test')

petstore_play_book;

mpm uninstall urlread2
mpm uninstall jsonlab

%%
has_urlread2 = which('urlread2');
has_jsonencode = which('jsonencode');
has_jsondecode = which('jsondecode');
has_http_createHeader = which('http_createHeader');
has_http_paramsToString = which('http_paramsToString');
has_loadjson_mod = which('loadjson_mod');
has_struct2jdata = which('struct2jdata');
has_varargin2struct = which('varargin2struct');
has_jsonopt = which('jsonopt');
has_mergestruct = which('mergestruct');

    % jsonlab_master
    % urlread2
    % urlread2_fragments

    % (readme) next version
    % (tests) next version

    %dependencies.has_urlread2 = which('urlread2');
    %dependencies.has_jsonencode = which('jsonencode');
    %dependencies.has_jsondecode = which('jsondecode');
    %dependencies.has_http_createHeader = which('http_createHeader');
    %dependencies.has_http_paramsToString = which('http_paramsToString');
    %dependencies.has_loadjson_mod = which('loadjson_mod');
    %dependencies.has_struct2jdata = which('struct2jdata');
    %dependencies.has_varargin2struct = which('varargin2struct');
    %dependencies.has_jsonopt = which('jsonopt');
    %dependencies.has_mergestruct = which('mergestruct');
    %dependencies.has_loadjson = which('loadjson');
    %dependencies.has_savejson = which('savejson');


