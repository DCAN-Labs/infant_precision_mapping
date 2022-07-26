function make_figures_s3(pics_folder, area, vertex, session, folder)
% area: label for vetext that is selected
%vertex: number of vertex for seed
% session: Nordic or not
% folder: input folder from s3 (ither ICA or not or certain amount of minutes)
settings.path{1}='/home/faird/shared/code/internal/utilities/figure_maker/make_dscalar_pics_v9.3.sh';
settings.path{2}='/home/faird/shared/code/internal/utilities/figure_maker/MSC01_template_quad_scaled_v3_legend_fixed_MSI.scene';  
settings.path{3}='/home/faird/shared/code/internal/utilities/figure_maker/MSC01_template_scene_subcort_label_MSI.scene'; 
settings.path{4}='/home/feczk001/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command'; % workbench command path

make_subcortical_images = 'FALSE';
%pics_code_path = '/home/faird/shared/code/internal/utilities/figure_maker/make_dscalar_pics_v9.3.sh';
    pics_code_path = settings.path{1}; % path to figure_maker bash script.
     
 
    disp(['mkdir -p ' pics_folder])
    system(['mkdir -p ' pics_folder]);
    scalar_name=[area '_' vertex '_' session '_' folder '.dscalar.nii'];
    output_name=[area '_' vertex '_' session '_' folder];
    
    
    %make template matching pic
    cmd = [pics_code_path ' ' scalar_name ' ' output_name '_fig ' pics_folder ' FALSE -0.4 0.5 ROY-BIG-BL FALSE 0 20 THRESHOLD_TEST_SHOW_OUTSIDE TRUE  ' make_subcortical_images ' png 8 118 FALSE ' settings.path{4} ' ' settings.path{2} ' ' settings.path{3}];
    disp(cmd);
    system(cmd);

end
    
