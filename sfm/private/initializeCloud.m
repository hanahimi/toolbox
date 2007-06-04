% Display a point cloud animation
%
% USAGE
%  initializeCloud( prm )
%
% INPUTS
%  I       - Nx3xT or Nx2xT array (N=num points, T=num frames)
%  fps     - [100] maximum number of frames to display per second
%            use fps==0 to introduce no pause and have the movie play as
%            fast as possible
%  loop    - [0] number of time to loop video (may be inf),
%            if neg plays video forward then backward then forward etc.
%  N       - [] cell array containing the connectivity neighbors
%
% OUTPUTS
%
% EXAMPLE
%
% See also

% Piotr's Image&Video Toolbox      Version 1.03
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function [hPoint, hCam]=initializeCloud( prm )

dfs = {'cam',[],'nCamera',0,'c',[0 0 1],'N',[],'i',1,'A','REQ','bound',[]};
prm = getParamDefaults( prm, dfs );
cam=prm.cam; nCamera=prm.nCamera; c=prm.c; N=prm.N; i=prm.i;
A=prm.A; bound=prm.bound;

nDim=size(A,1);

% Initialize the point cloud
if ~isempty(N)
  % Define some connectivities
  conn = cell(1,nPoint); coord=cell(1,3);
  for j = 1 : nPoint; conn{j}(:,2) = N{j}'; conn{j}(:,1) = i; end
  conn = cell2mat(conn');
  for j=1:nDim; coord{j}=[A(j,conn(:,1),i),A(j,conn(:,2),i)]'; end
  
  if nDim==3; hPoint=line(coord{1},coord{2},coord{3});
  else hPoint=line(coord{1},coord{2}); end
else
  if nDim==3; hPoint=plot3(A(1,:,i),A(2,:,i),A(3,:,i));
  else hPoint=plot(A(1,:,i),A(2,:,i)); end
  set(hPoint,'LineStyle','none');
end
set(hPoint,'Color',c,'Marker','.');

% Initialize the cameras
hold on;
inter=i-nCamera:i+nCamera;
inter((inter<1) | (inter>size(A,3)))=[];
hCam=plot3(cam(1,inter),cam(2,inter),cam(3,inter),'Color','b',...
  'Marker','s','LineStyle','none');

axis(bound);
