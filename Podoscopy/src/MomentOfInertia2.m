function [inertiaX, inertiaY, inertiaXY] = MomentOfInertia2(image, x, y)
% Funkcja liczy moment bezwładności zdjęcia względem podanego punktu.
imageSize = size(image);

inertiaX = 0;
for i = 1:imageSize(1)
    row = image(i, :);
    sumRow = sum(row);
    inertiaX = inertiaX + ((i-x)*(i-x))*sumRow;
end

inertiaY = 0;
for i = 1:imageSize(2)
    col = image(:, i);
    sumCol = sum(col);
    inertiaY = inertiaY + ((i-y)*(i-y))*sumCol;
end

inertiaXY = 0;
for i = 1:imageSize(1)
    for j = 1:imageSize(2)
        inertiaXY = inertiaXY + (i-x)*(j-y)*image(i, j);
    end
end
end