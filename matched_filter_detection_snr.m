clc;
close all;
rstream = RandStream.create('mt19937ar', 'seed', 2009);
spower = 1; % signal power is 1
Ntrial = 1e5; % number of Monte-Carlo trials
s = ones(1, Ntrial); % signal
mf = 1;
Pfa = 0.5;
Pd = [];
for snrdb = 0:1:30 % SNR in dB
    snr = db2pow(snrdb); % SNR in linear scale
    npower = spower / snr; % noise power
    namp = sqrt(npower / 2); % noise amplitude in each channel
    n = namp * (randn(rstream, 1, Ntrial) + 1i * randn(rstream, 1, Ntrial)); % noise
    x = s + n;
    y = mf' * x; % apply the matched filter
    z = real(y);
    snrthreshold = npwgnthresh(Pfa, 1, 'coherent');
    mfgain = mf' * mf;
    threshold = sqrt(npower * mfgain * snrthreshold);
    Pd = [Pd sum(z > threshold) / Ntrial];
end
figure;
SNR = 0:1:30;
s = plot(SNR, Pd, 'r-*');
set(s, 'linewidth', 1);
title('Matched Filter');
grid on;
xlabel('Signal-to-noise ratio (dB)');
ylabel('probability of detection(pd)');
legend(['PFA=' num2str(Pfa)]);
