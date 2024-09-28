function [] = plotIdentificationResult(filterResult, depthImage, colorImage)
%PLOTIDENTIFICATIONRESULT Summary of this function goes here
%   Detailed explanation goes here

[outliers, ~] = find_outliers(filterResult, 2); %% 2 seems to be most optimal

red = colorImage(:, :, 1);
green = colorImage(:, :, 2);
blue = colorImage(:, :, 3);

red(outliers == 1) = 255;
green(outliers == 1) = 0;
blue(outliers == 1) = 0;

colorImage(:, :, 1) = red;
colorImage(:, :, 2) = green;
colorImage(:, :, 3)= blue;
markedrgb = uint8(colorImage);

% displays marked 2-D color image
imshow(markedrgb);

% intrinsic matrix from function
oylainstrinics = OYLA_Intrinsic(depthImage);

% constructs intrinsic object using matrix data
intrinsics = cameraIntrinsics([oylainstrinics(1,1) oylainstrinics(2,2)],[oylainstrinics(1,3) oylainstrinics(2,3)],[640 480]);

% generates point cloud
ptCloud = pcfromdepth(depthImage,1,intrinsics);

% assigns color to point cloud
ptCloud.Color = colorImage;

% displays marked point cloud
pcshow(ptCloud, VerticalAxis="Y", VerticalAxisDir="Up", ViewPlane="YX");

end

