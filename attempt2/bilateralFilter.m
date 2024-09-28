function [phi] = bilateralFilter(colorWeight, depthMap, WS, normalization)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% obtain dimensions
[R, C] = size(depthMap);

% preallocation
phi = zeros(R, C);

for i = 1:R
    for j = 1:C

        % compose color weight + sum of norm of depth differences
        phi(i, j) = colorWeight(i, j) * depthMap(i, j);

    end
end

% normalize if enabled
if normalization == 1
    phi = phi / (WS^2);
end

end