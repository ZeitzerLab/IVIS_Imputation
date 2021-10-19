%% Bland ALtman plots

%% Load Data
load('C:\Users\Lara\OneDrive - Stanford\Research\Zeitzer\UKBB\Data\Imputation\impT20211019.mat')

%% Heatmap Gen
Days = unique(T.Day);
Durs = unique(T.Dur);
Starts = unique(T.StartHr);

Da = [];
Du = [];
St = [];
impIV = [];
mimpIV = [];
impIS = [];
mimpIS = [];
for i = 1:length(Days)
    for j = 1:length(Starts)
        for k = 1:length(Durs)
            ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
            
            Da = [Da;Days(i)];
            Du = [Du;Durs(k)];
            St = [St;Starts(j)];
            impIV = [impIV; mean(T.IV_imp(ind))-mean(T.IV_mask(ind))];
            mimpIV = [mimpIV; mean(T.IV_mimp(ind))-mean(T.IV_mask(ind))];
            impIS = [impIS; mean(T.IS_imp(ind))-mean(T.IS_mask(ind))];
            mimpIS = [mimpIS; mean(T.IS_mimp(ind))-mean(T.IS_mask(ind))];
        end
    end
end

Tcont = table(Da,Du,St,impIV,mimpIV,impIS,mimpIS);



Days = unique(T.Day);
Durs = unique(T.Dur);
Starts = unique(T.StartHr);

Da = [];
Du = [];
St = [];
impIV = [];
mimpIV = [];
impIS = [];
mimpIS = [];

iIV = [];
miIV = [];
iIS = [];
miIS = [];
for i = 1:length(Days)
    for j = 2:length(Starts)
        for k = 1:length(Durs)
            ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
            
            iIV(j,k) = mean(T.IV_imp(ind))-mean(T.IV_mask(ind));
            miIV(j,k) = mean(T.IV_mimp(ind))-mean(T.IV_mask(ind));
            iIS(j,k) = mean(T.IS_imp(ind))-mean(T.IS_mask(ind));
            miIS(j,k) = mean(T.IS_mimp(ind))-mean(T.IS_mask(ind));
%             Da = [Da;Days(i)];
%             Du = [Du;Durs(k)];
%             St = [St;Starts(j)];
%             impIV = [impIV; mean(T.IV_imp(ind))-mean(T.IV_mask(ind))];
%             mimpIV = [mimpIV; mean(T.IV_mimp(ind))-mean(T.IV_mask(ind))];
%             impIS = [impIS; mean(T.IS_imp(ind))-mean(T.IS_mask(ind))];
%             mimpIS = [mimpIS; mean(T.IS_mimp(ind))-mean(T.IS_mask(ind))];
        end
    end
end

figure
heatmap(iIV)
%xticks(Starts)
xlabel('Start Time')
%xticks(Durs)
ylabel('Duration')
title('iIV')

figure
heatmap(miIV)
%xticks(Starts)
xlabel('Start Time')
%xticks(Durs)
ylabel('Duration')
title('miIV')

figure
heatmap(iIS)
%xticks(Starts)
xlabel('Start Time')
%xticks(Durs)
ylabel('Duration')
title('iIS')

figure
heatmap(miIS)
%xticks(Starts)
xlabel('Start Time')
%xticks(Durs)
ylabel('Duration')
title('miIS')


miIV = [];
iIS = [];
miIS = [];

contourf(Tcont.St,Tcont.Du,Tcont.impIV)


            
            % IV
            figure
            %subplot(1,2,1)
            %plot((T.IV_comp(ind)+T.IV_mask(ind))./2,T.IV_mask(ind)-T.IV_comp(ind),'.b','markersize',5)
            hold on
            plot((T.IV_comp(ind)+T.IV_imp(ind))./2,T.IV_imp(ind)-T.IV_comp(ind),'.r','markersize',5)
            %plot((T.IV_comp(ind)+T.IV_mimp(ind))./2,T.IV_mimp(ind)-T.IV_comp(ind),'.k','markersize',5)
            title(sprintf('IV - Day:%d - Dur:%d - Start:%d',Days(i), Durs(j), Starts(k)))
            xlabel('Average IV')
            ylabel('Difference')
            grid on







% % % %% loop
% % % Days = unique(T.Day);
% % % Durs = unique(T.Dur);
% % % Starts = unique(T.StartHr);
% % % for i = 1:length(Days)
% % %     for j = [4,6,8,11]%1:length(Starts)
% % %         for k = 1:length(Durs)
% % %             ind = T.Day == Days(i) & T.Dur == Durs(k) & T.StartHr == Starts(j);
% % %             
% % %             % IV
% % %             figure
% % %             %subplot(1,2,1)
% % %             %plot((T.IV_comp(ind)+T.IV_mask(ind))./2,T.IV_mask(ind)-T.IV_comp(ind),'.b','markersize',5)
% % %             hold on
% % %             plot((T.IV_comp(ind)+T.IV_imp(ind))./2,T.IV_imp(ind)-T.IV_comp(ind),'.r','markersize',5)
% % %             %plot((T.IV_comp(ind)+T.IV_mimp(ind))./2,T.IV_mimp(ind)-T.IV_comp(ind),'.k','markersize',5)
% % %             title(sprintf('IV - Day:%d - Dur:%d - Start:%d',Days(i), Durs(j), Starts(k)))
% % %             xlabel('Average IV')
% % %             ylabel('Difference')
% % %             grid on
% % %             axis equal
% % %             xlim([.2 .8])
% % %             ylim([-.2 .3])
% % %             
% % %             
% % % %             % IS
% % % % %             figure
% % % % %             subplot(1,2,2)
% % % % %             plot(T.IS_comp(ind),T.IS_mask(ind)-T.IS_comp(ind),'.b','markersize',5)
% % % % %             hold on
% % % % %             plot(T.IS_comp(ind),T.IS_imp(ind)-T.IS_comp(ind),'.r','markersize',5)
% % % % %             plot(T.IS_comp(ind),T.IS_mimp(ind)-T.IS_comp(ind),'.k','markersize',5)
% % % % %             title(sprintf('IS - Day:%d - Dur:%d - Start:%d',Days(i), Durs(k), Starts(j)))
% % % % %             xlabel('Complete IS')
% % % % %             ylabel('Difference')
% % % % %             xlim([0 .045])
% % % % %             ylim([-.004 .006])
% % % % %             grid on
% % %             
% % %         end
% % %     end
% % % end


% 
% figure
% plot(T.IV_comp)
% hold on
% plot(T.IV_mask)
% plot(T.IV_imp)
% plot(T.IV_mimp)
% legend('Complete','Masked','Imp','MeanImp')
% title('IV')
% 
% figure
% plot(T.IS_comp)
% hold on
% plot(T.IS_mask)
% plot(T.IS_imp)
% plot(T.IS_mimp)
% legend('Complete','Masked','Imp','MeanImp')
% title('IS')
% 
% figure
% plot(T.IV_mask -T.IV_comp)
% hold on
% plot(T.IV_imp -T.IV_comp)
% plot(T.IV_mimp -T.IV_comp)
% legend('Masked','Imp','MeanImp')
% title('IV Difference')
% 
% figure
% plot(T.IS_mask -T.IS_comp)
% hold on
% plot(T.IS_imp -T.IS_comp)
% plot(T.IS_mimp -T.IS_comp)
% legend('Masked','Imp','MeanImp')
% title('IS Difference')
% 
% figure
% subplot(1,2,1)
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2)],{'Masked','Imp','Mean Imp'})
% title('IV RMSE')
% ylabel('RMSE')
% grid on
% set(gca,'fontweight','bold')
% 
% subplot(1,2,2)
% boxplot([sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_imp -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2)],{'Masked','Imp','Mean Imp'})
% title('IS RMSE')
% ylabel('RMSE')
% grid 
% set(gca,'fontweight','bold')
% 
% 
% 
% figure
% subplot(1,2,1)
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2)]',T.hrsmiss)
% title('IV RMSE')
% ylabel('RMSE')
% grid on
% set(gca,'fontweight','bold')
% 
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.hrsmiss)
% ylabel('IS RMSE')
% title('Masked')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.hrsmiss)
% title('Graph Imputed')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.hrsmiss)
% title('Mean Imputed')
% linkaxes(ax,'xy')
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.hrsmiss)
% ylabel('IV RMSE')
% title('Masked')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.hrsmiss)
% title('Graph Imputed')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.hrsmiss)
% title('Mean Imputed')
% linkaxes(ax,'xy')
% 
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.days)
% ylabel('IS RMSE')
% title('Masked')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.days)
% title('Graph Imputed')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.days)
% title('Mean Imputed')
% linkaxes(ax,'xy')
% 
% figure
% ax(1) = subplot(1,3,1);
% boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.days)
% ylabel('IV RMSE')
% title('Masked')
% ax(2) = subplot(1,3,2);
% boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.days)
% title('Graph Imputed')
% ax(3) = subplot(1,3,3);
% boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.days)
% title('Mean Imputed')
% linkaxes(ax,'xy')
% 
% 
% 
% 
% ttest(sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2))
% ttest(sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_imp -T.IS_comp).^2))
% 
% ttest(sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2))
% ttest(sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2))
% 
% ttest(sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2))
% ttest(sqrt((T.IS_imp -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2))
% 
% 
% 
% 
% 
