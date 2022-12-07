function cleared_image = ClearBinaryImage(image, coords)
% Funkcja zachowuje ze zdjęcia interesujący nas region, a czyści pozostałą
% część zdjęcia.
cleared_image = zeros(size(image));
cleared_image(coords(1):coords(2), coords(3):coords(4)) = image(coords(1):coords(2), coords(3):coords(4));
end