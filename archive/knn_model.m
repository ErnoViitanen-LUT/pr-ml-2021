close all
clear all
clc
loadstrokes;
%% Features (mu,Std,Min,Max,Median,Skewness,Kurtosis)
n = 1000;
data = datanormalization2d(data)
for i = 1:n
    matData = cell2mat(data(i));
    mu = mean(matData);%extracting mean value of each sample point;
    X(i,:)= mu;
    St = std(matData);%extracting Standard deviation value of each sample point
    Y(i,:)= St;
    Min = min(matData);%extracting minimum value of each sample point
    W(i,:)= Min;
    Max = max(matData);%extracting maximum value of each sample point
    Z(i,:)= Max;
    Med = median(matData);%extracting median value of each sample point
    V(i,:)= Med;
    Sk = skewness(matData);%extracting skewness value of each sample point
    U(i,:) = Sk;
    Ku = kurtosis(matData);%extracting kurtosis value of each sample point
    K(i,:) = Ku;
    
end

Data = [X, Y, W, Z, V, U, K]; % Final data set with considered features of each sample 
data22 = [Data(:,:)';class]; %normalized dataset with the class details
data = data22';
%% Dividing the data
N = 1000;
[e,q] = size(data);
Per = 0.7; %splitting percentage
Tr = round(Per * e);%amount of data to be trained to the closest integer
Tn = N - Tr; % number of testing observations
Ind = randperm(N); % randomizing the order of sample points
trainD = data(Ind(1:Tr),1:end-1); %training data 
trainC = data(Ind(1:Tr),end); %classes of training data
testD = data(Ind(Tr+1:end),1:end-1); %test data 
testC = data(Ind(Tr+1:end),end); %classes of testing data

%% Checking the accuracy for different number of K levels
k = 2:15;

for i = 1:length(k)
    C = knn_predict(trainC,trainD,testD,k(i));
    accuracy(i) = sum(C==testC)/length(testC)
    c = confusionmat(testC, C);
    figure
    confusionchart(c)
    title(sprintf('k = %d', k(i)));    
end