function [error,syndmatrix] = mybchdec(synd,n,m,t)


alpha = gf(2,m).*ones(1,n);
alpha = alpha.^(0:(n-1));
% convert sydrome from binary to gf(m)
syndarray = synd.x';
gfsynd = zeros(1,2*t);
for i = 1:(2*t)
    gfsynd(i) = bi2de(syndarray(((i-1)*m+1):(i*m)),'left-msb');
end
gfsynd = gf(gfsynd,m);
%trying out algorithm in table 8.4 of mceliece


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
%     detM = det(syndmatrix);
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