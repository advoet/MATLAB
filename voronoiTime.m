function [X,Y2,Y3] = voronoiTime(k)

X = 10:3:k;
Y1 = zeros(size(X));
Y2 = zeros(size(X));
Y3 = zeros(size(X));

m=1;

for i = 10:3:k
   %tic
   %voronoinAreaSim(i,floor(.8*i));
   %Y1(m) = toc;
   
   tic
   voronoinAreaSim2(i,floor(.8*i));
   Y2(m) = toc;
   
   tic
   voronoinAreaSim3(i,floor(.8*i));
   Y3(m) = toc;
   
   m=m+1;
end


hold on

plot(X,Y1,'b');
plot(X,Y2,'r');
plot(X,Y3,'g');



end

