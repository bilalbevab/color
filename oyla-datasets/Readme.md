# Raw (nearly) from Oyla camera for three different scenes

## Each folder has following subfolders
- `ampl_png` amplitude from TOF camera, uint16 format, at resolution (640x480) 
- `zmap_png` distance in cartesian Z-coordinate: image plane to object, uint16 format, mm units, at resolution (640x480)
- `dist_png` radial distance from image plane center to object, uint16 format, mm units, at resolution (640x480)
- `rgb_jpg` rgb image from optical camera, aligned at resolution (640x480) 
- `rgb_jpg_native` rgb image at native resolution from optical camera (1920x1440)


to read uint16 format
```
cv2.imread(<file_name>,-1)
```


Note that data from TOF camera is natively at 320x240 resolution -- it has been nearest neighbour upsampled to (640x480) resolution to match with `rgb_jpg` resolution.
Original data can be recovered by subsampling.

`dist_png` is radial distance as measured by the TOF camera, while `zmap_png` is the (cartesian) Z-coordinate from image plane to object.
Latter is obtained by transforming radial distance to cartesian coordinates by using camera's FOV intrinsic parameters.

In root directory there is  a file  `calibration.ipynb`.

This file shows how to transform radial distance in `dist_png` to Z-coordinate in `zmap_png` using spherical to cartesian transformation with FOV as intrinsic param.
And to use Z-coordinates in open3d library's pinhole camera model to generate an equivalent point cloud.


Two outdoor datasets — one of a chair, and one of a pallet in HomeDepot. In this case multiple images are available, but they are of the same static scene.
Perhaps they can be used for temporal averaging?

Indoor dataset of our office wall — its a dynamic scan of the scene, with each image  a different point in the scan.





