%% Imputation over gaps and 4000+ acc values

Dpath = 'C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Raw\Files_accelerating_4000';
d = dir(Dpath);

fn = {d.name}';
fn = fn(3:end);

%fn = gunzip('*.gz');

parfor i = 1:length(fn)
    fprintf('%d - %s\n',i,fn{i})
    dt = readtable(fullfile(Dpath,fn{i}),'Delimiter', ',');
    dt2 = readtable(fullfile(Dpath,fn{i}));
    ttt=[];
    for jj = 1:length(dt2.Var2)
        ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
    end
    
    notGap_ind = ~(dt.imputed);
    gaps = gapDur(notGap_ind);
    acc_med = medianImputation(dt.acc,ttt,gaps);
    dt.acc_med = acc_med;
    
    notGap_ind = ~(dt.imputed | dt.acc>4000);
    gaps = gapDur(notGap_ind);
    acc_med4000 = medianImputation(dt.acc,ttt,gaps);
    dt.acc_med4000 = acc_med4000;
    
    [IV_acc_med4000(i,1),IS_acc_med4000(i,1)] = calcIVIS(acc_med4000,ttt);
    [IV_acc_med(i,1),IS_acc_med(i,1)] = calcIVIS(acc_med,ttt);
    [IV_acc(i,1),IS_acc(i,1)] = calcIVIS(dt.acc,ttt);
%     figure
%     plot(dt.acc)
%     hold on
%     plot(acc_med4000) 
%     title(fn{i})
%     pause(.01)
    
    %writetable(dt,fullfile(Dpath,fn{i}),'Delimiter',',')  
end

T = table(fn,IV_acc,IS_acc,IV_acc_med,IS_acc_med,IV_acc_med4000,IS_acc_med4000);
%writetable(T,fullfile('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\UKBB IVIS','acc_med4000IVIS.csv'),'Delimiter',',')





