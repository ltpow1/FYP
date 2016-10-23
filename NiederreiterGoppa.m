%MIEDERREITERGOPPA Niederreiter cryptosystem with Goppa codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    binary Goppa codes.
%    
%
%
clear;close all; clc; rng('shuffle');
% parameters
t = 53;
m = 10;
n = 2^m;
k = n-m*t;

%key generation
[Hpub,S,Sinv,P,H,g,L] = nikeygen(m,t);
%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
messagegf = gf(message);

[ cgf ] = niencrypt(Hpub, messagegf);
%% decryption
[ decodedm ] = nidecrypt( cgf,Sinv,P,g,L,H,m);
%% results
check = all(decodedm == message')