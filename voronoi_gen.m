function [ output_args ] = voronoi_gen( numPoints,steps )
%voronoi_gen(numPoints,steps) will create a movie of creating a random
%       voronoi diagram on numPoints points and removing steps points one
%       at a time.
%   Detailed explanation goes here

    x = rand(numPoints,1);
    y = rand(numPoints,1);
    figure;
    hold on;
    dt = DelaunayTri(x,y);
    voronoi(dt);
    for (i = 0:steps-1)
        %Pick random point
        r = randi(numPoints-i,1);
        x1 = x(r);
        y1 = y(r);
        plot(x1,y1,'ro');
        M(4*i+1)=getframe;

        %get closests neighbor
        x(r)=[];
        y(r)=[];
        dt = DelaunayTri(x,y);
        p = nearestNeighbor(dt,x1,y1);
        x2 = dt.X(p,1);
        y2 = dt.X(p,2);
        plot(x2,y2,'g*');
        M(4*i+2)=getframe;

        %calculate new point
        xnew = .5*(x1+x2);
        ynew = .5*(y1+y2);
        plot(xnew,ynew,'y*')
        x = dt.X(:,1);
        y = dt.X(:,2);
        x(p)=[];
        y(p)=[];
        x = [x;xnew];
        y = [y;ynew];
        M(4*i+3)=getframe;


        hold off;
        dt = DelaunayTri(x,y);
        voronoi(dt);
        hold on;
        M(4*i+4)=getframe;

    end

    %movie(M,1,6)
    %writerObj = VideoWriter(testmerge.a)
end



function [X,Y] = voronoiPrep(points)
% Returns periodic random data set X,Y which represents a 3x3 (1-periodic)
% data set each size "points" (9*points total) centered at the unit square
% (0,0),(1,0),(1,1),(0,1)

    X = zeros(1,points*9);

    X0 = rand(1,points);
    Y0 = rand(1,points);

    X1 = {X0-ones(1,points);X0;X0+ones(1,points)};
    Y1 = {Y0-ones(1,points);Y0;Y0+ones(1,points)};

    iter = 1;
    X2 = cell(1,9);
    Y2 = cell(1,9);

    for i = 1:3
        for j = 1:3
            X2{iter} = X1{i};
            Y2{iter} = Y1{j};
            iter = iter+1;
        end
    end

    X = cell2mat(X2);
    Y = cell2mat(Y2);
end