function [s] = calculate_sum_matrix_depth(d, ws)
if nargin < 2
    ws = 2; % changed from 3
end

d = im2double(d);

[h, w] = size(d);
s = zeros(h, w);

for i = 1:h
    for j = 1:w
        % Calculate valid window indices
        row_min = max(1, i - ws);
        row_max = min(h, i + ws);
        col_min = max(1, j - ws);
        col_max = min(w, j + ws);

        % Calculate window and absolute differences
        window = d(row_min:row_max, col_min:col_max);
        d_ij = d(i, j) * ones(size(window));
        abs_diffs = abs(window - d_ij);

        s(i, j) = sum(sum(abs_diffs));

    end
end

end


% function sum_matrix = calculate_sum_matrix_depth(d, ws)
%     size = 2*ws+1;
%     % Define the function to be applied to each window
%     func = @(window) sum(abs(window(:) - window(ceil(size/2), ceil(size/2))));
% 
%     % Apply the function to each window
%     sum_matrix = nlfilter(d, [size size], func);
% end