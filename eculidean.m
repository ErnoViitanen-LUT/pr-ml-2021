myFolder = 'F:\Business Analytics\1st Period\Pattern Recognition and Machine Learning\Assignment\digits_3d\training_data'; % Define your working folder
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.mat');
matFiles = dir(filePattern);
for k = 1:length(matFiles)
  baseFileName = matFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  
  fprintf(1, 'Now reading %s\n', fullFileName);
  matData(k) = load(fullFileName);
end



%% Features (mu,Std,Min,Max,Median,Skewness,Kurtosis)
n = 1000;

for i = 1:n
    mu = mean(matData(i).pos)%extracting mean value of each sample point
    X(i,:)= mu;
    St = std(matData(i).pos)%extracting Standard deviation value of each sample point
    Y(i,:)= St;
    Min = min(matData(i).pos)%extracting minimum value of each sample point
    W(i,:)= Min;
    Max = max(matData(i).pos)%extracting maximum value of each sample point
    Z(i,:)= Max;
    Med = median(matData(i).pos)%extracting median value of each sample point
    V(i,:)= Med
    Sk = skewness(matData(i).pos)%extracting skewness value of each sample point
    U(i,:) = Sk
    Ku = kurtosis(matData(i).pos)%extracting kurtosis value of each sample point
    K(i,:) = Ku
    
end

Data = [X, Y, W, Z, V, U, K] % Final data set with considered features of each sample 


Cat = [1 2 3 4 5 6 7 8 9 10]';%number of classes
class = (repelem(Cat,100))';%generating the class vector
nor_data12 = normalize(Data)
data22 = [nor_data12(:,:)';class] %normalized dataset with the class details


data = data22';

%% Dividing the data
N = 1000;
[e,q] = size(data);
Per = 0.7; %splitting percentage
Tr = round(Per * e);%amount of data to be trained to the closest integer
Tn = N - Tr; % number of testing observations
Ind = randperm(N); % randomizing the order of sample points
trainD = data(Ind(1:Tr),1:21); %training data
trainC = data(Ind(1:Tr),22); %classes of training data
testD = data(Ind(Tr+1:end),1:21); %test data
testC = data(Ind(Tr+1:end),22); %classes of testing data


%% Checking the accuracy for different number of K levels
k = 2:15;

for i = 1:k
    C = knn(trainC,trainD,testD,i)
    accuracy(i) = sum(C==testC)/length(testC)
    c = confusionmat(testC, C);
    figure
    confusionchart(c)
    title(sprintf('k = %d', k));
end

%% Function for K-Nearest Neighbour

function C = knn(trainclass,traindata,data,k)

for i = 1:length(data)
    a = data(i,:);% taking one row of test data at a time to calculate the distance with the training data
    for j = 1:length(traindata)
        b = traindata(j,:);% considering all the row values of training data to compare with the each row of testing data
        d = distanceCalculator(a,b); %calculating the distance
        dis(i,j) = d;%collecting all the distance calculation into a matrix (300*700 in our case)
    end
end

[s, t] = size(dis)

for p = 1:s
    q = dis(p,:);%considering one row at a time
    [nearest,index] = sort(q); %sorting each row in ascending order
    N = nearest(1:k); %getting the values of k-nearest neigbours
    I = index(1:k); %getting the index values of k-nearest neigbours
    C(p) = mode(trainclass(I));% taking the most frequent class of the first k number row wise(observation wise) and assigned it as the predicted class
end

C = C'%converting the final C row vector into cloumn vector as it will be easy to calculate the accuracy against the test class data
end

%% Function to calculate the eculidean distance of two points in a row vector
 function d = distanceCalculator(a,b)
    D = 0; % Initial distance value set to zero
  
    for i = 1:length(a)%going through all the element in both vectors
        D = D + (a(1,i) - b(1,i))^2 
    end
    d = sqrt(D)%final distance value
 end

