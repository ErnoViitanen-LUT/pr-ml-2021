function [model, C, y_test] = augmented_model(data,class,train_size,dim, seed)
% AUGMENTEDSTATISTICALMODEL(data, class, train_size, dim, seed)
%     DEBUG=true;
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
    
    if(train_size<=0 || train_size>=1)
        error("Train size must be a value from (0,1>");
    end
    
    if(DEBUG==true)
        close all; % if debug is true, close all figures generated in the previous run
    end
    
    
    %calculating the sizes of training and testing data
    train_data_size = round(train_size*data_size);
    train_data = zeros(dim,train_data_size);
    %if train size is different from 1 it means we want to also test the model
    test_data = zeros(dim,data_size-train_data_size);
    test_class = zeros(1,data_size - train_data_size);
    [~,test_data_size] = size(test_data);
    
    for digit = 0:9 %for each digit
        num_dat = data(class==digit); %we take only data which we know belongs to certain digit
        N = length(num_dat); 
        N_train = round(N*train_size);
        N_test = N-N_train;
        [x_train, x_test, seed]=test_train_split(num_dat,train_size,seed); %we split our data into training and testing
        % Training data %
        if(DEBUG==true)
            figure
        end
        for i = 1:N_train
            x = cell2mat(num_dat(i)); %we convert our data from cell to matrix
            if(isempty(x))
                train_data(:,digit*N_train+i)=NaN(1,dim);
                continue;
            end
            avg = mean(x(:,1:dim)); % and we compute the mean of our data
            [avg_m, avg_n] = size(avg);
            if(avg_n < dim)
                train_data(:,digit*N_train+i)=x(:,1:dim);
                continue;
            end
            if(DEBUG==true)
                if(dim==2)
                    plot(avg(1),avg(2),'k.'); hold on
                elseif(dim==3)
                    plot3(avg(1),avg(2),avg(3),'k.'); hold on
                end
            end
            train_data(:,digit*N_train+i)=avg; % we assign the mean to our training dataset
        end
        if(DEBUG==true)
            title(strcat(num2str(digit),'\_train'))
            axis([0,1,0,1]);
%             saveas(gcf,strcat(num2str(digit),'_train.png')); %uncomment this if you want to save the results as a png file
            hold off;
        end
        % Testing data %
        if(DEBUG==true)
            figure
        end
        for i = 1:N_test
            x = cell2mat(num_dat(N_train+i)); %we convert the cell into matrix
            if(isempty(x))
                test_data(:,digit*N_train+i)=NaN(1,dim);
                continue;
            end
            avg = mean(x(:,1:dim)); %once more we compute the mean
            [avg_m, avg_n] = size(avg);
            if(avg_n < dim)
                test_data(:,digit*N_train+i)=x(:,1:dim);
                continue;
            end
            if(DEBUG==true)
                if(dim==2)
                    plot(avg(1),avg(2),'k.'); hold on
                elseif(dim==3)
                    plot3(avg(1),avg(2),avg(3),'k.'); hold on
                end
            end
            test_data(:,digit*N_test+i)=avg; % we assign the mean to the testing data
            test_class(:,digit*N_test+i) = digit; %we add information about the class
        end
        if(DEBUG==true)
            title(strcat(num2str(digit),'\_test'))
            axis([0,1,0,1]);
%             saveas(gcf,strcat(num2str(digit),'_test.png'));
            hold off;
        end
    end
    
    %Computing bayesian classifiers models%
    model = bayesian_classifiers();
    
    
    %Checking test data 

    C = zeros(10,test_data_size);
    for j=1:test_data_size
        for k=0:9
            s = strcat("digit_",num2str(k));
%             C(k+1,j) = discriminant_function(test_data(:,j), model.(s).mu,model.(s).sigma)
            try
                C(k+1,j) =  mvnpdf(test_data(:,j),model.(s).mu,model.(s).sigma); %we calculate the density function for test data with each model
            catch ME
                C(k+1,j) = 0;
            end
        end
    end
    [~,y_test] = max(C,[],1); %we choose the class which has the biggest value
    y_test = y_test - 1; %because argmax would be from 1 to 10 we subtract 1 to go back to 0 to 9
    error = sum(y_test ~= test_class); % we compare our results with the expected values
    acc = (test_data_size-error)/(test_data_size) % we compute the accuracy
    confusion = confusionmat(test_class,y_test) %we compute the confusion matrix
    confusionchart(confusion)
    
    function model = bayesian_classifiers
        % For each digit we compute the sigmas and mus
        for digit = 0:9
            s = strcat("digit_",num2str(digit));
            model.(s).mu = mean(train_data(:,digit*N_train+1:(digit+1)*N_train),2);
            cov_mat = cov(train_data(:,digit*N_train+1:(digit+1)*N_train)','includenan');
            cov_mat(cov_mat<0)=0;
            model.(s).sigma = cov_mat;
        end
    end
end
