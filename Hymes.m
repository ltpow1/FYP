%HYMES Hybrid McEliece cryptosystem with Goppa codes
%    Implementation of the Hybrid McEliece public key cryptosystem based on
%    binary Goppa codes.
%    

clear;close all; clc; rng('shuffle');

t = 3;
m = 5;
n = 2^m;
k = n-m*t;

[ Ghat,H,g,L ] = hymeskeygen( m,t );
% public key is [Ghat, t]
%% encryption
message = randi([0 1],1,k); % generate random message of length k
messagegf = gf(message);

[ cgf ] = hymesencrypt( messagegf,Ghat,n,t );
%% decryption
[decodedmessage ] = hymesdecrypt( cgf,g,L,H,m,k );
check = all(decodedmessage == messagegf)