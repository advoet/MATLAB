function [Areas] = voronoinAreaSim(numpoints,timesteps)
%%Returns a (1 x timesteps) cell array, each cell of which contiains an
%%array consisting of all of the areas of individual cells in the voronoi
%%diagram.

%%Description:
%%Constructs a voronoi diagram with (numpoints) points, then for each
%%timestep performs a merging procedure by randomly selecting a point and
%%one of its neighbors to combine. These two points are replaced by a
%%midpoint to simulate droplets of water merging to form a larger droplet.

Areas = cell(1,timesteps);

points_left = numpoints;
x = rand(points_left,1);
y = rand(points_left,1);

points = [x,y];


%timestep looping procedure
for i = 1:timesteps
   
    %compute areas
    [vertices vcells] = voronoin(points);
    
    areas = -ones(1, vcells);
    j=1;
    for i = 1:length(c)
        polygon = c{i};
        areas(j) = 
    
    
    %input the area into our output array
    %NOTE: not all of the area matrix will be filled, the remainder will be
    %filled with -1's to prevent ambiguity
    Areas{i} = areas;
    
    %get point and neighbors
    point_index = randi(points_left);
    %%NEIGHBOR GETTING CODE
    
end


end