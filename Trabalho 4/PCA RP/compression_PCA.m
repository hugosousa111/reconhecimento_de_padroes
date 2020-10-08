close all
clear all
% clc

% Numer of samples
ns = 150;

% Treshold for eigenvalues of PCA
rth = 0.8;

% Generating database of binary 8x8 images
I = zeros(8,8,ns);
for i = 1:ns
    ix = randi([2,7],1,1);
    iy = randi([2,7],1,1);
    I(ix-1:ix+1,iy-1:iy+1,i) = ones(3);
    I_vec(:,i) = reshape(I(:,:,i),64,1); % Vectorizing
end

% Removing the average
I_vec_zm = I_vec - mean(I_vec,2)*ones(1,ns);

% EVD
Ri = cov(I_vec_zm.');
[Q,D] = eig(Ri);
lambda = diag(D);
lambda = lambda(end:-1:1);

% Visualizing the eigenvalues
figure,plot(lambda)

% Choosing the number of components
energ = cumsum(lambda);
figure,plot(energ)
inde = find(energ < energ(end)*rth);
if length(inde) == 0
    inde = 0;
end
Q2 = Q(:,64-inde(end)+1:64);

% Transforming data
I_vec_zm_pca1 = Q.'*I_vec_zm; % without loss
I_vec_zm_pca2 = Q2.'*I_vec_zm; % with loss

% Data reduction
[d1,d2]=size(I_vec_zm_pca1);
[e1,e2]=size(I_vec_zm_pca2);
% d1
% e1
e1/d1

% Bringing the variables to the original basis and aadding the average
I_vec_oldbase1 = Q*I_vec_zm_pca1 + mean(I_vec,2)*ones(1,ns);
I_vec_oldbase2 = Q2*I_vec_zm_pca2 + mean(I_vec,2)*ones(1,ns);

% Transforimg back to matrices
for i = 1:ns
    I_oldbase1(:,:,i) = reshape(I_vec_oldbase1(:,i),8,8);
    I_oldbase2(:,:,i) = reshape(I_vec_oldbase2(:,i),8,8);
end

% Reconstruction error
% (mean(mean(mean(abs(I - I_oldbase1).^2)))/mean(mean(mean(abs(I).^2))))
(mean(mean(mean(abs(I - I_oldbase2).^2)))/mean(mean(mean(abs(I).^2))))
% length(find((I - round(I_oldbase1))~=0))/(64*ns)
length(find((I - round(I_oldbase2))~=0))/(64*ns)
