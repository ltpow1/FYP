%MCELIECE_BCH McEliece cryptosystem with BCH codes
%    Implementation of the McEliece public key cryptosystem based on BCH
%    codes.
%
%

clear; clc;
m = 10;
t = 5; % maximum error correcting ability of code
n = 2^m-1;
k = n-t*m; % can also use T = bchnumerr(n) to find k for desired n
messages = gf(eye(k));

polyG = gf(zeros(k,n));

po = bchgenpoly(n,k);
for i = 1:k
    msg = messages(i,:);
    polyG(i,:) = conv(msg,po);
end

[G,~,~] = systematizer2(double(polyG.x),1);

% oldG = gf(zeros(k,n));
% for i = 1:k
%     msg = messages(i,:);
%     oldG(i,:) = bchenc(msg,n,k);
% end

%% 
seed_bits = 16; % must be less than 32
seed_binary = randi([0 1],1,seed_bits);
seed = bi2de(seed_binary);

[S,S_inv] = S_generator(seed,k);


P = P_generator(seed,n);


G_hat = mod(S*G*P,2);

% public key is [G_hat, t]

%% encryption
message = randi([0 1],1,k); % generate random message of length k
message = gf(message);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % random error of weight t
z = gf(z);

c = message*G_hat+z;

%% decryption

c_hat = c*P';
mS = bchdec(c_hat, n,k);

decoded_m = mS*S_inv;

%% results
all(message==decoded_m)