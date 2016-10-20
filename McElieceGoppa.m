%MCELIECEGOPPA McEliece cryptosystem with Goppa codes
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

    [Ghat,g,L,Sinv,P,H] = mceliecekeygen(m,t);
    % public key is [Ghat, t]
    % private key is [g,L,Sinv,P]
    H = gf(H);
    %% encryption
    message = randi([0 1],1,k); % generate random message of length k 
    z = zeros(1,n);
    z(randperm(numel(z), t)) = 1; % generate random error of weight t
    
    c = mod(message*Ghat+z,2);
    
    %% decryption
    
    chat = gf(mod(c*P',2));
    [zhat] = patterson(chat,g,H,L,m);
    
    decodedciphertext = zhat+chat;
    
    mS = decodedciphertext(1:k);
    decodedmessage = mS*Sinv;
    
    check = all(decodedmessage == message)
end

%% attack
p = 2;
l = floor(k/2);
attack = stern(Ghat,c,t,p,l);
sterncheck = all(attack == z)