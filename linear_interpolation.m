function interpolated_data = linear_interpolation(data,N)
% LINEAR_INTERPOLATION interpolated_data = f(data,N)
% input:
% data - matrix of points to interpolate
% N - number of total points in the interpolated output

[data_length,data_width] = size(data);
interpolated_data = zeros(N,data_width);

i = 1;
step = floor(N/(data_length-1));
while(N>0)
    while(mod(i,data_length-1) ~= 0)
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
    step2 = N;
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