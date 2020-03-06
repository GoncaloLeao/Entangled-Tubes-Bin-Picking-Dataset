[![DOI](https://zenodo.org/badge/192831421.svg)](https://zenodo.org/badge/latestdoi/192831421)

# Overview

This dataset was used in "Perception of Entangled Tubes for Automated Bin Picking". This dataset is intended to be used to help evaluate perception algorithms of entangled tubes.

The dataset consists of point clouds captured by a Zivid One Plus sensor looking downwards towards a 55 cm (length) x 37 cm (width) x 20 cm (height) box with variable amounts of tube in different arrangements. The tubes are made of Polyvinyl chloride (PVC) and are bent with different curvatures. Each tube has a diameter of 2.5 cm and a length of 50 cm. 

The test case naming convention is as follows: "X_bin_pickingY", where:
- X is the actual number of tubes present in the box (ranges from 1 to 10)
- Y is the test case ID (ranges from 1 to 5)

The dataset also contains a test case called "0_bin_picking" where the box is empty.

# Terms of use

Over and above the legal restrictions of the license, this dataset is for research purposes only. When using this dataset, namely when writing a research paper or article, the End User shall reference the following scientific paper:

(IEEE citation format)
```
G. Leão, C. Costa, A. Sousa, and G. Veiga, “Perception of Entangled Tubes for Automated Bin Picking,” in Advances in Intelligent Systems and Computing, 2019.
```

(Bibtex citation)
```
@inbook{Leao2019,
	title={Perception of Entangled Tubes for Automated Bin Picking},
	author={Leão, Gonçalo and Costa, Carlos and Sousa, Armando and Veiga, Germano},
	booktitle={Advances in Intelligent Systems and Computing},
	publisher={Springer},
	year={2019},
	address = {Porto, Portugal}
}
```

# File formats

Each test case is available in multiple formats, each one in a distinct sub-folder.

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene.
- a .zdf (Zivid native format) file with the point cloud, color image and depth image. These files can be opened with Zivid Studio.

Note: The cloud point coordinates are expressed in millimeters (mm).

# Future work
- Make the color and depth images available in more conventional formats such as .png
