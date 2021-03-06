function [E] = generate_E_operator(F,M,W,A,T2s,B0) 
% function [E] = generate_E_operator(F,M,W,A,T2s,B0) 
%=========================================================================
%
%	TITLE:
%       generate_E_operator.m
%
%	DESCRIPTION:
%       Generates the extended encoding operator E which includes spatial
%       encoding F, chemical shift encoding M, coils sensitivty weighting
%       W, radio frequency relaxation A, transverse relaxation T2s and
%       field inhomogeneity-induced phase-offsets B0.
%
%	INPUT:
%       F:              spatial encoding (Fourier) operator F
%                       dimension:  [Ns,1,1,Nv,1]
%
%       M:              chemical shift encoding operator M
%                       dimension:  [Ns,Ne,1,1,Nm]
%
%       W:              coil sensitivty weighting operator W
%                       dimension:  [1,1,Nc,Nv,1]
%
%       A:              depolarization operator A
%                       dimension:  [1,Ne,1,Nv,Nm]
%
%       T2s:            transverse relaxation operator T2s
%                       dimension:  [Ns,Ne,1,Nv,Nm]
%
%       B0:             B0-induced phase-offset operator B0
%                       dimension:  [Ns,Ne,1,Nv,1]
%
%	OUTPUT:
%       E:              extended encoding operator E
%                       dimension:  [Ns*Ne*Nc,Nv*Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Ns = size(F,1);
Ne = size(M,2);
Nc = size(W,3);
Nv = size(F,4);
Nm = size(M,5);

%% build E: [Ns*Ne*Nc,Nv,Nm]
E = single(reshape(F.*M.*W.*A.*T2s.*B0,[Ns*Ne*Nc,Nv*Nm]));

end