%script for comparison between sessions
addpath('/home/miran045/shared/projects/WashU_Nordic/code');
% step1: see how much data is left from each session at FD 0.3
ses1_frames=readmatrix('ses1_pconn/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
time_ses1=sum(ses1_frames)*1.761/60;
ses2_frames=readmatrix('ses2_pconn/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
time_ses2=sum(ses2_frames)*1.761/60;
ses3_frames=readmatrix('ses3_pconn/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
time_ses3=sum(ses3_frames)*1.761/60;
ses4_frames=readmatrix('ses4_pconn/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
time_ses4=sum(ses4_frames)*1.761/60;

%step2 find comon time window and calculate correlations
for i=1:4
    for k=1:4
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['ses' num2str(i) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_6_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'DconnTwo',['ses' num2str(k) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_6_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_col(k,1)=dconn_corr;
    end
    corr_mat(:,i)=corr_col;
end
 %add correlation to data from all sessions
 for i=1:4
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['ses' num2str(i) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_6_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'DconnTwo',['sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_6_minutes_of_data_at_FD_0.3.pconn.nii'],...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_col_all(i,1)=dconn_corr;
 end

 full_corr_mat=[[corr_mat,corr_col_all];[corr_col_all',1]];
 

%% plot
figure
imagesc(full_corr_mat)
colorbar
colormap('jet')
caxis([0 1])
set(gcf,'color','white')
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

%% use all data of each session
for i=1:4
    for k=1:4
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['ses' num2str(i) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'DconnTwo',['ses' num2str(k) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_col(k,1)=dconn_corr;
    end
    corr_mat_all(:,i)=corr_col;
end

 for i=1:4
dconn_corr=CalculateDconntoDconnCorrelation('DconnOne',['ses' num2str(i) '_pconn/sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'DconnTwo',['sub-4049_ses-102521NORDIC_task-rest_bold_atlas-Gordon2014FreeSurferSubcortical_desc-filtered_timeseries.ptseries.nii_all_frames_at_FD_0.3.pconn.nii'],...
    'OutputDirectory','corr_val', ...
    'wb_command','/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command', ...
    'CIFTI_path','/home/faird/shared/code/external/utilities/cifti-matlab', ...
    'GIFTI_path','/home/faird/shared/code/external/utilities/gifti/');
corr_col_all(i,1)=dconn_corr;
 end

 full_corr_mat=[[corr_mat_all,corr_col_all];[corr_col_all',1]];
 