function C = digit_classify(testdata)
%Let's assume model accuracy and how sure it is be defined by the variable x
% be presented as [digit,acc,sureness] = model
%then we need to find such a function that will boost high accuracy and
%high sureness models to our voting system 
%then each model votes for one of the digit and the score of the vote
%is the function y. We choose the digit where y is the highest

%Models loading
load('models.mat');
load('simpleGridModel.mat')
load('knn_model.mat')

%Choose the best model
m1 = model_benchmark.intpol_model_attempt_4_train_r_90_dim_3;

testdata = datanormalization2d(testdata); %data normalization for Bayes models
interpolated_data = linear_interpolation(testdata,300); % data interpolation for interpolating model

c = zeros(10,1);
c1 = zeros(10,300);
C3 = zeros(1,10);
for digit = 0:9
    s = strcat("digit_",num2str(digit));
    for i = 1:size(c1,2)
        c1(digit+1,i) = mvnpdf(interpolated_data(i,:),m1.(s).mu(i,:),m1.(s).sigma);
    end
end

c1_sum = sum(c1,2);

C1 = normalize_pdf(c1_sum);

% Grid model
[C2,~] = simpleprediction(testdata,simpleGridModel);
p_min = min(C2); %find digit with minimum pdf
p_max = max(C2); %find digit with maximum pdf
C2 = (C2-p_min)./(p_max-p_min);

% kNN model
mu = mean(testdata);%extracting mean value of each sample point;
St = std(testdata);%extracting Standard deviation value of each sample point
Min = min(testdata);%extracting minimum value of each sample point
Max = max(testdata);%extracting maximum value of each sample point
Med = median(testdata);%extracting median value of each sample point
Sk = skewness(testdata);%extracting skewness value of each sample point
Ku = kurtosis(testdata);%extracting kurtosis value of each sample point
tData = [mu, St, Min, Max, Med, Sk, Ku]; % Final data set with considered features of each sample 
knn_c = knn_predict(data(:,end),data(:,1:end-1),tData,2);
C3(knn_c) = 1;
C3 = C3';

c = C3+1.2*C2+0.9*C1;
[~,C] = max(c); %we choose the class which has the biggest value
C = C - 1; 
end