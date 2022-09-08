# Overview

This dataset was used in "An Inductive Logic Programming Approach for Entangled Tube Modeling in Bin Picking". This dataset is intended to be used to create theories (i.e. sets of rules in Prolog) that indicate how to connect a set of cylinders to form complete tubes, using a machine-learning method known as Inductive Logic Programming (ILP).

In bin picking scenarios, a robotic arm must remove, one-by-one, a set of randomly assorted items from a container. This is specially challenging of the items are prone to be entangled, such as when they are shaped like curved tubes (which is the case of this here). In order for the robot to determine the next item to pick and how it should grasp it, it is useful for the robot to have a model of the items contained in the bin.

A set of entangled tubes can be modeled as a linked list of cylinders. The modeling algorithm proposed in previous work reads a point cloud captured by a 3D scanner facing towards the inside of a bin to construct a model of the items inside it. This algorithm fits a set of cylinders to the point cloud and then combines them to form the linked lists, as shown below.

![Step-by-step example of the tube modeling algorithm](https://www.researchgate.net/profile/Goncalo-Leao/publication/359745643/figure/fig2/AS:1142284020137984@1649353141616/An-example-of-the-result-of-each-step-of-the-tube-modeling-solution_W640.jpg)

The goal is to use ILP to learn how these cylinders should be combined.

# Terms of use

Over and above the legal restrictions of the license, this dataset is for research and educational purposes only. When using this dataset, namely when writing a research paper or article, the End User shall reference the following scientific paper:

(IEEE citation format)
```
TBA
```

(Bibtex citation)
```
TBA
```

# Prerequisites

This tutorial was tested in Ubuntu 18.04, but it should also work on other Linux operating systems and on Windows.

In order to form ILP with this repository's files, the following software is needed:
- [SWI-Prolog](https://github.com/SWI-Prolog/swipl-devel), the Prolog interpreter;
- Aleph, the ILP engine. The [port of Aleph for SWI-Prolog by Fabrizio Riguzzi](https://github.com/friguzzi/aleph) is recomended.

Optionally, for Ubuntu, it is recommended to install ``rlwrap'', so that the user can go back to older commands/queries within SWI-Prolog's console.

All these software elements are free.

# Instructions

## Training

## Testing 
