function mask_half1_relmap(TR, min)
%note: run rng('shuffle') before running this code to ensure true
%randomization
rng('shuffle')

%load frames for half 1 
frames=load('masks/mask_half1.txt');

  
nmin_frames=round(min*60/TR);

good_frames=find(frames==1); %good frames in whole half 1

starting_point=size(good_frames,1)-nmin_frames;
try
starting_number=randi(starting_point,1);
catch
    error('not enough data below FD threshold for selected amount of minutes')
end

nmin_good_frames=good_frames(starting_number:starting_number+nmin_frames-1);

frames_new=zeros(size(frames));
frames_new(nmin_good_frames)=1;

writematrix(frames_new, ['masks/maskC_half1_', num2str(min), 'min.txt']);



end

