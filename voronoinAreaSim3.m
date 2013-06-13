function [Areas] = voronoinAreaSim2(numpoints,timesteps)
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



    visual = true;



    Areas = cell(1,timesteps);

    points_left = numpoints;
    x = rand(points_left,1);
    y = rand(points_left,1);

    points = [x,y];


    %timestep looping procedure
    for i = 1:timesteps
          
        %% MANUAL AREA CODE USING POLYAREA
        
        dt = DelaunayTri(points(:,1),points(:,2));
        [vertices vcells] = voronoiDiagram(dt);
        
        
        %%  deal with points that meet outside of the square
        for m = 1:length(vertices)
           
            if vertices(m,1)>1 || vertices(m,2)>1 || vertices(m,1)<0 || vertices(m,2)<0
                vertices(m,1) = Inf;
                vertices(m,2) = Inf;
            end
        end
            % If we want to plot the voronoi
            
        if visual    
            voronoi(points(:,1),points(:,2));
            hold on;
        end
        
        
        %areas of edge cells for now will be given -1
        Areas{i} = -ones(size(vcells));
        
        
        if i>2
            
            %get original cells
            
            %get their neighbors
            
            %recompute areas
            
            
        else
            for j = 1 : length (vcells)
                xpoints = vertices(vcells{j,:},1); 
                ypoints = vertices(vcells{j,:},2);
                area = polyarea (xpoints,ypoints);

                %if we have a vornoi diagram, visually fills the polygons we 
                %compute areas

                if visual
                    fill(xpoints,ypoints, 'r')     
                end

                if (isnan(area))
                    continue;           %Skips the areas that include infinity
                end
                Areas{i}(j) = area;     
            end
        end
        %NOTE: not all of the area matrix will be filled, the remainder will be
        %filled with -1's to prevent ambiguity
        
        %%
        if visual
            getframe();
        end
        %%
       
        
        
        %% NEIGHBOR GETTING CODE
        % Each neighbor pair corresponds to vertices whose cells share a 
        % point in the voronoi diagram. Then selects a random neighbor pair
        % to remove from the set of points and in place adds it's midpoint
              
        
        neighborSet = edges(dt);
        
        pair_to_remove = randi(length(neighborSet));
        [vertex1] = neighborSet(pair_to_remove,1);
        [vertex2] = neighborSet(pair_to_remove,2);
        
        
        
        
        
        
        
        %gets the indices of each appearance of either vertex in the list
        %of edges in order to find the neighbors
        [v1_x_indices,v1_y_indices] = find(neighborSet==vertex1);
        [v2_x_indices,v2_y_indices] = find(neighborSet==vertex2);
        
        %toggles y index to get opposite end of edge aka voronoi neighbor
        v1_y_indices = 3.-v1_y_indices;
        v2_y_indices = 3.-v2_y_indices;
        
        toUpdate1 = ones(size(v1_y_indices));
        toUpdate2 = ones(size(v2_y_indices));
        
        for p = 1:length(toUpdate1)
            toUpdate1(p) = neighborSet(v1_x_indices(p),v1_y_indices(p));
        end
        
        for q = 1:length(toUpdate2)
            toUpdate2(q) = neighborSet(v2_x_indices(q),v2_y_indices(q));
        end
        
        toUpdate = union(toUpdate1,toUpdate2);
        
        %toUpdate is now the list of unique neighbors of either vertex1 or
        %vertex2 without repeats or inclusion of vertex1 or vertex2
        %themseleves
        toUpdate = setdiff(toUpdate,[vertex1,vertex2]);
        
        %check if order preserved in the new triangulation. Probably not,
        %so we may have to manually update the DT calc. ACTUALLY!!!!!!!!!!!
        %We can get the actual locations of the points from this list and
        %then find them in the new triangulation.
        
        
        
        if visual
           fill( vertices(vcells{vertex1,:},1), vertices(vcells{vertex1,:},2),'g');
           getframe();
           fill( vertices(vcells{vertex2,:},1), vertices(vcells{vertex2,:},2),'g');
           getframe();
        end

        x1 = points(vertex1,1); y1 = points(vertex1,2);
        x2 = points(vertex2,1); y2 = points(vertex2,2);

        midpoint = [(x1+x2)/2, (y1+y2)/2];

        points(vertex1,:) = midpoint;
        points(vertex2,:) = [];

        %When you remove a point you only mess with the triangulation a
        %bit, maybe manually change the triangulation and plug it back into
        %squarebv instead of evaluating each time
        
        if visual
            hold off;
        end
    end
end