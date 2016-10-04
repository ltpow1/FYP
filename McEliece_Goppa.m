%MCELIECE_GOPPA McEliece cryptosystem with Goppa codes
%    Implementation of the McEliece public key cryptosystem based on binary
%    Goppa codes.
%
%
%

clear;close all; clc; rng('shuffle');

t = 5;
m = 6;
n = 2^m;
k = n-m*t;
%check that params are valid
if k <1
    disp('invalid parameters')
else

    [G_hat,g,L,S_inv,P,H] = mceliecekeygen(m,t);
    % public key is [G_hat, t]
    % private key is [g,L,S_inv,P
    H = gf(H);
    %% encryption
    message = randi([0 1],1,k); % generate random message of length k 
    z = zeros(1,n);
    z(randperm(numel(z), t)) = 1; % generate random error of weight t
    
    c = mod(message*G_hat+z,2);
    
    %% decryption
    
    c_hat = gf(mod(c*P',2));
    [z_hat] = patterson(c_hat,g,H,L,m);
    
    decoded_ciphertext = z_hat+c_hat;
    
    mS = decoded_ciphertext(1:k);
    decoded_message = mS*S_inv;
    
    check = all(decoded_message == message)
end

%% attack
p = 2;
l = floor(k/2);
attack = stern(G_hat,c,t,p,l);
sterncheck = all(attack == z)