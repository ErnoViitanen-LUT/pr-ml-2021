augmentedstatisticalmodel(data,class,0.7,2);
function augmentedstatisticalmodel(data,class,train_size,dim)
% AUGMENTEDSTATISTICALMODEL
DEBUG=true;
    if ~exist('DEBUG', 'var')
        DEBUG = false;
    end
    if ~exist('train_size', 'var')
        train_size = 0.7;
    end
    if ~exist('dim', 'var')
        dim = 2;
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
    
    train_data_size = round(train_size*data_size);
    train_data = zeros(dim,train_data_size);
    test_data = zeros(dim,data_size-train_data_size);
    test_class = zeros(1,data_size - train_data_size);
    [~,test_data_size] = size(test_data);
    for digit = 0:9
        num_dat = data(class==digit);
        N = length(num_dat);
        N_train = round(N*train_size);
        N_test = N-N_train;
        [x_train, x_test, seed]=test_train_split(num_dat,train_size);
        
        % Training data %
        if(DEBUG==true)
            close all;
            figure
        end
        for i = 1:N_train
            x = cell2mat(num_dat(i));
            avg = mean(x(:,1:dim));
            if(DEBUG==true)
                if(dim==2)
                    plot(avg(1),avg(2),'k.'); hold on
                elseif(dim==3)
                    plot3(avg(1),avg(2),avg(3),'k.'); hold on
                end
            end
            train_data(:,digit*N_train+i)=avg;
        end
        if(DEBUG==true)
            title(strcat(num2str(digit),'\_train'))
            axis([0,1,0,1]);
%             saveas(gcf,strcat(num2str(digit),'_train.png'));
        end
        hold off;
        % Testing data %
        if(DEBUG==true)
            figure
        end
        for i = 1:N_test
            x = cell2mat(num_dat(N_train+i));
            avg = mean(x(:,1:dim));
            if(DEBUG==true)
                if(dim==2)
                    plot(avg(1),avg(2),'k.'); hold on
                elseif(dim==3)
                    plot3(avg(1),avg(2),avg(3),'k.'); hold on
                end
            end
            test_data(:,digit*N_test+i)=avg;
            test_class(:,digit*N_test+i) = digit;
        end
        if(DEBUG==true)
            title(strcat(num2str(digit),'\_test'))
            axis([0,1,0,1]);
%             saveas(gcf,strcat(num2str(digit),'_test.png'));
        end
        hold off;
    end
    
    %Computing bayesian classifiers models%
    model = bayesian_classifiers()
    
    %Checking test data 
    C = zeros(10,test_data_size);
    for j=1:test_data_size
        for k=0:9
            s = strcat("digit_",num2str(k));
            C(k+1,j) =  mvnpdf(test_data(:,j),model.(s).mu,model.(s).sigma);
        end
    end
    [~,y_test] = max(C,[],1);
    y_test = y_test - 1;
    error = sum(y_test ~= test_class);
    acc = (test_data_size-error)/(test_data_size)
    C = confusionmat(test_class,y_test)
    confusionchart(C)
    
    
    function model = bayesian_classifiers
        for digit = 0:9
            s = strcat("digit_",num2str(digit));
            model.(s).mu = mean(train_data(:,digit*N_train+1:(digit+1)*N_train),2);
            model.(s).sigma = cov(train_data(:,digit*N_train+1:(digit+1)*N_train)');
        end
    end
end
