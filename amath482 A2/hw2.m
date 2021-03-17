clear all; close all; clc

%%
% figure(1)
[y1,Fs1] = audioread('GNR.m4a');
tr_gnr1 = length(y1)/Fs1;
% plot((1:length(y1))/Fs1,y1);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('GNR');
% p8 = audioplayer(y1,Fs1);playblocking(p8)

% figure(2)
[y2,Fs2] = audioread('Floyd.m4a');
tr_floyd = length(y2)/Fs2;
% plot((1:length(y2))/Fs2,y2);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Floyd');
% p8 = audioplayer(y2,Fs2);playblocking(p8)

% create the list of notes
noteNames = {...
    'AN' 'AN♯/BN♭' 'BN' 'CN' 'CN♯/DN♭' 'DN' 'DN♯/EN♭' 'EN' 'FN' 'FN♯/GN♭' 'GN' 'GN♯/AN♭'};
note_freq = 440 * (2^(1/12)).^(-57:42);
allNotes = [];
for ii = 0:8
    allNotes = [allNotes regexprep(noteNames, 'N', num2str(ii))]; end %#ok<AGROW>
allNotes = allNotes(4:end-5);
%% Q1
% Through the use of the Gabor filtering, 
% reproduce the music score for the guitar in the GNR clip, and the bass in the Floyd clip.

% GNR
a = 800;
tau = 0:0.3:tr_gnr1;
y1 = y1.';
n1 = length(y1);
L1 = length(y1)/Fs1;
tp = linspace(0,L1,n1+1); t1 = tp(1:n1);
k = (1/L1)*[0:n1/2-1 -n1/2:-1]; % Notice the 1/L instead of 2*pi/L
ks = fftshift(k);


for j = 1:length(tau)
    g = exp(-a*(t1-tau(j)).^2);
    yg1 = g.*y1;
    ygt1 = fft(yg1);
    ygt1_spec(:,j) = fftshift(abs(ygt1));
end   

figure(3)
yyaxis left
pcolor(tau,ks,ygt1_spec)
shading interp
set(gca,'ylim',[0,500], 'Fontsize', 16)
set(gca,'yTick',note_freq)
set(gca, 'YTicklabel',allNotes)
colormap(hot)
ylabel('music note')
yyaxis right
pcolor(tau,ks,ygt1_spec)
shading interp
set(gca,'ylim',[0,500], 'Fontsize', 16)
ylabel('frequency(Hz)')
xlabel('time(s)')
title('The frequency(Hz) and music score of GNR clip')

%%
% Floyd
a = 1000;

y2 = y2.';
y2 = y2(1:end-1);
n2 = length(y2);
L2 = length(y2)/Fs2;
tau = 0:2:tr_floyd;
tp = linspace(0,L2,n2+1); t2 = tp(1:n2);
k = (1/L2)*[0:n2/2-1 -n2/2:-1]; % Notice the 1/L instead of 2*pi/L
ks2 = fftshift(k);

for j = 1:length(tau)
    g = exp(-a*(t2-tau(j)).^2);
    yg2 = g.*y2;
    ygt2 = fft(yg2);
    ygt2_spec(:,j) = fftshift(abs(ygt2));
end   

figure(4)
yyaxis right
pcolor(tau, ks2,ygt2_spec)
shading interp
set(gca,'ylim',[0,300], 'Fontsize', 16)
colormap(hot)
xlabel('time(s)'), ylabel('frequency(Hz)')

yyaxis left 
pcolor(tau, ks2,ygt2_spec)
shading interp
set(gca,'ylim',[0,300], 'Fontsize', 16)
set(gca,'yTick',note_freq)
set(gca, 'YTicklabel',allNotes)
colormap(hot)
ylabel('music note')

title('The frequency(Hz) and music score of Floyd clip')

%% Q2
% use a filter in frequency space to try to isolate the bass
% the center is the frequency of the bass

bass = zeros(n2,length(tau));

for j = 1:length(tau)
    [mxv,idx] = max(ygt2_spec(:,j));
    k0 = abs(ks2(idx));   
    g = exp(-0.01*(ks2-k0).^2);
    bass(:,j) = g.'.* ygt2_spec(:,j);
end   

figure(5)
yyaxis right
pcolor(tau,ks2,bass)
shading interp
set(gca,'ylim',[0,300], 'Fontsize', 16)
colormap(hot)
xlabel('time(s)'), ylabel('frequency(Hz)')

yyaxis left 
pcolor(tau, ks2,bass)
shading interp
set(gca,'ylim',[0,300], 'Fontsize', 16)
set(gca,'yTick',note_freq)
set(gca, 'YTicklabel',allNotes)
colormap(hot)
ylabel('music note')
title('bass in the Floyd clip')
%% Q3
guitar = zeros(n2,length(tau));
% y2_nobass = highpass(ygt2_spec,300,Fs2);
for j = 1:length(tau)
    [mxv,idx] = max(ygt2_spec(:,j));
    k0 = abs(ks2(idx));   
    g = exp(-0.01*(ks2-k0).^2);
    guitar(:,j) = g.'.* ygt2_spec(:,j);
end   

figure(6)
yyaxis right
pcolor(tau,ks2,guitar)
shading interp
set(gca,'ylim',[400,1000], 'Fontsize', 16)
colormap(hot)
xlabel('time(s)'), ylabel('frequency(Hz)')

yyaxis left 
pcolor(tau, ks2,guitar)
shading interp
set(gca,'ylim',[400,1000], 'Fontsize', 16)
set(gca,'yTick',note_freq)
set(gca, 'YTicklabel',allNotes)
colormap(hot)
ylabel('music note')
title('guitar solo in the Floyd clip')
