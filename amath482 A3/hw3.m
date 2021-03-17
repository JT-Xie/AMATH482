clear all; close all; clc;

%% Load data
load('cam1_1.mat')
load('cam1_2.mat')
load('cam1_3.mat')
load('cam1_4.mat')
load('cam2_1.mat')
load('cam2_2.mat')
load('cam2_3.mat')
load('cam2_4.mat')
load('cam3_1.mat')
load('cam3_2.mat')
load('cam3_3.mat')
load('cam3_4.mat')
%% Ideal Case
[height11, width11, rgb11, num_frames1_1] = size(vidFrames1_1);
X11 = [];
Y11 = [];
for j = 1:num_frames1_1   
    X = rgb2gray(vidFrames1_1(:,:,:,j));
    % imshow(X); drawnow 
    yrange = [300,400];
    xrange = [200,450];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    X11 = [X11 mean(round((filter_x)))];
    Y11 = [Y11 mean(round((filter_y)))];
end

[height12, width12, rgb12, num_frames1_2] = size(vidFrames2_1);
X12 = [];
Y12 = [];
for j = 1:num_frames1_2   
    X = rgb2gray(vidFrames2_1(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [100,375];
    yrange = [250,350];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    X12 = [X12 mean(round((filter_x)))];
    Y12 = [Y12 mean(round((filter_y)))];
end


[height13, width13, rgb13, num_frames1_3] = size(vidFrames3_1);
X13 = [];
Y13 = [];
for j = 1:num_frames1_3   
    X = rgb2gray(vidFrames3_1(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [200,350];
    yrange = [250,500];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X13 = [X13 x_last];
    Y13 = [Y13 y_last];
end

% combine the data from three cameras
X_min1 = min([length(X11) length(X12) length(X13)]);
X1 = [X11(1:X_min1);Y11(1:X_min1);X12(1:X_min1);Y12(1:X_min1);X13(1:X_min1);Y13(1:X_min1)];
[row,col] = size(X1);
means = mean(X1.').';
X1 = X1-means;
[U1,S1,V1] = svd(X1,'econ');
Y = U1'*X1;
principal_component = Y(1:2,:);
figure(1)
names = [];
for k = 1:2
    plot(principal_component(k,:),'linewidth',2),hold on;
    names = [names;strcat('Principal Component',num2str(k))];
    xlabel('Frame number')
    ylabel('Position in x')
end

xlim([0,length(principal_component)])
title('Case 1: Ideal case')
legend(names);

%% Case 2: Noisy Case
[height21, width21, rgb21, num_frames2_1] = size(vidFrames1_2);
X21 = [];
Y21 = [];
for j = 1:num_frames2_1   
    X = rgb2gray(vidFrames1_2(:,:,:,j));
    % imshow(X); drawnow 
    yrange = [200,400];
    xrange = [300,400];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X21 = [X21 x_last];
    Y21 = [Y21 y_last];
end

[height22, width22, rgb22, num_frames2_2] = size(vidFrames2_2);
X22 = [];
Y22 = [];
for j = 1:num_frames2_2   
    X = rgb2gray(vidFrames2_2(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [50,450];
    yrange = [300,400];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X22 = [X22 x_last];
    Y22 = [Y22 y_last];
end


[height23, width23, rgb23, num_frames2_3] = size(vidFrames3_2);
X23 = [];
Y23 = [];
for j = 1:num_frames2_3   
    X = rgb2gray(vidFrames3_2(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [200,350];
    yrange = [250,500];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X23 = [X23 x_last];
    Y23 = [Y23 y_last];
end

% combine the data from three cameras
X_min2 = min([length(X21) length(X22) length(X23)]);
X2 = [X21(1:X_min1);Y21(1:X_min1);X22(1:X_min1);Y22(1:X_min1);X23(1:X_min1);Y23(1:X_min1)];
[row,col] = size(X2);
means = mean(X2.').';
X2 = X2-means;
[U2,S2,V2] = svd(X2,'econ');
Y = U2'*X2;
principal_component = Y(1:4,:);
figure(1)
names = [];
for k = 1:2
    plot(principal_component(k,:),'linewidth',2),hold on;
    names = [names;strcat('Principal Component',num2str(k))];
    xlabel('Frame number')
    ylabel('Position in x')
end

xlim([0,length(principal_component)])
title('Case 2: Noisy Case')
legend(names);

%% Case 3: Horizontal Displacement
[height31, width31, rgb31, num_frames3_1] = size(vidFrames1_3);
X31 = [];
Y31 = [];
for j = 1:num_frames3_1   
    X = rgb2gray(vidFrames1_3(:,:,:,j));
    % imshow(X); drawnow 
    yrange = [200,450];
    xrange = [250,400];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X31 = [X31 x_last];
    Y31 = [Y31 y_last];
end

[height32, width32, rgb32, num_frames3_2] = size(vidFrames2_3);
X32 = [];
Y32 = [];
for j = 1:num_frames3_2   
    X = rgb2gray(vidFrames2_3(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [175,400];
    yrange = [200,400];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    X32 = [X32 mean(round((filter_x)))];
    Y32 = [Y32 mean(round((filter_y)))];
end


[height33, width33, rgb33, num_frames3_3] = size(vidFrames3_3);
X33 = [];
Y33 = [];
for j = 1:num_frames3_3   
    X = rgb2gray(vidFrames3_3(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [200,350];
    yrange = [250,450];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X33 = [X33 x_last];
    Y33 = [Y33 y_last];
end

% combine the data from three cameras
X_min3 = min([length(X31) length(X32) length(X33)]);
X3 = [X31(1:X_min1);Y31(1:X_min1);X32(1:X_min1);Y32(1:X_min1);X33(1:X_min1);Y33(1:X_min1)];
[row,col] = size(X3);
means = mean(X3.').';
X3 = X3-means;
[U3,S3,V3] = svd(X3,'econ');
Y = U3'*X3;
principal_component = Y(1:3,:);
figure(3)
names = [];
for k = 2:3
    plot(principal_component(k,:),'linewidth',2),hold on;
    names = [names;strcat('Principal Component',num2str(k))];
    xlabel('Frame number')
    ylabel('Position in x')
end

xlim([0,length(principal_component)])
legend(names);
title('Case 3: Horizontal Displacement')

%% Horizontal Displacement and Rotation
[height41, width41, rgb41, num_frames4_1] = size(vidFrames1_4);
X41 = [];
Y41 = [];
for j = 1:num_frames4_1   
    X = rgb2gray(vidFrames1_4(:,:,:,j));
    % imshow(X); drawnow 
    yrange = [200,400];
    xrange = [300,450];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X41 = [X41 x_last];
    Y41 = [Y41 y_last];
end

[height42, width42, rgb42, num_frames4_2] = size(vidFrames2_4);
X42 = [];
Y42 = [];
for j = 1:num_frames4_2   
    X = rgb2gray(vidFrames2_4(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [100,350];
    yrange = [200,450];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X42 = [X42 x_last];
    Y42 = [Y42 y_last];
    
end


[height43, width43, rgb43, num_frames4_3] = size(vidFrames3_4);
X43 = [];
Y43 = [];
for j = 1:num_frames4_3   
    X = rgb2gray(vidFrames3_4(:,:,:,j));
    % imshow(X); drawnow 
    xrange = [100,300];
    yrange = [200,500];
    % filter the data
    bright = max(X,[],'all');
    [x,y] = ind2sub(size(X), find(X==bright));
    filter_x = x(find(x>xrange(1) & x<xrange(2)));
    filter_y = y(find(y>yrange(1) & y<yrange(2)));
    if isempty(filter_x)
        x_last = mode(x);
    else    
        x_last = mean(round((filter_x)));
    end
    if isempty(filter_y)
        y_last = mode(x);
    else    
        y_last = mean(round((filter_y)));
    end
    X43 = [X43 x_last];
    Y43 = [Y43 y_last];
end

% combine the data from three cameras
X_min4 = min([length(X41) length(X42) length(X43)]);
X4 = [X41(1:X_min1);Y41(1:X_min1);X42(1:X_min1);Y42(1:X_min1);X43(1:X_min1);Y43(1:X_min1)];
[row,col] = size(X4);
means = mean(X4.').';
X4 = X4-means;
[U4,S4,V4] = svd(X4,'econ');
Y = U4'*X4;
principal_component = Y(1:3,:);
figure(4)
names = [];
for k = 2:3
    plot(principal_component(k,:),'linewidth',2),hold on;
    names = [names;strcat('Principal Component',num2str(k))];
    xlabel('Frame number')
    ylabel('Position in x')
end

xlim([0,length(principal_component)])
legend(names);
title('Case 4: Horizontal Displacement and Rotation')


