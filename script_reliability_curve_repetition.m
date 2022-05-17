%script for comparison between sessions
function script_reliability_curve_repetition(rep)

addpath('/home/miran045/shared/projects/WashU_Nordic/code');
cd('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/');

%calculate correlations between each time interval and the half 2 data
for i=1:40
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['half1_TE2/', num2str(i), 'min/sub-4049_ses-102521_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'DconnTwo','half2_TE2/sub-4049_ses-102521_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii',...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_curve(i,1)=dconn_corr;
end

% same curve with NORDIC data
for i=1:40
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['half1_TE2/', num2str(i), 'min/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'DconnTwo','half2_TE2/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii',...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_curve_N(i,1)=dconn_corr;
end

save(['rel_curves/rel_curve_consec_TE2', num2str(rep), '.mat'], 'corr_curve');
save(['rel_curves/rel_curve_consec_TE2_NORDIC', num2str(rep), '.mat'], 'corr_curve_N');


end
