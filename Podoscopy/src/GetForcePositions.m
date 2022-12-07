function force_positions = GetForcePositions()
force_positions = containers.Map('KeyType', 'char', 'ValueType', 'any');
force_positions('Fz1') = [20 480 0];
force_positions('Fz2') = [480 480 0];
force_positions('Fz3') = [480 20 0];
force_positions('Fz4') = [20 20 0];
force_positions('Fy') = [500 250 0];
force_positions('Fx') = [250 0 0];
end