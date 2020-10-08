close all
clear all
clc

N = 2;
M = 1;
ns = 30;
A = randn(N,M);
s = randn(M,ns);
v = randn(N,ns);
noise_var = 0.02;
x = A*s + v*sqrt(noise_var);
x2 = A*s;
figure,plot(x(1,:),x(2,:),'bd')
hold on,plot(x2(1,:),x2(2,:),'rd')

Rx = cov(x.');
[Q,D] = eig(Rx);
Q2 = Q(:,N-M+1:end);
y_pca = Q2.'*x;
% hold on,plot(x_pca(1,:),x_pca(2,:),'k.')
x_pca = Q2*y_pca;
hold on,plot(x_pca(1,:),x_pca(2,:),'kd')

mean(mean(abs(x - x2).^2))
mean(mean(abs(x_pca - x2).^2))