function [F] = generate_F_operator(k,r)
% function [F] = generate_F_operator(k,r)
%=========================================================================
%
%	TITLE:
%       generate_F_operator.m
%
%	DESCRIPTION:
%       Generates spatial encoding operator F which implements spatial
%       encoding as discrete Fourier transform.
%
%	INPUT:
%       k:              sampling points k = [kx,ky,kz]
%                       dimension:  [Ns,dim] (dim=2 or dim=3)
%
%       r:              spatial coordinates [m] r=[rx,ry,rz]
%                       dimension:  [Nv,dim] (dim=2 or dim=3)
%
%	OUTPUT:
%       F:              spatial encoding (Fourier) operator F
%                       dimension:  [Ns,1,1,Nv,1]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Ns = length(k);
Nv = length(r);

%% build F operator
F = single(1/sqrt(Ns).*exp(-1i*k*r.'));

%% reshape F: [Ns,1,1,Nv,1]
F = reshape(F,[Ns,1,1,Nv,1]);

end