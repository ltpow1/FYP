% plot results of runtimes
close all

m = [10,11];
n = 2.^(m);
t = [13,29,53,71];

load('finaltimes.mat')

% times(m,t,system)
%system order = mc, ni, hyme
%   keygen, enc, dec

%plot keygen times
figure
plot(t,times(1,:,1),'r*',t,times(1,:,4),'b*',t,times(1,:,7),'k*')
title('Public and Private key generation run-times with n = 1024')
legend('McEliece','Niederreiter','HyMes', 'Location','NorthWest')
xlabel('t')
ylabel('run-time (s)')

figure
plot(t,times(2,:,1),'r*',t,times(2,:,4),'b*',t,times(2,:,7),'k*')
title('Public and Private key generation run-times with n = 2048')
legend('McEliece','Niederreiter','HyMes', 'Location','NorthWest')
xlabel('t')
ylabel('run-time (s)')

% plot decryption times

figure
plot(t,times(1,:,3),'r*',t,times(1,:,6),'b*',t,times(1,:,9),'k*')
title('Decryption run-times with n = 1024')
legend('McEliece','Niederreiter','HyMes', 'Location','NorthWest')
xlabel('t')
ylabel('run-time (s)')

figure
plot(t,times(2,:,3),'r*',t,times(2,:,6),'b*',t,times(2,:,9),'k*')
title('Decryption run-times with n = 2048')
legend('McEliece','Niederreiter','HyMes', 'Location','NorthWest')
xlabel('t')
ylabel('run-time (s)')