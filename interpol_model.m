loadstrokes;
data = datanormalization2d(data);
class = class-1;
[model, C, y_test, acc, acc_total] = interpolating_model(data,class,0.7,3,300);
function [model, C, y_test, acc, acc_total] = interpolating_model(data,class,train_size,dim, intpol_num, seed)
    DEBUG=true;
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
    if(DEBUG==true)
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
        [~,y_train] = max(C_sum,[],2);
        y_train = y_train - 1;%because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9
        y_train = y_train';
        acc_train = zeros(1,10);
        for i = 1:10 
            err = sum(y_train(train_class==i-1) ~= train_class(train_class==i-1)); % we compare our results with the expected values
            acc_train(i) = (train_data_size/10-err)/(train_data_size/10); % we compute the accuracy
        end
        acc_train
        err = sum(y_train ~= train_class); % we compare our results with the expected values
        acc_training_total = (train_data_size-err)/(train_data_size) % we compute the accuracy
        
    end
    %testing
    
    C = zeros(test_data_size,10,intpol_num);
    
    for i = 1:test_data_size
        x = reshape(test_data(i,:,:),intpol_num,dim);
        for digit = 0:9
            for j = 1:intpol_num
                s = strcat("digit_",num2str(digit));
                C(i,digit+1,j) = mvnpdf(x(j,:),model.(s).mu(j,:),model.(s).sigma);
            end
        end
    end
    
    C_sum = sum(C,3);
    [~,y_test] = max(C_sum,[],2)
    y_test = y_test - 1;%because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9
    y_test = y_test';
    acc = zeros(1,10);
    for i = 1:10 
        err = sum(y_test(test_class==i-1) ~= test_class(test_class==i-1)); % we compare our results with the expected values
        acc(i) = (test_data_size/10-err)/(test_data_size/10); % we compute the accuracy
    end
    err = sum(y_test ~= test_class); % we compare our results with the expected values
    acc_total = (test_data_size-err)/(test_data_size) % we compute the accuracy
    if(DEBUG==true)
        figure
        confusion = confusionmat(test_class,y_test); %we compute the confusion matrix
        confusionchart(confusion)
        title('Interpolated model')
    end  
end