function M = cutandpaste(option, r, delta, d, X)

% outputs a movie M which shows either
% probability density funtion f(t,x)/N(t) (if option = 1)
% rescaled funtion 1/N(t)^2 f(t,x/N(t))  (if option = 2)
% at each time step. 

% input:  (e.g. suami1D(2, 0.25, 0.1, rand(1,10000))
% option = 1 or option = 2 as described above
% r is the fraction of intervals remaining 
% when the movie stops.
% delta is the bin width for each plot
% d is the number of pieces
% X is a vector, where X(i) represents the
% distance between adjacent nodes x_i and x_{i+1}


K = length(X);
n = floor(K*(1-r));
g0 = 1/(sum(X)/K);

%[C, D] = trapezoidG(g0, 4, 50000);



% remove a node at each step
for j = 1:n
 
    L = length(X);
    q = 1 + floor(L .* rand(1,1));
    c = X(q)/d;
    X(q) = [];
    
    for i = 1:d
        L = length(X);
        q = 1 + floor((L + 1 - i) .* rand(1,1));
        X(L+1) = X(q) + c;
        X(q) = [];
    end
   

% capture every tenth frame    
if 1 == mod(j,10)    
J = 1 + (j-1)/10;    

% m represents N(t)/N(0) (following the setup of Pego and Carr)
m = 1 - j/K

if option == 1

    N = ceil(max(X)/delta);
    Z = delta/2:delta:(N -1/2)*delta;
    G = (1/(delta*K*m))*hist(X,Z);
    a = delta*Z*G'

    else if option == 2

        N = ceil(max(X)*m/delta);
        Z = delta/2:delta:(N -1/2)*delta;
        U = 1/m*delta/2:1/m*delta:(N -1/2)*1/m*delta;
        G = (1/(delta*K*m))*hist(X,U);
        a = delta*Z*G'
    end
end

hold off;
%bar(Z,G);
%plot(C,D, 'r');
Y = g0*exp(-g0*Z);
plot(Z,Y, 'r')
hold on;
plot(Z,G);
axis([0 4 0 2]);
M(J) = getframe;
end

end

end