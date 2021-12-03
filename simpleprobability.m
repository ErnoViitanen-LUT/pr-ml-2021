function [startProbabilities,endProbabilities,sumProbabilities] = simpleprobability(simple,class)
    
    startDistributions = getDistributions(simple,1,class);
    endDistributions = getDistributions(simple,2,class);
    
    startProbabilities = startDistributions ./ (sum(startDistributions));
    endProbabilities = endDistributions ./ (sum(endDistributions));
    %startProbabilities = startDistributions ./ (sum(startDistributions) + sum(endDistributions))
    %endProbabilities = endDistributions ./ (sum(endDistributions) + sum(startDistributions))
    
    %startProbabilities(isnan(startProbabilities))=0;
    %endProbabilities(isnan(endProbabilities))=0;
    sumProbabilities = startProbabilities + endProbabilities
end

function distribution = getDistributions(data,row,class)
    % get point distributions in a 1-9 grid (starting from lower left)
    % data = stroke simplified data [start 1-9,end 1-9,intersections... 1-9]
    
    distribution = zeros(10,9); % assume 1-9 grid with 0-9 digits

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

