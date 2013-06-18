function [X,Y] = voronoiPrep(X0,Y0);


%creates a periodic set of shifts of the given inputs to form a 3x3 grid
%around the original square. 


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