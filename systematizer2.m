function [G, Prow,Pcol] = systematizer2(G)
%SYSTEMATIZER Returns systematic form of H
%    Convert the binary parity check matrix H into systematic form.
%    P is a permutation matrix documenting the column swaps required to obtain
%    the systematic form. Note this is an altered version of the algorithm
%    from Hill to be used with parity check matrices.
%
%    Primary Reference: "A first course in coding theory" Raymond Hill

[numrows,numcols] = size(G);
G = gf(G);
Prow = gf(eye(numrows));
Pcol = gf(eye(numcols)); % column permutation matrix (see biswas)

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
                Prow([j,i],:) = Prow([i,j],:);
            end
        end
        if swaprow == 0
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
    for i = 1:numrows
        if (i ~= j)&&(G(i,j)==1)
            G(i,:) = G(i,:) + G(j,:);
            Prow(i,:) = Prow(i,:) + Prow(j,:);
        end
    end
end

end