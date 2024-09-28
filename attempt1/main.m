% rgbImage
% cbar -- 6[R, C] -> [R, C] color matrix average
% ctilda -- average cbar of neighbors in WS of given cbar
% depthImage
% i -- row / j -- col

SCALE = 6; % should be 1:1 as depth/rgbImage are both 480x640 IN THIS CASE ONLY
           % N -> 6N synthesis is superior

% image declaration
depthImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/zmap_png/oyla_0000.png');
rgbImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/rgb_jpg/oyla_0000.jpg');

% data conversion
depthImage = im2double(depthImage);

% obtain dimensions of depth image
[R, C] = size(depthImage);

R_MIN = 1;
R_MAX = R;

C_MIN = 1;
C_MAX = C;

% vector preallocation
cbar = zeros(R, C);
ctilda = zeros(R, C);
colorweight = zeros(R, C);
depthweight = zeros(R, C);
phi = zeros(R, C);

% control window size [odd values only]
WS = 3;

% depth slide
for j = 1:C
    for i = 1:R

        % refer to color window for depth pixel
        count = 0;
        for n = ((SCALE * (j - 1)) + 1):(SCALE * j)
            for m = ((SCALE * (i - 1)) + 1):(SCALE * i)
                % extract average color vector for each depth pixel
                % CONFIDENCE CHECK FAILURE?
                
                if (a >= R_MIN) && (a <= R_MAX)
                    if (b >= C_MIN) && (b <= C_MAX)

                        % exclude the target depth pixel
                        if (a ~= i) && (b ~= j)
                            ctilda(i, j) = ctilda(i, j) + cbar(a, b);
                            count = count + 1;
                        end

                    end
                end 
                
                cbar(i, j) = cbar(i, j) + rgbImage(m, n);
            end
        end
        cbar(i, j) = cbar(i, j) / count;
        
    % color weight
        % find color values based on neighbors around depth pixel given WS
        count = 0;
        for b = (j - ((WS - 1) / 2)):(j + ((WS - 1) / 2))
            for a = (i - ((WS - 1) / 2)):(i + ((WS - 1) / 2))
                
                % maintain boundaries
                if (a >= R_MIN) && (a <= R_MAX)
                    if (b >= C_MIN) && (b <= C_MAX)

                        % exclude the target depth pixel
                        if (a ~= i) && (b ~= j)
                            ctilda(i, j) = ctilda(i, j) + cbar(a, b);
                            count = count + 1;
                        end

                    end
                end

            end
        end
        ctilda(i, j) = ctilda(i, j) / count;

        colorweight(i, j) = exp(-norm(cbar(i, j) - ctilda(i, j)));
        
    % bilateral filter [WIP?]
        % sum absolute differences
        %SAD = calculate_sum_matrix_depth(depthImage, WS);
        %depthweight(i, j) = norm(depthImage(i, j) - SAD(i, j));

        % result
        phi(i, j) = (1 / (R * C)) * colorweight(i, j); %* depthweight(i, j);

% end of program

    end
end
