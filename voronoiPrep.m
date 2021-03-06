function [X,Y] = voronoiPrep(X0,Y0);


%creates a periodic set of shifts of the given inputs to form a 3x3 grid
%around the original square. 


X1 = {X0-ones(length(X0),1);X0;X0+ones(length(X0),1)};
Y1 = {Y0+ones(length(X0),1);Y0;Y0-ones(length(X0),1)};

iter = 1;
X2 = cell(9,1);
Y2 = cell(9,1);

for i = 1:3
    for j = 1:3
        X2{iter} = X1{j};
        Y2{iter} = Y1{i};
        iter = iter+1;
    end
end

X = cell2mat(X2);
Y = cell2mat(Y2);