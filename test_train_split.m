function[x_train, x_test, seed]=test_train_split(data,train_size, seed)
    % TEST_TRAIN_SPLIT Function divides a dataset of one class into
    % training set and testing set using random permutation from a given
    % seed, if there is no seed in function input new seed is created
    [M,N] = size(data);
    data_size = 0;
    if(M==1)
        data_size=N;
    elseif(N==1)
        data_size=M;
    else
        error("Input data need to be a 1xN vector");
    end
    if(train_size<=0 || train_size>=1)
        error("Train size must be a value between 0 and 1")
    end
    if ~exist('seed', 'var')
        seed = rng;
    end
    rng(seed) %set random number generator to seed
    permutation = randperm(data_size);
    perm_ind = round(train_size*data_size);
    x_train = data(permutation(1:perm_ind));
    x_test = data(permutation(perm_ind+1:end));
end