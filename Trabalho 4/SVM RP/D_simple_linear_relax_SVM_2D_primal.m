clc
% close all
clear all


% Number of samples
N = 1000;

%  Parameter C
C = 1000;

% Samples for class 1
X1 = [1; 1]*ones(1,N/2) + diag([0.2 0.1])*randn(2,N/2)*2;

% Samples for class 2
X2 = [1.5; -1]*ones(1,N/2) + diag([0.1 0.5])*randn(2,N/2)*2;

% All Samples
X = [X1 X2];

% Gráfico de dispersão
figure,  plot(X1(1,:),X1(2,:),'bd')
hold on, plot(X2(1,:),X2(2,:),'ro')
grid on
axis([-2 2 -2 2])

% Vetor com as classes
y = [ones(N/2,1); -ones(N/2,1)];

% Formulação da programação quadrática
H = zeros(N+3);
H(1:2,1:2) = eye(2);
f = [zeros(3,1); C*ones(N,1)];
A1(1,:) = y.'.*X(1,:);
A1(2,:) = y.'.*X(2,:);
A1(3,:) = y.';
A1 = -A1.';
A1 = [A1 -eye(N)];
b1 = -ones(N,1);
A2 = -eye(N+3);
A2(1:3,1:3) = zeros(3);
b2 = zeros(N+3,1);
A = [A1; A2];
b = [b1; b2]; 

% Chamada da função de otimização
wb = quadprog(H,f,A,b);
w = wb(1:2);
b = wb(3);

% Estimated classes
y_est = sign(w.'*X + b).';

% Error rate
error_rate = length(find(y~=y_est))/length(y)

% Plot separation line
x1 = linspace(-2,2,20);
x2 = -w(1)/w(2)*x1 - b/w(2);
hold on,plot(x1,x2);

% Plot margin lines
hold on,plot(x1,x2-1/w(2));
hold on,plot(x1,x2+1/w(2));

