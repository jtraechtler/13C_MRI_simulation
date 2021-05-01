function [T2s] = generate_T2s_operator(T2s_map,t)
% function [T2s] = generate_T2s_operator(T2s_map,t)
%=========================================================================
%
%	TITLE:
%       generate_T2s_operator.m
%
%	DESCRIPTION:
%       Generates relaxation operator T2s which implements transverse 
%       relaxation as exponential signal decay over echo-shifted
%       acquisiton time t.
%
%	INPUT:
%       T2s_map:        high-resolution T2s map [s]
%                       dimension:  [Nx,Ny,Nz,1,1,1,Nm]
%
%       t:              time vector [s] t=ts+te
%                       dimension:  [Ns,Ne]
%
%	OUTPUT:
%       T2s:            transverse relaxation operator T2s
%                       dimension:  [Ns,Ne,1,Nv,Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% exception handling
if isempty(T2s_map); T2s = 1; return; end

%% dimensions
Nv = prod(size(T2s_map,[1:3]));
Nm = size(T2s_map,7);
Ns = size(t,1);
Ne = size(t,2);

%% reshape input
T2s_map = reshape(T2s_map,[Nv*Nm,1]).';
t       = reshape(t,[Ns*Ne,1]);

%% build T2s operator
T2s = single(exp(-t*(1./T2s_map)));

%% reshape T2s: [Ns,Ne,1,Nv,Nm]
T2s = reshape(T2s,[Ns,Ne,1,Nv,Nm]);

end