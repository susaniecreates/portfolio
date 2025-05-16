function [t, y] = EM(f, t0, tN, y0, h) 

    t = t0:h:tN; 
    y = zeros(1, length(t));

    % Setting the initial condition
    y(1) = y0; 

    % Iterate over time steps using the Improved Euler method
    for n = 1:(length(t)-1)
        y(n+1) = y(n) + h*f(t(n), y(n));
    end
end