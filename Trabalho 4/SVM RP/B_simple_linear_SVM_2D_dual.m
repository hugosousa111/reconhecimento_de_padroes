clc
close all
clear all


% Number of samples
N = 500;

% Samples for class 1
X1 = [1; 1]*ones(1,N/2) + diag([0.2 0.1])*randn(2,N/2);

% Samples for class 2
X2 = [1.5; -1]*ones(1,N/2) + diag([0.1 0.5])*randn(2,N/2);

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
vet_sup = find(alpha > 1e-6);

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

% Plot separation line
x1 = linspace(-2,2,20);
x2 = -w(1)/w(2)*x1 - b/w(2);
hold on,plot(x1,x2);

% Plot margin lines
hold on,plot(x1,x2-1/w(2));
hold on,plot(x1,x2+1/w(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Generation of Decision Regions %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generate matrix of test from 2D rectanguar grid
% pode fazer usando a função meshgrid
u = linspace(-2,2,100).';
U = [kron(u,ones(length(u),1)).'; kron(ones(length(u),1),u).'];

% Decision classes for the grid
y_est_grid = sign(w.'*U + b).';

% Plot decision regions at original space
for ii = 1:length(u)
    for jj = 1:length(u)
        if y_est_grid((ii-1)*length(u) + jj) == 1
            hold on,plot(u(ii),u(jj),'.k')
        else
             hold on,plot(u(ii),u(jj),'.g')
        end
    end
end









