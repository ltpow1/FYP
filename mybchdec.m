function [error] = mybchdec(synd,n,m,t)
%MYBCHDEC error = mybchdec(synd,n,m,t)
%   Uses the PGZ algorithm to find the error associated with the syndrome
%   synd of the bch code with parameters n and t.
%

alpha = gf(2,m).*ones(1,n); %define primitive of the finite field
alpha = alpha.^(0:(n-1));
% convert sydrome from binary to gf(m)
syndarray = synd.x';
gfsynd = zeros(1,2*t);
for i = 1:(2*t)
    gfsynd(i) = bi2de(syndarray(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);

% use peterson-gorenstein-zierler algorithm to find error locator
% polynomial sigma
v = t+1;
detM = 0;
while (detM == 0)&&(v>0)
    v = v-1;
    syndmatrix = gf(zeros(v),m);
    for i = 1:v
        syndmatrix(i,:) = gfsynd(i:(i+v-1));
    end
    detM = rank(syndmatrix)==length(syndmatrix);
end

error = gf(zeros(n,1));
if v>0 % if v=0, there are no errors
    Svector = -gfsynd((v+1):(2*v))';
    Lvector = syndmatrix\Svector;
    % Lvector is the error locating polynomial coefficients in column form
    sigma = [Lvector',1];
    sigmaroots = roots(sigma);
    errorlocations = sigmaroots.^(-1);
    
    if any(errorlocations)
        for i = 1:length(errorlocations)
            errorindex(i) = find(alpha == errorlocations(i));
        end
        for j = 1:length(errorindex)
            error(errorindex(j)) = 1;
        end
    end
end
end