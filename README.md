# Entangled-Tubes-Bin-Picking-Dataset

This repository contains the dataset used in "Perception of Entangled Tubes for Automated Bin Picking".

The file naming convention is as follows: "X_bin_picking_Y.Z", where:
- X is the actual number of tubes present in the box (ranges from 1 to 10)
- Y is the test case ID (ranges from 1 to 5)
- Z is the file extention

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene
- a .zdf (Zivid native format) file with the point cloud, color image and depth image


Future work:
- make the color and depth images available in more conventional formats such as .png
