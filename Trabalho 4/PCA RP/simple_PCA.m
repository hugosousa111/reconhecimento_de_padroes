clc
close all
clear all

% Samples for class 1
X1 = [4,2;2,4;2,3;3,6;4,4].';

% Samples for class 2
X2 = [9,10;6,8;9,5;8,7;10,8].';

% All data in one class
X = [X1 X2];

% Removing the mean
u = mean(X,2);
Xm = X - u;

% Gr�fico de dispers�o
plot(X(1,:),X(2,:),'rd'),grid on
axis([-10 10 -10 10])

figure, plot(Xm(1,:),Xm(2,:),'bd'),grid on
axis([-10 10 -10 10])

% Covariance matrices
Rx = cov(Xm.');

% Eigendecomposition 
[V,D] = eig(Rx)

% Vetor de proje��o �timo
w = V(:,2);

% Reta passando pelo vetor de proje��o
x = -20:0.01:20;
g = w(2)/w(1)*x;

% Gr�fico de dispers�o
hold on, plot(x,g,'k-')

% Amostras projetadas
y = w.'*Xm;
y2 = V.'*Xm;

% % Amostras projetadas em formato vetorial (no subespa�o original)
% y2 = y*exp(sqrt(-1)*atan(w(2)/w(1)));
% 
% % Gr�fico de dispers�o
% hold on, plot(y2,'r.')
figure, plot(real(y),imag(y),'ro')
hold on, plot(y2(2,:),y2(1,:),'ko')
grid on
axis([-10 10 -10 10])
