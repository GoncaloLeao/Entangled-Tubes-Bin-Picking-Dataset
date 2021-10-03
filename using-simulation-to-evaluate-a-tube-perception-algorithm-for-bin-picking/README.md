[![DOI](https://zenodo.org/badge/192831421.svg)](https://zenodo.org/badge/latestdoi/192831421)

# Overview

This dataset was generated and used in "Using Simulation to Evaluate a Tube Perception Algorithm for Bin Picking". This dataset is intended to be used to help evaluate perception algorithms of entangled tubes. The paper presents a methodology for performing this evaluation.

The dataset consists of point clouds composed of tubes that were procedurally generated in a Gazebo environment. The tubes are placed in a bin with dimensions 55 cm (length) x 37 cm (width) x 20 cm (height). All of the data was captured at a time instant where the tubes were stabilized inside the bin (i.e. their linear and angular velocities were very close to 0). Alongside the point clouds, the dataset also includes a geometric representation of the tubes and .gazebo world files, which can be run in Gazebo to interact with each bin filled with tubes.

The clouds were generated using a Gazebo built-in virtual sensor that mimics a Zivid One Plus L scanner (which produces depth images with dimensions 1920 x 1200). The sensor is placed looking downwards towards the bin. 

To simplify the analysis and save space, only the points belonging to the tubes are included in the cloud (i.e. the clouds were pre-filtered to remove the points that belonged to the bin's bottom and walls).

Each of the main directories refers to a collection of test cases with the same amount of tubes that were procedurally generated with the same properties. The naming convention of these directories is as follows: "XY", where:
- X is the identifier of the set ("A", "B" or "C")
- Y is the number of tubes in the bin

Within each of the main directories, there are three subdirectories, which contain each the test cases in a different format (refer to the "File formats" section below). Within the three subdirectories, there are 20 files, each one corresponding at a distinct test case. The name of these files refers to the test case ID.

# Terms of use

Over and above the legal restrictions of the license, this dataset is for research purposes only. When using this dataset, namely when writing a research paper or article, the End User shall reference the following scientific paper:

(IEEE citation format)
```
(Awaiting publication)
```

(Bibtex citation)
```
(Awaiting publication)
```

# File formats

Each test case is available in multiple formats, each one in a distinct sub-folder.

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene.
- a .world (Gazebo SDF format) file with the description of the scene for Gazebo. These files can be opened in Gazebo.
- a .txt file with the geometric description of the tubes. The structure of this file is as follows:
