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

```
<number of tubes in the bin>
<tube 1 description>
<tube 2 description>
...
<tube N description>
```

Each tube is described as a "pseudo-graph". Each node is associated with a bifurcation or endpoint. In the simulated environment, each node represents a sphere, while each edge represents a cylinder. Please note that, unlike, "conventional graphs" where *ONE* edge connects two nodes, in this representation, there is an ordered set of edges connecting node A to node B, since there are multiple cylinder connecting two endpoints/bifurcations. The "order" of each of the P edges in the "path" connecting two nodes is given by the "order" property (which ranges from 1 to P). The nodes' radii is the same as the cylinder's radii since all of the datasets contain tubes with constant radii throughout their length. The format for a tube description is as follows:
```
<ID> <number of nodes> <number of edges>
<node 1 description>
<node 2 description>
...
<node V description>
<edge 1 description>
<edge 2 description>
...
<edge E description>
```

Each node (sphere) is described as follows:
```
<ID> <center X coordinate> <center X coordinate> <center X coordinate> <sphere radius>
```

Each edge (cylinder) is described as follows:
```
<ID> <node 1 ID> <node 2 ID> <order> <center X coordinate> <center Y coordinate> <center Z coordinate> <axis orientation vector X component> <axis orientation vector Y component> <axis orientation vector Z component> <length>
```
