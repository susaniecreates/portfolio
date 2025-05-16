function [t, y] = IEM(f, t0, tN, y0, h) 

    t = t0:h:tN; 
    y = zeros(1, length(t));

    % Setting the initial condition
    y(1) = y0; 

    % Iterate over time steps using the Improved Euler method
    for n = 1:(length(t)-1)
        % Estimating intermediate y
        y_int = y(n) + h * f(t(n), y(n));
        
        % Corrector step: compute the next value of y
        y(n+1) = y(n) + (h/2) * (f(t(n), y(n)) + f(t(n+1), y_int));
    end
end