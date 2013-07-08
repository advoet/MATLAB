function [ m,X,Y] = scaleDensity(Areas,framerate)
%This function plots the rescaled density function
%(1/N(t)^2)*(f(t,(x/N(t)))). It takes a cell array as input. 




%length of cell array. 
lenArray = length(Areas); 

%Picking the width of the bins to put the areas in.
dx = 1/10;

%Finding the biggest area value that will need to be plotted at the last
%time step so that a good bound for plotting is chosen. 
endBound = max(Areas{lenArray/2})*length(Areas{lenArray/2}); 
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
        
        %fits and evaluates a gaussian curve to the data
        [sigma,mu,alpha] = mygaussfit(X,y);
        
        %output all of the coefficients for gauss fit.
        sigmas(i/framerate) = sigma;
        alphas(i/framerate) = alpha;
        mus(i/framerate) = mu;
        
        
        y2 = alpha/(2*sigma)*exp(-(X-mu).^2/(2*sigma^2));
        
      
        
        
        bar(X,y);
        hold on;
        
        
        plot(X,y2,'r','LineWidth',3)
       
        axis([0, endBound, 0, 1.2]);
        hold off;
        m(i/framerate) = getframe();
        display(i)
    end
    


end

end

