%% Bland ALtman plots

%% Load Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impT20211022.mat')

%%
Days = unique(T.Day);
Durs = unique(T.Dur);
Starts = unique(T.StartHr);

for i = 1:length(Days)
    iIV = [];
    miIV = [];
    iIS = [];
    miIS = [];
    maskIV = [];
    maskIS = [];
    for j = 1:length(Starts)
        for k = 1:length(Durs)
            ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
            
            iIV(k,j) = nanmean(T.IV_imp(ind))-nanmean(T.IV_comp(ind));
            miIV(k,j) = nanmean(T.IV_mimp(ind))-nanmean(T.IV_comp(ind));
            iIS(k,j) = nanmean(T.IS_imp(ind))-nanmean(T.IS_comp(ind));
            miIS(k,j) = nanmean(T.IS_mimp(ind))-nanmean(T.IS_comp(ind));

            maskIV(k,j) = nanmean(T.IV_mask(ind))-nanmean(T.IV_comp(ind));
            maskIS(k,j) = nanmean(T.IS_mask(ind))-nanmean(T.IS_comp(ind));
            
%             iIV(k,j) = nanmean(T.IV_imp(ind) - T.IV_mask(ind));
%             miIV(k,j) = nanmean(T.IV_mimp(ind)- T.IV_mask(ind));
%             iIS(k,j) = nanmean(T.IS_imp(ind)- T.IS_mask(ind));
%             miIS(k,j) = nanmean(T.IS_mimp(ind)- T.IS_mask(ind));
%             
%             maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
%             maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
            
            
        end
    end
    iv_mm = max(abs([min(min(iIV)),max(max(iIV)),min(min(miIV)),max(max(miIV)),min(min(maskIV)),max(max(maskIV))]));
    is_mm = max(abs([min(min(iIS)),max(max(iIS)),min(min(miIS)),max(max(miIS)),min(min(maskIS)),max(max(maskIS))]));
    
    %iv_ma = 0.002;
    %is_ma = 0.022;
    
    %max(max(abs(maskIS)))
    %max(max(abs(maskIV)))
    
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,3,1)
    h1 = heatmap(iIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h1.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf(' Graph Imputation IV - Day %d',Days(i)))

    subplot(1,3,2)
    h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h2.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('Mean Imputation IV - Day %d',Days(i)))
    
    subplot(1,3,3)
    h3 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h3.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('Masked IV - Day %d',Days(i)))
    
    %%
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,3,1)
    h4 = heatmap(iIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h4.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('Graph Imputation IS - Day %d',Days(i)))

    subplot(1,3,2)
    h5 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h5.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('Mean Imputation IS - Day %d',Days(i)))
    
    subplot(1,3,3)
    h6 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h6.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('Masked IS - Day %d',Days(i)))
    
    %%
%     figure('Renderer', 'painters', 'Position', [100 100 800 400])
%     h5 = heatmap(maskIV);%,'ColorLimits',[-iv_ma 0],'Colormap',hsv);
%     h5.NodeChildren(3).YDir='normal';
%     ax = gca;
%     ax.XDisplayLabels = num2cell(Starts);
%     ax.YDisplayLabels = num2cell(Durs);
%     %xticks(Starts)
%     xlabel('Start Time')
%     %xticks(Durs)
%     ylabel('Duration')
%     title(sprintf('maskedIV vs complete - Day %d',Days(i)))
% 
%     figure('Renderer', 'painters', 'Position', [100 100 800 400])
%     h6 = heatmap(maskIS);%,'ColorLimits',[-is_ma is_ma],'Colormap',hsv);
%     h6.NodeChildren(3).YDir='normal';
%     ax = gca;
%     ax.XDisplayLabels = num2cell(Starts);
%     ax.YDisplayLabels = num2cell(Durs);
%     %xticks(Starts)
%     xlabel('Start Time')
%     %xticks(Durs)
%     ylabel('Duration')
%     title(sprintf('maskedIS vs complete - Day %d',Days(i)))

    
end

