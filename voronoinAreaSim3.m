function [Areas, AreaChange, numNeighbors, AreaRedist] = voronoinAreaSim3(numpoints,timesteps)
%% Returns 
% Areas - (1 x timesteps) cell array, each cell of which contiains an
%array consisting of all of the areas of individual cells in the voronoi
%diagram along with values of -1 (representing areas that had a
%vertex at infinity)
%
% AreaChange -  1x(timesteps-1) array with values of the ratio 
%B/(A1+A2), where A1 and A2 are the areas of the cells being merged and B 
%is the area of the new cell formed from their midpoint.
%
% numNeighbors - 1xtimesteps array with values the number of neighbors of
% both cells being merged with no repeats - the number of areas 
%
% AreaRedist - 1xtimesteps cell array in which each cell contains a list of
% the percent change of each neighbor whose area changes at the given
% timestep DOESNT WORK YET, NOT SURE WHAT THIS VALUE SHOULD REALLY BE

%% Description
% Constructs a voronoi diagram with (numpoints) points, then for each
% timestep performs a merging procedure by randomly selecting a point and
% one of its neighbors to combine. These two points are replaced by a
% midpoint to simulate distribution of a resource being moved to a
% centralized location in order to model city growth in a community with a
% finite resources


    visual = false;
    
    Areas = cell(timesteps,1);
    AreaChange = -ones(timesteps-1,1);
    numNeighbors = -ones(timesteps,1);
    AreaRedist = cell(timesteps-1,1);
    
    %RANDOM POINT DISTRIBUTION
    points_left = numpoints;
    x = rand(points_left,1);
    y = rand(points_left,1);

    
%         %UNIFORM POINT DISTRIBUTION
%     x = .01:.02:.99;
%     y = .01:.02:.99;
%     
%    [x,y] = meshgrid(x,y);
    
    x = x(:);
    y = y(:);
    
    
    points = [x,y];

    dt = DelaunayTri(points(:,1),points(:,2));
    
    
    
    %timestep looping procedure
    for i = 1:timesteps
        %% MANUAL AREA CODE USING POLYAREAc
        
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
            voronoi(dt.X(:,1),dt.X(:,2));
            hold on;
        end
        
        
        %areas of edge cells for now will be given -1
        Areas{i} = -ones(size(vcells));
        
        
        if i>=2
            
            %fill Areas cell with previous area values
            for j=1:vertex2-1
                Areas{i}(j) = Areas{i-1}(j);
            end
            for j=vertex2:length(Areas{i-1})-1;
                Areas{i}(j) = Areas{i-1}(j+1);
            end
            
            
           
            %the midpoint of vertex 1 and vertex 2 replaces  vertex 1, so 
            %recompute its area. NOTE: we do not check if vertex1>vertex2
            %since the edge list is sorted 
            xpoints = vertices(vcells{vertex1,:},1); 
            ypoints = vertices(vcells{vertex1,:},2);
            area = polyarea(xpoints,ypoints);
            
            if visual
                fill(xpoints,ypoints, 'b');
                getframe();
            end
            
            %Skips the areas that include infinity
            if (~isnan(area))
                Areas{i}(vertex1) = area;
                A1 = Areas{i-1}(vertex1);
                A2 = Areas{i-1}(vertex2);
                %ratio of the new area to the old combined areas
                AreaChange(i-1) = area/(A1+A2);
                %total area that gets redistributed to other cells
                
            else
                Areas{i}(vertex1) = -1;
            end
            
            
            AreaRedist{i-1} = -2*ones(size(toUpdate));
            
            %Account for removal of vertex2 from the list of vertices
            for h = 1:length(toUpdate)
                
                vertex_shifted = false;
                
                vertex = toUpdate(h);
                %Account for removal of vertex2 from the list of vertices
                if vertex>vertex2
                    vertex_shifted = true;
                    vertex = vertex-1;
                end
                
                xpoints = vertices(vcells{vertex,:},1);
                ypoints = vertices(vcells{vertex,:},2);
                area = polyarea(xpoints,ypoints);
                if visual
                    fill(xpoints,ypoints, 'b');
                    getframe();
                end
                %Skips the areas that include infinity
                if (~isnan(area))
                    Areas{i}(vertex) = area;
                    %fraction of possible area gained
                    if vertex_shifted
                        AreaRedist{i-1}(h) = (area-Areas{i-1}(vertex+1))/(A1+A2 - area);
                    else
                        AreaRedist{i-1}(h) = (area-Areas{i-1}(vertex))/(A1+A2 - area);
                    end
                end
                
            end
            
            
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
                
                %Skips the areas that include infinity
                if (~isnan(area))
                    Areas{i}(j) = area;            
                end
                    
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
        
        numNeighbors(i) = length(toUpdate);
        
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

        x1 = dt.X(vertex1,1); y1 = dt.X(vertex1,2);
        x2 = dt.X(vertex2,1); y2 = dt.X(vertex2,2);

        midpoint = [(x1+x2)/2, (y1+y2)/2];

        
        dt.X(vertex1,:) = midpoint;
        dt.X(vertex2,:) = [];
        %When you remove a point you only mess with the triangulation a
        %bit, maybe manually change the triangulation and plug it back into
        %squarebv instead of evaluating each time
        
        if visual
            hold off;
        end
        
        
        % apparently dt automatically recomputes itself when you add/remove
        % points, so implemented that. I wish we still didnt have to reget
        % the voronoi from there but i think its fine
        
        
    end
end