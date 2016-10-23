function [G,Pcol,Prow] = systematizer2(G,allowcolswaps)
%SYSTEMATIZER Returns systematic form of G
%    Convert the binary generator matrix G into systematic form. Pcol is a
%    permutation matrix documenting the column swaps required to obtain the
%    systematic form. 
%
%    Primary Reference: "A first course in coding theory" Raymond Hill

[numrows,numcols] = size(G);
Pcol = eye(numcols);
Prow = eye(numrows);

% n-k = number of rows in H
for j = 1:min([numrows,numcols])
    % step 1 note: step 2 not required, since G is binary
    if G(j,j) == 0
        % step 1
        swaprow = 0;
        i = j;
        while (i < numrows)&&(swaprow ==0) %check all rows below row j
            i = i+1;
            if G(i,j) ~= 0 %swap rows if true
                temprow = G(i,:);
                G(i,:) = G(j,:);
                G(j,:) = temprow;
                swaprow = 1;
                Prow([i,j],:) = Prow([j,i],:);
            end
        end
        if (swaprow == 0)&&(allowcolswaps)
            h = 0;
            swapcol = 0;
            while (h < numcols)&&(swapcol ==0)
                h = h+1;
                if G(j,h) ~= 0
                    tempcol = G(:,j);
                    G(:,j) = G(:,h);
                    G(:,h) = tempcol;
                    swapcol = 1;
                    Pcol(:,[j,h]) = Pcol(:,[h,j]);
                end
            end
        end
        
    end
    
    % step 3
    checkCol = G(:,j);
    checkCol(j) = 0;
    checkEye = diag(checkCol);
    G = mod(G + checkEye*repmat(G(j,:),[numrows,1]),2);

end

end