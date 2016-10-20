%MCELIECEBCH McEliece cryptosystem with BCH codes
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
seedbits = 16; % must be less than 32
seedbinary = randi([0 1],1,seedbits);
seed = bi2de(seedbinary);

[S,Sinv] = Sgenerator(seed,k);


P = Pgenerator(seed,n);


Ghat = mod(S*G*P,2);

% public key is [Ghat, t]

%% encryption
message = randi([0 1],1,k); % generate random message of length k
message = gf(message);

z = zeros(1,n);
z(randperm(numel(z), t)) = 1; % random error of weight t
z = gf(z);

c = message*Ghat+z;

%% decryption

chat = c*P';
mS = bchdec(chat, n,k);

decodedm = mS*Sinv;

%% results
all(message==decodedm)