function cop = COP(data)
% Funkcja zwraca położenie stopy na płaszczyźnie platformy (x, y) w
% milimetrach na podstawie danych z czujników sił i wielkości platformy.
% Przyjęte wymiary platformy (w milimetrach).
a = 500;
b = 500;

sum_Fz = Re(data);
sum_Fz = -sum_Fz(:, 3);

x0 = data('Fz3')*a + data('Fz4')*a;
x0 = x0./sum_Fz;

y0 = data('Fz2')*b + data('Fz3')*b;
y0 = y0./sum_Fz;

cop = horzcat(x0, y0);
end