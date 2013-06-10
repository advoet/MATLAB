function [movie] = vSim(points, simlength)
    %%Constructs a 3x3 grid of identical points and its veronoi diagram.
    %Takes as its first argument the number of points (will be duplicated
    %9 times) and its second argument the simulation length (# of points
    %to take away

    %%TODO:
    % Figure out how to determine neighboring points (self email re:
    % neighbors?)
    % Rather than delete a point, merge neighboring points into a middle point
    % Keep track of areas of cells (self email stackexchange?)
    % Try to look into faster voronoi updates since only neighbors &
    % neighbors of neighbors are affected by removal
    

    [X,Y] = voronoiPrep(points);

    k=simlength;
    
    %movie initialization?
    
    display(length(X))
    
    
    voronoi(X,Y);
    movie(1) = getframe;
    
    for i = 1:simlength
        
        %number of original points
        points = length(X)/9 ;
        
        %index of point to remove
        point = round(rand(1)*points);
        
        if point == 0
            point = 1;
        elseif point == points
            point = points - 1;
        end

        %loop through periodically and remove each corresponding point
        %TODO: merge surrounding points into one point in the middle
        for j = 1:9
            X(point+(j-1)*points - (j-1)) = [];
            Y(point+(j-1)*points - (j-1)) = [];
        end
        
       
        voronoi(X,Y);
        
        movie(i+1) = getframe;    
        
    end

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