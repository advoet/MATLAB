function Areas = voronoinAreaSim5(numpoints,timesteps,beta,mNeighbors)

%THIS SIMULATION IS SUPPOSED TO REFLECT MORE ACCURATELY OUR MODEL. AT EACH
%TIMESTEP, CELLS ARE MERGED INTO A CELL OF 1/BETA THE SIZE AND THE
%REMAINING AREA IS DISTRIBUTED EQUALLY AMONG A CONSTANT M CELLS.

% beta determined to be 1.6144


%% Returns 
% Areas - (1 x timesteps) cell array, each cell of which contiains an
%array consisting of all of the areas of individual cells in the voronoi
%diagram along with values of -1 (representing areas that had a
%vertex at infinity)
%


%% Description
%Since our model does not account for localized area gain from area
%redistribution to exact neighbors, we can model this process by simply
%retrieving the original cells from a voronoi model and just choosing
%random cells to merge as well as random (different) cells to recieve the
%areas at each timestep. This works due to our homogeneity assumption
%throughout the procedure.


    Areas = cell(timesteps,1);
    
    %RANDOM POINT DISTRIBUTION
    x = rand(numpoints,1);
    y = rand(numpoints,1);
    
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
    [vertices vcells] = voronoiDiagram(dt);
    
    
    Areas{1} = -ones(numpoints,1);

    for j = 1:length(dt.X)/9
        xpoints = vertices(vcells{j+4*length(dt.X)/9,:},1); 
        ypoints = vertices(vcells{j+4*length(dt.X)/9,:},2);
        area = polyarea(xpoints,ypoints);

        Areas{1}(j) = area;

    end
    
    
    %timestep looping procedure
    for i = 1:timesteps
        
        Areas{i+1} = -ones(numpoints-i,1);
        
        cells = [];
        
        %gets m+2 unique points to be affected by the time step
        while length(cells)<mNeighbors+2 && length(cells)<=length(Areas{i});
            cells = union(cells,randi(numpoints-i+1));
        end
        cells = cells(randperm(length(cells)));
        
        %merges first two cells into the lower indexed cell
        mergeInto = min(cells(1),cells(2));
        mergeRemove = max(cells(1),cells(2));
        
        cells = cells(3:end);
        
        %populates next step areas pre-redistribution
        Areas{i+1} = [Areas{i}(1:mergeRemove-1);Areas{i}(mergeRemove+1:end)];
        
        total = Areas{i}(mergeInto) + Areas{i}(mergeRemove);
        newArea = total/beta;
        toRedist = total - newArea;
        perCell = toRedist/mNeighbors;
        
        
        if(total-newArea-toRedist ~= 0)
            display('problem');
        end
        if perCell*mNeighbors ~= toRedist
            display('also problem');
        end
        
        %makes the merged cell
        Areas{i+1}(mergeInto) = newArea;
        
        %decrements the index of those after the removed index
        cells(cells>mergeRemove) = cells(cells>mergeRemove)-1;
        
        %adds the desired area
        Areas{i+1}(cells) = Areas{i}(cells) + perCell;
        
        
    end
    
end