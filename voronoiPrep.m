function [X,Y] = voronoiPrep(points);

X = zeros(1,points*9);

X0 = rand(1,points);
Y0 = rand(1,points);

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