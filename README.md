# MATLAB GUI for the automated calibration of Optical Tweezers (aka. Photonic Force Microscopy)

## Description
Optical tweezers are commonly used and powerful tools to perform force measurements on the piconewton scale and to detect nanometer-scaled displacements. However, the precision of these instruments relies to a great extent on the accuracy of the calibration method. A well-known calibration procedure is to record the stochastic motion of the trapped particle and compare its statistical behavior with the theory of
the Brownian motion in a harmonic potential. Here we present an interactive calibration software which allows for the simultaneous fitting of three different statistical observables (power spectral density, mean square displacement and velocity autocorrelation function) calculated from the trajectory of the probe to enhance fitting accuracy. The fitted theory involves the hydrodynamic interactions experimentally observable at high sampling rates. Furthermore, a qualitative extension is included in our model to handle the thermal fluctuations in the orientation of optically trapped asymmetric objects. The presented calibration methodology requires no prior knowledge of the bead size and can be applied to non-spherical probes as well. The software was validated on synthetic and experimental data.

For a more detailed description, please refer to the attached publication.

## Related publication (included in the repository)
Á. Butykai, F.M. Mor, R. Gaál, P. Domínguez-García, L. Forró, S. Jeney, Calibration of optical tweezers with non-spherical probes via high-resolution detection of Brownian motion, Computer Physics Communications 196, 599-610, (2015)

DOI: https://doi.org/10.1016/j.cpc.2015.06.024

## Software requirements
MatLab 2011a or later, Statistics toolbox

## Installation of the software
The Matlab code is located in the folder named 'PFMCal_Deluxe'. 

## Executing the software
The calibration software can be executed from MatLab (MathWorks Inc.) by running the PFMCal.m file. Select either 'Add to path' or 'Change current directory' options.

## Using the software
Please refer to Section 7. in the manuscript

## Test data
Test data are located in the Testdata folder. 
Si_Spheres archive contains experimental data measured on silica speheres.
Si_splinters_non_spherical folder contains experimental data measured on fragmented silica particles with random shape.
Synthetic_non_spherical folder contains 100 generated datasets with random error for the validation of the non-spherical model.
Synthetic_spherical folder contains 100 generated datasets with random error for the validation of the spherical model.
