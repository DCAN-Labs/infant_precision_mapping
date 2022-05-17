cd('/home/miran045/shared/projects/WashU_Nordic/reliability_maps/reliability_curve_pconn/repeating_curves/rel_curves');

%% load files
for k=1:100
load(['rel_curve_consec_TE2', num2str(k),'.mat']);
corr_mat(:,k)=corr_curve;
end

for k=1:100
load(['rel_curve_consec_TE2_NORDIC', num2str(k),'.mat']);
corr_mat_N(:,k)=corr_curve_N;
end

for k=1:100
load(['rel_curve_consec_ME', num2str(k),'.mat']);
corr_matC(:,k)=corr_curve;
end

for k=1:100
load(['rel_curve_consec_ME_NORDIC', num2str(k),'.mat']);
corr_matC_N(:,k)=corr_curve_N;
end
%% boxplot for15min sampled differently (from 16-40min)
% figure
% set(gcf,'color','white')
% box off
% subplot(1,2,1)
% boxplot(corr_mat', 'PlotStyle','compact')
% xlabel('Time sampled from (min)')
% ylabel('Correlation to half 2 (ground truth)')
% title('reliability 15min of data')
% ylim([0.62 0.84]);
% xlim([16 40]);
% subplot(1,2,2)
% boxplot(corr_mat_N',  'PlotStyle','compact', 'Colors', 'c')
% xlabel('Time sampled from (min)')
% ylabel('Correlation to half 2 (ground truth)')
% title('reliability 15min of data with Nordic')
% ylim([0.62 0.84]);
% xlim([16 40]);
%% calculate mean and std
mean_corr=mean(corr_mat,2);
mean_corr_N=mean(corr_mat_N,2);
std_corr=std(corr_mat, [], 2);
std_corr_N=std(corr_mat_N, [], 2);
min_corr=min(corr_mat, [], 2);
min_corr_N=min(corr_mat_N, [], 2);
max_corr=max(corr_mat, [], 2);
max_corr_N=max(corr_mat_N, [], 2);


mean_corrC=mean(corr_matC,2);
mean_corrC_N=mean(corr_matC_N,2);
min_corrC=min(corr_matC, [], 2);
min_corrC_N=min(corr_matC_N, [], 2);
max_corrC=max(corr_matC, [], 2);
max_corrC_N=max(corr_matC_N, [], 2);
%%
x=[1:40];
figure
plot(x, mean_corr, 'color', '#D55700', 'LineWidth',4) %'#A130EA'
set(gcf,'color','white')
box off
hold on 
plot(x, mean_corr_N, 'color', '#0289B0', 'LineWidth',4) %'#0256FF'
hold on
plot(x, mean_corrC, 'color', '#CA4072', 'LineWidth',4)
hold on 
plot(x, mean_corrC_N, 'color', '#23A7AC', 'LineWidth',4)
legend({'TE2 consec','TE2-NORDIC consec', 'ME consec', 'ME-NORDIC consec'},'Location','southeast')
xlabel('Time (min)')
ylabel('Correlation')
hold on
h1=plot(x, min_corr, 'color', '#D55700', 'LineWidth',1);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h2=plot(x, min_corr_N, 'color', '#0289B0', 'LineWidth',1);
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h3=plot(x, max_corr, 'color', '#D55700', 'LineWidth',1);
h3.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h4=plot(x, max_corr_N, 'color', '#0289B0', 'LineWidth',1);
h4.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h1c=plot(x, min_corrC, 'color', '#CA4072', 'LineWidth',1);
h1c.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h2c=plot(x, min_corrC_N, 'color', '#23A7AC', 'LineWidth',1);
h2c.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h3c=plot(x, max_corrC, 'color', '#CA4072', 'LineWidth',1);
h3c.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h4c=plot(x, max_corrC_N, 'color', '#23A7AC', 'LineWidth',1);
h4c.Annotation.LegendInformation.IconDisplayStyle = 'off';
x2=[x,fliplr(x)];
y1=[min_corr', fliplr(max_corr')];
y2=[min_corr_N', fliplr(max_corr_N')];
y1c=[min_corrC', fliplr(max_corrC')];
y2c=[min_corrC_N', fliplr(max_corrC_N')];
c1=[0.853 0.341 0];
c2=[0.08 0.537 0.69];
c1c=[0.79 0.25 0.45];
c2c=[0.14 0.65 0.67];
f1=fill(x2, y1, c1, 'FaceAlpha', 0.3, 'LineStyle', 'none');
f1.Annotation.LegendInformation.IconDisplayStyle = 'off';
f2=fill(x2, y2, c2, 'FaceAlpha', 0.3, 'LineStyle', 'none');
f2.Annotation.LegendInformation.IconDisplayStyle = 'off';
f1c=fill(x2, y1c, c1c, 'FaceAlpha', 0.3, 'LineStyle', 'none');
f1c.Annotation.LegendInformation.IconDisplayStyle = 'off';
f2c=fill(x2, y2c, c2c, 'FaceAlpha', 0.3, 'LineStyle', 'none');
f2c.Annotation.LegendInformation.IconDisplayStyle = 'off';

%% table
resultstable=table(mean_corr, std_corr, min_corr, max_corr, mean_corr_N, std_corr_N, min_corr_N, max_corr_N);
writetable(resultstable, 'pconn_curves_consec_TE2_stats.csv');