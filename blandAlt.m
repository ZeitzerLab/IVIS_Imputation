%% Bland ALtman plots

%% Load Data
load('impT.mat')





figure
plot(T.IV_comp)
hold on
plot(T.IV_mask)
plot(T.IV_imp)

figure
plot(T.IS_comp)
hold on
plot(T.IS_mask)
plot(T.IS_imp)


figure
plot(T.IV_mask -T.IV_comp)
hold on
plot(T.IV_imp -T.IV_comp)

figure
plot(T.IS_mask -T.IS_comp)
hold on
plot(T.IS_imp -T.IS_comp)





