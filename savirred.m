% generate and save some irreducible polynomials
clear
clc
m = 10;
t = 71;
% note, if t is prime, calculation is MUCH faster

g = rabin(m,t);

mstr = num2str(m);
tstr = num2str(t);
filename = strcat('m=',mstr,'t=',tstr,'.mat');
save(filename,'g')