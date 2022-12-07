function [com_x, com_y] = COM(image)
% Funkcja zwraca Center of Mass ze zdjęcia binarnego. Jeżeli COM nie został
% wykryty, funkcja zwraca -1, -1.
com = regionprops(image, 'centroid');
if isempty(com)
    com_x = -1;
    com_y = -1;
else
    com = com.Centroid;
    com_x = com(1);
    com_y = com(2);
end
end
