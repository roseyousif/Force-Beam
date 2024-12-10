function [Fb, Fa] = GE(Fc, c, b)
    % GE calculates the roller reaction forces for a beam in equilibrium
    % Inputs:
    %   Fc  magnitude of the applied force (must be positive)
    %   c  location where the force is applied
    %   b  total length of the beam
    %
    % Outputs:
    %   Fb  reaction force at the right roller
    %   Fa  reaction force at the left roller

    % Calculate the reaction forces using static equilibrium equations
    Fb = (Fc * c) / b;  
    Fa = -Fb + Fc;      
end
