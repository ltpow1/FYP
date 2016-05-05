function [H, colswaps] = systematizer(H)
% H = systematizer(H)
% convert the binary matrix H into systematic form

[numrows,numcols] = size(H);
colswaps = zeros(1,numcols);
H = gf(H);
numcolswaps = 0;
% the below is taken from a first course in coding theory, raymond hill
% n-k = number of rows in H
for j = 1:numrows
    % step 1
    if H(j,j) ~= 0
        % step 2
        H(j,:) = H(j,:)./H(j,j);
        
    else
        % step 1 continued
        swaprow = 0;
        i = j;
        while (i <= numrows)&&(swaprow ==0)
            i = i+1;
            if H(i,j) ~= 0
                temprow = H(i,:);
                H(i,:) = H(j,:);
                H(j,:) = temprow;
                swaprow = 1;
            end
        end
        if swaprow == 0
            h = 0;
            swapcol = 0;
            while (h <= numcols)&&(swapcol ==0)
                h = h+1;
                if H(j,h) ~= 0
                    tempcol = H(:,j);
                    H(:,j) = H(:,h);
                    H(:,h) = tempcol;
                    swapcol = 1;
                    numcolswaps = numcolswaps+1;
                    colswaps(numcolswaps,h) = 1;
                    colswaps(numcolswaps,j) = 1;
                end
            end
        end
        
    end
    
    % step 3
    for i = 1:numrows
        if i ~= j
            H(i,:) = H(i,:) - H(i,j)*H(j,:);
        end
    end
    
    
end

H = double(H.x);

end