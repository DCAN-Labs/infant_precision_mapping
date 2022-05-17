function mask_n_rand_min_half1(k)
%note: run rng('shuffle') before running this code to ensure true
%randomization
cd('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves');

TR=1.761;
%original version:
%load frames for half 1 no NORDIC
% frames=load('half1_whole/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
% %same for runs processed with NORDIC
% framesN=load('half1_whole/ses-102521NORDIC_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');

%new test version:
frames=load('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/sub-4049_mask_half1_each_ses.txt');
%same for runs processed with NORDIC - same ones in this case (doesn't make
%a difference for now, (to be updated if this version is actually used)
framesN=load('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/sub-4049_mask_half1_each_ses.txt');

rng('shuffle');
for min=1:40
    
nmin_frames=round(min*60/TR);

good_frames=find(frames==1); %good frames in whole half 1

nmin_good_frames=randsample(good_frames, nmin_frames);

frames_new=zeros(size(frames));
frames_new(nmin_good_frames)=1;
mkdir(['masks/masks', num2str(k)]);
writematrix(frames_new, ['masks/masks', num2str(k), '/mask_all_half1_', num2str(min), 'min.txt']);

%NORDIC

good_framesN=find(framesN==1); %good frames in whole half 1

nmin_good_framesN=randsample(good_framesN, nmin_frames);

frames_newN=zeros(size(framesN));
frames_newN(nmin_good_framesN)=1;

writematrix(frames_newN, ['masks/masks', num2str(k), '/mask_all_half1_', num2str(min), 'min_NORDIC.txt']);
end

end

