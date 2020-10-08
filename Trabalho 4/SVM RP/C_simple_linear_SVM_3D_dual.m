clc
close all
clear all


% Number of samples
N = 500;

% Samples for class 1
X1 = [1; 1; 1]*ones(1,N/2) + diag([0.2 0.1 0.3])*randn(3,N/2);

% Samples for class 2
X2 = [1.5; -1; 0.5]*ones(1,N/2) + diag([0.1 0.5 0.2])*randn(3,N/2);

% All Samples
X = [X1 X2];

% Gráfico de dispersão
figure,  plot3(X1(1,:),X1(2,:),X1(3,:),'bd')
hold on, plot3(X2(1,:),X2(2,:),X2(3,:),'ro')
grid on
axis([-2 2 -2 2 -2 2])

% Vetor com as classes
y = [ones(N/2,1); -ones(N/2,1)];

% Formulação da programação quadrática
H = diag(y)*X.'*X*diag(y);
H = (H + H.')/2; % Forçar simetria exata
f = -ones(N,1);
A = -eye(N);
b = zeros(N,1);
Aeq = y.';
beq = 0;

% Chamada da função de otimização
alpha = quadprog(H,f,A,b,Aeq,beq);

% Cálculo do vetor de pesos
w = sum(X*diag(y)*diag(alpha),2);

% Achar vetores suporte
vet_sup = find(alpha > 1e-8);

% Cálculo da constante b
b = 0;
for ii = 1:length(vet_sup)
    b = b + 1/y(vet_sup(ii)) - w.'*X(:,vet_sup(ii));
end
b = b/length(vet_sup);

% Estimated classes
y_est = sign(w.'*X + b).';

% Error rate
error_rate = length(find(y~=y_est))/length(y)

% Plot separation plane
[x1 x2] = meshgrid(-2:1:2);
x3 = -w(1)/w(3)*x1 -w(2)/w(3)*x2 - b/w(3);
hold on,surf(x1,x2,x3);

% Plot margin planes
hold on,surf(x1,x2,x3-1/w(3));
hold on,surf(x1,x2,x3+1/w(3));



