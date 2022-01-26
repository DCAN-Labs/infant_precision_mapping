function CalculateDconntoDconnCorrelationIndividualSeeds(varargin)
%CalculateDconntoDconnCorrelation calculates a correlation between dconns.
%In this case between a part of a dconn from a short part of a time series
%and the ground truth
%It calculates the correlation between each seed of one dconn and each seed
%of teh other and created an average value
% this function loads two dconns/pconns, calculates their correlation and
% writes the resulting matrix as a .txt file to the output directory
%
% Usage: [dconn_corr] = CalculateDconntoDconnCorrelation(varargin)
%
%   Required inputs:
%   dconn_one <path>               :  path to first pconn/dconn to load
%   dconn_two <path>       :  path to second pconn/dconn to load
%   wb_command <path>       :  path to workbench command
%   OutputDirectory <path> : path to output directory
%   GIFTI_path <path> : path to GIFTI tool box
%   CIFTI_path <path> : path to CIFTI tool box

%% declare optional input defaults then parse varargin
p = inputParser;
addParamValue(p,'DconnShort','./dummy');
addParamValue(p,'DconnGroundTruth','./dummytwo');
addParamValue(p,'OutputDirectory','./');
addParamValue(p,'wb_command','wb_command');
addParamValue(p,'CIFTI_path','/home/faird/shared/code/internal/utilities/cifti-matlab');
addParamValue(p,'GIFTI_path','/home/faird/shared/code/internal/utilities/gifti/');

parse(p,varargin{:})

addpath(genpath('/home/miran045/shared/code/internal/utilities/Matlab_CIFTI'));
addpath(genpath('/home/miran045/shared/code/internal/utilities/CIFTI/'));
addpath(genpath('/home/miran045/shared/code/internal/utilities/gifti'));

%% parse the inputs
output_directory=p.Results.OutputDirectory;
wb_command=p.Results.wb_command;
addpath(genpath(p.Results.CIFTI_path))
addpath(genpath(p.Results.GIFTI_path))
dconn_short=p.Results.DconnShort;
dconn_long=p.Results.DconnGroundTruth;

%% load dconn one and select upper triangle

dconn_short_conn = ciftiopen(dconn_short,wb_command);
dconn_short_data = dconn_short_conn.cdata;
if (dconn_short_data(1,1) > 7)
    dconn_short_data = tanh(dconn_short_data);
end
clear dconn_short_conn

%% load dconn two and select upper triangle
dconn_long_conn = ciftiopen(dconn_long,wb_command);
dconn_long_data = dconn_long_conn.cdata;
if (dconn_long_data(1,1) > 7)
    dconn_long_data = tanh(dconn_long_data);
end
clear dconn_long_conn


%% calculate correlation and write to file
dconn_corr = corr(dconn_short_data,dconn_long_data);
%along y dimension: each seed from short dataset. Along x dimension: each seed from long dataset.
% to get average connectivity of each seed from short dataset with ground truth, average has to be taken along second (x) dimesion.
avg_dconn_corr=mean(dconn_corr,2);

% define fitting string for output name (cannot be too long) --> should be refined for more general usage purposes
[~,dconn_short_short]=fileparts(dconn_short); 
str_ind1=strfind(dconn_short_short, '_task');
str_ind2=strfind(dconn_short_short, 'nii');
dconn_short_short=dconn_short_short([1:str_ind1-1, str_ind2+3:end]);

[~,dconn_long_short]=fileparts(dconn_long); 
str_ind1=strfind(dconn_long_short, '_task');
str_ind2=strfind(dconn_long_short, 'nii');
dconn_long_short=dconn_long_short([1:str_ind1-1, str_ind2+3:end]);

%dlmwrite(strcat(output_directory,'/',dconn_one_short,'_CorrTo_',dconn_two_short,'.txt'),dconn_corr);
writematrix(avg_dconn_corr, strcat(output_directory,'/',dconn_short_short,'_CorrTo_',dconn_long_short,'all_vertices.txt'));
end

