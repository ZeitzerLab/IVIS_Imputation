%% Actigraphy imputation via network
% Lara Weed 18 OCT 2021

%% Load Data
% Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Organized\dataOrganized.mat')

% Masks
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Masks\masks2gapSweep_20211104_2.mat')

%% Loop

% Set Vars
Subject = []; 
Day = [];
StartHr = [];
Spacing = [];
IV_mask = [];
IS_mask = [];
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
    
    % Calculate IVIS
    [IV_comp1,IS_comp1] = calcIVIS(act_full,t);
    
    for j = 1:size(m,1)
        fprintf('    Mask %d of %d\n',j,size(m,1))
        %clear act
        %try
            %% -------------------------- Apply Mask --------------------------- %%
            if ~isnan(m.start_ind1(j)) && ~isnan(m.end_ind1(j)) && ~isnan(m.start_ind2(j)) && ~isnan(m.end_ind2(j))
                               
                %% ----------------------- Compute Imputation ---------------------- %%
                act = act_full;
                act(m.start_ind1(j):m.end_ind1(j)) = 0;
                act(m.start_ind2(j):m.end_ind2(j)) = 0;
                if m.start_ind1(j)>1
                    gaps = [m.start_ind1(j)-1,m.end_ind1(j);m.start_ind2(j)-1,m.end_ind2(j)];
                else
                    gaps = [m.start_ind1(j),m.end_ind1(j);m.start_ind2(j)-1,m.end_ind2(j)];
                end
                            
                % Imputation
                medianimputed = medianImputation(act,t,gaps);
                meanimputed = meanImputation(act,t,gaps);
                linInterpimputed = linInterpImputation(act,t,gaps);

                %% ------------------------- Calculate IVIS ------------------------ %%
                [IV_mask1,IS_mask1] = calcIVIS(act,t);
                [IV_meanimp,IS_meanimp] = calcIVIS(meanimputed,t);
                [IV_medianimp,IS_medianimp] = calcIVIS(medianimputed,t);
                [IV_liimp,IS_liimp] = calcIVIS(linInterpimputed,t);

                Subject = [Subject;subjects(i)]; 
                Day = [Day;m.day1(j)];
                StartHr = [StartHr;m.startHr1(j)];
                Spacing = [Spacing;m.spacing(j)];
                IV_mask = [IV_mask; IV_mask1];
                IS_mask = [IS_mask; IS_mask1];
                IV_mimp = [IV_mimp;IV_meanimp];
                IS_mimp = [IS_mimp;IS_meanimp];
                IV_medimp = [IV_medimp;IV_medianimp];
                IS_medimp = [IS_medimp;IS_medianimp];
                IV_linimp = [IV_linimp;IV_liimp];
                IS_linimp = [IS_linimp;IS_liimp];
                IV_comp = [IV_comp;IV_comp1];
                IS_comp = [IS_comp;IS_comp1];
            end
        %catch
        %    fprintf('    error\n')
        %end
    end   
end

%% ----------------------------- Save Table ---------------------------- %%
T = table(Subject,Day,StartHr,Spacing,IV_comp,IV_mask,IV_mimp,IV_medimp,IV_linimp,IS_comp,IS_mask,IS_mimp,IS_medimp,IS_linimp);

save_path = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation';

save_fn = fullfile(save_path,'impTmult20211112.mat');

save(save_fn,'T')
