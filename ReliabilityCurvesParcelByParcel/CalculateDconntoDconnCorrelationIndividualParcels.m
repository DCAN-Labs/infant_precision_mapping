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
addParamValue(p,'OutputName','./');
addParamValue(p,'wb_command','wb_command');
addParamValue(p,'CIFTI_path','/home/miran045/shared/code/internal/utilities/cifti-matlab');
addParamValue(p,'GIFTI_path','/home/miran045/shared/code/internal/utilities/gifti/');

parse(p,varargin{:})

addpath(genpath('/home/miran045/shared/code/internal/utilities/cifti-matlab'));
addpath(genpath('/home/miran045/shared/code/internal/utilities/gifti/'));
% addpath(genpath('/home/miran045/shared/code/internal/utilities/Matlab_CIFTI'));
% addpath(genpath('/home/miran045/shared/code/internal/utilities/CIFTI/'));
% addpath(genpath('/home/miran045/shared/code/internal/utilities/gifti'));

%% parse the inputs
output_directory=p.Results.OutputDirectory;
output_name=p.Results.OutputName;
wb_command=p.Results.wb_command;
%addpath(genpath(p.Results.CIFTI_path))
%addpath(genpath(p.Results.GIFTI_path))
dconn_short=p.Results.DconnShort;
dconn_long=p.Results.DconnGroundTruth;

%% load dconn one 
dconn_short_conn = ciftiopen(dconn_short,wb_command);
dconn_short_data = dconn_short_conn.cdata;
if (dconn_short_data(1,1) > 7)
    dconn_short_data = tanh(dconn_short_data);
end


clear dconn_short_conn

%% load dconn two 
dconn_long_conn = ciftiopen(dconn_long,wb_command);
dconn_long_data = dconn_long_conn.cdata;
if (dconn_long_data(1,1) > 7)
    dconn_long_data = tanh(dconn_long_data);
end
clear dconn_long_conn


%% calculate pairwise correlation (R squared)
%use loop as we're only interested in the diagonal of the matrix (faster)
tic
for i=1:size(dconn_short_data,1)
    seedCorr(i,1)=(corr(dconn_short_data(:,i), dconn_long_data(:,i), 'rows','pairwise')).^2;
end
toc
%% calculate correlation and write to file

writematrix(seedCorr, strcat(output_directory,'/', output_name, '.txt'));

end

