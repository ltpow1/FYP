%NIEDERREITERBCH Niederreiter cryptosystem with BCH codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    BCH codes.
%
%

clear; clc;
m = 5;
t = 2; 

n = 2^(m)-1;
k = n-m*t;

[ Hpub, S, Sinv, P ] = nibchkeygen( m,t );
%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t

[ c ] = niencrypt(Hpub, message);
%% decryption
[ decodedm ] = nibchdecrypt( c,Sinv,P,m,t);
%% results
all(message'==decodedm)