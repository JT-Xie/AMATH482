clear all; close all; clc

%% Ski_drop_low.mp4
video = VideoReader('ski_drop_low.mp4');
frames = read(video);
numFrame = video.numFrames;
t = 1:10:numFrame;
dt = 10;
X = zeros(540*960,length(t));
for i = 1:length(t)
    single_frame = frames(:,:,:,(i-1)*dt+1);
    F = rgb2gray(single_frame);
    F = im2double(F);
    X(:,i) = reshape(F,[540*960,1]);
    % imshow(F)
end

%%
v1 = X(:,1:end-1);
v2 = X(:,2:end);
[U1, Sigma1, V1] = svd(v1,'econ');
%%
figure(1)
plot(diag(Sigma1),'ko','Linewidth',2)
set(gca,'Fontsize')

xlabel('modes'), ylabel('singular value')
title('Singular Value of Ski clip')
%%
m = 2;
Sm = Sigma1(1:m,1:m);
Um = U1(:,1:m);
Vm = V1(:,1:m);

S = Um'*v2*Vm*diag(1./diag(Sm));
[eV, D] = eig(S); % compute eigenvalues + eigenvectors
mu = diag(D); % extract eigenvalues
omega1 = log(mu)/dt;
%%
Phi1 = Um*eV;

%%
y0 = Phi1\v1(:,1); % pseudoinverse to get initial conditions
u_modes1 = zeros(length(y0),length(t));
for i = 1:length(t)
   u_modes1(:,i) = y0.*exp(omega1*t(i)); 
end
%%
u_dmd1 = Phi1*u_modes1;
u_sparse1 = abs(X - u_dmd1);

residual_matrix1 = u_sparse1 .* (u_sparse1 < 0);
u_dmd1 = residual_matrix1 + abs(u_dmd1);
u_sparse1 = u_sparse1 - residual_matrix1;



%% extract several frames
figure(2)
for i = 1:9
    subplot(3,3,i)
    vidtype1 = floor((i-1)/3);
    timeframe1 = mod(i,3);
    if timeframe1 == 0
        timeframe1 = 3;
    end
    if vidtype1 == 0
        temp = X(:,timeframe1*10);
    elseif vidtype1 == 1
        temp = u_dmd1(:,timeframe1*10); 
    elseif vidtype1 == 2
        temp = u_sparse1(:,timeframe1*10); 
    end
    temp = reshape(temp,[540 960]);
    imagesc(temp);
    colormap(gray);
    axis off;
end

