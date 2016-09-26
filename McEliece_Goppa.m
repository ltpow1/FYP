%MCELIECE_GOPPA McEliece cryptosystem with Goppa codes
%    Implementation of the McEliece public key cryptosystem based on binary
%    Goppa codes.
%
%
%

clear;close all; clc; rng('shuffle');

t = 7;
m = 6;
k = 2^m-m*t;
%check that params are valid
if k <1
    disp('invalid parameters')
else
    name = strcat('m=',num2str(m),'t=',num2str(t),'.mat');
    if exist(name,'file') == 2 
        % irred poly prepared earlier
        load(name)
    [H, n, k,g,L] = goppagen(t,m,g);
    else
        [H, n, k,g,L] = goppagen(t,m);
    end
    [Hsys, Psys] = systematizer(H);
    Gsys = [eye(k),Hsys(:,1:k)'];
    % if Psys is a non-identity matrix permutation, must recalculate H and L
    if(all(all(Psys == eye(size(Psys))))==0)
        L = L*Psys;
        H = goppargen(g,L);
    end
    
    G_gf = gf(Gsys);
    H_gf = gf(H);
    
    seed_bits = 16; % must be less than 32
    seed_binary = randi([0 1],1,seed_bits);
    seed = bi2de(seed_binary);
    
    [S,S_inv] = S_generator(seed,k);

    
    P = P_generator(seed,n);

    
    G_hat = mod(S*Gsys*P,2);
    
    % public key is [G_hat, t]
    
    %% encryption
    message = randi([0 1],1,k); % generate random message of length k
    message_gf = gf(message);
    
    z = zeros(1,n);
    z(randperm(numel(z), t)) = 1; % generate random error of weight t
    z_gf = gf(z);
    
    c_gf = message_gf*G_hat+z_gf;
    
    %% decryption
    
    c_hat = c_gf*P';
    [z_hat] = patterson(c_hat,g,H_gf,L,m);
    
    decoded_ciphertext = z_hat+c_hat;
    ciphertext = message_gf*S*Gsys;
    
    % mS = decoded_ciphertext/G;
    % decoded_message = mS*S_inv;
    
    % [~,ptry,pcol] = systematizer2(G');
    % mS = ptry*decoded_ciphertext';
    % mS = mS2(1:k)';
    % decoded_message = mS*S_inv;
    
    mS = decoded_ciphertext(1:k);
    decoded_message = mS*S_inv;
    
    check = all(decoded_message == message_gf)
end
