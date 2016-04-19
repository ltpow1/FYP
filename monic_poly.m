function [P] = monic_poly(m,t)
%generates a monic polynomial of degree t over the field F 2^m
% left most element of P is coefficient of largest power (ie, 1, since
% polynomial is monic
P = ones(1,t+1);

for i = 1:t
    P(i+1) = randi([0,2^m-1],1);
end
end