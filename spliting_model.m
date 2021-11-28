k = 2;
train_size = 0.5;

data_size = size(data,2);
divided_data = cell(k,k,data_size);
train_data_size = round(train_size*data_size);
test_data_size = data_size-train_data_size;
test_class = zeros(1,test_data_size);
C_total = zeros(k^2, 10, test_data_size);
y_total = zeros(k^2, test_data_size);

for i = [1:data_size]
    divided_data(:,:,i) = hyperplane_division(data(i),k);
end
rng shuffle
seed = rng;
for i = [1:k]
    for j = [1:k]
        [model, C, y]=augmented_model(divided_data(i,j,:),class, train_size,2, seed);
        C_total(2*(i-1)+j,:,:) = C; 
        y_total(2*(i-1)+j,:) = y; 
    end
end
close all;
C_sum = sum(C_total,1);

[~,y_test] = max(C_sum,[],2); %we choose the class which has the biggest value
y_test = reshape(y_test,[1,test_data_size]);
y_test = y_test - 1; %because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9

for digit = [0:9]
    test_class(:,(digit)*(test_data_size/10)+1:(digit+1)*(test_data_size/10))=digit;
end

error = sum(y_test ~= test_class); % we compare our results with the expected values
acc = (test_data_size-error)/(test_data_size) % we compute the accuracy
confusion = confusionmat(test_class,y_test) %we compute the confusion matrix
confusionchart(confusion)

% subplot(2,2,3)
% x = cell2mat(divided(1))
% plot(x(:,1),x(:,2),'k.')
% subplot(2,2,4)
% x = cell2mat(divided(2))
% plot(x(:,1),x(:,2),'k.')
% subplot(2,2,1)
% x = cell2mat(divided(3))
% plot(x(:,1),x(:,2),'k.')
% subplot(2,2,2)
% x = cell2mat(divided(4))
% plot(x(:,1),x(:,2),'k.')

