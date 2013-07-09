function [xPoints,yPoints] = voronoiEulerMethod(h, endBound, m, determiner)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (determiner == 1)
points = {[0, 1, -1i]};
end 

if (determiner == 0)
points = {[0,1,1i]}; 
end 

 
beta = 1.582; 
alpha = (beta-1)/(beta*m); 

for n = 1:floor(endBound/h) 
    
    leftBoundAlpha = floor(n*alpha)+1; 
    delayPointAlpha = points{leftBoundAlpha}; 
    leftBoundBeta = floor(n/beta)+1; 
    delayPointBeta = points{leftBoundBeta}; 
    
    newX = n*h; 
    newY = points{n}(2) + h*points{n}(3); 
    
    delayYAlpha = (n*h*alpha - floor(n*alpha)*h)*delayPointAlpha(3) + delayPointAlpha(2); 
    delayYbeta = (n*(h/beta) - floor(n/beta)*h)*delayPointBeta(3)+delayPointBeta(2); 
    
    newSlope = (1/(n*h))*(delayYbeta^2 + m*newY*(delayYAlpha)^2 - (m+1)*newY); 
    
    if (n < floor(endBound/h))
    points{n+1} = [newX, newY, newSlope]; 
    end

end

if (determiner == 0) 
xPoints = - points{1}(1);
end  

if (determiner == 1) 
xPoints = points{1}(1);
end  

for i = 2:length(points)
    
   if (determiner == 0)
   xPoints(i) = - points{i}(1); 
   end 

   if (determiner == 1)
   xPoints(i) = points{i}(1); 
   end 
 
   yPoints(i) = points{i}(2); 
 
end

if (determiner == 0) 
xPoints = fliplr(xPoints);
yPoints = fliplr(yPoints); 
end 
 

end

