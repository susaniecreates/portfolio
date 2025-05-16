%% ODE Lab: Creating your own ODE solver in MATLAB
%
% In this lab, you will write your own ODE solver for the Improved Euler 
% method (also known as the Heun method), and compare its results to those 
% of |ode45|.
%
% You will also learn how to write a function in a separate m-file and 
% execute it.
% 
% Opening the m-file lab3.m in the MATLAB editor, step through each
% part using cell mode to see the results.  Compare the output with the
% PDF, which was generated from this m-file.
%
% There are six (6) exercises in this lab that are to be handed in on the
% due date. Write your solutions in the template, including
% appropriate descriptions in each step. Save the .m files and submit them 
% online on Quercus.
%
%% Student Information
%
% Student Name: Zarah Mathew
% Student Number: 1009967120
%

%% Creating new functions using m-files.
%  
% Create a new function in a separate m-file:
%
% Specifics:  Create a text file with the file name f.m
% with the following lines of code (text):
%
%  function y = f(a,b,c) 
%  y = a+b+c;
%
% Now MATLAB can call the new function f (which simply accepts 3 numbers
% and adds them together).  
% To see how this works, type the following in the matlab command window:
% sum = f(1,2,3)

%% Exercise 1
%
% Objective: Write your own ODE solver (using the Heun/Improved Euler
% Method).
%
% Details: This m-file should be a function which accepts as variables 
% (t0,tN,y0,h), where t0 and tN are the start and end points of the 
% interval on which to solve the ODE, y0 is the initial condition of the
% ODE, and h is the stepsize.  You may also want to pass the function into
% the ODE the way |ode45| does (check lab 2).
%
% Note: you will need to use a loop to do this exercise.  
% You will also need to recall the Heun/Improved Euler algorithm learned in lectures. 
%


%A new m file IEM.m was created to make this function. 
%% Exercise 2
%
% Objective: Compare Heun with |ode45|.
%
% Specifics:  For the following initial-value problems (from lab 2, 
% exercises 1, 4-6), approximate the solutions with your function from
% exercise 1 (Improved Euler Method).
% Plot the graphs of your Improved Euler Approximation with the |ode45| 
% approximation.
%
% (a) |y' = y tan t + sin t, y(0) = -1/2| from |t = 0| to |t = pi|
%
% (b) |y' = 1 / y^2 , y(1) = 1| from |t=1| to |t=10|
%
% (c) |y' =  1 - t y / 2, y(0) = -1| from |t=0| to |t=10|
%
% (d) |y' = y^3 - t^2, y(0) = 1| from |t=0| to |t=1|
%
% Comment on any major differences, or the lack thereof. You do not need
% to reproduce all the code here. Simply make note of any differences for
% each of the four IVPs.

%Code used to compare the two methods.
    % Defining the inline function
    %f = @(t,y) (y.^3) - (t.^2);
    
    % Initial condition and time range
    %t0 = 0;
    %tN = 1;
    %y0 = 1;
    %h = 0.1;
    
    % Solving using the Improved Euler's method
    %[t_iem, y_iem] = IEM(f, t0, tN, y0, h);
    
    % Solving using ode45 for comparison
    %[t_ode45, y_ode45] = ode45(f, [t0 tN], y0);
    
    % Plot the results
    %figure;
    %plot(t_iem, y_iem, 'DisplayName', 'IEM');
    %hold on;
    %plot(t_ode45, y_ode45, 'DisplayName', 'ode45');
    %hold off;
    %xlabel('t');
    %ylabel('y');
    %legend;
    %title('Comparison of Heun Method and ode45');

%For a), the graphs are very similar with no major differences within the
%interval [0, pi]. However, there is a kink at t = 1.6 in the IEM Graph.
%For b), the two graphs produced illustrate no major differences within the interval [1, pi]
%For c), the two graphs produced illustrate no major differences
%within the interal [0,10].
%For d),there are major differences between the two graphs produced. The
%ode45 graph stops at t = 0.5 (this is expected, as in Lab 2, we observed
%that it blew up to infinity at t = 0.5). However, the graph using the
%improved euler's method continues its plot till t = 0.8, indicating
%improvement. 


%% Exercise 3
%
% Objective: Use Euler's method and verify an estimate for the global error.
%
% Details: 
%
% (a) Use Euler's method (you can use
% euler.m from iode) to solve the IVP
%
% |y' = 2 t sqrt( 1 - y^2 )  ,  y(0) = 0|
%
% from |t=0| to |t=0.5|.
%
% (b) Calculate the solution of the IVP and evaluate it at |t=0.5|.
%
% (c) Read the attached derivation of an estimate of the global error for 
%     Euler's method. Type out the resulting bound for En here in
%     a comment. Define each variable.
%
% (d) Compute the error estimate for |t=0.5| and compare with the actual
% error.
%
% (e) Change the time step and compare the new error estimate with the
% actual error. Comment on how it confirms the order of Euler's method.


%a) A new m file EM.m was created to make this function.

%b) 
% Solving the differential equation using Separation. 
% The general solution is arcsin(y) = t^2 + C
% At initial condition y(0) = 0, C = 0, hence, the solution is arcsin(y) = t^2 

%arcsin(y) = t^2 ; y = sin(t^2)
% At t = 0.5,
% y = sin(0.5^2)
%Therefore, y = 0.2474;

%Graphing the Euler's method and exact solution 

%Defining the inline function
f = @(t, y) 2 * t * sqrt(1 - y^2);

t0 = 0;
y0 = 0;
tN = 0.5;
h = 0.01;

[t,y] = EM(f, t0, tN, y0, h);

x_exact = linspace(t0, tN);
y_exact = sin(x_exact.^2);
plot(t,y,x_exact, y_exact);
legend("Euler", "Exact");

xlabel("t");
ylabel("y");

%c)
%The global error is bounded by (exp(M*Δt*n) -1)/M*Δt/
%We multiply this by ((M+M^2)/2)*(Δt)^2.
%We get the resulting bound En = Δt*(exp(M*Δt*n)-1)(1+M)/2 where,
%En is the absolute error at step n, 
%M is the upper bound on the derivatives of the function f and its partial
%derivatives. This means |f| <= M, |df/dt| <= M, and |df/dy| <= M, 
%Δt is the step size, and
%n is the number of steps.

%d)
% Computing the error estimate when t = 0.5. Assume step size Δt = 0.01. We
% must find the bounds on f, df/dt, and df/dy. 

%Bounds on f 
% f = 2*t*sqrt(1-y^2). sqrt(1-y^2) reaches its maximum value when y = 0. 
% It is important to note that |sqrt(1-y^2)| <=1.
% Hence, when y = 0, at t = 0.5, 
% |f(t,y)| = |2*0.5*sqrt(1)| <= 1

%Bounds on df/dt
%f_dt = 2*sqrt(1-y^2). Therefore, |df/dt| <= 2

%Bounds of df/dy
%f_dy = -(2*t*y)/sqrt(1-y^2). Therefore, given|sqrt(1-y^2)| <=1, |df/dy| <=
%1

%Given these points, we can conservatively choose M = 2.

% E_n <= Δt*(exp(M*Δt*n)-1)(1+M)/2
%     <= 0.01*(exp(2*0.5)-1)*(1+2)/2
% E_n <= 0.02577;

%Calculating the actual error
%Exact solution at t = 0.5 : 0.247404
%Estimated solution from Euler's method at t = 0.5 : 0.242672
% actual error = abs(0.247404-0.242672) = 0.004732

%The actual error is lower than the calculated error.

%e)
% Let's take h = 0.001
% actual error = abs(0.247404-0.246932) = 0.000472

% This demonstrates that  step size is proportional to actual
% error. This is expected for Euler's method as the more specific step size
% is, the more accurate the solution is. 

%% Adaptive Step Size
%
% As mentioned in lab 2, the step size in |ode45| is adapted to a
% specific error tolerance.
%
% The idea of adaptive step size is to change the step size |h| to a
% smaller number whenever the derivative of the solution changes quickly.
% This is done by evaluating f(t,y) and checking how it changes from one
% iteration to the next.

%% Exercise 4
%
% Objective: Create an Adaptive Euler method, with an adaptive step size |h|.
%
% Details: Create an m-file which accepts the variables |(t0,tN,y0,h)|, as 
% in exercise 1, where |h| is an initial step size. You may also want to 
% pass the function into the ODE the way |ode45| does.
%
% Create an implementation of Euler's method by modifying your solution to 
% exercise 1. Change it to include the following:
%
% (a) On each timestep, make two estimates of the value of the solution at
% the end of the timestep: |Y| from one Euler step of size |h| and |Z| 
% from two successive Euler steps of size |h/2|. The difference in these
% two values is an estimate for the error.
%
% (b) Let |tol=1e-8| and |D=Z-Y|. If |abs(D)<tol|, declare the step to be
% successful and set the new solution value to be |Z+D|. This value has
% local error |O(h^3)|. If |abs(D)>=tol|, reject this step and repeat it 
% with a new step size, from (c).
%
% (c) Update the step size as |h = 0.9*h*min(max(tol/abs(D),0.3),2)|.
%
% Comment on what the formula for updating the step size is attempting to
% achieve.



%A new m file AEM.m was created to make this function. 

%The goal of the adaptive euler method is to adjust the step size to
%increase accuracy and control error dynamically as it takes larger steps where possible
%and smaller steps where necessary. The most h can be decreased is
%0.9*h*0.3 = 0.27h while the least h can be decreased is 0.9 * h = 0.9h.
%% Exercise 5
%
% Objective: Compare Euler to your Adaptive Euler method.
%
% Details: Consider the IVP from exercise 3.
%
% (a) Use Euler method to approximate the solution from |t=0| to |t=0.75|
% with |h=0.025|.
%
% (b) Use your Adaptive Euler method to approximate the solution from |t=0| 
% to |t=0.75| with initial |h=0.025|.
%
% (c) Plot both approximations together with the exact solution.

t0 = 0;
y0 = 0;
tN = 0.75;
h = 0.025;
f = @(t,y) 2*t*sqrt(1-y^2);
%a) Using Euler's method to approximate the solution
[t1,y1] = EM(f, t0, tN, y0, h);

%b) Using Adaptive Euler's method to approximate the solution
[t2,y2] = AEM(f, t0, tN, y0, h);
x_exact = linspace(t0, tN);
y_exact = sin(x_exact.^2);
plot(t1, y1, t2, y2, x_exact, y_exact);

%c) Plotting the solution 
legend("Euler", "Adaptive Euler", "Exact");
xlabel("t");
ylabel("y");

%% Exercise 6
%
% Objective: Problems with Numerical Methods.
%
% Details: Consider the IVP from exercise 3 (and 5).
% 
% (a) From the two approximations calculated in exercise 5, which one is
% closer to the actual solution (done in 3.b)? Explain why.
% 
% (b) Plot the exact solution (from exercise 3.b), the Euler's 
% approximation (from exercise 3.a) and the adaptive Euler's approximation 
% (from exercise 5) from |t=0| to |t=1.5|.
%
% (c) Notice how the exact solution and the approximations become very
% different. Why is that? Write your answer as a comment.

%a) It is important to note that the graph produced from the adaptive
% euler's method is so close to the exact solution that you can not see it
%on the graph. It is only when you zoom in, you can see Adaptive Euler
%Solution Graph. This is due to the local error of 1e-8, which is a very
%small number.This proves that given the two approximations calculated in exercise 5, 
%the adaptive euler's solution is closer to the actual solution. 

%b)

f = @(t, y) 2 * t * sqrt(1 - y^2);
y0 = 0;
t0 = 0;
tN = 1.5;
h = 0.025;

[t1,y1] = AEM(f, t0, tN, y0, h);
[t2,y2] = EM(f, t0, tN, y0, h);
x_exact = linspace(t0, tN);
y_exact = sin(x_exact.^2);
plot(t1, y1, t2, y2, x_exact, y_exact);

legend("Adaptive Euler", "Euler", "Exact");
xlabel("t");
ylabel("y");

%c)The three solutions are visible and start to diverge at t = 1.25. They
%become increasingly different as time increases. This may be because of
%the different metrics of accuracy for Euler's method and the Adaptive
%Euler's Method. With the Euler's method, each step introduces a local
%error, resulting in a noticeable difference between the varying step sizes
%that the Adaptive Euler's method offers. Additionally, the Adaptive Euler's method has a small local error of 1e-8.
%Regardless, the graph still indicates that the Adaptive Euler's method is closer to the exact 
%solution, proving that its more accurate than the Euler's method.
