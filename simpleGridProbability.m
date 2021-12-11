function model = simpleGridProbability(simple,class)
    
    
    model.startDistributions = getDistributions(simple,1,class);
    model.endDistributions = getDistributions(simple,2,class);
    model.emptyDistributions = getEmptyDistributions(simple(3:end,:),class);        
    model.startProbabilities = model.startDistributions ./ (sum(model.startDistributions));
    model.endProbabilities = model.endDistributions ./ (sum(model.endDistributions));    
    model.emptyProbabilities = model.emptyDistributions ./ (sum(model.emptyDistributions));

end

function distribution = getEmptyDistributions(data,class)
    distribution = zeros(9,10); % assume 1-9 grid with 0-9 digits       
    for digit=1:10
        digit_data = data(:,class==digit);

        [numRows,numCols] = size(digit_data);
        for col=1:numCols            
            for row=1:numRows
                empty_digit = digit_data(row,col);
                if any(empty_digit)
                    distribution(empty_digit,digit) = distribution(empty_digit,digit) + 1;                    
                end

            end
        end       
    end
end

function distribution = getDistributions(data,row,class)
    % get point distributions in a 1-9 grid (starting from lower left)
    % data = stroke simplified data [start 1-9,end 1-9,intersections... 1-9]
    
    distribution = zeros(9,10); % assume 1-9 grid with 0-9 digits
    numRows = size(data,1);
    %numCols = size(data,2);
    
    for i=1:numRows
        % get occurences for each stroke start/end position and class        
        [counts,centers]=hist(data(row,class == i),unique(data(row, class == i)));        
        % create distribution matrix 
        % [10x9] -> [1-10,1-9] -> [number,gridpos]      
        % [3,7]: number 3 distribution to start/end in gridpos 7
        if centers
            for j=1:size(centers,2)
                % 0-9 -> 1-10
                k = centers(j);
                %fprintf(i + " " + k + "j"+ j +". ")
                distribution(k,i) = counts(j);            
            end
        end
    end    
end

