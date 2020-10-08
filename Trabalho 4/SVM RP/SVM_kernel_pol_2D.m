%% INIT

clc;
close;
clear;

%% HYPERPARAMETERS

% Ordem do Kernel polinomial
d = 4; 

% Parâmetro de regularização
C = 0.1;

%% GENERATE SAMPLES

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

%% GENERATE (NON LINEAR) QUADRATIC PROBLEM

% Cálculo do Kernel polinomial
K = (X.'*X + 1).^d;

% Formulação da programação quadrática
H = diag(y)*K*diag(y);
H = (H + H.')/2; % Forçar simetria exata
f = -ones(N,1);
A = -eye(N);
b = zeros(N,1);
Aeq = y.';
beq = 0;

lb = zeros(N,1);        % Minimum values for SV (Lagrange Multipliers)
ub = C*ones(N,1);       % Maximum values for SV (Lagrande Multipliers)
x0 = [];                % Dosen't indicate a initial value for alphas
opt = optimoptions(@quadprog,'Algorithm', ...
                       'interior-point-convex','Display','off');

%% CALCULATE LAGRANGE MULTIPLIERS AND BIAS
                   
% Chamada da função de otimização
alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,opt);

% Achar vetores suporte
vet_sup = find(alpha > 1e-6);

% Cálculo da constante b
b = 0;
for i = 1:length(vet_sup)
    b = b + 1/y(vet_sup(i));
    for j = 1:length(vet_sup)
          b = b - y(vet_sup(j))*alpha(vet_sup(j))*K(vet_sup(j),vet_sup(i));
    end
end
b = b/length(vet_sup);

%% ESTIMATION

% Estimated classes
aux = zeros(1,N);
for j = 1:length(vet_sup)
    aux = aux + y(vet_sup(j))*alpha(vet_sup(j))*K(vet_sup(j),:);
end
y_est = sign(aux+ b).';

% Error rate
error_rate = length(find(y~=y_est))/length(y);

%% GENERATE DECISION BOUNDARIES

% Generate matrix of test from 2D rectanguar grid
u = linspace(-2,2,100).';
U = [kron(u,ones(length(u),1)).'; kron(ones(length(u),1),u).'];

% Decision classes for the grid
Ku = (X(:,vet_sup).'*U + 1).^d;
aux = zeros(1,length(u)^2);
for j = 1:length(vet_sup)
    aux = aux + y(vet_sup(j))*alpha(vet_sup(j))*Ku(j,:);
end
y_est_grid = sign(aux+ b).';

% Plot decision regions at original space
for j = 1:length(u)
    for i = 1:length(u)
        if y_est_grid((j-1)*length(u) + i) == 1
            hold on,plot(u(j),u(i),'.k')
        else
             hold on,plot(u(j),u(i),'.g')
        end
    end
end

%% END