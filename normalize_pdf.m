function C_normalized = normalize_pdf(C)
    p_min = min(C,[],1); %find digit with minimum pdf
    p_max = max(C,[],1); %find digit with maximum pdf
    C_normalized = (C-p_min)./(p_max-p_min); %normalization
end