% Goppa Encoding and decoding test using yi hongs suggested goppa polynomial
clear; close all; clc;
t = 2;
m = 3;
n = 2^m;
alpha = gf(2,m);
beta = gf(1,m);

g = gf([1,zeros(1,t-2),alpha,beta],m);

L = gf(zeros(1,n),m);
L(2) = gf(1,m);
for i = 3:n
    L(i) = alpha^(i-2);
end

% using formula on wikipedia

V = gf(zeros(t+1,n),m);
D = gf(zeros(n),m);

for i = 1:n
    D(i,i) = 1./(polyval(g,L(i)));
end

for j = 1:(t+1)
    V(j,:) = L.^(j-1);
end


H = V*D; % t by n matrix

% now convert to binary form, mt by n

binH = dec2bin(double(H.x))';


for i = 1:n
    tempVec = [];
    for j = 1:(t+1)
        tempVec = [tempVec;binH(:,j+(t+1)*(i-1))];
    end
    newH(:,i) = tempVec;
end

tempH = double(newH)-48;
nullspace = null2(tempH);
G = nullspace';
% parity check matrix will not be full rank, and hence will
% be a bit larger thanthe standard (n-k)xn

% now convert parity check matrix into systematic form
sysH = newH;
% algorithm: ensure ith row has ith element = 1, then make sure all elements
% below in column are zero. if ith row does not have 1, swap with first row
% that does
% for row = 1:size(sysH,1)
%     condition = 0;
%     if (sysH(row,row)==0)
%         count = row+1;
%         while condition == 0
%             if (sysH(count,row)==1)
%                 tempRow = sysH(row,:);
%                 sysH(row,:) = sysH(count,:);
%                 sysH(count,:) = tempRow;
%                 condition = 1;
%             end
%             count = count+1;
%         end
%     end
%     % row has ith element = 1, now clear elements below
%     if(row<size(H,1))
%         for j = (row+1):size(sysH,1)
%             if(sysH(j,row)==1)
%                 sysH(j,:) = sysH(j,:)+sysH(row,:);
%             end
%         end
%     end
%     % now clear elements above
%     if(row>1)
%         for j = 1:(row-1)
%             if(sysH(j,row)==1)
%                 sysH(j,:) = sysH(j,:)+sysH(row,:);
%             end
%         end
%     end
% end


% binary gaussian elimination algorithm from paper
% for j = 1:size(tempH,1)
%     % search for A(i,j) = 1 in column j
%     ind = find(tempH(:,j));
%     if any(ind)
%         for k = 1:size(tempH,1)
%             tempH(ind, k) = 1;
%            tempH(:,k) = mod(tempH(:,k)+tempH(:,j),2);
%         end
%     end
% end
% 







