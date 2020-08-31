function [M] = generate_M_operator(fm,t)
% function [M] = generate_M_operator(fm,t)
%=========================================================================
%
%	TITLE:
%       generate_M_operator.m
%
%	DESCRIPTION:
%       Generates chemical shift encoding operator M which implements a
%       chemical shift-induced phase offset for each metabolite.
%       Matrix multiplication M*rho simulates superposition of the
%       phase-shifted metabolite components.
%
%	INPUT:
%       fm:             chemical shift vector [Hz]
%                       dimension:  [1,Nm]
%
%       t:              time vector [s] t=ts+te
%                       dimension:  [Ns,Ne]
%
%	OUTPUT:
%       M:              chemical shift encoding operator M
%                       dimension:  [Ns,Ne,1,1,Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Nm = length(fm);
Ns = size(t,1);
Ne = size(t,2);

%% reshape input
t = reshape(t,[Ns*Ne,1]);

%% build M operator
M = single(exp(1i*2*pi*t*fm));

%% reshape M: [Ns,Ne,1,1,Nm]
M = reshape(M,[Ns,Ne,1,1,Nm]);

end