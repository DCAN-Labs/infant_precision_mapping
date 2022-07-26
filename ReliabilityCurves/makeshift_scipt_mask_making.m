%makaeshift script for generating masks for sessions
% this script generates a mask for each of the four recording sessions of
% sub-4049

% sessions: day 1: 3 runs
%            day 2: 1 run
%            day 3: 4 runs
%            day4 : 5 runs
% TR: 1.761 seconds
% run length: 6.7505 min
% one run has 230 frames (1150 counting each of the 5 echos)
% the overall .dtseries has 2990 frames

ses1=zeros(230*3,1) +1;
ses2=zeros(230,1) +2;
ses3=zeros(230*4,1) +3;
ses4=zeros(230*5,1) +4;

accum_ses=[ses1;ses2;ses3;ses4];

mask_ses1=accum_ses==1;
mask_ses2=accum_ses==2;
mask_ses3=accum_ses==3;
mask_ses4=accum_ses==4;

% cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/reliability_maps
% writematrix(mask_ses1, 'sub-4049_mask_ses1.txt');
% writematrix(mask_ses2, 'sub-4049_mask_ses2.txt');
% writematrix(mask_ses3, 'sub-4049_mask_ses3.txt');
% writematrix(mask_ses4, 'sub-4049_mask_ses4.txt');

%% mask for half of data that contains half of each session

all_good_frames=load('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/session_comparison/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');
good_frames_ses1=(all_good_frames+double(mask_ses1))==2;
good_frames_ses2=(all_good_frames+double(mask_ses2))==2;
good_frames_ses3=(all_good_frames+double(mask_ses3))==2;
good_frames_ses4=(all_good_frames+double(mask_ses4))==2;

index_ses1=find(good_frames_ses1);
index_half1_ses1=index_ses1(1:(round(size(index_ses1,1)/2)));
index_half2_ses1=index_ses1((round(size(index_ses1,1)/2))+1:end);

index_ses2=find(good_frames_ses2);
index_half1_ses2=index_ses2(1:(round(size(index_ses2,1)/2)));
index_half2_ses2=index_ses2((round(size(index_ses2,1)/2))+1:end);

index_ses3=find(good_frames_ses3);
index_half1_ses3=index_ses3(1:(round(size(index_ses3,1)/2)));
index_half2_ses3=index_ses3((round(size(index_ses3,1)/2))+1:end);

index_ses4=find(good_frames_ses4);
index_half1_ses4=index_ses4(1:(round(size(index_ses4,1)/2)));
index_half2_ses4=index_ses4((round(size(index_ses4,1)/2))+1:end);

index_all_halves1=[index_half1_ses1; index_half1_ses2; index_half1_ses3; index_half1_ses4];
index_all_halves2=[index_half2_ses1; index_half2_ses2; index_half2_ses3; index_half2_ses4];

frames_all_halves1=zeros(size(all_good_frames));
frames_all_halves1(index_all_halves1)=1;
frames_all_halves2=zeros(size(all_good_frames));
frames_all_halves2(index_all_halves2)=1;
%%
cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/reliability_maps
writematrix(frames_all_halves1, 'sub-4049_mask_half1_each_ses.txt');
writematrix(frames_all_halves2, 'sub-4049_mask_half2_each_ses.txt');

%% masks for 8 times ten minutes of data
%makaeshift script for generating masks for ten minute segments

% TR: 1.761 seconds
% run length: 6.7505 min
% one run has 230 frames (1150 counting each of the 5 echos)
% the overall .dtseries has 2990 frames

TR=1.761;
ten_min_frames=round(600/TR);


all_good_frames=load('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/session_comparison/ses-102521_task-rest_power_2014_FD_only.mat_0.3_cifti_censor_FD_vector_All_Good_Frames.txt');

idx_good_frames=find(all_good_frames==1);

frames_ten_min1=zeros(size(all_good_frames));
frames_ten_min1(idx_good_frames(1:ten_min_frames,:))=1;

frames_ten_min2=zeros(size(all_good_frames));
frames_ten_min2(idx_good_frames(ten_min_frames+1:2*ten_min_frames,:))=1;

frames_ten_min3=zeros(size(all_good_frames));
frames_ten_min3(idx_good_frames((2*ten_min_frames+1):(3*ten_min_frames),:))=1;

frames_ten_min4=zeros(size(all_good_frames));
frames_ten_min4(idx_good_frames((3*ten_min_frames+1):(4*ten_min_frames),:))=1;

frames_ten_min5=zeros(size(all_good_frames));
frames_ten_min5(idx_good_frames((4*ten_min_frames+1):(5*ten_min_frames),:))=1;

frames_ten_min6=zeros(size(all_good_frames));
frames_ten_min6(idx_good_frames((5*ten_min_frames+1):(6*ten_min_frames),:))=1;

frames_ten_min7=zeros(size(all_good_frames));
frames_ten_min7(idx_good_frames((6*ten_min_frames+1):(7*ten_min_frames),:))=1;

frames_ten_min8=zeros(size(all_good_frames));
frames_ten_min8(idx_good_frames((7*ten_min_frames+1):(8*ten_min_frames),:))=1;

%%
cd /panfs/roc/groups/4/miran045/shared/projects/WashU_Nordic/cifti_connectivity
writematrix(frames_ten_min1, 'sub-4049_mask_ten_min1.txt');
writematrix(frames_ten_min2, 'sub-4049_mask_ten_min2.txt');
writematrix(frames_ten_min3, 'sub-4049_mask_ten_min3.txt');
writematrix(frames_ten_min4, 'sub-4049_mask_ten_min4.txt');
writematrix(frames_ten_min5, 'sub-4049_mask_ten_min5.txt');
writematrix(frames_ten_min6, 'sub-4049_mask_ten_min6.txt');
writematrix(frames_ten_min7, 'sub-4049_mask_ten_min7.txt');
writematrix(frames_ten_min8, 'sub-4049_mask_ten_min8.txt');
