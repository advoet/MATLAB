function [ m ] = graphDensity(Areas)
%input a cell array




dx = 1/(2*length(Areas{1}));

for i = 1:length(Areas)

    area = Areas{i};
    %Y = hist(area,buckets);
    %[N,X] = hist(area,buckets);
    %plot(X,Y)
    X = 0:dx:1;

    y = hist(area,X);

    y = y./ (dx*length(area));

    bar(X,y);

    
    %consider making the x bound some multiple of the expected area size
    %remaining for the number of points at the end (i.e
    %1/length(Areas{length(Areas)})
    axis([0, .04, ...
        0,.7*length(Areas{1})]);
    
    
    pause(.1);
    %m(i) = getframe();
    
    
end





end