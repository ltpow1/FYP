function codeword = stern(G_hat,y,w,p,l)
%STERN Applies Stern's Attack
%    Stern's algorithm takes a generator matrix G_hat and a codeword with
%    added error, y, and finds the error of weight w. p and l are
%    parameters controlling the runtime and probability of success of the
%    algorithm.
%
%    Primary Reference: "A method for finding codewords of small weight"
%    Stern


% testing sterns algorithm. see roering and engelbert
%first, generate a gopppa code for testing
n = length(y);
k = size(G_hat,1);

G = [G_hat;y];%append y to G to form new code
kstern = k+1;

% now find parity check matrix of new G
[Gsys,P1,~] = systematizer2(G,1);
Hstern = gen2par(Gsys);

iter = 0;
max_iter = 200;
codeword = zeros(1,n);
while (iter<max_iter)&&(~any(codeword))
    iter = iter+1;
    %now select n-k random columns of G and row reduce the resulting matrix
    % so permute n-k chosen columns to left for systematization, then undo
    % permutation
    A = eye(n);
    singular = 1;
    %%
    while singular == 1
        cols = randperm(n);
        % need to check that the columns are linearly independent, ie, that
        % systematization works on them
        %produce permutation matrix to move the chosen columns to the left
        Pcols = A(:,cols);
        Hreduce = Hstern*Pcols;
        
        %attempt to row reduce
        [Hsys,~,~] = systematizer2(Hreduce,0);
        
        %check result
        if all(Hsys(:,1:(n-kstern)) == eye(n-kstern))
            singular = 0;
        end
    end
    % now permute H back to normal
    Hstern2 = Hsys*Pcols';
    % now divide the remaing k columns into two subsets x and y
    % each remaining element has probability of 0.5 of being in subset x or y
    xchoose = rand([1,kstern])<0.5;
    %ensure at least one col for x and y each
    xchoose(1:2) = [1,0];
    remaining_cols = cols((n-kstern+1):n);
    
    xsubset = remaining_cols(xchoose);
    ysubset = remaining_cols(~xchoose);
    
    % now randomly select l rows
    L = randperm(n-kstern,l);
    
    % for every size p subset of cols of X compute sum of columns, call it piA
    Asubsets = logical(all_poss(length(xsubset)-p,p,length(xsubset)-p));
    numsubs = size(Asubsets);
    piA = zeros(l,numsubs(1));
    for i = 1:numsubs(1)
        piA(:,i) = mod(sum(Hstern2(L,xsubset(Asubsets(i,:))),2),2);
    end
    
    % same for y piB
    Bsubsets = logical(all_poss(length(ysubset)-p,p,length(ysubset)-p));
    numsubs2 = size(Bsubsets);
    piB = zeros(l,numsubs2(1));
    for i = 1:numsubs2(1)
        piB(:,i) = mod(sum(Hstern2(L,ysubset(Bsubsets(i,:))),2),2);
    end
    
    %for every piA==piB compute sum of all columns of A and B
    for i = 1:numsubs(1)
        for j = 1:numsubs2(1)
            collision = all(piA(:,i)==piB(:,j));
            if collision
                newsum = mod(sum(Hstern2(:,[xsubset(Asubsets(i,:)),ysubset(Bsubsets(j,:))]),2),2);
                % if the above vector has weiht w-2p, can form code word
                if sum(newsum)==(w-2*p)
                    % calculate codeword
                    codeword = zeros(1,n);
                    codeword([xsubset(Asubsets(i,:)),ysubset(Bsubsets(j,:))]) = 1;
                    codeword(cols(logical(newsum))) = 1;
                    codeword = codeword*P1';
                    return
                end
            end
        end
    end
    
end

end



