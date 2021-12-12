function C = digit_classify(testdata)
% digit_classify
% INPUT:
%     testdata - matrix of points of a stroke to be classified
% OUTPUT:
%     C - classification
%
% Digit classification
%
% Let's assume model accuracy and how sure it is be defined by the variable x
% be presented as [digit,acc,sureness] = model
% then we need to find such a function that will boost high accuracy and
% high sureness models to our voting system 
% then each model votes for one of the digit and the score of the vote
% is the function y. We choose the digit where y is the highest

% Load pretrained models
load('models/models.mat'); % models are trained with 300 stroke points
load('models/simpleGridModel.mat')
load('models/knnModel.mat')

%Choose the best model from pretrained interpolated models
m1 = model_benchmark.intpol_model_attempt_4_train_r_90_dim_3;

testdata = normalize2D(testdata); %data normalization for Bayes models
interpolated_data = linearInterpolation(testdata,300); % data interpolation for interpolating model

c1 = zeros(10,300);
C3 = zeros(1,10);
for digit = 0:9
    s = strcat("digit_",num2str(digit));
    for i = 1:size(c1,2)
        c1(digit+1,i) = mvnpdf(interpolated_data(i,:),m1.(s).mu(i,:),m1.(s).sigma);
    end
end

c1_sum = sum(c1,2);

C1 = normalizeProbabilityMatrix(c1_sum);

% Grid model
[C2,~] = simpleGridPredict(testdata,simpleGridModel);
p_min = min(C2); %find digit with minimum pdf
p_max = max(C2); %find digit with maximum pdf
C2 = (C2-p_min)./(p_max-p_min);

% kNN model
K = 2;
knn_c = knnPredict(testdata,knnModel,K);
C3(knn_c) = 1;
C3 = C3';

c = C3+1.2*C2+0.9*C1;
[~,C] = max(c); %we choose the class which has the biggest value
C = C - 1; 
end