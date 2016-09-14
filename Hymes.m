%HYMES Hybrid McEliece cryptosystem with Goppa codes
%    Implementation of the Hybrid McEliece public key cryptosystem based on
%    binary Goppa codes.
%    
%
%

clear;close all; clc; rng('shuffle');

t = 3;
m = 5;

[H, G, n, k,g,L] = goppagen(t,m);
[Hsys, Psys] = systematizer(H);
Gsys = [eye(k),Hsys(:,1:k)'];
% if Psys is a non-identity matrix permutation, must recalculate H and L
if(all(all(Psys == eye(size(Psys))))==0)
    L = L*Psys;
    % should move below this line into a function call. genH or something
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

G_gf = gf(Gsys);
H_gf = gf(H);

G_hat = G_gf(:,(k+1):n); %exclude the identity part of the matrix

% public key is [G_hat, t]

%% encryption
message = randi([0 1],1,k); % generate random message of length k
message_gf = gf(message);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % generate random error of weight t
z_gf = gf(z);

c_gf = [message_gf,message_gf*G_hat]+z_gf;

%% decryption


[z_hat] = patterson(c_gf,g,H_gf,L,m);

decoded_ciphertext = z_hat+c_gf;


% mS = decoded_ciphertext/G;
% decoded_message = mS*S_inv;

% [~,ptry,pcol] = systematizer2(G');
% mS = ptry*decoded_ciphertext';
% mS = mS2(1:k)';
% decoded_message = mS*S_inv;

decoded_message = decoded_ciphertext(1:k);

check = all(decoded_message == message_gf)
