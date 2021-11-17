%% Bland ALtman plots

%% Load Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impT20211112.mat')

%%
Days = unique(T.Day);
Durs = unique(T.Dur);
Starts = unique(T.StartHr);

for i = 1:length(Days)
    linIV = [];
    miIV = [];
    linIS = [];
    miIS = [];
    maskIV = [];
    maskIS = [];
    mediIV = [];
    mediIS = [];
    for j = 1:length(Starts)
        for k = 1:length(Durs)
            ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
            
            linIV(k,j) = nanstd(T.IV_linimp(ind)-T.IV_comp(ind));
            miIV(k,j) = nanstd(T.IV_mimp(ind)-T.IV_comp(ind));
            linIS(k,j) = nanstd(T.IS_linimp(ind)-T.IS_comp(ind));
            miIS(k,j) = nanstd(T.IS_mimp(ind)-T.IS_comp(ind));
            maskIV(k,j) = nanstd(T.IV_mask(ind)-T.IV_comp(ind));
            maskIS(k,j) = nanstd(T.IS_mask(ind)-T.IS_comp(ind));
            mediIV(k,j) = nanstd(T.IV_medimp(ind)-T.IV_comp(ind));
            mediIS(k,j) = nanstd(T.IS_medimp(ind)-T.IS_comp(ind));
            
%             iIV(k,j) = nanmean(T.IV_imp(ind) - T.IV_mask(ind));
%             miIV(k,j) = nanmean(T.IV_mimp(ind)- T.IV_mask(ind));
%             iIS(k,j) = nanmean(T.IS_imp(ind)- T.IS_mask(ind));
%             miIS(k,j) = nanmean(T.IS_mimp(ind)- T.IS_mask(ind));
%             
%             maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
%             maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
            
            
        end
    end
    
%     iv_mm = max(abs([min(min(linIV)),max(max(linIV)),min(min(miIV)),max(max(miIV)),min(min(maskIV)),max(max(maskIV)),min(min(mediIV)),max(max(mediIV))]))
%     iv_mm_l = min(abs([min(min(linIV)),max(max(linIV)),min(min(miIV)),max(max(miIV)),min(min(maskIV)),max(max(maskIV)),min(min(mediIV)),max(max(mediIV))]))
%     is_mm = max(abs([min(min(linIS)),max(max(linIS)),min(min(miIS)),max(max(miIS)),min(min(maskIS)),max(max(maskIS)),min(min(mediIS)),max(max(mediIS))]))
%     is_mm_l = min(abs([min(min(linIS)),max(max(linIS)),min(min(miIS)),max(max(miIS)),min(min(maskIS)),max(max(maskIS)),min(min(mediIS)),max(max(mediIS))]))
    
    iv_mm = 0.39;
    iv_mm_l = 0;
    is_mm = 0.23;
    is_mm_l = 0;
    
    %max(max(abs(maskIS)))
    %max(max(abs(maskIV)))
    
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,4,1)
    h1 = heatmap(linIV,'ColorLimits',[iv_mm_l iv_mm],'Colormap',jet);
    h1.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Lin Imputation IV - Day %d',Days(i)))

    subplot(1,4,2)
    h2 = heatmap(miIV,'ColorLimits',[iv_mm_l iv_mm],'Colormap',jet);
    h2.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Mean Imputation IV - Day %d',Days(i)))
    
    subplot(1,4,3)
    h3 = heatmap(mediIV,'ColorLimits',[iv_mm_l iv_mm],'Colormap',jet);
    h3.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Median Imputation IV - Day %d',Days(i)))
    
    subplot(1,4,4)
    h4 = heatmap(maskIV,'ColorLimits',[iv_mm_l iv_mm],'Colormap',jet);
    h4.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Masked IV - Day %d',Days(i)))
    
    %%
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,4,1)
    h5 = heatmap(linIS,'ColorLimits',[is_mm_l is_mm],'Colormap',jet);
    h5.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Lin Imputation IS - Day %d',Days(i)))

    subplot(1,4,2)
    h6 = heatmap(miIS,'ColorLimits',[is_mm_l is_mm],'Colormap',jet);
    h6.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Mean Imputation IS - Day %d',Days(i)))
    
    subplot(1,4,3)
    h7 = heatmap(mediIS,'ColorLimits',[is_mm_l is_mm],'Colormap',jet);
    h7.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Median Imputation IS - Day %d',Days(i)))
    
    subplot(1,4,4)
    h6 = heatmap(maskIS,'ColorLimits',[is_mm_l is_mm],'Colormap',jet);
    h6.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Durs);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Duration')
    title(sprintf('STD Masked IS - Day %d',Days(i)))

    
end

