clc;
close all;
m = 10;
N = 2 * m;
pf = logspace(-4, 0, 40);
snr_avgdB = 6;
snr_avg = power(10, snr_avgdB / 10);
for i = 1:length(pf)
    over_num = 0;
    th(i) = gammaincinv(1 - pf(i), 2 * m);
    for kk = 1:1e5
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
    pd_sim(i) = over_num / kk;
end
figure;
s = semilogx(pf, pd_sim, 'r-*');
set(s, 'linewidth', 1);
title('Nonfluctuating Coherent ROC');
grid on;
xlabel('Probability of Falsed Alarm (pfa)');
ylabel('Probability of Detection (pd)');
legend(['SNR=' num2str(snr_avgdB) 'dB']);
