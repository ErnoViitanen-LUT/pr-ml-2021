function [trainData,trainClass,testData,testClass] = splitForTrainAndTest(data,class,pTrain)
% splitForTrainAndTest(data) - split data into training and test data
% INPUT:
%     data - data to be split
%     class - classes for the data
%     pTrain - percentage of training data (leftover is test data)
% OUTPUT:
%     trainData - training data
%     trainClass - training class
%     testData - test data
%     testClass - test class
    
    n = size(data,2);
    pValidate = 0;
    nTrain = ceil(pTrain * n);
    nValidate = ceil(pValidate * n);
    i = randperm(n);
    trainData = data(i(1:nTrain));
    trainClass = class(i(1:nTrain));
    %nTest = n - nTrain;
    testData = data(i(nTrain+nValidate+1:end));
    testClass = class(i(nTrain+nValidate+1:end));
            
end