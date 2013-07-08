
function [fx,fy] = discreteInvLap(x,y,minx,maxx,numsteps)
   const = 1/(2*pi);
   fx = zeros(numsteps,1);
   fy = zeros(numsteps,1);
   stepsize = (maxx-minx)/numsteps;
   index =1;
   for t = minx:stepsize:maxx    
      fx(index) = t;
      fy(index) = const*sum( exp(t*1i*x).*y)*(x(2)-x(1));
      index = index+1;
   end
end
