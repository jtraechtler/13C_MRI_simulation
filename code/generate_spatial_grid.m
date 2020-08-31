function [r] = generate_spatial_grid(N,FOV,dim)
% function [r] = generate_spatial_grid(N,FOV,dim)
%=========================================================================
%
%	TITLE:
%       generate_spatial_grid.m
%
%	DESCRIPTION:
%       Generates discrete spatial coordinates r according to the spatial
%       resolution defined by the field-of-view FOV and number of points N.
%
%	INPUT:
%       N:              number of points per dimension [Nx,Ny,Nz]
%                       dimension:  [1,dim] (dim=2 or dim=3)
%
%       FOV:            field-of-view [m] [FOVx,FOVy,FOVz]
%                       dimension:  [1,dim] (dim=2 or dim=3)
%
%       dim:            spatial encoding dimensionality
%                       dim=2 (2D) or dim=3 (3D)
%
%	OUTPUT:
%       r:              spatial coordinates [m] r=[rx,ry,rz]
%                       dimension:  [Nv,dim] (dim=2 or dim=3)
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% dimensions
Nv  = prod(N);

%% spatial grid
dr = FOV(1:dim)./N(1:dim);
xq = [-floor(N(1)/2):ceil(N(1)/2)-1]*dr(1);
yq = [-floor(N(2)/2):ceil(N(2)/2)-1]*dr(2);
switch dim
    case 2
        [x,y] = meshgrid(xq,yq);
        z = [];
    case 3
        zq = [-floor(N(3)/2):ceil(N(3)/2)-1]*dr(3);
        [x,y,z] = meshgrid(xq,yq,zq);
        z = reshape(permute(z,[2,1,3]),[Nv,1]);
end
x = reshape(permute(x,[2,1,3]),[Nv,1]);
y = reshape(permute(y,[2,1,3]),[Nv,1]);

%% build r: [Nv,dim]
r = single([x,y,z]);

end