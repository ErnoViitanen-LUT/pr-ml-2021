function data = datanormalization(data)
    if ~exist('DEBUG', 'var')
        DEBUG = false;
    end
    if ~exist('data','var')
        error("No data for normalization found")
    end
    [M,N]=size(data);
    data_len = 0;
    if(M==1)
        data_len=N;
    elseif(N==1)
        data_len=M;
    else
        error("Data needs to be 1xN cell vector")
    end
    for(i = 1:data_len)
        d = cell2mat(data(i)); %convert cell to matrix
        x_min = min(d(:,1)); %find minimum in x axis
        x_max = max(d(:,1)); %find maximum in x axis
        d(:,1) = (d(:,1)-x_min)/(x_max-x_min); %normalization
        
        y_min = min(d(:,2)); %find minimum in x axis
        y_max = max(d(:,2)); %find maximum in x axis
        d(:,2) = (d(:,2)-y_min)/(y_max-y_min); %normalization
        
        z_min = min(d(:,3)); %find minimum in x axis
        z_max = max(d(:,3)); %find maximum in x axis
        d(:,3) = (d(:,3)-z_min)/(z_max-z_min); %normalization
        [m,n]=size(d);
        data(i) = mat2cell(d,m,n); %convert matrix back to cell
    end
end