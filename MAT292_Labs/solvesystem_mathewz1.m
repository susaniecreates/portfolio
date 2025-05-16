
function [t, x1, x2] = solvesystem_mathewz1(f, g, t0, tN, x0, h)
    t = t0:h:tN; 
    x1 = zeros(1, length(t));
    x2 = zeros(1, length(t));

    % Setting the initial conditions
    x1(1) = x0(1); 
    x2(1) = x0(2);

    % Iterate over time steps using the Improved Euler method
    for n = 1:(length(t)-1)
        % Predictor step: estimate intermediate values
        x1_int = x1(n) + h * f(t(n), x1(n), x2(n));
        x2_int = x2(n) + h * g(t(n), x1(n), x2(n));

        % Corrector step: compute the next values
        x1(n+1) = x1(n) + (h/2) * (f(t(n), x1(n), x2(n)) + f(t(n+1), x1_int, x2_int));
        x2(n+1) = x2(n) + (h/2) * (g(t(n), x1(n), x2(n)) + g(t(n+1), x1_int, x2_int));
    end
end
