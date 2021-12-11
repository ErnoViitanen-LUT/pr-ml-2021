function data = datanormalization2d(data)
% DATANORMALIZATION2D(data) - normalize data with preserving a ratio
% between X and Y axis
% INPUT:
%     data - data to be normalized
% OUTPUT:
%     data - normalized data
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
        
        y_min = min(d(:,2)); %find minimum in x axis
        y_max = max(d(:,2)); %find maximum in x axis
        
        
        y_scale = y_max-y_min;
        x_scale = x_max-x_min; 
        ratio = y_scale/x_scale;
        avg_x = x_min + x_scale/2;
        avg_y = y_min + y_scale/2;
        
        %If ratio is greater than one it means that difference 
        %between y values is greater than difference between x values.
        %We will change x values to fit into y scale and then use min max scaling
        
        if(ratio>1) 
            scaled_x_min = avg_x - abs(y_scale/2);
            scaled_x_max = avg_x + abs(y_scale/2);
            d(:,1) = ((d(:,1)-scaled_x_min)/(scaled_x_max-scaled_x_min));
            d(:,2) = (d(:,2)-y_min)/y_scale; %normalization
        else
            scaled_y_min = avg_y - abs(x_scale/2);
            scaled_y_max = avg_y + abs(x_scale/2);
            d(:,1) = (d(:,1)-x_min)/(x_max-x_min); %normalization
            d(:,2) = (d(:,2)-scaled_y_min)/(scaled_y_max-scaled_y_min);
        end

        z_min = min(d(:,3)); %find minimum in x axis
        z_max = max(d(:,3)); %find maximum in x axis
        d(:,3) = (d(:,3)-z_min)/(z_max-z_min); %normalization

        [m,n]=size(d);
        data(i) = mat2cell(d,m,n); %convert matrix back to cell
    end
end