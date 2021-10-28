%% Actigraphy imputation via network
% Lara Weed 18 OCT 2021

%% Load Data
% Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat')

% Masks
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Masks\masksWedSat2-2.mat')

%% Loop

% Set Vars
Subject = []; 
Day = [];
StartHr = [];
Dur = [];
IV_mask = [];
IS_mask = [];
IV_imp = [];
IS_imp = [];
IV_mimp = [];
IS_mimp = [];
IV_comp = [];
IS_comp = [];

subjects = fields(masks);
parfor i = 1:length(subjects)
    %clear act_full act t
    fprintf('%d - %s\n',i,subjects{i})
    m = masks.(subjects{i}).ind;
    
    act_full = data.(subjects{i}).acc;
    t = data.(subjects{i}).t;
    
    [IV_comp1,IS_comp1] = calcIVIS(act_full,t);
    
    for j = 1:size(m,2)
        fprintf('    Mask %d of %d\n',j,size(m,2))
        %clear act
        try
            %% -------------------------- Apply Mask --------------------------- %%
            act = act_full.*m(:,j);

            %% ---------------------- Generate Gap Index ----------------------- %%
            notGap_ind = m(:,j)>0; %not gaps
            gaps = gapDur(notGap_ind);

            %% -------------------- Generate Network Graph --------------------- %%    
            % Generate Adjacency Matrix
            [Adj,nl] = genAccNet(act(notGap_ind),t(notGap_ind));

            %% ----------------------- Compute Imputation ---------------------- %%
            % Graph Imputation
            imputed = graphImputation(act,gaps,Adj,nl);

            % Mean Imputation
            meanimputed = meanImputation(act,t,gaps);

            %% ------------------------- Calculate IVIS ------------------------ %%
            [IV_mask1,IS_mask1] = calcIVIS(act,t);
            [IV_imp1,IS_imp1] = calcIVIS(imputed,t);
            [IV_meanimp,IS_meanimp] = calcIVIS(meanimputed,t);

            Subject = [Subject;subjects{i}]; 
            Day = [Day;masks.(subjects{i}).type(j,1)];
            StartHr = [StartHr;masks.(subjects{i}).type(j,2)];
            Dur = [Dur;masks.(subjects{i}).type(j,3)];
            IV_mask = [IV_mask; IV_mask1];
            IS_mask = [IS_mask; IS_mask1];
            IV_imp = [IV_imp; IV_imp1];
            IS_imp = [IS_imp; IS_imp1];
            IV_mimp = [IV_mimp;IV_meanimp];
            IS_mimp = [IS_mimp;IS_meanimp];
            IV_comp = [IV_comp;IV_comp1];
            IS_comp = [IS_comp;IS_comp1];
        catch
            fprintf('    error\n')
        end
    %% ------------------------ Plot ------------------------- %%   
%     figure
%      plot(dt.t,dt.act)
%      hold on
%      plot(dt.t(gaps(:,1)),dt.act(gaps(:,1)),'k*')
    end   
end


T = table(Subject,Day,StartHr,Dur,IV_comp,IV_mask,IV_imp,IV_mimp,IS_comp,IS_mask,IS_imp,IS_mimp);

save_path = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation';

save_fn = fullfile(save_path,'impT20211019.mat');

save(save_fn,'T')

%%
figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.Dur)
title('Mask')
ylabel('IV RMSE')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.Dur)
title('Imp')
xlabel('Gap Duration')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.Dur)
title('Mean Imp')
linkaxes(ax,'xy')

figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.Dur)
title('Mask')
ylabel('IS RMSE')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.Dur)
title('Imp')
xlabel('Gap Duration')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.Dur)
title('Mean Imp')
linkaxes(ax,'xy')



figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.StartHr)
title('Mask')
ylabel('IV RMSE')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.StartHr)
title('Imp')
xlabel('Start Hour')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.StartHr)
title('Mean Imp')
linkaxes(ax,'xy')

figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.StartHr)
title('Mask')
ylabel('IS RMSE')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.StartHr)
title('Imp')
xlabel('Start Hour')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.StartHr)
title('Mean Imp')
linkaxes(ax,'xy')







