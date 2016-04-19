% new goppa tester/generator
clear; close all; clc;

m = 3;
n = 2^m;
t = 2;

% g = rand_irred_poly(m,t);

% L = randperm(n)-1;
L = 0:(n-1);
L = gf(L,m);
% first, do example from textbook
g = gf([1 1 1],m);

% % engelbert parity check
% x = gf(zeros(t),m);
% y = gf(zeros(t,n),m);
% z = gf(zeros(n),m);
% 
% for i = 1:t
%     x(i,1:i) = g((t+1-i):t);
%     y(i,:) = L.^(i-1);
% end
% 
% for i = 1:n
%     z(i,i) = 1./polyval(g,L(i));
% end
% H = x*y*z;
% 
% newH = double(H.x);
% newHbin = dec2bin(newH)';
% 
% for i = 2:2:2*n
%     lastH(:,i/2) = [newHbin(1:m,i-1);newHbin(1:m,i)];
% end

% generate parity check matrix
H = zeros(t,n);
H = gf(H,m);

for i = 1:t
    H(i,:) = (L.^(i-1))./polyval(g,L);
end
newH = double(H.x);
newHbin = dec2bin(newH)';

for i = 2:2:2*n
    lastH(:,i/2) = [newHbin(1:m,i-1);newHbin(1:m,i)];
end

h = double(lastH)-48;

% generator = gen2par([eye(n-t)]);

lastH = gf(double(lastH)-48,1);
word_length = n-m*t;

m = randi([0 1],1,word_length); % generate random message of length k
m_gf = gf(m);

bookH = [1,1,0,0,0,0,0,0;0,0,0,1,0,1,1,1;0,0,1,1,1,0,0,1;0,1,1,1,1,1,1,1;0,0,1,0,1,1,0,1;0,0,0,1,1,1,1,0];

vec1 = gf([0,0,0,0,0,0,0,0],1);
vec2 = gf([0,0,1,1,1,1,1,1],1);
vec3 = gf([1,1,0,0,1,0,1,1],1);
vec4 = gf([1,1,1,1,0,1,0,0],1);














