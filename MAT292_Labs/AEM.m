function [t,y] = AEM(f,t0,tN,y0,h)
    t = [];
    y = [];
    y(1) = y0;
    t(1) = t0;
    
    n = 1;
    while t(n) < tN
        % Single Euler step with step size h
        Y = y(n) + h * f(t(n), y(n)); 
        
        % Two Euler steps with half the step size (h/2)
        Z_half = y(n) + (h/2) * f(t(n), y(n)); % First step with step size h/2
        Z = Z_half + (h/2) * f(t(n) + (h/2), Z_half); % Second step with step size h/2

        tol = 1e-8;
        D = Z-Y;
        if abs(D) < tol
            %This solution is successful
            y(n+1) = abs(Z+D); % local error O(h^3)
            t(n+1) = t(n)+h;
            n = n + 1;
        else %(abs(D) >= tol)
           h = 0.9*h*min(max(tol/abs(D),0.3),2);
        end    
    end
end


