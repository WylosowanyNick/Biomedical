function [video_path, left_leg_path, right_leg_path] = GetCasePaths(case_nr)
if ~(0 < case_nr & case_nr < 5)
    errordlg('Please input valid number (from range 1-4)', 'Error');
end

base_path = int2str(case_nr);
base_path = append('0', base_path);

video_path = append('../res/', base_path, '/Subject.mp4');
left_leg_path = append('../res/', base_path, '/Subject_left_leg.txt');
right_leg_path = append('../res/', base_path, '/Subject_right_leg.txt');
end