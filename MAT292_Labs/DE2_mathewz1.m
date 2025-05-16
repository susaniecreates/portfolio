function [t, y] = DE2_mathewz1(p, q, g, t0, tN, y0, y1, h)
    
    % Initializing the conditions
    t = t0:h:tN;
    N = length(t); 
    
    y = zeros(1, N);  
    yy = zeros(1, N); 
    
    % Initial values
    y(1) = y0;
    yy(1) = y1;
    
    %Using Euler's method
    y(2) = y(1) + (yy(1).*h);
    yy(2) = (y(2) - y(1)) ./ h;  

    for n = 2:(N-1)
        p_val = p(t(n));
        q_val = q(t(n));
        g_val = g(t(n));
        
        sderiv_y = g_val - p_val .* yy(n) - q_val .* y(n);
        
        y(n+1) = sderiv_y.*h^2 + 2*y(n) - y(n-1);
        
        yy(n+1) = (y(n+1) - y(n))./h;
    end
end