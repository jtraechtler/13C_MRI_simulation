function [W] = generate_W_operator(coil_map)
% function [W] = generate_W_operator(coil_map)
%=========================================================================
%
%	TITLE:
%       generate_W_operator.m
%
%	DESCRIPTION:
%       Generates weighting operator W which implements coil sensitiviy
%       encoding.
%
%	INPUT:
%       coil_map:       high-resolution coil map
%                       dimension:  [Nx,Ny,Nz,Nc]
%
%	OUTPUT:
%       W:              coil sensitivty weighting operator W
%                       dimension:  [1,1,Nc,Nv,1]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Nv = prod(size(coil_map,[1:3]));
Nc = size(coil_map,4);

%% reshape input
coil_map = reshape(coil_map,[Nv,Nc]);

%% build W operator
W = single(coil_map);

%% reshape W: [1,1,Nc,Nv,1]
W = permute(reshape(W,[1,1,Nv,Nc,1]),[1,2,4,3,5]);

end