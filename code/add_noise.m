function [sn] = add_noise(s,eta)
% function [sn] = add_noise(s,eta)
%=========================================================================
%
%	TITLE:
%       add_noise.m
%
%	DESCRIPTION:
%       Adds Gaussian distributed noise with 0 mean and standard deviation
%       defined by eta to the data s.
%
%	INPUT:
%       s:              noiseless (k-space) data
%
%       eta:            noise level (standard deviation)
%
%	OUTPUT:
%       sn:             noisy (k-space) data
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% add noise
if isreal(s)
    sn  = s + eta*randn(size(s));
else
    sn  = s + eta*randn(size(s)) + 1j*eta*randn(size(s));
end

end
