function [A] = generate_A_operator(alpha_map,Ne)
% function [A] = generate_A_operator(alpha_map,Ne)
%=========================================================================
%
%	TITLE:
%       generate_A_operator.m
%
%	DESCRIPTION:
%       Generates depolarization operator A which implements radio
%       frequency relaxation due to Ne succeeding excitation pulses in 
%       multi-echo acquisition.
%
%	INPUT:
%       alpha_map:      high-resolution alpha map [rad]
%                       dimension:  [Nx,Ny,Nz,1,1,1,Nm]
%
%       Ne:             number of echoes
%
%	OUTPUT:
%       A:              depolarization operator A
%                       dimension:  [1,Ne,1,Nv,Nm]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% exception handling
if isempty(alpha_map); A = 1; return; end

%% dimensions
Nv = prod(size(alpha_map,[1:3]));
Nm = size(alpha_map,7);

%% reshape input
echo_number = [1:Ne].';
alpha_map = reshape(alpha_map,[1,Nv,Nm]);

%% build A operator
A = single(sin(alpha_map).*(cos(alpha_map).^(echo_number-1)));

%% reshape A: [1,Ne,1,Nv,Nm]
A = reshape(A,[1,Ne,1,Nv,Nm]);

end