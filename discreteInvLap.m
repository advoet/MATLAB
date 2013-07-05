function [f] = discreteInvLap(x,y,minx,maxx,numsteps)
   const = 1/(2*pi);
   f = zeros(numsteps,2);
   stepsize = (maxx-minx)/numsteps;
   index =1;
   for t = minx:stepsize:maxx
      val = const*sum( exp(t*x).*y);    
      f(index,:) = [t,val];
      index = index + 1;
   end
end
