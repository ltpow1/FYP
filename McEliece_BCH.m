%MCELIECE_BCH McEliece cryptosystem with BCH codes
%    Implementation of the McEliece public key cryptosystem based on BCH
%    codes.
%
%

clear; clc;
k = 241;
n = 511;
t = bchnumerr(n,k); % maximum error correcting ability of code
messages = gf(eye(k));

G = gf(zeros(k,n));

for i = 1:k
    msg = messages(i,:);
    G(i,:) = bchenc(msg,n,k);
end
% G is now the systematic generator matrix of the bch code

H = [G(:,(k+1):n)',gf(eye(n-k))];
%% 
seed_bits = 16;
seed_binary = randi([0 1],1,seed_bits);
seed = bi2de(seed_binary);

[S,S_inv] = S_generator(seed,k);
S_gf = gf(S);

S_inv_gf = gf(S_inv);

P = P_generator(seed,n);
P_gf = gf(P);

G_hat = S_gf*G*P_gf;

% public key is G_hat, t

%% encryption
m = randi([0 1],1,k); % generate random message of length k
m_gf = gf(m);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % random error of weight t
z_gf = gf(z);

c_gf = m_gf*G_hat+z_gf;

%% decryption

c_hat = c_gf*P';
mS = bchdec(c_hat, n,k);

decoded_m = gf(mS)*S_inv_gf;

%% results
all(m==decoded_m)