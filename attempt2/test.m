depthImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/zmap_png/oyla_0000.png');
colorImage = imread('/Users/bilalbevab/Desktop/identification/color/oyla-datasets/Office/6m/rgb_jpg/oyla_0000.jpg');

depthMap = computeDepthMap(depthImage, 9);
colorWeight = computeColorWeight(colorImage, 9, 1, 1);

phitest = bilateralFilter(colorWeight, depthMap, 9, 1);
