% image declaration
depthImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/zmap_png/oyla_0000.png');
rgbImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/rgb_jpg/oyla_0000.jpg');

% data conversion
depthImage = im2double(depthImage);
rgbImage = im2double(rgbImage);

% obtain dimensions of depth image
[R, C] = size(depthImage);

ROW_MIN = 1;
ROW_MAX = R;

COL_MIN = 1;
COL_MAX = C;

% preallocation
phi = zeros(size(depthImage));
    % experimental
    weightblock = zeros(size(depthImage));
    depthblock = zeros(size(depthImage));
    %

% CONTROLS
parameter = 1;
WS = 9;
normalization = 1;

% program

% indices in depth/color image

for i = 1:R
    for j = 1:C
        
        col_ref = rgbImage(i, j, :);

        % indices of neighbors within given WS
        for a = (i - floor(WS / 2)):(i + floor(WS / 2))
            for b = (j - floor(WS / 2)):(j + floor(WS / 2))
                
                % constraints of indices
                if (a >= ROW_MIN) && (a <= ROW_MAX)
                    if (b >= COL_MIN) && (b <= COL_MAX)
                        %if (a ~= i) || (b ~= j)
                                            
                            % depth performance
                            d = norm(depthImage(a, b) - depthImage(i, j));
                            % color weight
                            col_neigh = rgbImage(a, b, :);
                            W = exp(-parameter * norm(col_neigh(:) - col_ref(:)));
                            
                                % experimental
                                %weightblock(i, j) = weightblock(i, j) + W;
                                %depthblock(i, j) = depthblock(i, j) + d;
                                %

                            % bilateral filter result
                            phi(i, j) = phi(i, j) + (W * d);

                        %end
                    end
                end

            end
        end

        % normalization
        if normalization == 1
            phi(i, j) = phi(i, j) / (WS^2);
            %weightblock(i, j) = weightblock(i, j) / (WS^2);
        end

    end
end



figure;
plot(phi(:));
title(['[Bilateral Filter] WS=',num2str(WS),' variance=',num2str(parameter),' normalization=',num2str(normalization)]);
xlabel('# of Image Pixels');
ylabel('\phi');

%figure;
%plot(weightblock(:));

% Ekamresh Depth Function
test = calculate_sum_matrix_depth(depthImage, WS);

figure;
plot(test(:));
title(['[SAD] WS=',num2str(WS)]);
xlabel('# of Image Pixels');
ylabel('SAD');

%%

%plotIdentificationResult(phi, depthImage, rgbImage);

rgbImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/rgb_jpg/oyla_0000.jpg');

d = calculate_sum_matrix_depth(depthImage, 9);

[outliers, ~] = find_outliers(d, 2); %% 2 seems to be most optimal

red = rgbImage(:, :, 1);
green = rgbImage(:, :, 2);
blue = rgbImage(:, :, 3);

red(outliers == 1) = 255;
green(outliers == 1) = 0;
blue(outliers == 1) = 0;

rgbImage(:, :, 1) = red;
rgbImage(:, :, 2) = green;
rgbImage(:, :, 3)= blue;
markedrgb = uint8(rgbImage);

% displays marked 2-D color image
imshow(markedrgb);

% intrinsic matrix from function
oylainstrinics = OYLA_Intrinsic(depthImage);

% constructs intrinsic object using matrix data
intrinsics = cameraIntrinsics([oylainstrinics(1,1) oylainstrinics(2,2)],[oylainstrinics(1,3) oylainstrinics(2,3)],[640 480]);

% generates point cloud
ptCloud = pcfromdepth(depthImage,1,intrinsics);

% assigns color to point cloud
ptCloud.Color = rgbImage;

% displays marked point cloud
pcshow(ptCloud, VerticalAxis="Y", VerticalAxisDir="Up", ViewPlane="YX");

