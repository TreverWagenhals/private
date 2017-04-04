N = 1e6;
x1 = randn(N, 1);
y1 = randn(N, 1);

x1_LPF = filter(LPF, 1, x1);
y1_LPF = filter(LPF, 1, y1);

% Create a filtered Rayleigh Distribution and an unfiltered
% for comparison
ray1_u = abs(x1 + 1i*y1);
ray1_f = abs(x1_LPF + 1i*y1_LPF);

figure()
set(gcf, 'Position', get(0, 'Screensize'));
subplot(2,2,1);                
histogram(x1);
title('Gaussian Array X1 Histogram without filtering')
subplot(2,2,2);            
histogram(y1);
title('Gaussian Array Y1 Histogram without filtering')

subplot(2,2,3);
histogram(x1_LPF);
title('Gaussian Array X1 Histogram with filtering')
subplot(2,2,4);   
histogram(y1_LPF);
title('Gaussian Array Y1 Histogram with filtering')

time = 0.001 * (1:1000000);
% Plot Raleigh fading for filtered and unfiltered data
figure()
set(gcf, 'Position', get(0, 'Screensize'));
subplot(2, 1, 1);
plot(time(2000:3000), 20*log10(ray1_u(2000:3000)), 'r')
title('Raleigh Distribution (ray1) without filtering')
xlabel('Time (in seconds)')
ylabel('Decibels (dB)')
subplot(2, 1, 2);
plot(time(2000:3000), 20*log10(ray1_f(2000:3000)), 'r')
title('Raleigh Distribution (ray1) with filtering')
xlabel('Time (in seconds)')
ylabel('Decibels (dB)')

figure()
subplot(1, 2, 1);
set(gcf, 'Position', get(0, 'Screensize'));
histogram(ray1_u, 'Normalization', 'pdf')
title('Normalized Histogram of Raleigh Distribution (unfiltered)')
hold on
range = [0:0.01:4];
theory = (range) .* exp( - (range.^2) / 2);
plot(range, theory)
legend('Simulation', 'Theoretical')
xlabel('Random Variable')
ylabel('Probability')
xlim([0 4]);

subplot(1, 2, 2);
% I want to create a pdf function for this histogram
histogram(ray1_f, 'Normalization', 'pdf');
title('Normalized Histogram of Raleigh Distribution (filtered)')
xlabel('Random Variable')
ylabel('Probability')
xlim([0 .6])