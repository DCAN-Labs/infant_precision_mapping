% example code for creating plot from reliability map .txt files created by
% CalculateDconntoDconnCorrelationIndividualSeeds.m

addpath(genpath('/home/faird/shared/code/external/utilities/cifti-matlab'));


wb_command='/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command';


% open random dscalar that has correct dimensions for given dataset (this
% example dscalar was created from the dconn of this subject)
cd('/panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/reliability_maps');
example_dscalar = cifti_read('test.dscalar.nii');
cd('./rel_maps_corr_val/noICA/');
%%
min=10

input=['sub-4049_ses-102521_', num2str(min), '_minutes_of_data_at_FD_0.3.dconn_CorrTo_sub-4049_ses-102521_all_frames_at_FD_0.3.dconnall_vertices.txt'];
rel_val=readtable(input);

example_dscalar.cdata=table2array(rel_val);

cifti_write(example_dscalar, ['rel_map_', num2str(min),'min.dscalar.nii']);

%% use figure maker to save figures
for min=[10, 15, 20, 25, 30, 35, 40]

settings.path{1}='/home/faird/shared/code/internal/utilities/figure_maker/make_dscalar_pics_v9.3.sh';
settings.path{2}='/home/faird/shared/code/internal/utilities/figure_maker/MSC01_template_quad_scaled_v3_legend_fixed_MSI.scene';  
settings.path{3}='/home/faird/shared/code/internal/utilities/figure_maker/MSC01_template_scene_subcort_label_MSI.scene'; 
settings.path{4}='/home/feczk001/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'; % workbench command path

make_subcortical_images = 'FALSE';
%pics_code_path = '/home/faird/shared/code/internal/utilities/figure_maker/make_dscalar_pics_v9.3.sh';
    pics_code_path = settings.path{1}; % path to figure_maker bash script.
 
pics_folder = '/panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/reliability_maps/rel_maps_corr_val/noICA/';
scalar_name=['rel_map_', num2str(min), 'min.dscalar.nii'];
output_name=['rel_map_', num2str(min), 'min'];
cmd = [pics_code_path ' ' scalar_name ' ' output_name '_fig ' pics_folder ' FALSE 0 0.5 JET256 FALSE 0 20 THRESHOLD_TEST_SHOW_OUTSIDE TRUE  ' make_subcortical_images ' png 8 118 FALSE ' settings.path{4} ' ' settings.path{2} ' ' settings.path{3}];
disp(cmd);
system(cmd);
end