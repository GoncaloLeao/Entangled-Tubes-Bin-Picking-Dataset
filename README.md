# Overview

This repository contains the dataset used in "Perception of Entangled Tubes for Automated Bin Picking". This dataset is intended to be used to help evaluate perception algorithms of entangled tubes.

The dataset consists of point clouds captured by a Zivid One Plus sensor looking downwards towards a 55 cm (length) x 37 cm (width) x 20 cm (height) box with variable amounts of tube in different arrangements. The tubes are made of Polyvinyl chloride (PVC) and are bent with different curvatures. Each tube has a diameter of 2.5 cm and a length of 50 cm. 

The test case naming convention is as follows: "X_bin_picking_Y", where:
- X is the actual number of tubes present in the box (ranges from 1 to 10)
- Y is the test case ID (ranges from 1 to 5)

The dataset also contains a test case called "0_bin_picking" where the box is empty.

# Structure

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene
- a .zdf (Zivid native format) file with the point cloud, color image and depth image

# Future work:
- make the color and depth images available in more conventional formats such as .png
