# Overview

This dataset was used in "An Inductive Logic Programming Approach for Entangled Tube Modeling in Bin Picking". This dataset is intended to be used to create theories (i.e. sets of rules in Prolog) that indicate how to connect a set of cylinders to form complete tubes, using a machine-learning method known as Inductive Logic Programming (ILP).

In bin picking scenarios, a robotic arm must remove, one-by-one, a set of randomly assorted items from a container. This is specially challenging of the items are prone to be entangled, such as when they are shaped like curved tubes (which is the case of this here). In order for the robot to determine the next item to pick and how it should grasp it, it is useful for the robot to have a model of the items contained in the bin.

A set of entangled tubes can be modeled as a linked list of cylinders. The modeling algorithm proposed in conference paper in [previous work](https://link.springer.com/chapter/10.1007/978-3-030-35990-4_50) reads a point cloud captured by a 3D scanner facing towards the inside of a bin to construct a model of the items inside it. This algorithm fits a set of cylinders to the point cloud and then combines them to form the linked lists, as shown below.

![Step-by-step example of the tube modeling algorithm](https://github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/blob/master/an-ilp-approach-for-entangled-tube-modeling-in-bin-picking/images/modeling-example.png?raw=true)

A simple strategy explored in previous work to combine the cylinders is to combine the closest pairs of cylinders first (greedy approach). The scientific paper from the previous work presents this strategy in further detail.

![Step-by-step joining of the cylinders beloning to two tubes using a greedy strategy](https://github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/blob/master/an-ilp-approach-for-entangled-tube-modeling-in-bin-picking/images/tube-joining-steps.png?raw=true)

The goal is to use ILP to learn alternative ways of how these cylinders should be combined (i.e. to perform the last step of the first image). These alternative methods can provide more accurate models, since the greedy strategy above may produce incorrect pairings of cylinders. For instance, cylinders from two different tubes can be joined, tricking the robot into thinking it is seeing a single, long tube, rather than two shorted tubes.

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

Optionally, for Ubuntu, it is recommended to install [rlwrap](https://github.com/hanslub42/rlwrap), so that the user can go back to older commands/queries within SWI-Prolog's console.

All these software elements are free.

It is strongly recomended to read [Aleph's manual](https://www.di.ubi.pt/~jpaulo/competence/tutorials/aleph.pdf) to understand how ILP works and, specially, to learning about Aleph's parameters. The scientific paper associated with this repository illustrated in the results section how Aleph's parameters have a huge impact on the result, both in terms of:
- the quality/predictive performance of the induced theory;
- the training time.

# Instructions

For both training and testing, we begin by opening SWI-Prolog in the console while inside the root folder of this repository:

```
swipl
```

Alternatively, if rlwrap is installed, we can open SWI with rlwrap to be able to scroll back to older commands by pressing the "up key":

```
rlwrap swipl
```

For both training and testing, the user should be within the SWI-Prolog console.

## Training

First, tubes.pl is consulted (i.e. imported), to load all the parameters for Aleph, the definition of the predicates to be used to build rules/theories. This source file imports the aleph module.
```
consult('tubes.pl').
```

Then, the training set is imported. This file contains the background knowledge (ex: number of tubes in a test case), positive and negative examples for all the test cases used for training:
```
consult('training_set.pl').
```

Finally, the ILP engine can be executed:
```
induce.
```

The user then needs to be patient while the training is being performed. If the files of this repository are used without modification, training time should take around 20-30 seconds (tested on a Intel Core i7-8750H processor, with 2.20 GHz). Meanwhile, a lot of text is printed in the console with the results of the training process.

In the end, the user should see a result as depicted below:

![Training output](https://github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/blob/master/an-ilp-approach-for-entangled-tube-modeling-in-bin-picking/images/training.png?raw=true)

The induced theory (set of Prolog rules) is below the ```[theory]``` tag. In this case, the theory contains three rules. After learning a theory, it is recomended to save all of this output in a file, namely the Prolog code of the theory.

Under ```[Training set performance]```, a set of results are depicted, including the resulting confusion matrix of applying the induced theory to the training set, the accuract and the training time.

After this first training example, multiple elements can be changed, namely:
- Aleph's parameters: by changing the values in the ```aleph_set/2``` terms at the beginning of ```tubes.pl```.
- the predictes used to build the rules ("building-block predicates"): by adding/removing/modifying the ```modeb/2``` and ```determination/2``` terms in ```tubes.pl```, and the respective definition of the building-block predicates, which are also in ```tubes.pl```.

## Testing 

To test the predictive performance of a theory in a test set, the ```test.pl``` file needs to be modified.

First, the second ```include/1``` directive must be modified to match the name of the testing file. This repository contains four files usable for testing: 
```test_training_set.pl```, ```test_set_a```, ```test_set_b``` and ```test_set_c```. The ```test_training_set.pl``` file is used to test the, if the user so wishes (it is a modified version of ```training_set.pl``` without some directives used for training). Do not include the ```.pl``` extention inside the ```include/1``` directive.

Secondly, right below the second ```include/1``` directive, the rules for ```join/3``` should be replaced with the code for the theory to be tested.

Finally, inside the SWI-Prolog console, the ```test.pl``` file is imported and the ```test/0``` predicate is called.

```
consult('test.pl').
test.
```

If this repository's version of ```test.pl``` is used without any modifications, the user should see a result as depicted below:

![Testing output](https://github.com/GoncaloLeao/Entangled-Tubes-Bin-Picking-Dataset/blob/master/an-ilp-approach-for-entangled-tube-modeling-in-bin-picking/images/testing.png?raw=true)

The user can freely modify the code of ```test/0``` to include other metrics to measure the predictive performance.
