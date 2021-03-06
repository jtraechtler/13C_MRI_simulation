function run_simulation(id,eta)
% function run_simulation(id,eta)
%=========================================================================
%
%	TITLE:
%       run_simulation.m
%
%	DESCRIPTION:
%       Example script to generate synthetic 13C data from pre-simulated
%       raw data stored in 'data/[id].mat'.
%        - mask:        anatomical mask      3-D array: [Nx,Ny,Nz]
%        - C:           signal amplitudes    1xNm cell: [Nd,Ncomp]
%        - T1_map:      T1 map [s]           7-D array: [Nx,Ny,Nz,1,1,1,Nm]
%        - coil_map:    sensitivity map      4-D array: [Nx,Ny,Nz,Nc]
%        - alpha_map:   flip angle map [rad] 7-D array: [Nx,Ny,Nz,1,1,1,Nm]
%        - T2s_map:     T2* map [s]          7-D array: [Nx,Ny,Nz,1,1,1,Nm]
%        - B0_map:      field map [Hz]       3-D array: [Nx,Ny,Nz]
%        - k:           sample points [1/m]  2-D array: [Ns,dim]
%        - ts:          sampling time [s]    1-D array: [Ns,1]
%        - td:          dyn. scan time [s]   1-D array: [Nd,1]
%        - fm:          chemical shifts [Hz] 1-D array: [1,Nm]
%        - TE:          echo times [s]       1-D array: [1,Ne]
%        - FOV:         field-of-view [m]    1-D array: [1,dim]
%        - metabolites: order of metabolites 1xNm cell
%
%	INPUT:
%       id:             data set ID
%       eta:            noise level 
%
%	SAVED FILES:							
%       Simulation results are stored in 'results/[id].mat'
%        - rho:         ground truth object 7-D array: [Nx,Ny,Nz,1,Nd,1,Nm]
%        - s:           k-space             7-D array: [Ns,1,1,Nc,Nd,1,Ne]
%
%	VERSION HISTORY:
%       200821JT Initial version for release
%
%	    JULIA TRAECHTLER (TRAECHTLER@BIOMED.EE.ETHZ.CH)
%
%=========================================================================

%% input
if nargin < 2
    eta = 5e-4;
end
if nargin < 1
    id = 'invivo1';
end

%% add path
addpath('code/')

%% get_data
load(['data/',id,'.mat'],'mask','C','td','T1_map','coil_map',...
    'alpha_map','T2s_map','B0_map','k','ts','fm','TE','FOV','metabolites');

%% dimensions
dim = size(k,2);            % spatial encoding dimensionality (2D or 3D)
N = size(mask,[(1:dim)]);   % number of points per dimension [Nx,Ny,Nz]
Nv = prod(N);               % total number of points Nx*Ny*Nz
Nc = size(coil_map,4);      % number of coils
Nd = length(td);            % number of dynamics
Nm = length(fm);            % number of metabolites
Ns = length(ts);            % number of k-space samples
Ne = length(TE);            % number of echoes
if dim<length(size(mask))
    Nz = size(mask,3);      % number of slices (2D & average over slices)
else
    Nz = 1;                 % number of slices (3D encoding)
end

%% t: [Ns,Ne] time vector including sampling time & shifted echo times [s]
t = ts+TE;

%% r: [Nv,dim] spatial coordinates [m]
[r] = generate_spatial_grid(N,FOV,dim);

%% T1: [Nx,Ny,Nz,1,Nd,1,Nm] longitudinal relaxation 
[T1] = generate_T1_operator(T1_map,td);

%% rho: [Nx,Ny,Nz,1,Nd,1,Nm] >> [Nv*Nm,Nd,Nz] spatio-temporal object
[rho] = generate_rho_object(mask,C,T1);
rho = reshape(permute(reshape(rho,[Nv,Nz,Nd,Nm]),[1,4,3,2]),[Nv*Nm,Nd,Nz]);

%% noise frame
rho(:,end+1,:) = 0; Nd = size(rho,2);

%% F: [Ns,1,1,Nv,1] spatial encoding (Fourier transform)
[F] = generate_F_operator(k,r);

%% M: [Ns,Ne,1,1,Nm] chemical shift encoding
[M] = generate_M_operator(fm,t);

%% W: [1,1,Nc,Nv*Nz,1] coil sensitiviy weighting
[W] = generate_W_operator(coil_map);

%% A: [1,Ne,1,Nv*Nz,Nm] depolarization
[A] = generate_A_operator(alpha_map,Ne);

%% T2s: [Ns,Ne,1,Nv*Nz,Nm] transverse relaxation
[T2s] = generate_T2s_operator(T2s_map,t);

%% B0: [Ns,Ne,1,Nv*Nz,1] B0-induced phase-offset
[B0] = generate_B0_operator(B0_map,t);
    
%% s:   [Ns*Ne*Nc,Nd,Nz] multi-echo, multi-coil k-space
s = single(zeros([Ns*Ne*Nc,Nd,Nz]));

for i=1:Nz  % slices
    %% E: [Ns*Ne*Nc,Nv*Nm] extended encoding operator
    [E] = generate_E_operator(F,M,W(:,:,:,(i-1)*Nv+1:i*Nv,:),...
        A(:,:,:,(i-1)*Nv+1:i*Nv,:),T2s(:,:,:,(i-1)*Nv+1:i*Nv,:),...
        B0(:,:,:,(i-1)*Nv+1:i*Nv,:));
    for j=1:Nd  % dynamics        
        %% s: [Ns*Ne*Nc,Nd,Nz] k-space
        s(:,j,i) = E*rho(:,j,i);
    end    
end
s = mean(s,3); % average over slices if 2D encoding

%% reshape s: [Ns,1,1,Nc,Nd,1,Ne] multi-echo, multi-coil k-space
s = permute(reshape(s,[Ns,1,1,Ne,Nc,Nd,1]),[1,2,3,5,6,7,4]);

%% noise
s = add_noise(s,eta);

%% reshape rho: [Nx,Ny,Nz,1,Nd,1,Nm] spatio-temporal object
rho = reshape(permute(reshape(rho,[Nv,Nm,Nd,Nz]),[1,4,3,2]),...
    [size(mask),1,Nd,1,Nm]);

%% save data
save(['results/',id,'.mat'],'s','rho')

end