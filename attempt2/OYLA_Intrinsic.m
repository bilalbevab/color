function intrinsic = OYLA_Intrinsic(depth_img)

height = size(depth_img, 1);
width = size(depth_img, 2);
fov_angle=33;
fov_angle_o=44;
alpha = fov_angle*pi/180;
beta = fov_angle_o*pi/180;

fl_h = height/2*(1/tan(alpha/2));
fl_w = width/2*(1/tan(beta/2));

% disp(fl_h)
% disp(fl_w)

% Generate intrinsic matrix
intrinsic = [fl_w, 0, width/2; 0, fl_h, height/2; 0, 0, 1];

end