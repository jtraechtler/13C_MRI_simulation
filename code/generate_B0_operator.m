function [B0] = generate_B0_operator(B0_map,t)
% function [B0] = generate_B0_operator(B0_map,t)
%=========================================================================
%
%	TITLE:
%       generate_B0_operator.m
%
%	DESCRIPTION:
%       Generates B0 operator which implements field inhomogeneity-induced
%       phase offsets.
%
%	INPUT:
%       B0_map:         high-resolution B0 map [Hz]
%                       dimension:  [Nx,Ny,Nz]
%
%       t:              time vector [s] t=ts+te
%                       dimension:  [Ns,Ne]
%
%	OUTPUT:
%       B0:             B0-induced phase-offset operator B0
%                       dimension:  [Ns,Ne,1,Nv,1]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Nv = prod(size(B0_map,[1:3]));
Ns = size(t,1);
Ne = size(t,2);

%% reshape input
B0_map  = reshape(B0_map,[Nv,1]);
t       = reshape(t,[1,Ns*Ne]);

%% build B0 operator
B0 = single(exp(1i*2*pi*B0_map*t));

%% reshape B0: [Ns,Ne,1,Nv,1]
B0 = permute(reshape(B0,[Nv,Ns,Ne,1,1]),[2,3,4,1,5]);

end