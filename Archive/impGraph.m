%% Actigraphy imputation via network
% Lara Weed 14 OCT 2021

%% Load Paths
% Masked Data
dpath = 'C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\raw\ukbb_masked';
ddpath = dir(dpath);
fn = {ddpath.name}';
fn = fn(3:end);

% Complete Data
dpathC = 'C:\Users\Laraw\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\raw\ukbb_complete';
ddpathC = dir(dpathC);
fnC = {ddpathC.name}';
fnC = fnC(3:end);

%% Get file info
subjects = {};
days = {};
hrsmiss = {};

for ff = 1:length(fn)
    us = find(fn{ff}=='_');
    pe = find(fn{ff}=='.');
    subjects{ff,1} = fn{ff}(us(1)+1:us(4)-1);
    days{ff,1} = fn{ff}(pe(1)+1:pe(2)-1);
    hrsmiss{ff,1} = fn{ff}(pe(2)+1:pe(3)-1);
end

%% Preallocate
IV_mask = nan(length(fn),1);
IS_mask = nan(length(fn),1);
IV_imp = nan(length(fn),1);
IS_imp = nan(length(fn),1);
IV_mimp = nan(length(fn),1);
IS_mimp = nan(length(fn),1);

for i = 1:length(fn)
    %% -------------------------- Load Data ---------------------------- %%
    fprintf('%d - %s - %s - %s\n',i,subjects{i},days{i},hrsmiss{i})
    dt = readtable(fullfile(dpath,fn{i}));
    dt.Var1 = datetime(dt.Var1);
    dt.Properties.VariableNames = {'t','act'};
    
    %% ---------------------- Generate Gap Index ----------------------- %%
    notGap_ind = dt.act>0; %not gaps
    gaps = gapDur(notGap_ind);
    
    %% -------------------- Generate Network Graph --------------------- %%
    fprintf('    Generating Network...\n')
    
    % Remove missing data
    act = dt.act(notGap_ind);
    t = dt.t(notGap_ind);
    
    % Generate Adjacency Matrix
    [Adj,nl] = genAccNet(act,t);

    %% ----------------------- Compute Imputation ---------------------- %%
    fprintf('    Computing Imputation...\n')
    
    % Graph Imputation
    imputed = graphImputation(dt.act,gaps,Adj,nl);
    
    % Mean Imputation
    meanimputed = meanImputation(dt.act,dt.t,gaps);
    
    %% ------------------------- Calculate IVIS ------------------------ %%
    fprintf('    Calculate IVIS...\n')
    [IV_mask1,IS_mask1] = calcIVIS(dt.act,dt.t);
    [IV_imp1,IS_imp1] = calcIVIS(imputed,dt.t);
    [IV_meanimp,IS_meanimp] = calcIVIS(meanimputed,dt.t);
    
    IV_mask(i) = IV_mask1;
    IS_mask(i) = IS_mask1;
    IV_imp(i) = IV_imp1;
    IS_imp(i) = IS_imp1;
    IV_mimp(i) = IV_meanimp;
    IS_mimp(i) = IS_meanimp;
    
    %% ------------------------ Plot ------------------------- %%   
%     figure
%      plot(dt.t,dt.act)
%      hold on
%      plot(dt.t(gaps(:,1)),dt.act(gaps(:,1)),'k*')
    
end



%% Load data
subjectsC = {};
for ffC = 1:length(fnC)
    us = find(fnC{ffC}=='_');
    subjectsC{ffC,1} = fnC{ffC}(1:us(3)-1);
end
IV_c = nan(length(fnC),1);
IS_c =nan(length(fnC),1);
for i = 1:length(fnC)
    dt = readtable(fullfile(dpathC,fnC{i}),'Delimiter', ',');
    dt2 = readtable(fullfile(dpathC,fnC{i}));
    ttt=[];
    for jj = 1:length(dt2.Var2)
        ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
    end
    
    fprintf('%d - %s\n',i,subjectsC{i})
    [IV,IS] = calcIVIS(dt.acc,ttt);
    
    IV_c(i,1) = IV;
    IS_c(i,1) = IS;
    
end

IV_comp = nan(length(IV_mask),1);
IS_comp = nan(length(IS_mask),1);
for iii = 1:length(subjects)
    if sum(strcmp(subjects{iii},subjectsC))>0 
        ind = find(strcmp(subjects{iii},subjectsC),1);
        IV_comp(iii) = IV_c(ind);
        IS_comp(iii) = IS_c(ind);
    end
end

T = table(subjects,days,hrsmiss,IV_comp,IV_mask,IV_imp,IV_mimp,IS_comp,IS_mask,IS_imp,IS_mimp);






