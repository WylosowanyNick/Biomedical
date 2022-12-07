function torque = Torque(data)
% Wartość bezwzględna (!) momentów sił działających na platformę.
% Przyjęte wymiary platformy (w metrach).
a = 0.5;
b = 0.5;

Mx = data('Fz2')*b + data('Fz3')*b;
My = data('Fz3')*a + data('Fz4')*a;

torque = horzcat(Mx, My);
end