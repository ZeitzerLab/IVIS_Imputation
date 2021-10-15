%% Actigraphy imputation via network
% Lara Weed 14 OCT 2021

%% Load data
% masked Data
dpath = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\raw\ukbb_masked';
ddpath = dir(dpath);
fn = {ddpath.name}';
fn = fn(3:end);

%complete data
dpathC = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\raw\ukbb_complete';
ddpathC = dir(dpathC);
fnC = {ddpathC.name}';
fnC = fnC(3:end);

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

IV_mask = nan(length(fn),1);
IS_mask = nan(length(fn),1);
IV_imp = nan(length(fn),1);
IS_imp = nan(length(fn),1);

for i = 1:length(fn)
    dt = readtable(fullfile(dpath,fn{i}));
    dt.Var1 = datetime(dt.Var1);
    dt.Properties.VariableNames = {'t','act'};
    
    fprintf('%d - %s - %s - %s\n',i,subjects{i},days{i},hrsmiss{i})
    
    % Gaps
    notGap_ind = dt.act>0; %not gaps
    gaps = [find(diff(~notGap_ind)>0),ones(length(find(diff(~notGap_ind)>0)),1);...
        find(diff(~notGap_ind)<0),zeros(length(find(diff(~notGap_ind)<0)),1)];
    gaps = sortrows(gaps);
    
    if rem(size(gaps,1),2) == 1
        if gaps(end,2) == 1
            gaps = [gaps;length(dt.act),0];
        end
        
        if gaps(1,2) == 0
            gaps = [1,1;gaps];
        end
    end
    starts = gaps(gaps(:,2)==1,1);
    stops = gaps(gaps(:,2)==0,1);
    gaps = [starts,stops];
%     figure
%      plot(dt.t,dt.act)
%      hold on
%      plot(dt.t(gaps(:,1)),dt.act(gaps(:,1)),'k*')
    
    %% ------------------ Generate Network Graph ------------------------%%
    fprintf('    Generating Network...\n')
    % Remove missing data
    act = dt.act(notGap_ind);
    t = dt.t(notGap_ind);
    
    % Determine node values
    nl = unique(act);
    
    % initialize sparse matrix
    S = sparse(length(nl),length(nl));
    
    % Determine pairs
    A = act(1:2:end);
    B = act(2:2:end);
    C = A(2:end);
    A = A(1:end-1);
    
    % Pre allocate 
    A1 = nan(length(A),1);
    B1 = nan(length(B),1);
    C1 = nan(length(C),1);
    
    % Convert pairs to labels
    for j = 1:length(nl)
        ind_A = find(A==nl(j));
        ind_B = find(B==nl(j));
        ind_C = find(C==nl(j));
        
        A1(ind_A) = j;
        B1(ind_B) = j;
        C1(ind_C) = j;
    end
    
    for k = 1:length(A)
        if t(2*k)-t(2*k-1)==seconds(30)
            %forward
            S(A1(k),B1(k)) = S(A1(k),B1(k)) + 1;
            %backward
            S(B1(k),A1(k)) = S(B1(k),A1(k)) + 1;
        end
        if t(2*k+1)-t(2*k)==seconds(30)
            %forward
            S(B1(k),C1(k)) = S(B1(k),C1(k)) + 1;
            %backward
            S(C1(k),B1(k)) = S(C1(k),B1(k)) + 1;
        end
    end
    
    %S = S(2:end,2:end);
    
    %G = graph(S);
    
    %% ------------------- Compute Imputation ---------------------------%%
    fprintf('    Computing Imputation...\n')
    %figure
    %plot(G)
    figure
    plot(dt.t,dt.act)
    title(sprintf('%s - %s - %s',subjects{i},days{i},hrsmiss{i}))
    imputed = dt.act;
    for q = 1:size(gaps,1)
        if gaps(q,1) == 1
            seedNode = find(nl == dt.act(gaps(q,2)+1));
        else
            seedNode = find(nl == dt.act(gaps(q,1)));
        end
        impLength = gaps(q,2) - gaps(q,1);
        
        impsNode = [seedNode];
        % Options form seed node
        for qq = 1:impLength
            conn = full(S(impsNode(end),:));
            conn_ind = find(conn>0);
            cons = [conn_ind',conn(conn_ind)'];
            opVals = [];
            for pp = 1:size(cons,1)
                opVals = [opVals;repmat(cons(pp,1),1)];
            end
            
            if isempty(opVals)
                n = 1;
                while isempty(opVals)
                    conn = full(S(impsNode(end)-n,:));
                    conn_ind = find(conn>0);
                    cons = [conn_ind',conn(conn_ind)'];
                    opVals = [];
                    for pp = 1:size(cons,1)
                        opVals = [opVals;repmat(cons(pp,1),1)];
                    end
                    n=n+1;
                end
            end 
            nextNode = randsample(opVals,1);
            impsNode = [impsNode;nextNode];
        end
        
        imps = nan(length(impsNode),1);
        for tt = 1:length(nl)
            imps(impsNode==tt)= nl(tt);
        end
        
        if gaps(q,1) == 1
            imps = flipud(imps);
        end
            
        hold on
        plot(dt.t(gaps(q,1):gaps(q,2)),imps,'k')
        imputed(gaps(q,1):gaps(q,2)) = imps;
    end

    
    
    %% ----------------------- Calculate IVIS ---------------------------%%
    fprintf('    Calculate IVIS...\n')
    [IV_mask1,IS_mask1] = calcIVIS(dt.act,dt.t);
    [IV_imp1,IS_imp1] = calcIVIS(imputed,dt.t);
    
    IV_mask(i) = IV_mask1;
    IS_mask(i) = IS_mask1;
    IV_imp(i) = IV_imp1;
    IS_imp(i) = IS_imp1;
    
    
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

T = table(subjects,days,hrsmiss,IV_comp,IV_mask,IV_imp,IS_comp,IS_mask,IS_imp);






