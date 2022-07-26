function mask_n_rand_min_half1_consecutive(k)
%note: run rng('shuffle') before running this code to ensure true
%randomization

cd('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves');

TR=1.761;

%load frames for half 1 no NORDIC
frames=load('half1_whole/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
%same for runs processed with NORDIC
framesN=load('half1_whole/ses-102521NORDIC_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');


for min=1:40
    
nmin_frames=round(min*60/TR);

good_frames=find(frames==1); %good frames in whole half 1

starting_point=size(good_frames,1)-nmin_frames;
starting_number=randi(starting_point,1);

nmin_good_frames=good_frames(starting_number:starting_number+nmin_frames-1);

frames_new=zeros(size(frames));
frames_new(nmin_good_frames)=1;
mkdir(['masks/masksC', num2str(k)]);
writematrix(frames_new, ['masks/masksC', num2str(k), '/maskC_half1_', num2str(min), 'min.txt']);

%NORDIC

good_framesN=find(framesN==1); %good frames in whole half 1

starting_pointN=size(good_framesN,1)-nmin_frames;
starting_numberN=randi(starting_pointN,1);

nmin_good_framesN=good_framesN(starting_numberN:starting_numberN+nmin_frames-1);

frames_newN=zeros(size(framesN));
frames_newN(nmin_good_framesN)=1;

writematrix(frames_newN, ['masks/masksC', num2str(k), '/maskC_half1_', num2str(min), 'min_NORDIC.txt']);
end

end

