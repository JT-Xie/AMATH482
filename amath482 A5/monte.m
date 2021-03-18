clear all; close all; clc

%% Monte_carlo.mp4
v = [];
vreader = VideoReader('monte_carlo_low.mp4');
%%
numFrame = vreader.NumFrames;
% tf = 1:numFrame;
frame = readFrame(vreader);
frame = rgb2gray(frame);
frame = reshape(frame,[],1);
v = frame;
while hasFrame(vreader)
    frame = readFrame(vreader);
    frame = rgb2gray(frame);
    frame = reshape(frame,[],1);
    if sum(abs(frame - v(:,end))) ~= 0
        v = [v,frame];
    end
end
    

%%
v = double(v);
v1 = v(:,1:end-1);
v2 = v(:,2:end);
[U1, Sigma1, V1] = svd(v1,'econ');
%%
figure(1)
plot(diag(Sigma1),'ko','Linewidth',2)
set(gca,'Fontsize')

xlabel('modes'), ylabel('singular value')
title('Singular Value of Monte clip')
%%
m = 2;
Sm = Sigma1(1:m,1:m);
Um = U1(:,1:m);
Vm = V1(:,1:m);

S1 = Um'*v2*Vm*diag(1./diag(Sm));
[eV1, D1] = eig(S1); % compute eigenvalues + eigenvectors
mu1 = diag(D1); % extract eigenvalues
omega1 = log(mu1);
%%
Phi1 = v2*Vm/Sm*eV1;

%%
y0 = Phi1\v1(:,1); % pseudoinverse to get initial conditions
u_modes1 = zeros(m,size(v1,2));
for i = 1:size(v1,2)
   u_modes1(:,i) = y0.*exp(omega1*i); 
end
%%
u_dmd1 = Phi1*u_modes1;
u_sparse1 = abs(v1 - u_dmd1);

residual_matrix1 = u_sparse1 .* (u_sparse1 < 0);
u_dmd1 = residual_matrix1 + abs(u_dmd1);
u_sparse1 = u_sparse1 - residual_matrix1;

%% extract several frames
figure(2)

for i = 1:12
    subplot(3,4,i)
    vidtype1 = floor((i-1)/4);
    timeframe1 = mod(i,4);
    if timeframe1 == 0
        timeframe1 = 4;
    end
    if vidtype1 == 0
        temp = v(:,timeframe1*30);
    elseif vidtype1 == 1
        temp = u_dmd1(:,timeframe1*30); 
    elseif vidtype1 == 2
        temp = u_sparse1(:,timeframe1*30); 
    end
    temp = reshape(temp,[540 960]);
    imagesc(temp);
    colormap(gray);
    axis off;
end
