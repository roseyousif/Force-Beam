function M_at_d = calculateBendingMoment(h, d, Fc, c, b, Fa,a)
    % Inputs:
    % h   Step size for discretization
    % d   Position at which to compute the bending moment
    % Fc  Magnitude of the applied force
    % c   Position where the force is applied
    % b   Length of the beam
    % Fa  Reaction force at the left support
    
    % Define the x positions for calculation based on the given step size
    xused = a:h:b;         % x positions from 0 to b with step size h 
    
    % Compute the shear force at each x position
    V = zeros(size(xused)); % Shear force vector
    for i = 1:length(xused)
        if xused(i) < c
            V(i) = Fa;         % Shear force before the point of application
        else
            V(i) = Fa - Fc;    % Shear force after the point of application
        end
    end
    
    V_interp = interp1(xused, V, d, 'linear');  % Interpolating the shear force at point d
    
    % Apply the trapezoidal rule to calculate the bending moment at 'd'
    M = 0;  % Initialize bending moment at the start
    for i = 2:length(xused)
        if xused(i) > d %the code will stop the moment M is calculated at d
            break;
        end
        M = M + (h / 2) * (V(i) + V(i-1));  % Trapezoidal rule to accumulate bending moment
    end
    
    % Return the bending moment at the specified position 'd'
    M_at_d = M;
end