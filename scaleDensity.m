function [ m,X,Y] = scaleDensity(Areas,framerate)
%This function plots the rescaled density function
%(1/N(t)^2)*(f(t,(x/N(t)))). It takes a cell array as input. 




%length of cell array. 
lenArray = length(Areas); 

%Picking the width of the bins to put the areas in.
dx = 1/10;

%Finding the biggest area value that will need to be plotted at the last
%time step so that a good bound for plotting is chosen. 
endBound = max(Areas{floor(lenArray/2)})*length(Areas{floor(lenArray/2)}); 
X = 0:dx:endBound;
Y = cell(size(Areas));
%Plotting the rescaled density function. 
for i = 1:lenArray

    area = Areas{i};
    
    %Rescaling area values. 
    newArea = area .* length(area);  


    %Putting rescaled areas into bins. 
    y = hist(newArea,X);

    %Rescaling information in bins so that we obtain a density function. 
    y = y./ (dx*(length(newArea)));
    %Plotting Density function. 
    
    Y{i} = y;
    
    if mod(i,framerate) == 0;
        
        %fits a gaussian curve to the data. looks pretty but doesnt really
        %help with anything. Also fit does not work on my comp -AV
        
        %y2 = fit(X',y','gauss2');             
        
        bar(X,y);
        hold on;
        
        
        %plot(y2,'r');
       
        axis([0, endBound, 0, 1.2]);
        hold off;
        m(i/framerate) = getframe();
        display(i)
    end
    


end

end

