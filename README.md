## MATLAB ConvNet for Breast Cancer Classification

Using [MatConvNet](http://www.vlfeat.org/matconvnet/) (like Lasagne for MATLAB) for classification of breast cancer histopathology images: benign / malignant.

Here is the associated [course paper](http://www.uoguelph.ca/~jknigh04/docs/Sample%20-%20Conv%20Net%20Breast%20Cancer.pdf).

Architecture is nooby and performance is poor, but it is a nice example of MatConvNet in action.

#### Functional Overview
* `traincnn` - main
* `defnet` - define the net
* `buildmdb` - build the image database
* `functions/` - weight init, error function, batch select, show layer conv kernels
* `validation/` - functions for characterizing performance