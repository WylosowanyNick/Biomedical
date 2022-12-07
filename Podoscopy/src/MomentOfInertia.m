function [inertiaX, inertiaY, inertiaXY] = MomentOfInertia(image)
% Funkcja liczy moment bezwładności zdjęcia względem środka ciężkości stopy.
    [com_x, com_y] = COM(image);
    [inertiaX, inertiaY, inertiaXY] = MomentOfInertia2(image, com_x, com_y);
end