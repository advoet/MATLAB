function [fx,fy] = discreteLap(x,y,minx,maxx,numsteps)
   
   fx = zeros(numsteps,1);
   fy = zeros(numsteps,1);
   stepsize = (maxx-minx)/numsteps;
   index =1;
   for t = minx:stepsize:maxx
      fx(index) = t;
      fy(index) = sum( exp(-t*x).*y)*(x(2)-x(1));
      index = index + 1;
   end
end
