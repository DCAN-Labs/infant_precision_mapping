%script for comparison between sessions
addpath('/home/miran045/shared/projects/WashU_Nordic/code');

%calculate correlations between each time interval and teh half 2 data
for i=1:40
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['sub-4049_ses-102521_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_'  num2str(i) '_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'DconnTwo','half2/sub-4049_ses-102521_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii',...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_curve(i,1)=dconn_corr;
end

%% same curve with NORDIC data
for i=1:40
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_'  num2str(i) '_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'DconnTwo','half2/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii',...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_curve_N(i,1)=dconn_corr;
end

%% plot
figure
plot(corr_curve, 'm', 'LineWidth',4)
set(gcf,'color','white')
box off
hold on 
plot(corr_curve_N, 'b', 'LineWidth',4)
legend({'ME','ME-NORDIC'},'Location','southeast')
xlabel('Time (min)')
ylabel('Correlation')

