%MCELIECEGOPPA McEliece cryptosystem with Goppa codes
%    Implementation of the McEliece public key cryptosystem based on binary
%    Goppa codes.
%

clear;close all; clc; rng('shuffle');
t = 53;
m = 11;
n = 2^m;
k = n-m*t;
%check that params are valid
if k <1
    disp('invalid parameters')
else

    [Ghat,g,L,Sinv,P,H] = mckeygen(m,t);
    % public key is [Ghat, t]
    % private key is [g,L,Sinv,P]
    %% encryption
    message = randi([0 1],1,k); % generate random message of length k 
    
    c = mcencrypt(message,Ghat,t);
    
    %% decryption
    [ decodedmessage, z] = mcdecrypt(c,P,Sinv,g,H,L,m,k);
    
    check = all(decodedmessage == message)
end
%% attack
% p = 1;
% l = floor(k/2);
% attack = stern(Ghat,c,t,p,l);
% sterncheck = all(attack == z)