%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code for testing the goppa code generation, encoding and decoding without
% the scrambler and permutation matrices found in McEliece.


clear;close all; clc; rng('shuffle');
t = 3;
m = 4;
[H, G, n, k,g,L] = goppagen(t,m);
[hnew,pnew] = systematizer(H);
if(all(all(pnew == eye(size(pnew))))==0) %columns of H permuted, must appropriately permute L and recalculate H
    L = L*pnew;
    V = gf(zeros(t,n),m);
    D = gf(zeros(n),m);
    X = gf(zeros(t),m);
    
    for i = 1:n
        D(i,i) = 1./(polyval(g,L(i)));
    end
    
    for j = 1:t
        V(j,:) = L.^(j-1);
    end
    
    for i = 1:t
        X(i,:) = [fliplr(g(1:i)),zeros(1,t-i)];
    end
    
    tempH = X*V*D; % t by n matrix
    
    % now convert to binary form, mt by n
    % by expanding elements of H into binary column vectors
    
    binH = dec2bin(double(tempH.x))';
    
    for i = 1:n
        tempVec = [];
        for j = 1:t
            tempVec = [tempVec;binH(:,j+t*(i-1))];
        end
        newH(:,i) = tempVec;
    end
    
    H = double(newH)-48;
end
gnew = [eye(k),hnew(:,1:k)'];
G_gf = gf(gnew);
H_gf = gf(H);



message = randi([0 1],1,k); % generate random message of length k
message_gf = gf(message);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % generate random error of weight t
z_gf = gf(z);

c_gf = message_gf*G_gf+z_gf;

[z_hat] = patterson(c_gf,g,H,L,m);
codeword = message_gf*G_gf;
decoded_ciphertext = z_hat+c_gf;
% decoded_message = decoded_ciphertext/G;


% [~,ptry,pcol] = systematizer2(G');
% decoded_message = ptry*decoded_ciphertext';
% decoded_message = decoded_message2(1:k)';


decoded_message = decoded_ciphertext(1:k);
check = all(decoded_message == message_gf)