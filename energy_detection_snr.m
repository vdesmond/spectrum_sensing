clc;
close all;
m = 10;
N = 2 * m;
pd_sim = [];
pf = 0.5;
for snr_avgdB = 0:1:30
    snr_avg = power(10, snr_avgdB / 10);
    for i = 1:length(pf)
        over_num = 0;
        th(i) = gammaincinv(1 - pf(i), 2 * m);
        for kk = 1:1000
            t = 1:N;
            x = sin(pi * t);
            noise = randn(1, N);
            pn = mean(noise.^2);
            amp = sqrt(noise.^2 * snr_avg);
            x = amp .* x ./ abs(x);
            SNRdB_Sample = 10 * log10(x.^2 ./ (noise.^2));
            signal = x(1:N);
            ps = mean(abs(signal).^2);
            Rev_sig = signal + noise;
            accum_power(i) = sum(abs(Rev_sig)) / pn;
            if accum_power(i) > th(i)
                over_num = over_num + 1;
            end
        end
        pd_sim = [pd_sim over_num / kk];
    end
end
figure;
SNR = 0:1:30;
s = plot(SNR, pd_sim, 'r-*');
set(s, 'linewidth', 1);
title('Energy detection method');
grid on;
xlabel('Signal-to-noise ratio (dB)');
ylabel('Probability of Detection (pd)');
legend(['PFA=' num2str(pf)]);
