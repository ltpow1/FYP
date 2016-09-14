%NIEDERREITER_BCH Niederreiter cryptosystem with BCH codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    BCH codes.
%
%

clear; clc;
k = 10; % can also use T = bchnumerr(n) to find k for desired n
n = 511;
m = log2(n+1);
t = bchnumerr(n,k); % maximum error correcting ability of code

% making parity check matrix
alpha = gf(2,m).*ones(1,n);
alpha = alpha.^(0:(n-1));
H = gf(zeros(2*t,n),m);
for i = 1:(2*t)
    H(i,:) = alpha.^i;
end
% now convert H into binary form
binH = dec2bin(double(H.x))';

for i = 1:n
    tempVec = [];
    for j = 1:(2*t)
        tempVec = [tempVec;binH(:,j+2*t*(i-1))];
    end
    newH(:,i) = tempVec;
end

H = double(newH)-48;
H = gf(H);
%%
seed_bits = 16; % must be less than 32
seed_binary = randi([0 1],1,seed_bits);
seed = bi2de(seed_binary);

[S,S_inv] = S_generator(seed,2*m*t);
S_gf = gf(S);

S_inv_gf = gf(S_inv);

P = P_generator(seed,n);
P_gf = gf(P);

H_hat = S_gf*H*P_gf;

% public key is [H_hat, t]

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
message_gf = gf(message);


c_gf = H_hat*message_gf';
%% decryption

c_hat = S_inv_gf*c_gf;
% c_hat is the syndrome of the permuted message, Pm

[Pm,synd_matrix] = mybchdec(c_hat,n,m,t);

decoded_m = P'*Pm;

%% results
all(message'==decoded_m)