% step 1 read in data
addpath(genpath('/home/faird/shared/code/external/utilities/cifti-matlab'));
addpath(genpath('/home/faird/shared/code/external/utilities/gifti/'));
wb_command='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command';

cd('/panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/T2StarMaps');
%% sub 4049
cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/T2StarMaps/wmparc_2mm_mean_t2s_tmadison/4049
sub4049=niftiread('sub-4049_ses-102521_task-rest_run-02_T2starmap_MNI2mm.nii.gz');
sub4049info=niftiinfo('sub-4049_ses-102521_task-rest_run-02_T2starmap_MNI2mm.nii.gz');
sub4049roi=niftiread('sub-4049_ses-102521_task-rest_run-02_T2starmap_MNI2mm_wmparc_label_means.nii.gz');

dimsub4049=size(sub4049,1)*size(sub4049,2)*size(sub4049,3);

vecsub4049=reshape(sub4049, [dimsub4049,1]);
vecsub4049fig=(vecsub4049(vecsub4049>0.001))*1000;

vecsub4049roi=reshape(sub4049roi, [dimsub4049,1]);
vecsub4049roifig=(vecsub4049roi(vecsub4049roi>0))*1000;

figure;
set(gcf,'color','white')
box off
histogram(vecsub4049fig, 'BinWidth', 2);
xlabel('T2* times in milliseconds')
ylabel('voxel count')

figure;
set(gcf,'color','white')
box off
histogram(vecsub4049roifig, 'BinWidth', 2, 'FaceColor', '#7E2F8E');
xlabel('T2* times in milliseconds')
ylabel('voxel count')

%% sub 4053
cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/T2StarMaps/wmparc_2mm_mean_t2s_tmadison/4053

sub4053=niftiread('sub-4053_ses-112921_task-rest_run-02_T2starmap_MNI2mm.nii.gz');
sub4053info=niftiinfo('sub-4053_ses-112921_task-rest_run-02_T2starmap_MNI2mm.nii.gz');
sub4053roi=niftiread('sub-4053_ses-112921_task-rest_run-02_T2starmap_MNI2mm_wmparc_label_means.nii.gz');

dimsub4053=size(sub4053,1)*size(sub4053,2)*size(sub4053,3);

vecsub4053=reshape(sub4053, [dimsub4053,1]);
vecsub4053fig=(vecsub4049(vecsub4049>0.001))*1000;

vecsub4053roi=reshape(sub4053roi, [dimsub4053,1]);
vecsub4053roifig=(vecsub4053roi(vecsub4053roi>0))*1000;

figure;
set(gcf,'color','white')
box off
histogram(vecsub4053fig, 'BinWidth', 2);
xlabel('T2* times in milliseconds')
ylabel('voxel count')

figure;
set(gcf,'color','white')
box off
histogram(vecsub4053roifig, 'BinWidth', 2, 'FaceColor', '#D95319');
xlabel('T2* times in milliseconds')
ylabel('voxel count')

%% sub MSC02
cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/T2StarMaps/wmparc_2mm_mean_t2s_tmadison/MSC02

subMSC02=niftiread('sub-MSC02_ses-20210818MENORDIC_2p0task-rest_run-02_T2starmap_MNI2mm.nii.gz');
subMSC02info=niftiinfo('sub-MSC02_ses-20210818MENORDIC_2p0task-rest_run-02_T2starmap_MNI2mm.nii.gz');
subMSC02roi=niftiread('sub-MSC02_ses-20210818MENORDIC2p0_task-rest_run-02_T2starmap_MNI2mm_wmparc_label_means.nii.gz');

dimsubMSC02=size(subMSC02,1)*size(subMSC02,2)*size(subMSC02,3);

vecsubMSC02=reshape(subMSC02, [dimsubMSC02,1]);
vecsubMSC02fig=(vecsubMSC02(vecsubMSC02>0.001))*1000;

vecsubMSC02roi=reshape(subMSC02roi, [dimsubMSC02,1]);
vecsubMSC02roifig=(vecsubMSC02roi(vecsubMSC02roi>0))*1000;

figure;
set(gcf,'color','white')
box off
histogram(vecsubMSC02fig, 'BinWidth', 2);
xlabel('T2* times in milliseconds')
ylabel('voxel count')

figure;
set(gcf,'color','white')
box off
histogram(vecsubMSC02roifig, 'BinWidth', 2, 'FaceColor', '#EDB120');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
%%
figure;
set(gcf,'color','white')
box off
subplot(1,3,1)
histogram(vecsub4049roifig, 'BinWidth', 2, 'FaceColor', '#7E2F8E');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('newborn 1')
subplot(1,3,2)
histogram(vecsub4053roifig, 'BinWidth', 2, 'FaceColor', '#D95319');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('newborn 2')
subplot(1,3,3)
histogram(vecsubMSC02roifig, 'BinWidth', 2, 'FaceColor', '#EDB120');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('adult')
%%
figure;
set(gcf,'color','white')
box off
subplot(1,3,1)
histogram(vecsub4049fig, 'BinWidth', 2, 'FaceColor', '#7E2F8E');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('newborn 1')
xlim([0 400])
subplot(1,3,2)
histogram(vecsub4053fig, 'BinWidth', 2, 'FaceColor', '#D95319');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('newborn 2')
xlim([0 400])
subplot(1,3,3)
histogram(vecsubMSC02fig, 'BinWidth', 2, 'FaceColor', '#EDB120');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('adult')
xlim([0 400])
%% plot based on cifti surfave files
sub4049 = ciftiopen('/home/miran045/shared/projects/WashU_Nordic/T2StarMaps/examples//surface_4049/cifti_mni/efield_norm_cifti.dscalar.nii', wb_command);
sub4053 = ciftiopen('/home/miran045/shared/projects/WashU_Nordic/T2StarMaps/examples//surface_4053/cifti_mni/efield_norm_cifti.dscalar.nii', wb_command);
subMSC02 = ciftiopen('/home/miran045/shared/projects/WashU_Nordic/T2StarMaps/examples//surface_MSC02/cifti_mni/efield_norm_cifti.dscalar.nii', wb_command);

dat4049=sub4049.cdata*1000;
dat4053=sub4053.cdata*1000;
datMSC02=subMSC02.cdata*1000;
%%
figure;
set(gcf,'color','white')
box off
subplot(1,3,1)
histogram(dat4049, 'BinWidth', 2, 'FaceColor', '#7E2F8E');
xlabel('T2* times in milliseconds')
ylabel('voxel count surface')
title('newborn 1')
subplot(1,3,2)
histogram(dat4053, 'BinWidth', 2, 'FaceColor', '#D95319');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('newborn 2')
subplot(1,3,3)
histogram(datMSC02, 'BinWidth', 2, 'FaceColor', '#EDB120');
xlabel('T2* times in milliseconds')
ylabel('voxel count')
title('adult')