%MCELIECEBCH McEliece cryptosystem with BCH codes
%    Implementation of the McEliece public key cryptosystem based on BCH
%    codes.
%

clear; clc;
m = 5;
t = 2; % maximum error correcting ability of code
n = 2^m-1;
k = n-t*m; % can also use T = bchnumerr(n) to find k for desired n

[ Ghat,S,Sinv,P ] = mcbchgen( n,k );
% public key is [Ghat, t]
%% encryption
message = randi([0 1],1,k); % generate random message of length k

c = mcencrypt(message,Ghat,t);
%% decryption
[ decodedm] = mcbchdecrypt(c,P,Sinv,n,k);
%% results
all(message==decodedm)