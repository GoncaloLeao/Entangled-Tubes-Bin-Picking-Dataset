[![DOI](https://zenodo.org/badge/192831421.svg)](https://zenodo.org/badge/latestdoi/192831421)

# Overview

This repository contains the dataset used in "Detecting and Solving Tube Entanglement in Bin Picking Operations".

The dataset consists of point clouds captured by a Photoneo PhoXi 3D Scanner S looking downwards towards a 77 cm (length) x 58 cm (width) x 9 cm (height) box with variable amounts of tube in different arrangements.

Two sets of tubes were used:
- Set A: Straight plumbing pipes that were manually bent to have different shapes. They are a subset of the tubes used in the research and dataset for the "Perception of Entangled Tubes for Automated Bin Picking" article.
- Set B: Radiator hoses from a Fiat Tipo engine.

Properties of each set of tubes:
| | Set A | Set B |
| --- | --- | --- |
| Material | Polyvinyl chloride (PVC) | Rubber |
| Curve length | 50 cm | 40 cm |
| Radius | 1.25 cm | 1.00 cm |
| Stiffness | Fully rigid | Semi-rigid |
| Weight | 55 g | 110 g |

The test case naming convention is as follows: "X_Y_Z", where:
- X is the identifier of the set ("A" or "B")
- Y is the test case ID (ranges from 1 to 5)
- Z is the actual number of tubes present in the box (ranges from 0 to 7)

# Terms of use

Over and above the legal restrictions of the license, this dataset is for research purposes only. When using this dataset, namely when writing a research paper or article, the End User shall reference the following scientific paper:

(IEEE citation format)
```
To be added
```

(Bibtex citation)
```
To be added
```

# File formats

Each test case is available in multiple formats, each one in a distinct sub-folder.

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene.
- a .png (Zivid native format) file, of black-and-white images captured by the sensor's camera.
