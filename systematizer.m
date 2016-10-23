function [H, P] = systematizer(H)
%SYSTEMATIZER Returns systematic form of H
%    Convert the binary parity check matrix H into systematic form. P is a
%    permutation matrix documenting the column swaps required to obtain the
%    systematic form.
%
%    Primary Reference: "A first course in coding theory" Raymond Hill

[numrows,numcols] = size(H);
P = eye(numcols); % column permutation matrix

% n-k = number of rows in H
for j = (numcols-numrows+1):numcols
    % step 1 note: step 2 not required, since G is binary
    if H(j-(numcols-numrows),j) == 0
        % step 1
        swaprow = 0;
        i = j-(numcols-numrows);
        while (i < numrows)&&(swaprow ==0) %check all rows below row
            i = i+1;
            if H(i,j) ~= 0 %swap rows if true
                temprow = H(i,:);
                H(i,:) = H(j-(numcols-numrows),:);
                H(j-(numcols-numrows),:) = temprow;
                swaprow = 1;
            end
        end
        if swaprow == 0
            h = 0;
            swapcol = 0;
            while (h < numcols)&&(swapcol ==0)
                h = h+1;
                if H(j-(numcols-numrows),h) ~= 0
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
    checkCol = H(:,j);
    checkCol(j-(numcols-numrows)) = 0;
    checkEye = diag(checkCol);
    H = mod(H + checkEye*repmat(H(j-(numcols-numrows),:),[numrows,1]),2);  
end
end