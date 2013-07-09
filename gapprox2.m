function [xvalues, yvalues] = gapprox2()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[X,Y] = voronoiEulerMethod(.01, 10, 8, 0);
[Q,Z] = voronoiEulerMethod(.01, 10, 8, 1);

M = [X,Q]; 
N = [Y,Z];


for z = 0:70 

    zvalue = 0; 

    for j = 1:2000
        
        zvalue = zvalue + (1/(2*pi))* (.01) * real(exp( .01 *(j - 1001)* 1i * (z/10)) * N(j));
        

    end 

    yvalues(z+1) = zvalue; 
    xvalues(z+1) = z/10; 
    
    

end

%figure;
%q = plot(xvalues,yvalues);
%axis([0,1,0,10]); 

end

