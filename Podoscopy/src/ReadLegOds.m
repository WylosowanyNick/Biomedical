function [time, leg_data] = ReadLegOds(leg_path)
raw_leg_data = readtable(leg_path);

time = table2array(raw_leg_data(:, 1));

leg_data = containers.Map('KeyType', 'char', 'ValueType', 'any');
key_set = {'Fy1' 'Fy2' 'Fz1' 'Fz2' 'Fz3' 'Fz4' 'Fx1' 'Fx2'};
idx = 2:2:16;
for i = 1:8
    leg_data(cell2mat(key_set(i))) = table2array(raw_leg_data(:, idx(i)));
end
end