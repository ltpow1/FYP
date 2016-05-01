function [P] = monic_poly(m,t)
%generates a monic polynomial of degree t over the field F 2^m
% left most element of P is coefficient of largest power (ie, 1, since
% polynomial is monic
% limited to polynomials of the form f(x) = x^t + a*x + b; fpr now
P = zeros(1,t+1);
P(1) = 1;
P(t) = randi([0,2^m-1],1);
P(t+1) = randi([0,2^m-1],1);
%code below is from when polynomials of arbitrary form were generated
% for i = 1:t
%     P(i+1) = randi([0,2^m-1],1);
% end
end