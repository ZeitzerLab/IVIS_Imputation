%% Bland ALtman plots

%% Load Data
if exist('T','var') == 0
    load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impTmult20211112.mat')
end

%%
Days = unique(T.Day);
Spacing = unique(T.Spacing);
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
        for k = 1:length(Spacing)
            ind = T.Day == Days(i) & T.Spacing == Spacing(k) & T.StartHr == Starts(j);
            
            linIV(k,j) = nanmean(T.IV_linimp(ind)-T.IV_comp(ind));
            miIV(k,j) = nanmean(T.IV_mimp(ind)-T.IV_comp(ind));
            linIS(k,j) = nanmean(T.IS_linimp(ind)-T.IS_comp(ind));
            miIS(k,j) = nanmean(T.IS_mimp(ind)-T.IS_comp(ind));
            maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
            maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
            mediIV(k,j) = nanmean(T.IV_medimp(ind)-T.IV_comp(ind));
            mediIS(k,j) = nanmean(T.IS_medimp(ind)-T.IS_comp(ind));
            
%             iIV(k,j) = nanmean(T.IV_imp(ind) - T.IV_mask(ind));
%             miIV(k,j) = nanmean(T.IV_mimp(ind)- T.IV_mask(ind));
%             iIS(k,j) = nanmean(T.IS_imp(ind)- T.IS_mask(ind));
%             miIS(k,j) = nanmean(T.IS_mimp(ind)- T.IS_mask(ind));
%             
%             maskIV(k,j) = nanmean(T.IV_mask(ind)-T.IV_comp(ind));
%             maskIS(k,j) = nanmean(T.IS_mask(ind)-T.IS_comp(ind));
            
            
        end
    end
    %iv_mm = max(abs([min(min(linIV)),max(max(linIV)),min(min(miIV)),max(max(miIV)),min(min(maskIV)),max(max(maskIV)),min(min(mediIV)),max(max(mediIV))]))
    %is_mm = max(abs([min(min(linIS)),max(max(linIS)),min(min(miIS)),max(max(miIS)),min(min(maskIS)),max(max(maskIS)),min(min(mediIS)),max(max(mediIS))]))

    iv_mm = 0.10;
    is_mm = 0.06;
    
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,4,1)
    h1 = heatmap(linIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h1.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Lin Imputation IV - Day %d',Days(i)))

    subplot(1,4,2)
    h2 = heatmap(miIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h2.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Mean Imputation IV - Day %d',Days(i)))
    
    subplot(1,4,3)
    h3 = heatmap(mediIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h3.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Median Imputation IV - Day %d',Days(i)))
    
    subplot(1,4,4)
    h4 = heatmap(maskIV,'ColorLimits',[-iv_mm iv_mm],'Colormap',jet);
    h4.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Masked IV - Day %d',Days(i)))
    
    %%
    figure('Renderer', 'painters', 'Position', [100 100 800 400])
    subplot(1,4,1)
    h5 = heatmap(linIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h5.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Lin Imputation IS - Day %d',Days(i)))

    subplot(1,4,2)
    h6 = heatmap(miIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h6.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Mean Imputation IS - Day %d',Days(i)))
    
    subplot(1,4,3)
    h7 = heatmap(mediIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h7.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Median Imputation IS - Day %d',Days(i)))
    
    subplot(1,4,4)
    h6 = heatmap(maskIS,'ColorLimits',[-is_mm is_mm],'Colormap',jet);
    h6.NodeChildren(3).YDir='normal';
    ax = gca;
    ax.XDisplayLabels = num2cell(Starts);
    ax.YDisplayLabels = num2cell(Spacing);
    %xticks(Starts)
    xlabel('Start Time')
    %xticks(Durs)
    ylabel('Spacing')
    title(sprintf('Masked IS - Day %d',Days(i)))

    
end

