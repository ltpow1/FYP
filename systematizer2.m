% systematizer 2
% aim: use gaussian elimination to convert a parity check matrix H into
% systematic form [R, I], where I is the identity matrix.
% also need the permutation matrix P such that [R, I] = UHP.
clear; close all; clc;

t = 2;
m = 3;
[H, G, n, k,g,L] = goppagen(t,m);

[newH, cols] = systematizer(H);
newG = zeros(k,n);
newG(:,1:k) = eye(k);
newG(:,(k+1):n) = newH(:,1:k)';
