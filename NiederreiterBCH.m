%NIEDERREITERBCH Niederreiter cryptosystem with BCH codes
%    Implementation of the Niederreiter public key cryptosystem based on
%    BCH codes.
%
%

clear; clc;
k = 5; % can also use T = bchnumerr(n) to find k for desired n
n = 15;
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

%%
seedbits = 16; % must be less than 32
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);

[S,Sinv] = Sgenerator(seed,2*m*t);

P = Pgenerator(seed,n);


Hhat = mod(S*H*P,2);

% public key is [Hhat, t]

%% encryption
message = zeros(1,n);
message(randperm(numel(message), randi([0 t]))) = 1; % generate random message of weight at most t
messagegf = gf(message);


cgf = Hhat*messagegf';
%% decryption

chat = Sinv*cgf;
% chat is the syndrome of the permuted message, Pm

[Pm,syndmatrix] = mybchdec(chat,n,m,t);

decodedm = P'*Pm;

%% results
all(message'==decodedm)