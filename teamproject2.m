%INPUT BY THE USER
Fc= 7;        % The external force magnitude 
c = 3;        % where the external force is applied inside the beam 
b = 6;        % Length of the beam 
d = 5;        % a random point where the bending moment is needed and the Error is calculated 

if Fc < 0 || c < 0 || d < 0 || b < 0 || c > b  || d > b
    % all of the values must be positive cause they are only magnitudes
    % the direction is taken care of by the  code also c and d must be
    % inside the beam else the code will not work properly 
    error('Please enter a positive quantity or a point (c, d) inside the beam')
end


% PART I: REACTION FORCES AT THE ROLLERS (point a and b)

a = 0;              % Starting point of the beam 
[Fb, Fa] = GE(Fc, c, b);

%PART II : THE SHEAR FORCE GRAPH

x = a:(10^-5):b;    % x are the points on the beam as a distance from a
V = zeros(size(x)); % Initiating shear force vector

for i = 1:length(x)
   if x(i) < c

       V(i) = Fa;         % Shear force before the point of application
   else
       V(i) = Fa - Fc;    % Shear force after the point of application
   end
end

subplot(2, 2, 1);
plot(x, V, 'r-');
xlabel('Position along the beam (x)');
ylabel('Shear Force (V)');
title('Shear Force Graph');
grid on;





% Part III: THE BENDING MOMENT WITH TTRAPEZOIDAL RULE AND DIFFERENT H VALUES GRAPH 

h = [0.1, 0.01, 10e-5];   % Different step sizes (different stepsizes can be used but the code is limited to plot 3 graphs)
colors = ['r', 'g', 'b']; % Colors for each step size
subplot(2, 2, 2);
hold on;
for z = 1:length(h)
   hused = h(z);              % Current step size
   xused = a:hused:b;         % x positions for current h
   V_interp = interp1(x, V, xused, 'linear');  
 %In this code, the shear force (V) is computed for a very fine grid (x = a:(10^-5):b), but for different step sizes (h),
 %new points (xused = a:hused:b) are introduced. These new points may not align exactly with the original x grid.
 %The interp1 function helps estimate the shear force (V) values at these new points (xused) based on the original data
   M = zeros(size(xused));   % initiating Bending moment vector
  
   % Compute bending moment using trapezoidal rule
   for i = 2:length(xused)
       M(i) = M(i-1) + (hused / 2) * (V_interp(i) + V_interp(i-1));  % Trapezoidal rule
   end
   plot(xused, M, colors(z));
end
xlabel('Position along the beam (x)');
ylabel('Bending Moment (M)');
title('Bending Moment Graph for Different h');
legend('h = 0.1', 'h = 0.01', 'h = 10^{-5}');
grid on;
hold off;

% for different h value there is a different bending moment Graph 



%PART IV: THE BENDING MOMENT WITH DIFFERENT H (STEP SIZES) AT A POINT  d AND COMPARE IT TO THE TRUE VALUE

%calculating the true bending moment by integrating the shear force
% an if statement is used to deal with the improper integral
if d < c
   Mtrue = Fa * d;
else
   Mtrue = Fa * d - Fc * (d - c);
end
disp(Mtrue)

%calculating the error plotting the graph 
Errh=zeros(size(h));  %initiating the error vector
Mtrap=zeros(size(h)); %initiating the bending moment of d that is calculated by the Trapezoidal method
for i=1:length(h)
    Mtrap(i)=calculateBendingMoment(h(i), d, Fc, c, b, Fa,a);
    Errh(i)=abs(Mtrue- Mtrap(i)); %calculating the error

end
subplot(2,2,3)
loglog(h,Errh)
xlabel('h');
ylabel('Error');
title('Error diagram');
grid on;