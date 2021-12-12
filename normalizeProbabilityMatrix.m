function C_normalized = normalizeProbabilityMatrix(C)
% normalizeProbabilityMatrix(C) - normalizes probability matrix to values from 0 to 1
% INPUT:
%     C - probability matrix
% OUTPUT:
%     C_normalized - normalized probability matrix
    
    p_min = min(C,[],1); %find digit with minimum pdf
    p_max = max(C,[],1); %find digit with maximum pdf
    C_normalized = (C-p_min)./(p_max-p_min); %normalization
end