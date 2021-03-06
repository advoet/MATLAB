function [Areas, Betas, numNeighbors, AreaRedist] = voronoinAreaSim4(numpoints,timesteps)

%PERIODIC SIMULATION, ONLY COMPUTES THE AREAS OF THE POINTS IN THE MIDDLE
%CELL, PERIODIC CONSTRAINT FORCES AREAS TO WRAP AROUND AND STILL TOTAL 1


%% Returns 
% Areas - (1 x timesteps) cell array, each cell of which contiains an
%array consisting of all of the areas of individual cells in the voronoi
%diagram along with values of -1 (representing areas that had a
%vertex at infinity)
%
% Betas -  1x(timesteps-1) array with values of the ratio 
%(A1+A2)/B, where A1 and A2 are the areas of the cells being merged and B 
%is the area of the new cell formed from their midpoint.
%
% numNeighbors - 1xtimesteps array with values the number of neighbors of
% both cells being merged with no repeats - the number of areas 
%
% AreaRedist - 1xtimesteps cell array in which each cell contains a list of
% the percent change of each neighbor whose area changes at the given
% timestep NOT IMPLEMENTED

%% Description
% Constructs a voronoi diagram with (numpoints) points, then for each
% timestep performs a merging procedure by randomly selecting a point and
% one of its neighbors to combine. These two points are replaced by a
% midpoint to simulate distribution of a resource being moved to a
% centralized location in order to model city growth in a community with a
% finite resource


    visual = false;
    
    Areas = cell(timesteps,1);
    Betas = -ones(timesteps-1,1);
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
%   [x,y] = meshgrid(x,y);
    
    x = x(:);
    y = y(:);
    
    %create the periodic mesh
    [x,y] = voronoiPrep(x,y);
    points = [x,y];

    
    
    dt = DelaunayTri(points(:,1),points(:,2));
    
    %timestep looping procedure
    for i = 1:timesteps
        %% MANUAL AREA CODE USING POLYAREAc
        
        
        middleIndices = 4*length(dt.X)/9+1:5*length(dt.X)/9;
        [vertices vcells] = voronoiDiagram(dt);
        
            
        if visual    
            voronoi(dt.X(:,1),dt.X(:,2));
            hold on;
            axis([-.1,1.1,-.1,1.1]);
            plot([0,0,1,1,0],[0,1,1,0,0],'LineWidth',2,'Color','g');
            if i>=2
                fill(plotv1a,plotv1b,'g');
                getframe();
                fill(plotv2a,plotv2b,'g');
                getframe();
            end
        end
        
        
        %all areas can be computed for middle vertex set. initialize to -1
        Areas{i} = -ones(length(vcells)/9,1);
        
        
        if i>=2
            
            
            %fill Areas cell with previous area values
            
            
            Areas{i} = Areas{i-1};
            Areas{i}(baseVertex2) = [];
            
            for h = 1:length(toUpdate)
                
                vertex = toUpdateArea(h);
                
                xpoints = vertices(vcells{vertex,:},1);
                ypoints = vertices(vcells{vertex,:},2);
                area = polyarea(xpoints,ypoints);
                
                if visual
                    fill(xpoints,ypoints, 'b');
                    getframe();
                end
                
                Areas{i}(toUpdateIndex(h)) = area;
            end
            
            %sometimes vertex1 is larger than vertex 2 so it gets shifted
            if baseVertex1<baseVertex2
                Betas(i-1) = (Areas{i-1}(baseVertex1) + ...
                    Areas{i-1}(baseVertex2))/Areas{i}(baseVertex1);
            else
                Betas(i-1) = (Areas{i-1}(baseVertex1) + ...
                    Areas{i-1}(baseVertex2))/Areas{i}(baseVertex1-1);
            end
            
            
        else
            
            for j = 1:length(dt.X)/9
                xpoints = vertices(vcells{j+4*length(dt.X)/9,:},1); 
                ypoints = vertices(vcells{j+4*length(dt.X)/9,:},2);
                area = polyarea (xpoints,ypoints);

                %if we have a vornoi diagram, visually fills the polygons we 
                %compute areas

                if visual
                    fill(xpoints,ypoints, 'r')     
                end

                Areas{i}(j) = area; 
                
            end
        end
        
        
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
        
        vertex1 = randi([middleIndices(1),middleIndices(end)]);

        [v1x,v1y] = find(neighborSet==vertex1);
        v1y = 3.-v1y;
        
        idx = sub2ind(size(neighborSet),v1x,v1y);
        v1neighbors = neighborSet(idx);
        
        vertex2 = v1neighbors(randi(length(v1neighbors)));
        
        
        
        [v2x,v2y] = find(neighborSet==vertex2);
        v2y = 3.- v2y;
        
        idx = sub2ind(size(neighborSet),v2x,v2y);
        v2neighbors = neighborSet(idx);
        
        
        x1 = dt.X(vertex1,1); y1 = dt.X(vertex1,2);
        x2 = dt.X(vertex2,1); y2 = dt.X(vertex2,2);
        
        midpoint = [mod((x1+x2)/2,1),mod((y1+y2)/2,1)];
        
        baseVertex2 = base(vertex2,length(middleIndices));
        baseVertex1 = base(vertex1,length(middleIndices));
        
        
        
        % get the list of indices of cells (excluding vertex2) that
        % will need updating, modded to the first quadrant
        toUpdate = setdiff(union(base(v1neighbors,length(middleIndices)), ...
                                base(v2neighbors,length(middleIndices))), ...
                                baseVertex2);
        

        %shift those after baseVertex2 (will be removed)
        toUpdate(toUpdate>baseVertex2) = toUpdate(toUpdate>baseVertex2)-1;
        
        %move back into proper positions in center block
        toUpdateIndex = toUpdate;
        toUpdateArea = toUpdate + 4*(length(middleIndices)-1);
        
        
        %NO LONGER THE CASE. LEAVING COMMENT FOR POSTERITY
        %This is due to voronoiPrep filling blocks of vertices in order
        % 3,6,9
        % 2,5,8
        % 1,4,7
        vertex1List = zeros(9,1);
        vertex2List = zeros(9,1);
        for b = 1:9
            vertex1List(b) = baseVertex1 + (b-1)*length(middleIndices);
            vertex2List(b) = baseVertex2 + (b-1)*length(middleIndices);
        end
        
        if visual
            hold off;
        end
        
        if visual
            plotv1a = vertices(vcells{vertex1,:},1);
            plotv1b = vertices(vcells{vertex1,:},2);
            plotv2a = vertices(vcells{vertex2,:},1);
            plotv2b = vertices(vcells{vertex2,:},2);
        end
        
        
        [midx,midy] = voronoiPrep(midpoint(1),midpoint(2));
        
        dt.X(vertex1List,:) = [midx,midy];
        dt.X(vertex2List,:) = [];
        
        
        
        
        
        
    end
end


function baseVertex = base(index,numpoints)

    baseVertex = mod(index,numpoints);
    baseVertex(baseVertex==0) = numpoints;
    
end