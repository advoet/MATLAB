function [Areas] = voronoinAreaSim(numpoints,timesteps)
%% Returns a (1 x timesteps) cell array, each cell of which contiains an
%%array consisting of all of the areas of individual cells in the voronoi
%%diagram followed by a trail of -1's (representing areas that had a
%%vertex at infinity)

%% Description
% Constructs a voronoi diagram with (numpoints) points, then for each
% timestep performs a merging procedure by randomly selecting a point and
% one of its neighbors to combine. These two points are replaced by a
% midpoint to simulate droplets of water merging to form a larger droplet.

import containers.Map;

    Areas = cell(1,timesteps);

    %points_left = numpoints;
    %x = rand(points_left,1);
    
    x = .025:.05:.975;
    y = .025:.05:.975;
    
    [x,y] = meshgrid(x,y);
    
    x = x(:);
    y = y(:);
    
    %y = rand(points_left,1);

    points = [x,y];


    %timestep looping procedure
    for i = 1:timesteps
          
        
        %% BORROWED CELL AREA CODE USING BOUNDED SQUARE
        
        
        [CellArea, dt] = SquareBV(points(:,1),points(:,2),0,[0,1,0,1]);
        Areas{i} = CellArea;
        
        
        %% NEIGHBOR GETTING CODE
        % creates a set (each entry unique) of neighbor pairs (edge connecting
        % the two vertices) in the delaunay triangulation. Each neighbor
        % pair corresponds to vertices whose cells share a point in the
        % voronoi diagram. Then selects a random neighbor pair to remove
        % from the set of points and in place adds it's midpoint
        
        neighborSet = containers.Map();
        for k = 1:length(dt)
            for j = 1:3
                vertex1 = dt.Triangulation( k,(mod(j,3)+1));
                vertex2 = dt.Triangulation(k,mod(j+1,3)+1);
                if(vertex1<vertex2)
                    neighborSet(strcat(int2str(vertex1),',',int2str(vertex2))) = [vertex1,vertex2];
                else
                    neighborSet(strcat(int2str(vertex2),',',int2str(vertex1))) = [vertex2,vertex1];
                end
            end
        end
        
        keySet = keys(neighborSet);
       
        pair_to_remove = randi(length(keySet));
        
        pair = values(neighborSet,keySet(pair_to_remove));
        
        vertex1 = pair{1}(1);
        vertex2 = pair{1}(2);
        
        
        x1 = points(vertex1,1); y1 = points(vertex1,2);
        x2 = points(vertex2,1); y2 = points(vertex2,2);
        
        midpoint = [(x1+x2)/2, (y1+y2)/2];
        
        points(vertex1,:) = midpoint;
        points(vertex2,:) = [];

        %When you remove a point you only mess with the triangulation a
        %bit, maybe manually change the triangulation and plug it back into
        %squarebv instead of evaluating each time
        

    end
