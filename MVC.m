function lambda = MVC(X,Y,boundary)
row = length(X);
col = length(boundary);
lambda = zeros(row, col);
omega = zeros(1, col);

for i = 1:row
    vector1 = boundary - [X(i) * ones(col, 1), Y(i) * ones(col, 1)];
    vector2 = [vector1(2:end, :); vector1(1, :)];
    normResult = zeros(col, 1);
    dotResult = zeros(col, 1);
    for j = 1:col
        normResult(j, 1) = norm(vector1(j, :), 2);
        dotResult(j, 1) = dot(vector1(j, :), vector2(j, :));
    end
    for j = 1:col
        if j == 1
            n1 = normResult(col, 1);
        else
            n1 = normResult(j - 1, 1);
        end
        n2 = normResult(j, 1);
        if j == col
            n3 = normResult(1, 1);  
        else
            n3 = normResult(j + 1, 1);
        end
        alpha1 = acos(dotResult(j, 1) / (n1 * n2));
        alpha2 = acos(dotResult(j, 1) / (n2 * n3));
        omqqega(1, j) = (tan(alpha1 * 0.5) + tan(alpha2 * 0.5)) / n2;
    end
    omegaSum = ones(1, col);
    omegaSum = omegaSum * sum(omega, 2);
    lambda(i, :) = omega ./ omegaSum;
end