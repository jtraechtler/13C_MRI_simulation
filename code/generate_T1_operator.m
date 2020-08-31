function [T1] = generate_T1_operator(T1_map,td)
% function [T1] = generate_T1_operator(T1_map,td)
%=========================================================================
%
%	TITLE:
%       generate_T1_operator.m
%
%	DESCRIPTION:
%       Generates relaxation operator T1 which implements longitudinal 
%       relaxation as exponential signal decay over dynamic scan time td.
%
%	INPUT:
%       T1_map:         metabolite-dependent, spatial T1 map [s]
%                       dimension:  [Nx,Ny,Nz,1,1,1,Nm]
%
%       td:             dynamic scan time vector td [s]
%                       dimension:  [Nd,1]
%
%	OUTPUT:
%       T1:             longitudinal relaxation operator T1
%                       dimension: [Nx,Ny,Nz,1,Nd,1,Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Nd = length(td);

%% reshape input
td = reshape(td,[1,1,1,1,Nd,1,1]);

%% build T1 operator: [Nx,Ny,Nz,1,Nd,1,Nm]
T1 = single(exp(-td./T1_map));

end