function [H, P] = systematizer(H)
% H = systematizer(H)
% convert the binary matrix H into systematic form

[numrows,numcols] = size(H);
H = gf(H);
P = eye(numcols); % column permutation matrix (see biswas)
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
                    P(:,[j,h]) = P(:,[h,j]);
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
H = [H(:,(numrows+1):numcols),H(:,1:(numrows))];
P = [P(:,(numrows+1):numcols), P(:,1:numrows)];
end