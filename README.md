# 13C_MRI_simulation

## UPDATE

The repository was moved to https://gitlab.ethz.ch/ibt-cmr-public/13c_mri_simulation.git.

## Description

MATLAB code to generate synthetic k-space data simulating multi-echo acquisition using hyperpolarized 13C metabolic MRI.

## Requirements

MATLAB

## Usage

1. Run ```run_simulation(id,eta)``` to generate synthetic 13C data based on raw data stored in *'data/[id].mat'* and noise level *eta*. The simulated data is stored in *'results/[id].mat'*.
2. Process and reconstruct data using multi-echo reconstruction: https://gitlab.ethz.ch/ibt-cmr-public/multiecho_b0_recon.git

Example: 
```
run_simulation('invivo1',5e-4)
```

## Data

### Raw data *'data/[id].mat'* (pre-simulated or extracted from in vivo data):

| parameter   | description | dimension     |
| :---        |    :---     |   :---        |
| *mask* |        anatomical mask |      3-D array: [*Nx*,*Ny*,*Nz*] |
| *C* |           signal amplitudes |    1x*Nm* cell: [*Nd*,*Ncomp*] |
| *T1_map* |      T1 map [s] |           7-D array: [*Nx*,*Ny*,*Nz*,1,1,1,*Nm*] |
| *coil_map* |    sensitivity map |      4-D array: [*Nx*,*Ny*,*Nz*,*Nc*] |
| *alpha_map* |   flip angle map [rad] | 7-D array: [*Nx*,*Ny*,*Nz*,1,1,1,*Nm*] |
| *T2s_map* |     T2* map [s] |          7-D array: [*Nx*,*Ny*,*Nz*,1,1,1,*Nm*] |
| *B0_map* |      field map [Hz] |       3-D array: [*Nx*,*Ny*,*Nz*] |
| *k* |           sample points [1/m] |  2-D array: [*Ns*,*dim*] |
| *ts* |          sampling time [s] |    1-D array: [*Ns*,1] |
| *td* |          dyn. scan time [s] |   1-D array: [*Nd*,1] |
| *fm* |          chemical shifts [Hz] | 1-D array: [1,*Nm*] |
| *TE* |          echo times [s] |       1-D array: [1,*Ne*] |
| *FOV* |         field-of-view [m] |    1-D array: [1,*dim*] |
| *metabolites* | order of metabolites | 1x*Nm* cell

Exemplary raw data based on in vivo measurements using hyperpolarized [1-13C]pyruvate in the pig heart is available in *'data/invivo1-4.mat'*.

### Simulated data *'results/[id].mat'*:

| parameter   | description | dimension     |
| :---        |    :---     |   :---        |
| *rho* |         ground truth object  | 7-D array: [*Nx*,*Ny*,*Nz*,1,*Nd*,1,*Nm*] |
| *s* |           k-space |              7-D array: [*Ns*,1,1,*Nc*,*Nd*,1,*Ne*] |

### Dimensions:

| parameter   | description |
| :---        |    :---     |
| *Nx*,*Ny*,*Nz* |     number of points per dimension |
| *Nv* |           total number of points *Nv*=*NxNyNz* |
| *Nc* |           number of coils |
| *Nd* |           number of dynamics |
| *Nm* |           number of metabolites |
| *Ns* |           number of k-space samples |
| *Ne* |           number of echoes |
| *dim* |          spatial encoding dimensionality (2D or 3D) |
| *Ncomp* |        number of mask compartments (e.g. LV, RV, myocardium) |

**Image-domain** data is given as 7-D array [*x*,*y*,*z*,*c*,*d*,*hp*,*m*] of size [*Nx*,*Ny*,*Nz*,*Nc*,*Nd*,*Np*,*Nm*] with attributes:
| parameter   | description |
| :---        |    :---     |
| *x,y,z* |        spatial points |
| *c* |            coils |
| *d* |            dynamics |
| *hp* |           heart phases |
| *m* |            metabolites |

**K-space** data is given as 7-D array [*ks*,1,1,*c*,*d*,*hp*,*e*] of size [*Ns*,1,1,*Nc*,*Nd*,*Np*,*Nm*] with attributes:
| parameter   | description |
| :---        |    :---     |
| *ks* |           samples |
| *c* |            coils |
| *d* |            dynamics |
| *hp* |           heart phases |
| *e* |            echoes |
