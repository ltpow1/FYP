%NIEDERREITER_BCH Niederreiter cryptosystem with BCH codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    BCH codes.
%
%

clear; clc;
k = 4; % can also use T = bchnumerr(n) to find k for desired n
n = 7;
m = log2(n+1);
t = bchnumerr(n,k); % maximum error correcting ability of code
messages = gf(eye(k));

G = gf(zeros(k,n));

for i = 1:k
    msg = messages(i,:);
    G(i,:) = bchenc(msg,n,k);
end
% G is now the systematic generator matrix of the bch code

H = gen2par(G.x);
H_gf = gf(H);
%% 
seed_bits = 16; % must be less than 32
seed_binary = randi([0 1],1,seed_bits);
seed = bi2de(seed_binary);

[S,S_inv] = S_generator(seed,n-k);
S_gf = gf(S);

S_inv_gf = gf(S_inv);

P = P_generator(seed,n);
P_gf = gf(P);

H_hat = S_gf*H_gf*P_gf;

% public key is [H_hat, t]

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
message_gf = gf(message);


c_gf = H_hat*message_gf';

%% decryption

c_hat = S_inv_gf*c_gf;


decoded_m = P'*gf(Pm);

%% results
all(message==decoded_m)