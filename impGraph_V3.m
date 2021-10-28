%% Actigraphy imputation via network
% Lara Weed 18 OCT 2021

%% Load Data
% Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat')

% Masks
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Masks\masksAllt2-2.mat')

%% Loop

% Set Vars
Subject = []; 
Day = [];
StartHr = [];
Dur = [];
IV_mask = [];
IS_mask = [];
%IV_imp = [];
%IS_imp = [];
IV_mimp = [];
IS_mimp = [];
IV_comp = [];
IS_comp = [];
IV_medimp = [];
IS_medimp = [];
IV_linimp = [];
IS_linimp = [];

subjects = unique(masks.subject);
parfor i = 1:length(subjects)
    %clear act_full act t
    fprintf('%d - %s\n',i,subjects{i})
    m = masks(strcmp(masks.subject,subjects{i}),:);
    
    act_full = data.(subjects{i}).acc;
    t = data.(subjects{i}).t;
    
    % Generate full Adjacency Matrix
%     [Adj,nl] = genAccNet(act_full,t);
    
    % Calculate IVIS
    [IV_comp1,IS_comp1] = calcIVIS(act_full,t);
    
    for j = 1:size(m,1)
        fprintf('    Mask %d of %d\n',j,size(m,1))
        %clear act
        try
            %% -------------------------- Apply Mask --------------------------- %%
            if ~isnan(m.start_ind(j)) && ~isnan(m.end_ind(j))
                %% -------------------- Generate Network Graph --------------------- %%    
                % Remove connections of Adj Matrix corresponding to gaps
%                 extraConn = act_full(m.start_ind(j):m.end_ind(j));
%                 Adj_m = Adj;
%                 for kk = 2:length(extraConn)
%                     a = find(nl == extraConn(kk-1));
%                     b = find(nl == extraConn(kk));
%                     Adj_m(a,b) = Adj_m(a,b) - 1;
%                 end
                
                
                %% ----------------------- Compute Imputation ---------------------- %%
                act = act_full;
                act(m.start_ind(j):m.end_ind(j)) = 0;
                gaps = [m.start_ind(j)-1,m.end_ind(j)];
                
%                 % Graph Imputation
%                 imputed = graphImputation(act,gaps,Adj,nl,6); % 6 becuase 6 oother days are used in the mean imputation
                
                % Imputation
                medianimputed = medianImputation(act,t,gaps);
                meanimputed = meanImputation(act,t,gaps);
                linInterpimputed = linInterpImputation(act,t,gaps);

                %% ------------------------- Calculate IVIS ------------------------ %%
                [IV_mask1,IS_mask1] = calcIVIS(act,t);
%                 [IV_imp1,IS_imp1] = calcIVIS(imputed,t);
                [IV_meanimp,IS_meanimp] = calcIVIS(meanimputed,t);
                [IV_medianimp,IS_medianimp] = calcIVIS(medianimputed,t);
                [IV_liimp,IS_liimp] = calcIVIS(linInterpimputed,t);

                Subject = [Subject;subjects{i}]; 
                Day = [Day;m.day(j)];
                StartHr = [StartHr;m.startHr(j)];
                Dur = [Dur;m.dur(j)];
                IV_mask = [IV_mask; IV_mask1];
                IS_mask = [IS_mask; IS_mask1];
%                 IV_imp = [IV_imp; IV_imp1];
%                 IS_imp = [IS_imp; IS_imp1];
                IV_mimp = [IV_mimp;IV_meanimp];
                IS_mimp = [IS_mimp;IS_meanimp];
                IV_medimp = [IV_medimp;IV_medianimp];
                IS_medimp = [IS_medimp;IS_medianimp];
                IV_linimp = [IV_linimp;IV_liimp];
                IS_linimp = [IS_linimp;IS_liimp];
                IV_comp = [IV_comp;IV_comp1];
                IS_comp = [IS_comp;IS_comp1];
            end
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


% T = table(Subject,Day,StartHr,Dur,IV_comp,IV_mask,IV_imp,IV_mimp,IV_medimp,IS_comp,IS_mask,IS_imp,IS_mimp,IS_medimp);
T = table(Subject,Day,StartHr,Dur,IV_comp,IV_mask,IV_mimp,IV_medimp,IV_linimp,IS_comp,IS_mask,IS_mimp,IS_medimp,IS_linimp);

save_path = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation';

save_fn = fullfile(save_path,'impT20211028.mat');

save(save_fn,'T')

%%
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.Dur)
% title('Mask')
% ylabel('IV RMSE')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.Dur)
% title('Imp')
% xlabel('Gap Duration')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.Dur)
% title('Mean Imp')
% linkaxes(ax,'xy')
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.Dur)
% title('Mask')
% ylabel('IS RMSE')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.Dur)
% title('Imp')
% xlabel('Gap Duration')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.Dur)
% title('Mean Imp')
% linkaxes(ax,'xy')
% 
% 
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.StartHr)
% title('Mask')
% ylabel('IV RMSE')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.StartHr)
% title('Imp')
% xlabel('Start Hour')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.StartHr)
% title('Mean Imp')
% linkaxes(ax,'xy')
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.StartHr)
% title('Mask')
% ylabel('IS RMSE')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.StartHr)
% title('Imp')
% xlabel('Start Hour')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.StartHr)
% title('Mean Imp')
% linkaxes(ax,'xy')
% 






