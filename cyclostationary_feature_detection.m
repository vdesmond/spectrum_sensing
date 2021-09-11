clc;
close all;
r = randi([0 1], 100, 1);
stem(r, 'DisplayName', 'r');
hold on;
l = length(r);
r(l + 1) = 0;
n = 1;
L = 1000;
fs = 1000;
T = 1 / fs;
fc = 3 / T;
t1 = (0:L);
while n <= l
    t = (n - 1):.001:n;
    if r(n) == 1
        if r(n + 1) == r(n)
            y = (t <= n);
        else
            y = (t < n);
        end
    else
        if r(n + 1) == r(n)
            y = (t > n);
        else
            y = (t >= n);
        end
    end
    plot(t, y, 'r');
    title('NRZ encoding');
    grid on;
    xlabel('time');
    ylabel('amplitude');
    hold on;
    axis([0 100 -1.5 1.5]);
    n = n + 1;
end
b = (2 * 3.142 * fc * t1) + (3.142 * (1 - y));
s = sqrt(2) * cos(b);
figure;
plot(t1, s, 'r');
axis([0 1000 -1.5 1.5]);
title('BPSK - Transmitted');
xlabel('Time');
ylabel('Amplitude');
axis([0 1000 -1.5 1.5]);
hold on;
noise = awgn(s, 20, 'measured');
snr_db = 10 * log10(s.^2 / (noise.^2));
snr_avg = power(10, snr_db / 10);
rs1 = (s + noise) / 2;
vr = var(rs1);
figure;
plot(t1, rs1, 'r');
axis([0 100 -1.5 1.5]);
title('BPSK - Received');
xlabel('Time');
ylabel('Amplitude');
axis([0 1000 -1.5 1.5]);
hold on;
nfft = 2^nextpow2(L);
f1 = fft(rs1, nfft) / L;
fs1 = fs / 2 * linspace(0, 1, nfft / 2 + 1);
figure;
plot(fs1, 2 * abs(f1(1:nfft / 2 + 1)), 'r');
title('FFT of received signal');
xlabel('Frequency (HZ)');
ylabel('|rs1|');
grid on;
hold on;
fc = 1:3 / T;
s1 = cos(2 * 3.14 * fc * T);
l1 = length(s1);
sc = s1 + sin(2 * 3.14 * fc * T);
l2 = length(sc);
cr1 = xcorr2(rs1, s1);
figure;
plot(cr1, 'r');
title('Cross Correlation of Rx signal with cos');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
axis([0 500 -5.5 5.5]);
hold on;
cr2 = xcorr2(rs1, sc);
l2 = length(cr2);
figure;
plot(cr2, 'r');
title('Cross Correlation of Rx signal with with sin+cos');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
axis([0 500 -5.5 5.5]);
hold on;
for i = 1:500
    if s1(i) > 0.5 || sc(i) > 0.5
        disp('PU PRESENT');
    end
end
L = 2:1:30;
snr1 = 2:1:30;
q1 = (2 * L + 1) * (0.5)^2;
Pf = exp(-q1);
del = (2 * snr1 + 1) * vr / (2 * L + 1);
q2 = sqrt(2 * snr1 / vr);
q3 = 0.5 / del;
Pd = marcumq(q1, q2);
figure;
P = plot(snr1, Pd, 'r-*');
set(P, 'linewidth', 1);
title('Pd Vs SNR');
xlabel('SNR');
ylabel('Probability of detection');
hold on;
grid on;
figure;
P2 = semilogx(Pf, Pd, 'r-*');
set(P2, 'linewidth', 1);
title('Pfa Vs Pd');
xlabel('Probability of false alarm');
ylabel('Probability of detection');
hold on;
grid on;
