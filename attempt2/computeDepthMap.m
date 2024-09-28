function [depthMap] = computeDepthMap(depthImage, WS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

depthImage = im2double(depthImage);

% obtain dimensions + define bounds
[R, C] = size(depthImage);

ROW_MIN = 1;
ROW_MAX = R;

COL_MIN = 1;
COL_MAX = C;

% preallocation
depthMap = zeros(R, C);

for i = 1:R
    for j = 1:C
    
        % indices of neighbors within given WS
        for a = (i - floor(WS / 2)):(i + floor(WS / 2))
            for b = (j - floor(WS / 2)):(j + floor(WS / 2))
                
                % constraints of indices
                if (a >= ROW_MIN) && (a <= ROW_MAX)
                    if (b >= COL_MIN) && (b <= COL_MAX)
                        %if (a ~= i) || (b ~= j)

                            % sum of norm of depth differences
                            d = norm(depthImage(a, b) - depthImage(i, j));
                            depthMap(i, j) = depthMap(i, j) + d;

                        %end
                    end
                end
            end
        end
    end
end

end

