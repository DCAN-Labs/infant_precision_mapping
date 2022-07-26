function mask_data_Xmin_consecutive_adaptation_adult(inputfolder, TR, time1, time2)
%input: TR - repetition time
%time= time inerval mask should cover (time1 for half 1 and time 2 for groundtruth)
filename_struct=dir([inputfolder, '/', '*FD_vector_All_Good_Frames.txt'])';
filename=filename_struct.name;
%load frames for half 1 no NORDIC
frames=load([inputfolder '/' filename]);

% express time in seconds
time1=time1*60;
Xmin_frames=round(time1/TR);

idx_good_frames=find(frames==1);

frames_Xmin=zeros(size(frames)); % create template of 0 with length of all frames
frames_Xmin(idx_good_frames(1:Xmin_frames,:))=1; % select frames for given amount of minutes and fill with ones

mkdir('masks')
writematrix(frames_Xmin, 'masks/mask_half1.txt');

%% make second, non-overlapping mask
% express time in seconds
time2=time2*60;
Xmin_frames2=round(time2/TR)-1;

starting_point=Xmin_frames+1; % define starting point so two masks don't overlap
frames_Xmin2=zeros(size(frames)); % create template of 0 with length of all frames
frames_Xmin2(idx_good_frames(starting_point:starting_point+Xmin_frames2,:))=1; % select frames for given amount of minutes and fill with ones

writematrix(frames_Xmin2, 'masks/mask_groundtruth.txt');

end



