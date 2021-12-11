function C = knn_predict(trainclass,traindata,data,k)
% Function for K-Nearest Neighbour
for i = 1:size(data,1)
    a = data(i,:);% taking one row of test data at a time to calculate the distance with the training data
    for j = 1:length(traindata)
        b = traindata(j,:);% considering all the row values of training data to compare with the each row of testing data
        d = distanceCalculator(a,b); %calculating the distance
        dis(i,j) = d;%collecting all the distance calculation into a matrix (300*700 in our case)
    end
end

[s, t] = size(dis);

for p = 1:s
    q = dis(p,:);%considering one row at a time
    [nearest,index] = sort(q); %sorting each row in ascending order
    N = nearest(1:k); %getting the values of k-nearest neigbours
    I = index(1:k); %getting the index values of k-nearest neigbours
    C(p) = mode(trainclass(I));% taking the most frequent class of the first k number row wise(observation wise) and assigned it as the predicted class
end

C = C';%converting the final C row vector into cloumn vector as it will be easy to calculate the accuracy against the test class data
end

function d = distanceCalculator(a,b)
% Function to calculate the eculidean distance of two points in a row vector
    D = 0; % Initial distance value set to zero
  
    for i = 1:length(a)%going through all the element in both vectors
        D = D + (a(1,i) - b(1,i))^2; 
    end
    d = sqrt(D);%final distance value
 end