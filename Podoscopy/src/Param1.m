function param1 = Param1(Ix, Iy, Ixy)
% Funkcja liczy tan(2*alpha). alpha określa najlepiej dopasowany układ
% odniesienia x'y' (otrzymany poprzez obrót układy pierwotnego względem
% jego początku o kąt alpha) taki, że Ix' i Iy' osiągają ekstremum (max i
% min).
param1 = 2*Ixy/(Iy - Ix);
end