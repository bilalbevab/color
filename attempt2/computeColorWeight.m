function [colorWeight] = computeColorWeight(colorImage, WS, parameter, normalization)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

colorImage = im2double(colorImage);

% obtain dimensions + define bounds
[R, C, ~] = size(colorImage);

ROW_MIN = 1;
ROW_MAX = R;

COL_MIN = 1;
COL_MAX = C;

% preallocation
colorWeight = zeros(R, C);

for i = 1:R
    for j = 1:C
    
        col_ref = colorImage(i, j, :);

        % indices of neighbors within given WS
        for a = (i - floor(WS / 2)):(i + floor(WS / 2))
            for b = (j - floor(WS / 2)):(j + floor(WS / 2))
                
                % constraints of indices
                if (a >= ROW_MIN) && (a <= ROW_MAX)
                    if (b >= COL_MIN) && (b <= COL_MAX)
                        %if (a ~= i) || (b ~= j)

                            col_neigh = colorImage(a, b, :);
                            color_diff = col_neigh(:) - col_ref(:);
                            w = exp(-parameter * norm(color_diff));
                            colorWeight(i, j) = colorWeight(i, j) + w;

                        %end
                    end
                end
            end
        end
    end
end

% normalize if enabled
if normalization == 1
    colorWeight = colorWeight / (WS^2);
end

end