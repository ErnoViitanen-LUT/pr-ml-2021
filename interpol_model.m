loadstrokes;
data = datanormalization2d(data);
class = class-1;
interpolating_model(data,class,0.7,3,300);
function [model, C, y_test, acc, acc_total] = interpolating_model(data,class,train_size,dim, intpol_num, seed)
    DEBUG=false;
    if ~exist('DEBUG', 'var') %checks if DEBUG variable exists, if not we assume DEBUG = false
        DEBUG = false;
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

    %calculating the sizes of training and testing data
    train_data_size = round(train_size*data_size);
    train_data = zeros(train_data_size,intpol_num,dim);
    train_class = zeros(1,train_data_size);
    test_data = zeros(data_size-train_data_size,intpol_num,dim);
    test_class = zeros(1,data_size - train_data_size);
    test_data_size = size(test_data,2);
    
    model = struct;
    
    
    for digit = 0:9 %for each digit
        num_dat = data(class==digit); %we take only data which we know belongs to certain digit
        N = length(num_dat); 
        N_train = round(N*train_size);
        N_test = N-N_train;
        [x_train, x_test, seed]=test_train_split(num_dat,train_size,seed);
        
        for i = 1:N_train
            x = linear_interpolation(cell2mat(x_train(i)),intpol_num);
            train_data(digit*N_train+i,:,:)=x;
        end
        
        train_class(digit*N_train+1:(digit+1)*N_train) = digit;
        
        %constructing classifier
        s = strcat("digit_",num2str(digit));
        m = mean(train_data(digit*N_train+1:(digit+1)*N_train,:,:));
        model.(s).mu = reshape(m,intpol_num,dim);
        c = reshape(train_data(digit*N_train+1:(digit+1)*N_train,:,:),N_train*intpol_num,dim);
        cov_mat = cov(c);
        model.(s).sigma = cov_mat;
        
        for i= 1:N_test
            x = linear_interpolation(cell2mat(x_test(i)),intpol_num);
            test_data(digit*N_test+i,:,:) = x;
        end
        
        test_class(digit*N_test+1:(digit+1)*N_test) = digit;
    end
    
    %testing training accuracy
    
    C = zeros(train_data_size,10,intpol_num);
    
    for i = 1:train_data_size
        x = reshape(train_data(i,:,:),intpol_num,dim);
        for digit = 0:9
            for j = 1:intpol_num
                s = strcat("digit_",num2str(digit));
                C(i,digit+1,j) = mvnpdf(x(j,:),model.(s).mu(j,:),model.(s).sigma);
            end
        end
    end
    
    C_sum = sum(C,3);
    [~,y_train] = max(C_sum,[],2)
    y_train = y_train - 1;%because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9
    y_train = y_train';
    acc_train = zeros(1,10);
    for i = 1:10 
        err = sum(y_train(train_class==i-1) ~= train_class(train_class==i-1)); % we compare our results with the expected values
        acc_train(i) = (train_data_size/10-err)/(train_data_size/10); % we compute the accuracy
    end
    err = sum(y_train ~= train_class); % we compare our results with the expected values
    acc_training_total = (train_data_size-err)/(train_data_size) % we compute the accuracy
    
    


% m_0 = mean(interpolated_data(1:100,:,:));
% m_1 = mean(interpolated_data(101:200,:,:));
% m_2 = mean(interpolated_data(201:300,:,:));
% m_3 = mean(interpolated_data(301:400,:,:));
% m_4 = mean(interpolated_data(401:500,:,:));
% m_5 = mean(interpolated_data(501:600,:,:));
% m_6 = mean(interpolated_data(601:700,:,:));
% m_7 = mean(interpolated_data(701:800,:,:));
% m_8 = mean(interpolated_data(801:900,:,:));
% m_9 = mean(interpolated_data(901:1000,:,:));
% c_0 = cov(reshape(interpolated_data(1:100,:,:),100000,3));
% 
% m_0 = reshape(m_0,I,3);
% m_1 = reshape(m_1,I,3);
% m_2 = reshape(m_2,I,3);
% m_3 = reshape(m_3,I,3);
% m_4 = reshape(m_4,I,3);
% m_5 = reshape(m_5,I,3);
% m_6 = reshape(m_6,I,3);
% m_7 = reshape(m_7,I,3);
% m_8 = reshape(m_8,I,3);
% m_9 = reshape(m_9,I,3);

% x2 = linear_interpolation(cell2mat(data(2)),1000);
% 
% 
% len = size(x2,1);
% p_0 = zeros(len,3);
% p_1 = zeros(len,3);
% p_2 = zeros(len,3);
% p_3 = zeros(len,3);
% p_4 = zeros(len,3);
% p_5 = zeros(len,3);
% p_6 = zeros(len,3);
% p_7 = zeros(len,3);
% p_8 = zeros(len,3);
% p_9 = zeros(len,3);
% 
% 
% plot3(m_1(:,1),m_1(:,2),m_1(:,3),'.')
% 
% c = x2(1,:);
% 
% for i = 1:len
%     p_0(i,:) = normpdf(x2(i,:),m_0(i,:),c_0);
%     p_1(i,:) = normpdf(x2(i,:),m_1(i,:),c);
%     p_2(i,:) = normpdf(x2(i,:),m_2(i,:),c);
%     p_3(i,:) = normpdf(x2(i,:),m_3(i,:),c);
%     p_4(i,:) = normpdf(x2(i,:),m_4(i,:),c);
%     p_5(i,:) = normpdf(x2(i,:),m_5(i,:),c);
%     p_6(i,:) = normpdf(x2(i,:),m_6(i,:),c);
%     p_7(i,:) = normpdf(x2(i,:),m_7(i,:),c);
%     p_8(i,:) = normpdf(x2(i,:),m_8(i,:),c);
%     p_9(i,:) = normpdf(x2(i,:),m_9(i,:),c);
%     
% end
% 
% sum(p_0)
% sum(p_1)
% sum(p_2)
% sum(p_3)
% sum(p_4)
% sum(p_5)
% sum(p_6)
% sum(p_7)
% sum(p_8)
% sum(p_9)

% len = size(x,1);
% p = zeros(1,len);
% p2 = zeros(1,len);
% for i = 1:len
%     c = cov(x2);
%     p(i) = mvnpdf(x2(i,:),x(i,:),c);
%     p2(i) = discriminant(x2(i,:)',x(i,:)',c);
% end
% p2
end