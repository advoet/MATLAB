function [ m ] = scaleDensity(Areas)
%This function plots the rescaled density function
%(1/N(t)^2)*(f(t,(x/N(t)))). It takes a cell array as input. 

%length of cell array. 
lenArray = length(Areas); 

%Picking the width of the bins to put the areas in.
dx = 1/8;

%Finding the biggest area value that will need to be plotted at the last
%time step so that a good bound for plotting is chosen. 
endBound = max(Areas{lenArray})*length(Areas{lenArray}); 


%Plotting the rescaled density function. 
for i = 1:lenArray

    area = Areas{i};
    
    %Rescaling area values. 
    newArea = area .* length(area);  

    X = 0:dx:endBound;

    %Putting rescaled areas into bins. 
    y = hist(newArea,X);

    %Rescaling information in bins so that we obtain a density function. 
    y = y./ (dx*(length(newArea)));
    
    %Plotting Density function. 
    bar(X,y);
    axis([0, endBound, 0, 2]);
    
    m(i) = getframe();


end

end

