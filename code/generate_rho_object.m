function [rho] = generate_rho_object(mask,C,T1)
% function [rho] = generate_rho_object(mask,C,T1)
%=========================================================================
%
%	TITLE:
%       generate_rho_object.m
%
%	DESCRIPTION:
%       Generates spatio-temporal object rho based on a high-resolution
%       anatomical mask, weighted by the metabolites' signal amplitudes C
%       inlcuding longitudinal relaxation T1 of the hyperpolarized
%       substrates.
%
%	INPUT:
%       mask:           high-resolution anatomical mask with following
%                       compartments: 0 = background
%                                     1 = left ventricle 
%                                     2 = right ventricle 
%                                     3 = myocardium 
%                       dimension:  [Nx,Ny,Nz]
%
%       C:              metabolic signal amplitudes
%                       dimension: 1xNm cell with [Nd,Ncomp]
%
%       T1:             relaxation operator T1
%                       dimension: [Nx,Ny,Nz,1,Nd,1,Nm]
%
%	OUTPUT:
%       rho:            metabolite-dependent, spatio-temporal object rho
%                       dimension:  [Nx,Ny,Nz,1,Nd,1,Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
N       = size(mask,[1:3]);
Nv      = prod(N);
Nm      = length(C);
Nd      = size(C{1},1);
Ncomp   = length(setdiff(unique(mask),0));

%% mask compartments
mask_tmp = zeros([Nv,1,Ncomp]);
for i = 1:Ncomp
    mask_tmp(:,1,i) = single(mask(:)==i);
end

%% assign metabolites' signal amplitudes to compartments
rho = zeros([Nv,Nd,Nm]);
for i = 1:Nm
    C_tmp = reshape(C{i},[1,Nd,Ncomp]);
    rho(:,:,i) = sum(mask_tmp.*C_tmp,3);
end

%% reshape rho: [Nx,Ny,Nz,1,Nd,1,Nm]
rho = reshape(rho,[N,1,Nd,1,Nm]);

%% include longitudinal relaxation
rho = single(rho.*T1);

end