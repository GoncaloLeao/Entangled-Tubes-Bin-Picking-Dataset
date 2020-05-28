[![DOI](https://zenodo.org/badge/192831421.svg)](https://zenodo.org/badge/latestdoi/192831421)

# Overview

This dataset was used in "Detecting and Solving Tube Entanglement in Bin Picking Operations".

The raw footage of all the experiments is available in a playlist on Youtube: https://www.youtube.com/playlist?list=PLYO0JZ1ogamkUBgOI4QMSMGd6xnwgI8vV

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

A round consists of fully emptying the contents of a bin. Some rounds ended prematurely since some of the tubes were outside the scanner's range.  
Each round is associated with a folder, which is named with the following convention: "XY", where:
- X is the identifier of the set ("A" or "B")
- Y is the test case ID (ranges from 1 to 20)

Each round is composed of a sequence of picking attempts. Each test case (picking attempt) is named using the following convention: "N" (if only a single attempt was needed to remove a tube from the bin) or "N_M" (if multiple attempts were needed), where:
- N is the remaining number of tubes in the bin (ranges from 0 to 7)
- M is the number of the attempt (starting at 1).

All of the second picking attempts were sucessful.

Each 

# Terms of use

Over and above the legal restrictions of the license, this dataset is for research purposes only. When using this dataset, namely when writing a research paper or article, the End User shall reference the following scientific paper:

(IEEE citation format)
```
G. Leão, C. M. Costa, A. Sousa, and G. Veiga, “Detecting and Solving Tube Entanglement in Bin Picking Operations,” Applied Sciences, vol. 10, no. 7, p. 2264, Mar. 2020.
```

(Bibtex citation)
```
@article{Leao2020,
          title={Detecting and Solving Tube Entanglement in Bin Picking Operations},
          author={Leão, Gonçalo and Costa, Carlos M. and Sousa, Armando and Veiga, Germano},
          volume={10},
          ISSN={2076-3417},
          url={http://dx.doi.org/10.3390/app10072264},
          DOI={10.3390/app10072264},
          number={7},
          journal={Applied Sciences},
          publisher={MDPI AG},
          year={2020},
          month={Mar},
          pages={2264}
}
```

# File formats

Each test case is available in multiple formats, each one in a distinct sub-folder.

Each test case contains the following files:
- a .ply (Polygon File Format) file with the unordered point cloud of the scene.
- a .png (Zivid native format) file, of black-and-white images captured by the sensor's camera.

# Image examples

Here are some images from the dataset.

![Set A, test case 1, 7 tubes](https://raw.github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/master/detecting-and-solving-tube-entanglement-in-bin-picking-operations/A1/7.png)

![Set B, test case 1, 7 tubes](https://raw.github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/master/detecting-and-solving-tube-entanglement-in-bin-picking-operations/B1/7.png)
