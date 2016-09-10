function message = mybchdec(synd,n,k,m)


alph = gf(2,m);

t = bchnumerr(n,k);
a0 = zeros(1,2*t+1);
a0(1) = 1;

% convert syndrome into gf(m)
synd_array = synd.x;
%convert synd from GF(2) to GF(2^m)
for i = 1:t
    gfsynd(i) = bi2de(synd_array(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);


end