function [video_reader, left_leg_time, left_leg_data, right_leg_time, right_leg_data] = GetCaseData(case_nr)
[video_path, left_leg_path, right_leg_path] = GetCasePaths(case_nr);

video_reader = VideoReader(video_path);

[left_leg_time, left_leg_data] = ReadLegOds(left_leg_path);
[right_leg_time, right_leg_data] = ReadLegOds(right_leg_path);
end