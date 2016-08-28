%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code for testing the goppa code generation, encoding and decoding without
% the scrambler and permutation matrices found in McEliece.


clear;close all; clc; rng('shuffle');
t = 2;
m = 4;
[H, G, n, k,g,L] = goppagen(t,m);
G_gf = gf(G);
H_gf = gf(H);



message = randi([0 1],1,k) % generate random message of length k
message_gf = gf(message);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1 % generate random error of weight t
z_gf = gf(z);

c_gf = message_gf*G_gf+z_gf;

[m_hat, z_hat] = patterson(c_gf,g,G,H,L,m);


m_hat == message_gf