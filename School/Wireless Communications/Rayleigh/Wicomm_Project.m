% Question 1

	% -----------------------------------------------
	% Create a Rayleigh fading process the easy way. 
	% -----------------------------------------------

		% PART A

			% ------------------------------------------------------------------------------------
			% Take two independent arrays of Gaussian random numbers with mean 0 and variance 1. 
			% ------------------------------------------------------------------------------------

                N = 1e6;
				% Variable with 100,000 random variables with a Standard Deviation of
				% 1 and a mean of 0. The assignment asked for the variance of 1, but
				% variance is the sqrt(STD), which would still be 1.
				x1 = randn(N, 1);
				% Create a second array of Gaussian random numbers
				y1 = randn(N, 1);

			% --------------------------------------------------------------------------------------
			% Design a low pass filter with bandwidth 10Hz which
			% corresponds to a speed of approximately 3 MPH (5 kph, walking speed). Run each of the
			% two processes through the filter
			% --------------------------------------------------------------------------------------

				% Pass both Gaussian arrays through low pass filter and save to variable
				x1_LPF = filter(LPF, 1, x1);
				y1_LPF = filter(LPF, 1, y1);
			
			% -------------------------------------------------------------------
			% Take the amplitude of the complex process. Let one
			% function be real, and the other be complex.
			% -------------------------------------------------------------------
			
                % Create a filtered Rayleigh Distribution and an unfiltered for comparison
				ray1_u = abs(x1 + 1i*y1);
				ray1_f = abs(x1_LPF + 1i*y1_LPF);
				
				% It's interesting to see that the mean dB value of the filtered rayleigh distribution
				% is actually lower in power. Even still, we want to remove the power spikes associated
				% with unfiltered data
				mean(20.*log10(ray1_u))
				mean(20.*log10(ray1_f))
			
		% PART B
			
			% ---------------------------------------------------------------------------------
			% Verify using a histogram that each of the individual components are Gaussian. 
			% ---------------------------------------------------------------------------------

				figure('Name', 'Part B: Histograms of filtered and unfiltered Gaussian arrays')
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
				
				
		% PART C

			% -------------------------------------------------------------------------------------------
			% Plot about 1 second of the Rayleigh data but not the first second because the filter will
			% have transitory behavior. On the x axis is time, and on the y axis is amplitude in dB.
			% (remember amplitude is 20 log10. 
			% -------------------------------------------------------------------------------------------
			
				time = 0.001 * (1:1000000);
				
				% Plot Raleigh fading for filtered and unfiltered data
				figure('Name', 'Part C: Raleigh Fading for filter and unfiltered data')
                set(gcf, 'Position', get(0, 'Screensize'));
				
                subplot(2, 1, 1);
                plot(time(2000:3000), 20*log10(ray1_u(2000:3000)), 'r')
                title('Raleigh Distribution ray1 (unfiltered)')
				xlabel('Time (in seconds)')
				ylabel('Decibels (dB)')
                    
                subplot(2, 1, 2);
				plot(time(2000:3000), 20*log10(ray1_f(2000:3000)), 'r')
				title('Raleigh Distribution ray1 (filtered)')
				xlabel('Time (in seconds)')
				ylabel('Decibels (dB)')
				
		% PART D
			
			% ----------------------------------------------------------------------------------
			% Create a normalized histogram (estimate of the pdf) of the amplitude (not in dB)
			% and compare to a theoretical Rayleigh density function 
			% ----------------------------------------------------------------------------------
	
				figure('Name', 'Part D: Normalized histogram for filtered and unfiltered data')
                subplot(1, 2, 1);
                set(gcf, 'Position', get(0, 'Screensize'));
				title('Normalized Histogram of Raleigh Distribution (unfiltered)')
				
                histogram(ray1_u, 'Normalization', 'pdf')
                hold on
				
                range = [0:0.01:4];
                theory = (range) .* exp( - (range.^2) / 2);
                plot(range, theory, 'Linewidth', 1.5)
                legend('Simulation', 'Theoretical')
				xlabel('Random Variable')
				ylabel('Probability')
                xlim([0 4]);
                
                subplot(1, 2, 2);
                histogram(ray1_f, 'Normalization', 'pdf');
                title('Normalized Histogram of Raleigh Distribution (filtered)')
                xlabel('Random Variable')
				ylabel('Probability')
                
                mean_square = mean(ray1_f .^ 2);
                filter_theory = (range) * 2 / mean_square .* exp( - (range.^2) ./ mean_square);
                hold on
                plot(range, filter_theory, 'Linewidth', 1.5)
                xlim([0 .6])
                legend('Simulation', 'Theoretical')     

		% PART E
		
			% --------------------------------------------------------------------------------------------
			% Create a histogram of the distribution of the phase formed from the inverse tangent of the
			% I and Q terms. 
			% --------------------------------------------------------------------------------------------
						
                % It can be seen when the two arrays are plotted that the
                % distribution of phases does not change that dramatically,
                % even after filtering.
				atan_hist_1 = atan(y1 ./ x1) * 180/pi;
				atan_hist_2 = atan(y1_LPF ./ x1_LPF) * 180/pi;
                
                % Uncomment to show that the distributions of phases follows
                % the Gaussian properties and the mean is ~0 degrees
                % phase_u = mean(atan_hist_1)
                % phase_f = mean(atan_hist_2)
                
                % Uncomment to show visually that the phases over a set
                % period of time (1 sec) does not change even after filtering
                % figure()
                % subplot(2, 1, 1)
                % plot(time(2000:3000), atan_hist_2(2000:3000))
                % subplot(2, 1, 2)
                % plot(time(2000:3000), atan_hist_2(2000:3000))
				
				figure('Name', 'Part E: Histogram of phase formed (inverse tangent) of I and Q terms')
                set(gcf, 'Position', get(0, 'Screensize'));
				
				subplot(2, 1, 1)
				histogram(atan_hist_1)
                title('Histogram of phase formed (inverse tangent) of I and Q terms (unfiltered)')
                xlabel('Phase (degrees)')
                ylabel('Number of occurances')
                xlim([-95, 95])
				
				subplot(2, 1, 2)
				histogram(atan_hist_2)
                title('Histogram of phase formed (inverse tangent) of I and Q terms (filtered)')
                xlabel('Phase (degrees)')
                ylabel('Number of occurances')
                xlim([-95, 95])
			
% Question 2
	
	% ------------------------------------------------------------------------------------------------------
	% Create a second instance of the Rayleigh fading using the technique outlined in step 1. Make sure
	% that the two instances are independent.
	% ------------------------------------------------------------------------------------------------------
	
		x2 = randn(N, 1);
		y2 = randn(N, 1);
		x2_LPF = filter(LPF, 1, x2);
		y2_LPF = filter(LPF, 1, y2);
		ray2_u = abs(x2 + 1i*y2);
		ray2_f = abs(x2_LPF + 1i*y2_LPF);
		
	% -----------------------------------------------------------------------------------------------
	% Calculate the correlation coefficient (average of
	% P1.*P2(complex conjugate) of at least 100,000, preferably 500k to 1 Million samples of each	
	% process. Verify that the two processes are uncorrelated. 
	% -----------------------------------------------------------------------------------------------
	
        % Very close to 0, which means almost no correlation between the two
		correlation = corr2(ray1_f, ray2_f)
		
% Question 3

	% -------------------------------------------------------------------------------
	% Now create a diversity combined signal by first doing A) selection diversity, 
	% -------------------------------------------------------------------------------
	
		selective = max(ray1_f, ray2_f);
		selective_u = max(ray1_u, ray1_f);
		
	% ------------------------------------------------------------------------------
	% and B) maximal ratio combining diversity on the amplitude of the two signals. 
	% ------------------------------------------------------------------------------
	
		mrc = sqrt(ray1_f.^2 + ray2_f.^2);
		mrc_u = sqrt(ray1_u.^2 + ray2_u.^2);
			
	% ---------------------------------------------------------------------
	% In the time domain, plot a section of the combined signal (1 second)
	% and look at the difference in terms of fade depth between parts 1) and 3)
	% ---------------------------------------------------------------------
    
        figure('Name', 'Question 3: Rayleigh vs Selective vs MRC')
        set(gcf, 'Position', get(0, 'Screensize'));
		
        subplot(3,1,1);
		plot(time(2000:3000), 20*log10(ray1_f(2000:3000)), time(2000:3000), 20*log10(ray2_f(2000:3000)), time(2000:3000), 20*log10(selective(2000:3000)));
        legend('Rayleigh 1', 'Rayleigh 2', 'Selection');
        title('Rayleigh Fading vs Selective Fading (filtered)')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
		
        subplot(3,1,2);
        plot(time(2000:3000), 20*log10(ray1_f(2000:3000)), time(2000:3000), 20*log10(ray2_f(2000:3000)) ,time(2000:3000), 20*log10(mrc(2000:3000)));
        legend('Rayleigh 1', 'Rayleigh 2', 'MRC');
        title('Rayleigh Fading vs MRC Fading (filtered)')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
		
		subplot(3, 1, 3);
		plot(time(2000:3000), 20*log10(selective(2000:3000)), time(2000:3000), 20*log10(mrc(2000:3000)));
        legend('Selective', 'MRC')
        title('MRC Fading vs Selective Fading (filtered)')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
		
% Question 4

	% -----------------------------------------------------------------------------------------------
	% On the same plot, plot the CDF of the diversity combined signals and the uncombined signal as
	% shown below. 
	% -----------------------------------------------------------------------------------------------
			
		% Unfiltered CDF information
        [f, x] = ecdf(ray1_u);
        [g, k] = ecdf(mrc_u);
        [p, t] = ecdf(selective_u);
		loc_u = find(f < 0.010001 & f > 0.009999);
        xval_rayleigh_u = 20*log10(x(loc_u(1))); 
        loc2_u = find(g < 0.010001 & g > 0.009999);
        xval_mrc_u = 20*log10(k(loc2_u(1)));
        loc3_u = find(p < 0.010001 & p > 0.009999);
        xval_sel_u = 20*log10(t(loc3_u(1)));
		
		% Filtered CDF information
		[q, r] = ecdf(ray1_f);
        [w, z] = ecdf(mrc);
		[m, n] = ecdf(selective);
		loc_f = find(q < 0.010001 & q > 0.009999);
        xval_rayleigh_f = 20*log10(r(loc_f(1))); 
        loc2_f = find(w < 0.010001 & w > 0.009999);
        xval_mrc_f = 20*log10(z(loc2_f(1)));
		loc3_f = find(m < 0.010001 & m > 0.009999);
		xval_sel_f = 20*log10(n(loc3_f(1)));
        
        figure('Name', 'Question 4: CDF');
		set(gcf, 'Position', get(0, 'Screensize'));
		
        subplot(1, 2, 1);
        plot(20*log10(x), f, 20*log10(k), g, 20*log10(t), p);     
        hold on; % Plot the Diversity gain line next
        plot([xval_rayleigh_u, xval_rayleigh_u], [0.000001, 0.01], 'k', [xval_rayleigh_u, xval_mrc_u], [0.01, 0.01], 'k') 
		
		% Plot details
        xlabel('dB Relative to Mean');
        ylabel('Cumulative Property');
        set(gca, 'YScale', 'log');
        legend('Rayleigh', '2 Branch Max Ratio', '2 Branch Selective');
        title({'Cumulative Probability Distribution Rayleigh and 2 Branch'; 'Combining (unfiltered)'});
        xlim([-50 10])
        
        subplot(1, 2, 2);		
        plot(20*log10(r), q, 20*log10(z), w, 20*log10(n), m);  
        hold on
        plot([xval_rayleigh_f, xval_rayleigh_f], [0.00001, 0.01], 'k', [xval_mrc_f, xval_rayleigh_f], [0.01, 0.01], 'k') 
        
		% Plot details
        set(gca, 'YScale', 'log');
        xlabel('dB Relative to Mean');
        ylabel('Cumulative Property');
        title({'Cumulative Probability Distribution Rayleigh and 2 Branch'; 'Combining (filtered)'});
        legend('Rayleigh', '2 Branch Max Ratio', '2 Branch Selective');
        xlim([-50 0])
	
	
% Question 5

	% ------------------------------------------------------------
	% Measure the diversity gain at the 1% level of significance. 
	% ------------------------------------------------------------

        diversity_r_mrc_u = abs(xval_mrc_u - xval_rayleigh_u)
		diversity_r_sel_u = abs(xval_sel_u - xval_rayleigh_u)
		diversity_mrc_sel_u = abs(xval_mrc_u - xval_sel_u)
		
		% Its interesting to see how much the Selective fading benefits in regards to filtering
		% compared to the unfiltered diversity gain
        diversity_r_mrc_f = abs(xval_mrc_f - xval_rayleigh_f)
		diversity_r_sel_f = abs(xval_sel_f - xval_rayleigh_f)
		diversity_mrc_sel_f = abs(xval_mrc_f - xval_sel_f)
		
% Question 6

	% -----------------------------------------------------------------
	% Repeat 1-5 by creating 3 Rayleigh signals call them a, b and c. 
	% -----------------------------------------------------------------
	
		x3 = randn(100000, 1);
		y3 = randn(100000, 1);
		x3_LPF = filter(LPF, 1, x3);
		y3_LPF = filter(LPF, 1, y3);
		a = abs(x3_LPF + 1i*y3_LPF);
		a_u = abs(x3 + 1i*y3);
		
		x4 = randn(100000, 1);
		y4 = randn(100000, 1);
		x4_LPF = filter(LPF, 1, x4);
		y4_LPF = filter(LPF, 1, y4);
		b = abs(x4_LPF + 1i*y4_LPF);
		b_u = abs(x4 + 1i*y4);
		
		x5 = randn(100000, 1);
		y5 = randn(100000, 1);
		x5_LPF = filter(LPF, 1, x5);
		y5_LPF = filter(LPF, 1, y5);
		c = abs(x5_LPF + 1i*y5_LPF);
		c_u = abs(x5 + 1i*y5);
	
		
	% ------------------------------------------------------------------------------------------------
	% Let x=sqrt(1/3)(a+2b), y=sqrt(1/3)(c+2b). This is an example of partially correlated signals. 
	% See that the diversity gain is less.
	% ------------------------------------------------------------------------------------------------
        
        x = sqrt(1/3 * (a + 2 .* b));
		y = sqrt(1/3 * (c + 2 .* b));
		
        x_u = sqrt(1/3 * (a_u + 2 .* b_u));
		y_u = sqrt(1/3 * (c_u + 2 .* b_u));
		
		% Uncomment to see that the partially correlated signals have a higher mean dB (filtering or no filtering)
		% mean(20*log10(x))
		% mean(20*log10(x_u))
        
        % Correlation value is much closer to 1 (which is linear) than the
        % other gaussian arrays, because these are partially correlated.
        correlation2 = corr2(x, y)
		correlation2_f = corr2(x_u, y_u); % Won't show in console, but it is the same as unfiltered
        
        selective2 = max(x, y);
        mrc2 = sqrt(x.^2 + y.^2);
		
		selective2_u = max(x_u, y_u);
		mrc2_u = sqrt(x_u.^2 + y_u.^2);
        
        figure('Name', 'Question 6: Partially correlated Rayleigh, MRC, and Selective fades')
        set(gcf, 'Position', get(0, 'Screensize'));
		
        subplot(2, 2, 1)
        plot(time(2000:3000), 20*log10(x(2000:3000)), time(2000:3000), 20*log10(y(2000:3000)))
        legend('X', 'Y');
        title('Comparison of two partially correlated Rayleigh distributions')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
        
        subplot(2, 2, 2)
        plot(time(2000:3000), 20*log10(selective2(2000:3000)), time(2000:3000), 20*log10(mrc2(2000:3000)))
        legend('Selection', 'MRC');
        title('Partially correlated Selective fading vs Partially correlated MRC fading')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
        
        subplot(2,2,3);
        plot(time(2000:3000), 20*log10(x(2000:3000)), time(2000:3000), 20*log10(y(2000:3000)), time(2000:3000), 20*log10(selective2(2000:3000)))
        legend('X', 'Y', 'Selection')
        title('Partially correlated Rayleigh fading vs Partially correlated selective fading')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
        
        subplot(2,2,4);
        plot(time(2000:3000), 20*log10(x(2000:3000)), time(2000:3000), 20*log10(y(2000:3000)), time(2000:3000), 20*log10(mrc2(2000:3000)))
        legend('X', 'Y', 'MRC')
        title('Partially correlated Rayleigh fading vs Partially correlated MRC fading')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
        
        figure('Name', 'Question 6: CDF of partially correlated signals')
		set(gcf, 'Position', get(0, 'Screensize'));
		
		% Unfiltered CDF information
		[aa, bb] = ecdf(x_u);
		[cc, dd] = ecdf(mrc2_u);
		[ee, ff] = ecdf(selective2_u);
		loc_ray_part_u = find(aa < 0.010001 & aa > 0.009999);
        xval_rayleigh_part_u = 20*log10(bb(loc_ray_part_u(1))); 
        loc_mrc_part_u = find(cc < 0.010001 & cc > 0.009999);
        xval_mrc_part_u = 20*log10(dd(loc_mrc_part_u(1)));
		loc_sel_part_u = find(ee < 0.010001 & ee > 0.009999);
		xval_sel_part_u = 20*log10(ff(loc_sel_part_u(1)));
		
		% Filtered CDF information
		[r, v] = ecdf(x);
        [l, m] = ecdf(mrc2);
		[h, j] = ecdf(selective2);
        loc_ray_part = find(r < 0.010001 & r > 0.009999);
        xval_rayleigh_part = 20*log10(v(loc_ray_part(1))); 
        loc_mrc_part = find(l < 0.010001 & l > 0.009999);
        xval_mrc_part = 20*log10(m(loc_mrc_part(1)));
		loc_sel_part = find(h < 0.010001 & h > 0.009999);
		xval_sel_part = 20*log10(j(loc_sel_part(1)));
		
		subplot(1, 2, 1);
		semilogy(20*log10(bb), aa, 20*log10(dd), cc, 20*log10(ff), ee);
        hold on
        plot([xval_rayleigh_part_u, xval_rayleigh_part_u], [0.00001, 0.01], 'k', [xval_mrc_part_u, xval_rayleigh_part_u], [0.01, 0.01], 'k') 

        xlabel('dB Relative to Mean');
        ylabel('Cumulative Property');
        title({'Cumulative Probability Distribution Partially Correlated Rayleigh'; 'and 2 Branch Combining (unfiltered)'});
        legend('Rayleigh', '2 Branch Max Ratio', '2 Branch Selective');
        xlim([-15 10]);  
				
		subplot(1, 2, 2);
		semilogy(20*log10(v), r, 20*log10(m), l, 20*log10(j), h);
        hold on
        plot([xval_rayleigh_part, xval_rayleigh_part], [0.001, 0.01], 'k', [xval_mrc_part, xval_rayleigh_part], [0.01, 0.01], 'k') 

        xlabel('dB Relative to Mean');
        ylabel('Cumulative Property');
        title({'Cumulative Probability Distribution Partially Correlated Rayleigh'; 'and 2 Branch Combining (filtered)'});
        legend('Rayleigh', '2 Branch Max Ratio', '2 Branch Selective');
        xlim([-20 0]);  
        
        % Partial correlation diversity gain is much less than uncorrelated gain
        diversity_r_mrc_part = xval_mrc_part - xval_rayleigh_part
        diversity_r_sel_part = xval_sel_part - xval_rayleigh_part
        diversity_mrc_sel_part = xval_mrc_part - xval_sel_part
        
% Extra Credit

        db_thresh = -20;
        Cross_N_PD(20*log10(ray1_f(2000:3000)), db_thresh, 1); 
        figure('Name', 'Extra Credit: Ray1 and threshhold')
        set(gcf, 'Position', get(0, 'Screensize'));
        plot(time(2000:3000), 20*log10(ray1_f(2000:3000)), 'r')
        title('Raleigh Distribution (ray1) with filtering and Level of Crossing')
        xlabel('Time (in seconds)')
        ylabel('Decibels (dB)')
        
        hold on; % DB Threshold line
        plot([2, 3], [db_thresh, db_thresh])
        
		function  [CN_PD, AFD] = Cross_N_PD(x, L, ts)
			% This function takes three variables:
			%    x: Rayleigh vector
			%    L: Level of crossing (in dB)
			%    ts: sampling time (in seconds)
			% This function returns two variables:
			%    CN_PD: number of times the Level is crossed in Positive direction
			%    AFD  : Average fade duration (in milliseconds)
			AFD = 0;
			b = double(x < L);
			c = b;
			for k = length(b): -1 : 2
				if b(k) == 1 & b(k-1) == 1
				   c(k-1) = 0;
				end
			end
			CN_PD = sum(c)
			AFD = (sum(b)) .* ts ./ sum(c)         
        end
        
        
        
        
        