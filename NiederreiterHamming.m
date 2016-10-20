clear;close all; clc; rng('shuffle');
%NIEDERREITERHAMMING    Niederreiter cryptosystem based on Hamming codes
%    Implementation of the Niederreiter cryptosystem based on Hamming
%    codes, implemented using the hammgen and decode functions.
%    

[H, G, n, k] = hammgen(5);
Ggf = gf(G);
Hgf = gf(H);
t = 1; % maximum error correcting ability of code

seedbits = 10; % length of seed (in bits) max is 31
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);
%check that seed<2^(2n-4)

S = Sgenerator(seed,n-k);
Sgf = gf(S);

Sinvgf = inv(gf(S));

P = Pgenerator(seed,n);
Pgf = gf(P);

Hpub = Sgf*Hgf*Pgf;

% public key is [Hpub, t]

%% encryption
m = zeros(1,n);
m(randperm(numel(m), t)) = 1;
mgf = gf(m);

cgf = Hpub*mgf';

%% decryption

chat = Sinvgf*cgf;

trt = syndtable(H);

Pm = trt(1+bi2de(double(chat.x)','left-msb'),:);

decodedm = (Pgf'*gf(Pm'))';
%% results
all(m==decodedm)
