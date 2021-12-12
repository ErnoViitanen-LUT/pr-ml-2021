clear all;
loadTrainingStrokes;

ndata = normalize2D(data);
pTrain = 2/3;
[trainData,trainClass,testData,testClass] = splitForTrainAndTest(ndata,class,pTrain);

[~,m] = size(trainData);
for i = 1:m
    matData = cell2mat(trainData(i));
    % Features (mu,Std,Min,Max,Median,Skewness,Kurtosis)
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

knnData = [X, Y, W, Z, V, U, K]; % Final data set with considered features of each sample 
knnModel = [knnData(:,:)';trainClass]'; %normalized dataset with the class details

for times=1:10
    [~,~,testData,testClass] = splitForTrainAndTest(ndata,class,pTrain);
        
    for k=2:5
        predictedClass = knnPredict(testData,knnModel,k);
        
        data_size = size(testData,2);
        err = sum(testClass ~= predictedClass); % we compare our results with the expected values
        accuracy = (data_size-err)/(data_size); % we compute the accuracy
        fprintf("accuracy %s for K=%d\n", mat2str(accuracy), k);
    end
end