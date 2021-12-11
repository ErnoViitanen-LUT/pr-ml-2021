function interpolated_data = linear_interpolation(data,N)
% LINEAR_INTERPOLATION(data,N)
% INPUT:
%     data - matrix of points to interpolate
%     N - number of total points in the interpolated output
% OUTPUT:
%     interpolated_data - interpolated data matrix

[data_length,data_width] = size(data);
interpolated_data = zeros(N,data_width);

i = 1;
step = floor(N/(data_length-1));
while(N>0)
    while(mod(i,data_length-1) ~= 0) % For first N-2 points interpolate with a step
        for j = 1:data_width
            try
                c =linspace(data(i,j),data(i+1,j),step+1);
                interpolated_data((i-1)*step+1:i*step,j)=c(1:step);
            catch ME
                disp(ME)  
            end
        end
        N = N - step;
        i = i+1;
    end
    step2 = N; % For last interpolation, interpolate to make sure finally matrix contains N numbers
    for j = 1:data_width
        try
            c =linspace(data(i,j),data(i+1,j),step2);
            interpolated_data((i-1)*step+1:end,j)=c;
        catch ME
            disp(ME)
        end
    end
    N = N-step2;
end
end