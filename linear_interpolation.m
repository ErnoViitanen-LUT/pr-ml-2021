function interpolated_data = linear_interpolation(data,N)
% LINEAR_INTERPOLATION interpolated_data = f(data,N)
% input:
% data - matrix of points to interpolate
% N - number of points between X_i and X_i+1 for all points in data
% interpolated_data - modified matrix of points bigger N-1 times the original
% matrix
[data_length,data_width] = size(data);
interpolated_data = zeros(data_length*(N-1),data_width);
for i = 1:data_length-1
    for j = 1:data_width
        c = linspace(data(i,j),data(i+1,j),N+1);%generate N+1 points
        interpolated_data((i-1)*N+1:i*N,j)=c(1:N); %take N first of them
    end
end
end