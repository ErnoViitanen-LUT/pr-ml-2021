function C = knnPredict(testdata,model,k)
% knnPredict(testdata,model,k)
% INPUT:
%     testdata - matrix of points of a stroke to be classified
%     model - pretrained kNN model to be used in classification
%     k - number of nearest neighbors
% OUTPUT:
%     C - classification

    [N,M] = size(testdata);

    C = size(N,1);
    if N ~= 1 % we are predicting only one stroke
        M = 1;
    end
    for i = 1:M
        if N == 1
            stroke = cell2mat(testdata(i));
        else
            stroke = testdata;
        end
        
        C(i) = classify(stroke,model,k);
    end    
end

function C = classify(testdata,model,k)
% classify(testdata,model,k)
% classifies given data with knn model
% INPUT:
%     testdata - matrix of points of a stroke to be classified
%     model - pretrained kNN model to be used in classification
%     k - number of nearest neighbors
% OUTPUT:
%     C - classification

    trainclass = model(:,end);
    traindata = model(:,1:end-1);
    [N,~] = size(testdata);
    mu = mean(testdata); %extracting mean value of each sample point;
    St = std(testdata); %extracting Standard deviation value of each sample point
    Min = min(testdata); %extracting minimum value of each sample point
    Max = max(testdata); %extracting maximum value of each sample point
    Med = median(testdata); %extracting median value of each sample point
    Sk = skewness(testdata); %extracting skewness value of each sample point
    Ku = kurtosis(testdata); %extracting kurtosis value of each sample point
    
    testdataset = [mu, St, Min, Max, Med, Sk, Ku]; % Final data set with considered features of each sample 
    distances = zeros(1,N);
    % Function for K-Nearest Neighbour
    for i = 1:size(testdataset,1)
        a = testdataset(i,:); % taking one row of test data at a time to calculate the distance with the training data
        for j = 1:length(traindata)
            b = traindata(j,:); % considering all the row values of training data to compare with the each row of testing data
            d = distanceCalculator(a,b); %calculating the distance
            distances(i,j) = d; %collecting all the distance calculation into a matrix 
        end
    end
    
    [s, ~] = size(distances);
    C = zeros(1,s);
    
    for p = 1:s
        q = distances(p,:); %considering one row at a time
        [~,index] = sort(q); %sorting each row in ascending order
        %near = nearest_distances(1:k); %getting the values of k-nearest neigbours
        I = index(1:k); %getting the index values of k-nearest neigbours
        C(p) = mode(trainclass(I)); % taking the most frequent class of the first k number row wise(observation wise) and assigned it as the predicted class
    end
    
    C = C'; %converting the final C row vector into column vector as it will be easy to calculate the accuracy against the test class data
end

function d = distanceCalculator(a,b)
% Calculates eculidean distance of two points in a row vector
    D = 0; % Initial distance value set to zero
  
    for i = 1:length(a)%going through all the element in both vectors
        D = D + (a(1,i) - b(1,i))^2; 
    end
    d = sqrt(D); %final distance value
end