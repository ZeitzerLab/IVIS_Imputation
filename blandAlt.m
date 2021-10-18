%% Bland ALtman plots

%% Load Data
load('impTall.mat')


figure
plot(T.IV_comp)
hold on
plot(T.IV_mask)
plot(T.IV_imp)
plot(T.IV_mimp)
legend('Complete','Masked','Imp','MeanImp')
title('IV')

figure
plot(T.IS_comp)
hold on
plot(T.IS_mask)
plot(T.IS_imp)
plot(T.IS_mimp)
legend('Complete','Masked','Imp','MeanImp')
title('IS')

figure
plot(T.IV_mask -T.IV_comp)
hold on
plot(T.IV_imp -T.IV_comp)
plot(T.IV_mimp -T.IV_comp)
legend('Masked','Imp','MeanImp')
title('IV Difference')

figure
plot(T.IS_mask -T.IS_comp)
hold on
plot(T.IS_imp -T.IS_comp)
plot(T.IS_mimp -T.IS_comp)
legend('Masked','Imp','MeanImp')
title('IS Difference')

figure
subplot(1,2,1)
boxplot([sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2)],{'Masked','Imp','Mean Imp'})
title('IV RMSE')
ylabel('RMSE')
grid on
set(gca,'fontweight','bold')

subplot(1,2,2)
boxplot([sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_imp -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2)],{'Masked','Imp','Mean Imp'})
title('IS RMSE')
ylabel('RMSE')
grid 
set(gca,'fontweight','bold')



figure
subplot(1,2,1)
boxplot([sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2)]',T.hrsmiss)
title('IV RMSE')
ylabel('RMSE')
grid on
set(gca,'fontweight','bold')


figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.hrsmiss)
ylabel('IS RMSE')
title('Masked')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.hrsmiss)
title('Graph Imputed')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.hrsmiss)
title('Mean Imputed')
linkaxes(ax,'xy')

figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.hrsmiss)
ylabel('IV RMSE')
title('Masked')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.hrsmiss)
title('Graph Imputed')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.hrsmiss)
title('Mean Imputed')
linkaxes(ax,'xy')


figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IS_mask -T.IS_comp).^2)],T.days)
ylabel('IS RMSE')
title('Masked')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IS_imp -T.IS_comp).^2)],T.days)
title('Graph Imputed')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IS_mimp -T.IS_comp).^2)],T.days)
title('Mean Imputed')
linkaxes(ax,'xy')

figure
ax(1) = subplot(1,3,1);
boxplot([sqrt((T.IV_mask -T.IV_comp).^2)],T.days)
ylabel('IV RMSE')
title('Masked')
ax(2) = subplot(1,3,2);
boxplot([sqrt((T.IV_imp -T.IV_comp).^2)],T.days)
title('Graph Imputed')
ax(3) = subplot(1,3,3);
boxplot([sqrt((T.IV_mimp -T.IV_comp).^2)],T.days)
title('Mean Imputed')
linkaxes(ax,'xy')




ttest(sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_imp -T.IV_comp).^2))
ttest(sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_imp -T.IS_comp).^2))

ttest(sqrt((T.IV_mask -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2))
ttest(sqrt((T.IS_mask -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2))

ttest(sqrt((T.IV_imp -T.IV_comp).^2),sqrt((T.IV_mimp -T.IV_comp).^2))
ttest(sqrt((T.IS_imp -T.IS_comp).^2),sqrt((T.IS_mimp -T.IS_comp).^2))





