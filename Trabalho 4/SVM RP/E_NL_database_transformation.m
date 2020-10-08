clc
clear all
close all

% Número de amostras
N = 1000;

% Classe 1
r = rand(N/2,1);
theta = rand(N/2,1)*2*pi;
z = r.*exp(j*theta);
X1(1,:) = real(z);
X1(2,:) = imag(z);

% Classe 2
r = rand(N/2,1) + 1;
theta = rand(N/2,1)*2*pi;
z = r.*exp(j*theta);
X2(1,:) = real(z);
X2(2,:) = imag(z);

% Base de dados completa
X = [X1 X2];

% Gráfico de dispersão
figure,  plot(X1(1,:),X1(2,:),'b.')
hold on, plot(X2(1,:),X2(2,:),'r.')
grid on
axis([-3 3 -3 3])

% Teste de tranformações NL nos dados - 2D
% Y = X.^2;
% Y = X.^3;
% Y(1,:) = X(1,:).^2 + X(2,:).^2; Y(2,:) = zeros(N,1);
Y(1,:) = X(1,:).^2 + X(2,:).^2; Y(2,:) = X(2,:);

% Gráfico de dispersão
figure,  plot(Y(1,1:N/2),Y(2,1:N/2),'b.')
hold on, plot(Y(1,N/2+1:end),Y(2,N/2+1:end),'r.')
grid on


