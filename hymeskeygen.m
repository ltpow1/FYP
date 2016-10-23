function [ Ghat,H,g,L ] = hymeskeygen( m,t )
%HYMESKEYGEN Generate public and private keys for HyMes
%

name = strcat('m=',num2str(m),'t=',num2str(t),'.mat');
if exist(name,'file') == 2
    % irred poly prepared earlier
    load(name)
    [H, n, k,g,L] = goppagen(t,m,g);
else
    [H, n, k,g,L] = goppagen(t,m);
end
[Hsys, Psys] = systematizer(H);
% if Psys is a non-identity matrix permutation, must recalculate H and L
if(all(all(Psys == eye(size(Psys))))==0)
    L = L*Psys;
    % should move below this line into a function call. genH or something
    H = goppargen(g,L);
end

Ghat = Hsys(:,1:k)'; %exclude the identity part of the matrix
end

