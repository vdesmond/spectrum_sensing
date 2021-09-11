clc;
close all;
rstream = RandStream.create('mt19937ar', 'seed', 2009);
Ntrial = 1e5; % number of Monte-Carlo trials
spower = 1; % signal power is 1
pd_graph = [];
for snrdb = 6 % SNR in dB
    snr = db2pow(snrdb); % SNR in linear scale
    npower = spower / snr; % noise power
    namp = sqrt(npower / 2); % noise amplitude in each channel
    s = ones(1, Ntrial); % signal
    n = namp * (randn(rstream, 1, Ntrial) + 1i * randn(rstream, 1, Ntrial)); % noise
    x = s + n;
    mf = 1;
    y = mf' * x;
    z = real(y);
    Pfa = 1e-3;
    snrthreshold = npwgnthresh(Pfa, 1, 'coherent');
    mfgain = mf' * mf;
    % To match the equation in the text above
    % npower - N
    % mfgain - M
    % snrthreshold - SNR
    threshold = sqrt(npower * mfgain * snrthreshold);
    Pd = sum(z > threshold) / Ntrial;
    x = n;
    y = mf' * x;
    z = real(y);
    Pfa = sum(z > threshold) / Ntrial;
    [Y, X] = rocsnr(snrdb, 'SignalType', 'Nonfluctuatingcoherent', 'MinPfa', 1e-4);
    pd_graph = [pd_graph; Y'];
end
figure;
s = semilogx(X, pd_graph(1, :), 'r-*');
set(s, 'linewidth', 1);
title('Nonfluctuating Coherent ROC - Matched Filter');
grid on;
xlabel('probability of falsed alarm(pfa)');
ylabel('probability of detection(pd)');
snr_avgdB = 6;
legend(['SNR=' num2str(snr_avgdB(1)) 'dB']);
