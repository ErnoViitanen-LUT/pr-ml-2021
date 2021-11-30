function [model, C_sum, y_test, acc, acc_total] = spliting_model(data,class,k,train_size,dim,seed)
% AUGMENTEDSTATISTICALMODEL(data, class, train_size, dim, seed)
DEBUG=true;
if ~exist('DEBUG', 'var') %checks if DEBUG variable exists, if not we assume DEBUG = false
    DEBUG = false;
end
if ~exist('k', 'var') % by default our model works for 2x2 square
    k = 2;
end
if ~exist('train_size', 'var')
    train_size = 0.7;
end
if ~exist('dim', 'var') % by default our model works for 2d, data 
    dim = 2;
end
if ~exist('seed', 'var')
    seed = rng;
end
[M,N] = size(data);
data_size = 0;
if(M==1)
    data_size=N;
elseif(N==1)
    data_size=M;
else
    error("Input data need to be a 1xN vector");
end
if(dim~=2 && dim~=3)
    error("Model works with 2D and 3D data only");
end

if(train_size<=0 || train_size>1)
    error("Train size must be a value from (0,1)");
end

% if(DEBUG==true)
% %     close all; % if debug is true, close all figures generated in the previous run
% end

divided_data = cell(k,k,data_size);
train_data_size = round(train_size*data_size);
test_data_size = data_size-train_data_size;
test_class = zeros(1,test_data_size);
C_total = zeros(k^2, 10, test_data_size);
y_total = zeros(k^2, test_data_size);

for i = 1:data_size
    divided_data(:,:,i) = hyperplane_division(data(i),k);
end
seed = rng;
for i = 1:k
    for j = 1:k
        [model, C, y, acc,acc_total]=augmented_model(divided_data(i,j,:),class, train_size,2, seed);
        C_total(2*(i-1)+j,:,:) = C.*(acc'.*acc_total); 
        y_total(2*(i-1)+j,:) = y; 
    end
end
C_sum = sum(C_total,1);

[~,y_test] = max(C_sum,[],2); %we choose the class which has the biggest value
y_test = reshape(y_test,[1,test_data_size]);
y_test = y_test - 1; %because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9

for digit = 0:9
    test_class(:,(digit)*(test_data_size/10)+1:(digit+1)*(test_data_size/10))=digit;
end

acc = zeros(1,10);
for i = 1:10 
    err = sum(y_test(test_class==i-1) ~= test_class(test_class==i-1)); % we compare our results with the expected values
    acc(i) = (test_data_size/10-err)/(test_data_size/10); % we compute the accuracy
end
err = sum(y_test ~= test_class); % we compare our results with the expected values
acc_total = (test_data_size-err)/(test_data_size) % we compute the accuracy
if(DEBUG == true)
    figure
    confusion = confusionmat(test_class,y_test); %we compute the confusion matrix
    confusionchart(confusion)
    title('Spliting')
end