%MCELIECEHAMMING McEliece cryptosystem with Hamming codes
%    Implementation of the McEliece public key cryptosystem based on
%    Hamming codes.
%
%

clear;close all; clc;

[H, G, n, k] = hammgen(3);
Ggf = gf(G);
Hgf = gf(H);
t = 1; % maximum error correcting ability of code
seedbits = 16; % must be less than 32
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);
[S,Sinv] = Sgenerator(seed,k);
Sgf = gf(S);
Sinvgf = gf(Sinv);
P = Pgenerator(seed,n);
Pgf = gf(P);
Ghat = Sgf*Ggf*Pgf;
% public key is [Ghat, t]
%% encryption
m = randi([0 1],1,k); % generate random message of length k
mgf = gf(m);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % random error of weight t
zgf = gf(z);

cgf = mgf*Ghat+zgf;

%% decryption
chat = cgf*P';
mS = decode(double(chat.x), n,k,'hamming');

decodedm = gf(mS)*Sinvgf;
%% results
m==decodedm