%% Laplace Transform Lab: Solving ODEs using Laplace Transform in MATLAB
%
% This lab will teach you to solve ODEs using a built in MATLAB Laplace 
% transform function |laplace|.
%
% There are five (5) exercises in this lab that are to be handed in.  
% Write your solutions in a separate file, including appropriate descriptions 
% in each step.
%
% Include your name and student number in the submitted file.
%
%% Student Information
%
%  Student Name: Zarah Mathew
%
%  Student Number: 1009967120
%

%% Using symbolic variables to define functions
% 
% In this exercise we will use symbolic variables and functions.

syms t s x y

f = cos(t)
h = exp(2*x)


%% Laplace transform and its inverse

% The routine |laplace| computes the Laplace transform of a function

F=laplace(f)

%%
% By default it uses the variable |s| for the Laplace transform
% But we can specify which variable we want:

H=laplace(h)
laplace(h,y)

% Observe that the results are identical: one in the variable |s| and the
% other in the variable |y|

%% 
% We can also specify which variable to use to compute the Laplace
% transform:

j = exp(x*t)
laplace(j)
laplace(j,x,s)

% By default, MATLAB assumes that the Laplace transform is to be computed
% using the variable |t|, unless we specify that we should use the variable
% |x|

%% 
% We can also use inline functions with |laplace|. When using inline
% functions, we always have to specify the variable of the function.

l = @(t) t^2+t+1
laplace(l(t))

%% 
% MATLAB also has the routine |ilaplace| to compute the inverse Laplace
% transform

ilaplace(F)
ilaplace(H)
ilaplace(laplace(f))

%% 
% If |laplace| cannot compute the Laplace transform, it returns an
% unevaluated call.

g = 1/sqrt(t^2+1)
G = laplace(g)

%% 
% But MATLAB "knows" that it is supposed to be a Laplace transform of a
% function. So if we compute the inverse Laplace transform, we obtain the
% original function

ilaplace(G)

%%
% The Laplace transform of a function is related to the Laplace transform 
% of its derivative:

syms g(t)
laplace(diff(g,t),t,s)


%% Exercise 1
%
% Objective: Compute the Laplace transform and use it to show that MATLAB
% 'knows' some of its properties.
%
% Details:  
%
% (a) Define the function |f(t)=exp(2t)*t^3|, and compute its Laplace
%   transform |F(s)|.
% (b) Find a function |f(t)| such that its Laplace transform is
%   |(s - 1)*(s - 2))/(s*(s + 2)*(s - 3)|
% (c) Show that MATLAB 'knows' that if |F(s)| is the Laplace transform of
%   |f(t)|, then the Laplace transform of |exp(at)f(t)| is |F(s-a)| 
% 
% (in your answer, explain part (c) using comments).      
%
% Observe that MATLAB splits the rational function automatically when
% solving the inverse Laplace transform.


%a)
f1(t) = exp(2*t)*t^3;
%Computing its Laplace Transform 
laplace(f1) %Answer: F(s) = 6/(s-2)^4



%b)
f2(t) = ((s-1)*(s-2))./(s*(s+2)*(s-3));
ilaplace(f2) %Answer f(t) = (6*exp(-2*t))/5 + (2*exp(3*t))/15 - 1/3

%c)
syms f3(t) a s t;
F(s) = laplace(f3(t));
laplace(exp(a*t)*f3(t), t, s)
% MATLAB "knows" to take the Laplace transform of f3(t).  The third output
% s-a indicates that whenever we get F(s), F(s-a) is the final answer

%% Heaviside and Dirac functions
%
% These two functions are builtin to MATLAB: |heaviside| is the Heaviside
% function |u_0(t)| at |0|
%
% To define |u_2(t)|, we need to write

f=heaviside(t-2)
ezplot(f,[-1,5])

% The Dirac delta function (at |0|) is also defined with the routine |dirac|

g = dirac(t-3)

% MATLAB "knows" how to compute the Laplace transform of these functions

laplace(f)
laplace(g)


%% Exercise 2
%
% Objective: Find a formula comparing the Laplace transform of a 
%   translation of |f(t)| by |t-a| with the Laplace transform of |f(t)|
%
% Details:  
%
% * Give a value to |a|
% * Let |G(s)| be the Laplace transform of |g(t)=u_a(t)f(t-a)| 
%   and |F(s)| is the Laplace transform of |f(t)|, then find a 
%   formula relating |G(s)| and |F(s)|
%
% In your answer, explain the 'proof' using comments.


clear all; 
syms a s f(t) t;
a = 7; 
G(s) = laplace(heaviside(t-a)*f(t-a), t, s) %Answer: exp(-7*s)*laplace(f(t), t, s) = exp(-as)*F(s)
F(s) = laplace(f(t), t, s) %Answer: laplace(f(t), t, s) = F(s)
G(s)/F(s) %Answer: exp(-7*s)



%% Solving IVPs using Laplace transforms
%
% Consider the following IVP, |y''-3y = 5t| with the initial
% conditions |y(0)=1| and |y'(0)=2|.
% We can use MATLAB to solve this problem using Laplace transforms:

% First we define the unknown function and its variable and the Laplace
% tranform of the unknown

syms y(t) t Y s

% Then we define the ODE

ODE=diff(y(t),t,2)-3*y(t)-5*t == 0

% Now we compute the Laplace transform of the ODE.

L_ODE = laplace(ODE)

% Use the initial conditions

L_ODE=subs(L_ODE,y(0),1)
L_ODE=subs(L_ODE,subs(diff(y(t), t), t, 0),2)

% We then need to factor out the Laplace transform of |y(t)|

L_ODE = subs(L_ODE,laplace(y(t), t, s), Y)
Y=solve(L_ODE,Y)

% We now need to use the inverse Laplace transform to obtain the solution
% to the original IVP

y = ilaplace(Y)

% We can plot the solution

ezplot(y,[0,20])

% We can check that this is indeed the solution

diff(y,t,2)-3*y


%% Exercise 3
%
% Objective: Solve an IVP using the Laplace transform
%
% Details: Explain your steps using comments
%
%
% * Solve the IVP
% *   |y'''+2y''+y'+2*y=-cos(t)|
% *   |y(0)=0|, |y'(0)=0|, and |y''(0)=0|
% * for |t| in |[0,10*pi]|
% * Is there an initial condition for which |y| remains bounded as |t| goes to infinity? If so, find it.

syms y(t) t Y s;

%Defining the ODE
ODE = diff(y(t), t, 3) + 2*diff(y(t), t, 2) + diff(y(t), 1) + 2*y(t) == -cos(t);

%Computing the Laplace transform of the ODE
L_ODE = laplace(ODE);

%Using the inital conditions
L_ODE = subs(L_ODE, y(0), 0);
L_ODE = subs(L_ODE,subs(diff(y(t), t), t, 0),0);
L_ODE = subs(L_ODE, subs(diff(y(t), t, 2), t, 0), 0);


%Factoring out the Laplace transform of |y(t)|
L_ODE = subs(L_ODE, laplace(y(t), t, s), Y);
Y = solve(L_ODE, Y);

%Using the inverse Laplace transform to obtain the solution
y(t) = ilaplace(Y);

%Plotting the solution:
ezplot(y, [0,20]);


%Checking if this is the actual solution:
answerone = diff(y(t), t, 3) + 2*diff(y(t), t, 2) + diff(y(t), t) + 2*y(t)
g(t) = (t*cos(t))/10 - (t*sin(t))/5;
answertwo = diff(g(t), t, 3) + 2*diff(g(t), t, 2) + diff(g(t), t) + 2*g(t)

%It is -cos(t)! 
%There is no inital condition for which y remains bounded as t goes to
%infinity. 

%% Exercise 4
%
% Objective: Solve an IVP using the Laplace transform
%
% Details:  
% 
% * Define 
% *   |g(t) = 3 if 0 < t < 2|
% *   |g(t) = t+1 if 2 < t < 5|
% *   |g(t) = 5 if t > 5|
%
% * Solve the IVP
% *   |y''+2y'+5y=g(t)|
% *   |y(0)=2 and y'(0)=1|
%
% * Plot the solution for |t| in |[0,12]| and |y| in |[0,2.25]|.
%
% In your answer, explain your steps using comments.


syms y(t) t Y s;

%Defining the ODE
g(t)= 3*heaviside(t) + (t-2)*heaviside(t-2) + (4-t)*heaviside(t-5);
ODE = diff(y(t), t, 2) + 2*diff(y(t), t, 1) + 5*y(t) == g(t);

L_ODE = laplace(ODE);

%Using the inital conditions
L_ODE = subs(L_ODE, y(0), 2);
L_ODE = subs(L_ODE,subs(diff(y(t), t), t, 0),1);



%Factoring out the Laplace transform of |y(t)|
L_ODE = subs(L_ODE, laplace(y(t), t, s), Y);
Y = solve(L_ODE, Y);

%Using the inverse Laplace transform to obtain the solution
y(t) = ilaplace(Y);

%Plotting the solution:
ezplot(y, [0,12, 0,2.25]);


%% Exercise 5
%
% Objective: Use the Laplace transform to solve an integral equation
% 
% Verify that MATLAB knowns about the convolution theorem by explaining why the following transform is computed correctly.
syms t x y(x) s
I = int(sin(t - x) * y(x), x, 0, t);
laplace(I,t,s) 
%The answer is given as: laplace(y(t), t, s)/(s^2 + 1).
%The Laplace transform is 1/(s^2 + 1). By the convolution theorem, the
%Laplace transform of the integral is the product of the individual laplace
%transforms of sin(t) and y(t). So L_integral = laplace(y(t), t, s)/(s^2 +
%1), which is proven by the code above. 
