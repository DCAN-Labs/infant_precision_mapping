%script for comparison between sessions
function script_reliability_curve_repetition_adaptation_adult(rep, min)


%calculate correlations between each time interval and the half 2 data
for i=1:min
filename_struct1=dir([num2str(i),'min/*.pconn.nii'])';
filename1=filename_struct1.name;
filename_struct2=dir(['../groundtruth/*.pconn.nii'])';
filename2=filename_struct2.name;

dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',[num2str(i),'min/', filename1] ,...
    'DconnTwo', ['../groundtruth/' filename2],...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_curve(i,1)=dconn_corr;
end


mkdir('../rel_curve/')
save(['../rel_curve/rel_curve', num2str(rep), '.mat'], 'corr_curve');

end
