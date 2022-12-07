function reaction_force = Re(data)
Rex = -data('Fx1')-data('Fx2');
Rey = -data('Fy1')-data('Fy2');
Rez = -data('Fz1')-data('Fz2')-data('Fz3')-data('Fz4');

reaction_force = horzcat(Rex, Rey, Rez);
end