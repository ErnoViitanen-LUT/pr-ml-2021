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
    end
    if data_len > 0
        for(i = 1:data_len)
            d = cell2mat(data(i)); %convert cell to matrix
            d = normalizeData(d);
            %d = normalize(d,'range');
            [m,n]=size(d);
            data(i) = mat2cell(d,m,n); %convert matrix back to cell
        end
    else
        d = data;
        data = normalize(d,'range');
        %[m,n]=size(d);
        %data = mat2cell(d,m,n); %convert matrix back to cell
    end
    
end
function d = normalizeData(d)
    for i=1:size(d,2)
        x_min = min(d(:,i)); %find minimum in x axis
        x_max = max(d(:,i)); %find maximum in x axis
        d(:,i) = (d(:,i)-x_min)/(x_max-x_min); %normalization
    end    
end