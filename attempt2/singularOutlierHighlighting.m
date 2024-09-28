depthImage = imread('/Users/bilalbevab/Desktop/personalwork/sadidentification/oyla-datasets/Office/6m/zmap_png/oyla_0000.png');
RGBImage = imread('/Users/bilalbevab/Desktop/personalwork/sadidentification/oyla-datasets/Office/6m/rgb_jpg/oyla_0000.jpg');

% displays 2-D color image
imshow(RGBImage);

SADMatrix = calculate_sum_matrix_depth(depthImage, 5);
[outliers, ~] = find_outliers(SADMatrix, 2); %% 2 seems to be most optimal

red = RGBImage(:, :, 1);
green = RGBImage(:, :, 2);
blue = RGBImage(:, :, 3);

red(outliers == 1) = 255;
green(outliers == 1) = 0;
blue(outliers == 1) = 0;

RGBImage(:, :, 1) = red;
RGBImage(:, :, 2) = green;
RGBImage(:, :, 3)= blue;
markedRGB = uint8(RGBImage);

% displays marked 2-D color image
imshow(markedRGB);

% intrinsic matrix from function
oylainstrinics = OYLA_Intrinsic(depthImage);

% constructs intrinsic object using matrix data
intrinsics = cameraIntrinsics([oylainstrinics(1,1) oylainstrinics(2,2)],[oylainstrinics(1,3) oylainstrinics(2,3)],[640 480]);

% generates point cloud
ptCloud = pcfromdepth(depthImage,1,intrinsics);

% assigns color to point cloud
ptCloud.Color = RGBImage;

% displays marked point cloud
pcshow(ptCloud, VerticalAxis="Y", VerticalAxisDir="Up", ViewPlane="YX");

%% scatter3 plotting work (optional)

% for i = 1:640
%     k = 1;
%     for j = 1:480
%         X(j,i) = k;
%         Y(j,i) = k;
%         k = k + 1;
%     end
% end

% scatter3(X,Y,depthImage);