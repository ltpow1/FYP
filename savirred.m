% generate and save some irreducible polynomials
clear
clc
m = 11;
t = 97;
% note, if t is prime, calculation is MUCH faster

g = benor(m,t);

mstr = num2str(m);
tstr = num2str(t);
filename = strcat('m=',mstr,'t=',tstr,'.mat');
save(filename,'g')